Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4192F746D;
	Thu,  4 Dec 2025 16:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764865837; cv=none; b=Vr86CNqg6am07xO0gmddigkVoJh32mxs16n2LOQJVFhyeza8krrR34zzR72YcFSTUkwznctxFzh2D6HH+OpMzYmj+5IHYIJRf0izRc8cOsvBpMvPloPikDNLgT32vnj88u8vcMnb7/rpO3lINnvQKslJILYHllQbxXkBaGyeeQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764865837; c=relaxed/simple;
	bh=f3WMv3N5LqECui7C5uL8QRDByLseqNRjd02PewqXFKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C2dKGwAqDzwtr0AS9X1sFjevE/rlkjH/7GT8zOiD93VO5UM0C/ybIWH5WOd+QcLQq/pbaG3phta2Y+9nfJ7dq/mD21gXNmWKVAkqqWjpW1KlmmODrg8nJPN2CrcZBRiP61+e+g6/iLgdDQnf74ZhUbwnxdPjyCKbp6wna+XLOJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bcejqSFw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bcejqSFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666D3C116B1;
	Thu,  4 Dec 2025 16:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764865836;
	bh=f3WMv3N5LqECui7C5uL8QRDByLseqNRjd02PewqXFKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bcejqSFw1Hhkft2nMq+/0zGqY8Otrqtm63S2nOj3kPhQuVWhUO+PUZ52abt5p07SW
	 lUDtv0jcrwspT46xUWsIU+cy+a3R+M2Z5HELx9ebaJKA94q2ZL5F/As2vLAcOTlG+s
	 5AyXKFTxb+c+E6avT+jUund8GmJo90oo+6rEi2o0=
Date: Thu, 4 Dec 2025 17:30:33 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 136/392] drm/amd: add more cyan skillfish PCI ids
Message-ID: <2025120427-marrow-seismic-6fa2@gregkh>
References: <20251203152414.082328008@linuxfoundation.org>
 <20251203152419.094422510@linuxfoundation.org>
 <BL1PR12MB5144D48B9A9E384045157D13F7D9A@BL1PR12MB5144.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB5144D48B9A9E384045157D13F7D9A@BL1PR12MB5144.namprd12.prod.outlook.com>

On Wed, Dec 03, 2025 at 04:50:42PM +0000, Deucher, Alexander wrote:
> [Public]
> 
> > -----Original Message-----
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: Wednesday, December 3, 2025 10:25 AM
> > To: stable@vger.kernel.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
> > patches@lists.linux.dev; Deucher, Alexander <Alexander.Deucher@amd.com>;
> > Sasha Levin <sashal@kernel.org>
> > Subject: [PATCH 5.15 136/392] drm/amd: add more cyan skillfish PCI ids
> >
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Alex Deucher <alexander.deucher@amd.com>
> >
> > [ Upstream commit 1e18746381793bef7c715fc5ec5611a422a75c4c ]
> >
> > Add additional PCI IDs to the cyan skillfish family.
> >
> > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> There is no need to backport this patch to stable. It depends on a bunch of changes which are not in older kernels.  Please drop for stable.

Now dropped, thanks.

greg k-h
