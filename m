Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7B924DCF4
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 10:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749032641; cv=none; b=QB+8LOnqClWvWPWbFz7vOqtxb33zgB20Vf3JvAN7MZ5D5xBwztEBHVWnimp5YeweZ79k+O+OYJeBJWwRjWWn3fjEeaynoVQQy+Z8gMQWLtwyQX+iiOa0LYGXzOia2COugU9LtkFX2ro5J/K438Q5w0egr+wUxuH2Q1QQJbDLujk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749032641; c=relaxed/simple;
	bh=SiphSZlORfIR4dqiQQIm8GWuk89uFo2wCK55QMraYjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=asgSxIRHIKP4JKh5R31PMRFQfJQbGLkrawVe5ymxRfi73KTpej2q/1jc60g4qmplepwDqRR301tfxQiNLcm5hiJ9wJrQ0vajAfmOzkA/jf3hokYqIFg0F7DMxPiugp02MdO9J8AZMvSqe4Q2X/vCc0SB7y9FNoycTmSTwT6LZNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=bLphLywA; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="bLphLywA"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id E6ABE2321F;
	Wed,  4 Jun 2025 12:23:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1749032634;
	bh=tB+3BxLKwyiK9NwRxEKR/77hUyD88iZH/NPId60pNEw=; h=From:To:Subject;
	b=bLphLywAtT1zcDkkUG8mNPPRZHOvdDk1R4Z8uylgiWNeR7V7W2mEM8a6wr/8kWBnv
	 Q330rWkyste8xgEOHlSTyFjp+eJsvc0LSv8KHCCgXoghS0rWXciX6WdwKA41aCA14E
	 YRDRoO1HL3p9iiYF8mCTAzgq6T57EhVVOyg7Vq/SCoKYVxWP39KW+NEZ6cUsKRFPSn
	 hOUj7K7IMlWFfkSkQZpf6H9H0R+obwiQ9fMDWiEnApBtyfatf509aDrozFyHEU6sqs
	 aDjqORRFgqWu8A/oGMWnqY6/JlrzV3dScIVNMQWMBk1eODHoGssW10p3tvQNmKfZYf
	 Kce3G0LtMXwKw==
Date: Wed, 4 Jun 2025 12:23:52 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Vitor Soares <ivitro@gmail.com>
Subject: Re: [PATCH 6.12 130/626] wifi: mwifiex: Fix HT40 bandwidth issue.
Message-ID: <20250604102352.GB31115@francesco-nb>
References: <20250527162445.028718347@linuxfoundation.org>
 <20250527162450.311998747@linuxfoundation.org>
 <20250603203337.GA109929@francesco-nb>
 <2025060408-concur-bubbly-04ea@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025060408-concur-bubbly-04ea@gregkh>

On Wed, Jun 04, 2025 at 10:39:09AM +0200, Greg Kroah-Hartman wrote:
> On Tue, Jun 03, 2025 at 10:33:54PM +0200, Francesco Dolcini wrote:
> > Hello Greg, Sasha
> > 
> > On Tue, May 27, 2025 at 06:20:23PM +0200, Greg Kroah-Hartman wrote:
> > > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Jeff Chen <jeff.chen_1@nxp.com>
> > > 
> > > [ Upstream commit 4fcfcbe457349267fe048524078e8970807c1a5b ]
> > > 
> > > This patch addresses an issue where, despite the AP supporting 40MHz
> > > bandwidth, the connection was limited to 20MHz. Without this fix,
> > > even if the access point supports 40MHz, the bandwidth after
> > > connection remains at 20MHz. This issue is not a regression.
> > > 
> > > Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
> > > Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> > > Link: https://patch.msgid.link/20250314094238.2097341-1-jeff.chen_1@nxp.com
> > > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > Can you please drop this patch from any additional stable kernel update?
> > It seems that on 6.12.y it introduced a regression, we are currently
> > investigating it and we'll eventually send a revert for 6.12.y.
> 
> This is already in the following released kernels:
> 	6.12.31 6.14.9 6.15
> I'll be glad to queue up the revert when it hits Linus's tree.  Is that
> planned anytime soon?

mainline is not affected, the issues seems specific of the backport on
6.12 (6.14 not tested yet), therefore I do not expect any revert in
Linus tree.

I am looking into the details now, to be sure about my finding, I'll
confirm you in the next few days.

If you prefer to not wait, given that this fix was just improving the
performance of a specific use case, you can just revert from 6.12.y and
6.14.y.

Francesco


