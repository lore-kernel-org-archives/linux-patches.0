Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C6D53819;
	Tue, 20 Feb 2024 08:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708416973; cv=none; b=C1755POOkiuMcK1usMbWZrPchv2YxEpufOeQRryAI9O02ujLXc+gF3E7MhPg2BRiuEloxky3pL69R9k7MQeZUTpUIPfUFfI+6Q1Ws82BV0oSh1stzJRtBkTeMYQR2ffjqv20XeMx3LdXvC1wBP6Dz60RbAF+wjus3/itd9zpUtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708416973; c=relaxed/simple;
	bh=pVCYDmfneMY62lQgQwPPW3z78UJse8fVQB3vd1YwRjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MUv+vH8CC7/nRoAa1ajeo/TzDrJCRZP3VGNVSSN+h6fpQLqyeFNIAk27kHPwPWHoty8/tojDh9teXE8vYGOb3OSZoM00TdQvZlajHO70a4IUBn8/rAmfvmn54hoS15hreZfB2yi3/2/atECKYlNqmNJbyW01GHYOfNpOgk9SbBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qYozbIQO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qYozbIQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA45C433C7;
	Tue, 20 Feb 2024 08:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708416972;
	bh=pVCYDmfneMY62lQgQwPPW3z78UJse8fVQB3vd1YwRjs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qYozbIQOSK2rEkQCG/1xB0lScZDwfEmYACQKm0luEGGWMLhwjWqvA+5jXIdU2AMaR
	 E7BpqOtxhrdI7bG2R2deEsI+rvTMaZReRRU1O8wbGNwvsvbTsK8p8x+t7zsj/k4+8O
	 qebmuhmnyJsGVIKJGnJ33MVj+C9CNht3AlpPKTLY=
Date: Tue, 20 Feb 2024 09:16:08 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>, stable@vger.kernel.org,
	patches@lists.linux.dev, Frank Wang <frank.wang@rock-chips.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 6.7 093/124] Revert "usb: typec: tcpm: fix cc role at
 port reset"
Message-ID: <2024022003-doctrine-java-f6b0@gregkh>
References: <20240213171853.722912593@linuxfoundation.org>
 <20240213171856.446249309@linuxfoundation.org>
 <571afc70-dd77-4678-bdd0-673e15cdd5ad@leemhuis.info>
 <2024021630-unfold-landmine-5999@gregkh>
 <ZdDS4drripFkFqJp@finisterre.sirena.org.uk>
 <2024021752-shorty-unwarlike-671d@gregkh>
 <e8b11fc8-6c01-41a1-97a7-9269fa95a990@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8b11fc8-6c01-41a1-97a7-9269fa95a990@sirena.org.uk>

On Mon, Feb 19, 2024 at 12:40:52PM +0000, Mark Brown wrote:
> On Sat, Feb 17, 2024 at 05:11:28PM +0100, Greg Kroah-Hartman wrote:
> > On Sat, Feb 17, 2024 at 03:38:09PM +0000, Mark Brown wrote:
> 
> > > This getting backported to older stables is breaking at least this board
> > > in those stables, and I would tend to rate a "remove all power from the
> > > system" bug at the very high end of the severity scale while the
> > > reverted patch was there for six months and several kernel releases.
> 
> > Ok, that's different, I'll queue your revert for the revert up on Monday
> > and get this fixed up as that's not ok.
> 
> Thanks.

Now queued up.
