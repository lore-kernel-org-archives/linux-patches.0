Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BF81EB27
	for <patches@lists.linux.dev>; Wed, 16 Oct 2024 15:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729090868; cv=none; b=f+bFCVNbuffwPAb4KoiX/XtoxoI+FNCp9q4YwLBFPocuKNLPyYLPeEfxFQ7Rvq/fa/45QaCSf+sBtNeNj9Tfnbv3U+riDBoh6cRp7Q763FfU0mDL0gOm4vdA7/uCqIz7Fylrc0VxrY7cEpMmjOwZa9Ltcpd5ADEdb7FWmL153bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729090868; c=relaxed/simple;
	bh=mWrTOvMizslEnDykw+dBZu1ol8ORpgVyFabRsoAdpp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jkKbC6yaNiW+GdBz1cqq/UAOu7uVYXEHKqJSxTl8Jv20st1UjyAbUUIyg5S/vWJ3lHEgMGRiL3lfdJyGX4s4bSfGdkFa29AkbePSL3bUndjJwMf7esdJTWUKDPbo0XaN+4Ks4Mb7XOj1pvZNZldp9IhBv1rqYOMhGLmN3nBFmv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMJ5nzGX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMJ5nzGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF514C4CEC5;
	Wed, 16 Oct 2024 15:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729090868;
	bh=mWrTOvMizslEnDykw+dBZu1ol8ORpgVyFabRsoAdpp4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NMJ5nzGXvX1tGouWQ+IKfsWKmehUcaf38c49iRLWBQxl2b8467dN40uUvQjkmh9es
	 wjyND/s9Za5PsJa5xoPziFfr+koqFWPbqOk98RMdRWTGM8I386Qq8B8LtvhJ+OULuB
	 gSD9FDa2vBh6RFnjmM66sYmWfWzfVFeHDjD/LgRU=
Date: Wed, 16 Oct 2024 17:01:05 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH 6.11 076/214] drm/amdgpu: nuke the VM PD/PT shadow
 handling
Message-ID: <2024101628-freehand-copartner-07f3@gregkh>
References: <20241014141044.974962104@linuxfoundation.org>
 <20241014141047.955176387@linuxfoundation.org>
 <50cea54b-dac0-4f41-b7d5-1c7e71010597@amd.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50cea54b-dac0-4f41-b7d5-1c7e71010597@amd.com>

On Wed, Oct 16, 2024 at 02:01:47PM +0200, Christian König wrote:
> Hey Greg & Sasha,
> 
> I've pointed out before that this patch here shouldn't be backported.

Yeah, odd, it shouldn't have come back, sorry about that.

> 
> The patch just removes an unused feature on the current development kernel,
> but I can't guarantee that this feature is unused on older kernels.
> 
> Please don't backport this!

Now dropped.  Again.  :)

greg k-h
