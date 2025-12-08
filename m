Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4159D217F31;
	Mon,  8 Dec 2025 23:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765235586; cv=none; b=rVUW1MicUm6IF/YADaTTA8wv6/jGpvirfE0VSsKyRnmosfl5/VaqXi3jGujq9Mzkm28ArZSbNAqlMK6sgTjKzMu3h8ug60RP4I17z2TDFZvdHMM1mQovQ7LBN0YeBFdiDbPRwe46OySmU6cPzmnyzTuB50siSsbr9DYQdaK2aJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765235586; c=relaxed/simple;
	bh=Cf2YOykUUPZEXczjQ52eaCziQlE499P8AUDCYeKReiI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=twMuuAp2hg2CRN5RlYuYtT6XgDko1HPzRfEVOHNz9Hc/CpUTesbW8XuCdOmxD1eE/6vlDUDpcZHQzZdb9age6NOiYScM3ilVqTvIRd55qcvfXARfV9JxDLeaZ3nXBuLU+0y5mUxOJjgry/qEjCULCGLZgj2xULMKHfEUj+Pb4es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lTibPfGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lTibPfGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B04C4CEF1;
	Mon,  8 Dec 2025 23:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765235585;
	bh=Cf2YOykUUPZEXczjQ52eaCziQlE499P8AUDCYeKReiI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lTibPfGQbYWFfKb2bMHVSCbZHlX52DEb7/uJD8DJ2pQBerdfcA9JD9YM1YyYIP2js
	 n6KTO3u6sxfISFn/PRE0vxjkwOocHYB029RGlOkDc0xBHczrzQlsWRUZzqa896TgaV
	 P4O7cZ7qLFR1jlJMbDnR+lU7zHZFm/Z2QPH82jYE=
Date: Tue, 9 Dec 2025 08:13:02 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: "Koenig, Christian" <Christian.Koenig@amd.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Liang, Prike" <Prike.Liang@amd.com>
Subject: Re: [PATCH 6.17 129/146] drm/amdgpu: attach tlb fence to the PTs
 update
Message-ID: <2025120945-humming-uproot-2979@gregkh>
References: <20251203152346.456176474@linuxfoundation.org>
 <20251203152351.182356193@linuxfoundation.org>
 <725a5847-9653-454e-a6f6-5e689825d64c@amd.com>
 <BL1PR12MB514484FA812346EB147CDE9FF7D9A@BL1PR12MB5144.namprd12.prod.outlook.com>
 <BL1PR12MB51448F71631710E788BEB1F8F7A2A@BL1PR12MB5144.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB51448F71631710E788BEB1F8F7A2A@BL1PR12MB5144.namprd12.prod.outlook.com>

On Mon, Dec 08, 2025 at 03:31:05PM +0000, Deucher, Alexander wrote:
> [Public]
> 
> > -----Original Message-----
> > From: Deucher, Alexander
> > Sent: Wednesday, December 3, 2025 11:48 AM
> > To: Koenig, Christian <Christian.Koenig@amd.com>; Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org>; stable@vger.kernel.org
> > Cc: patches@lists.linux.dev; Liang, Prike <Prike.Liang@amd.com>
> > Subject: RE: [PATCH 6.17 129/146] drm/amdgpu: attach tlb fence to the PTs
> > update
> >
> > > -----Original Message-----
> > > From: Koenig, Christian <Christian.Koenig@amd.com>
> > > Sent: Wednesday, December 3, 2025 11:03 AM
> > > To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
> > > stable@vger.kernel.org
> > > Cc: patches@lists.linux.dev; Liang, Prike <Prike.Liang@amd.com>;
> > > Deucher, Alexander <Alexander.Deucher@amd.com>
> > > Subject: Re: [PATCH 6.17 129/146] drm/amdgpu: attach tlb fence to the
> > > PTs update
> > >
> > > Oh, wait a second, that one should clearly *not* be backported!
> > >
> > > @Alex or do we have userqueue support working on 6.17? I don't think so.
> > >
> >
> > Yes, userq support is available in 6.17.  That said, this patch did end up causing
> > a regression on SI parts.  I've got a fix for that which will land soon.
> 
> After further investigation this patch and it's upcoming fix should
> only go to 6.17.  Please drop from older stable kernels if it's been
> queued up on those.

It didn't go anywhere else, so no need to worry :)

thanks for the review.

greg k-h
