Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D033915887F;
	Tue, 25 Jun 2024 12:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719318303; cv=none; b=KIrGLodt85P9WvpZU/ajlj8UDQMF7knIYTvAj0nnLe755oZ+T/mGWI9A0PN7nw55UnwqEAbspDCHw/IOvb0YVmTyMip2UU7uxFSfwvLZlpQaMSa2LdQZr1TYlWnhayVB7AIIDQD2Ap+p7ETeuENAoOd6edOWPAHIcD8iF4fM+kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719318303; c=relaxed/simple;
	bh=H+4M0Z3fHDY/YaBJDOxxrGAUP+kl5BRhtqsJhBEgaV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ch1SaP+hkjaztvSZmMq2fkHVbLXuxptdYBSjY1oT5csKRf/sjSpYG9Ya87SMPGXIzZwOFfophP+2NXm/USqOtqmLsN2prppin4dA5yK/lAQDBzMTKn6sf62VBWX8KNIrkYCHurp/7cHcAUUrLvmtVPc3AAeojoVVf4RkT2oDFA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HT3swzvj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HT3swzvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091DEC32786;
	Tue, 25 Jun 2024 12:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719318303;
	bh=H+4M0Z3fHDY/YaBJDOxxrGAUP+kl5BRhtqsJhBEgaV0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HT3swzvj0cyZVZ2VDv3W7+LWwuA8xTbAs2wmUab/LhMsbTgKmWATTzBbNn4hpPIUH
	 +ePsyZiWaym7fhmJz93oXaC20jbcL+Kdvg23nQBrbu6rPjmA7f4YWYT2SVBqG4gQYk
	 lYY6fxlfaetloWJpLPTZb2OrktvUfGauPPOHI1Tk=
Date: Tue, 25 Jun 2024 14:25:00 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Dave Airlie <airlied@gmail.com>,
	"Vetter, Daniel" <daniel.vetter@intel.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.9 238/250] drm/xe: Use ordered WQ for G2H handler
Message-ID: <2024062554-caramel-capable-04e7@gregkh>
References: <20240625085548.033507125@linuxfoundation.org>
 <20240625085557.190548833@linuxfoundation.org>
 <ZnqyGW7Z9i5kJICs@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnqyGW7Z9i5kJICs@intel.com>

On Tue, Jun 25, 2024 at 08:03:37AM -0400, Rodrigo Vivi wrote:
> On Tue, Jun 25, 2024 at 11:33:16AM +0200, Greg Kroah-Hartman wrote:
> > 6.9-stable review patch.  If anyone has any objections, please let me know.
> 
> Please drop this patch.
> 
> Same as:
> 
> https://lore.kernel.org/stable/2024061946-salvaging-tying-a320@gregkh/raw

Now dropped.
