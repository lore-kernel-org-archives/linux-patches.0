Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435E26EB56;
	Thu, 25 Jan 2024 17:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706203665; cv=none; b=fxo4JSQeRP+nRFGjjiGG+xUoA1ux61nz1/hXM9Yylj+BJZTWoaWOygTDfIguTr/EmbTNHQDFlND8FV+qcoErOXoxCEum4tfM2RqqeLCsMzcHBWoLebSe3SMt+CCb3Y9ykEakce8v3IvyKopArYTMTZNLyFfK493nIf0yuMrIj6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706203665; c=relaxed/simple;
	bh=frJXwYuw4yolEPivsRKSZ4um4j0KD+rekbxMet8UWOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NP4YJ8KX1wPtSdlTuJ1hrVHx42maTIN4hWDM+qi7meUMtx88JXQj9AohEtTFamP8ZiK9sivngH4VRLX9cdqER8hDGkS0hK53nxDhdOyqDmrB+g3bSJIqmhurvbBpsYQXKqQ2UJ7+VfxMQW4U1g4DJS8YSEvW84TUT/QvRDfaeJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+W/aBLg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+W/aBLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0ADC433F1;
	Thu, 25 Jan 2024 17:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706203664;
	bh=frJXwYuw4yolEPivsRKSZ4um4j0KD+rekbxMet8UWOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k+W/aBLgvBDEMxtNdB1XG8JH0HFTql8uCVEbbZwozlPB7eiT0eznRtQHdW/VJYgTy
	 iBmAaN4+T1xJhaeUA2/MopPjCC40Fk76pAiAiz8DV5jRMh7iQ4/Kow9iijWs50KMoa
	 QDOhhiybgzDrYrFdHBvbqPPdJrIgyFpC5unsu9u0=
Date: Thu, 25 Jan 2024 09:27:43 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sjoerd Simons <sjoerd@collabora.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: Re: [PATCH 6.6 132/150] bus: moxtet: Mark the irq as shared
Message-ID: <2024012525-hastily-stipulate-11c9@gregkh>
References: <20240118104320.029537060@linuxfoundation.org>
 <20240118104326.164425257@linuxfoundation.org>
 <d0e3c99793d981c5ee90aa7457e480d83fe9e8de.camel@collabora.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d0e3c99793d981c5ee90aa7457e480d83fe9e8de.camel@collabora.com>

On Thu, Jan 25, 2024 at 09:24:31AM +0100, Sjoerd Simons wrote:
> Hey,
> 
> On Thu, 2024-01-18 at 11:49 +0100, Greg Kroah-Hartman wrote:
> > 6.6-stable review patch.  If anyone has any objections, please let me
> > know.
> 
> Thanks for picking this up! To complete this fix the following is also
> needed:
> 
> fca8a117c1c9 ("arm64: dts: armada-3720-turris-mox: set irq type for
> RTC")
> 
> Not sure if i missed something causing this one to not be picked up,
> while the others in the series were.

It's still in my queue, I just hadn't gotten to it yet, sorry about
that.  I'll queue it up now.

greg k-h
