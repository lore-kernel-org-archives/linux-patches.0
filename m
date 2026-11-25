Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626609;
	b=Wf8DxkiRhXRySzfSQqwyYx4FkMMgmGbW9ysRHzadMxcpmnwUudGFSRE4Ojq1DIWyIXHj
	 /o3quO45ds85mNv3xPNOfAnXbLaoaWgwYuHGUZbPwW09NZvWAcKPQ2V1RKqmR5Ebhsxl6
	 bj64BZTbW92xneW2/xgwoAnE+vawOBqggbf1VyIx1teSXn3pozYUoWypXNrY0Yeg0AdhH
	 noPmzF0mj65hDamnDj9FFK1GUAa3LL1UC0B1D/vDtr4C02p1NN8DtQ4wKGoI+K4AyqyQ5
	 vJPHCdiJRJHJCfpnCAE/9wATq8/Z4f1p6VRCiaaFFVnqLVfAYikCllD8NRu21622r/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626609;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=FaVQnZI6ZMS+IYv1XvD2XTeoW1FyoQAxeBabXsTEqcM=;
	b=KvHEU1n26bmtkrI2NT7AH87kWz5+jfpCYN43tcM0sZscYLYXxgWtn2WUGHgUvDSgROmD
	 zMpE2Auo4az5xQ4dIv+X2riu4XBohcNS0BPzcZoaJcs7fDyg2JoS5SjPZUF+Xb1WEFMZ+
	 b4qaRf664yroMSyzncC03Ofg0KYLMAfQ12sEdmOPSTde0D1KxLsrXurVrScGykESN2U6Z
	 MWsNI85x41OefPQueFR1gKbN8VESbzVurx6vQn1Qr3kHIhOugw6jgJUU5+gZ4A3etjPfV
	 9qFJ8UaJB1JKKU1VRMe3DgMQblzFGy/josuHHDWzuzEioPGDhBCFihR0QqfiJcSxi3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TNF0BJyP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EB6606A31E;
	Wed, 25 Nov 2026 17:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TNF0BJyP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BAF1F000C6;
	Wed, 25 Nov 2026 17:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626609;
	bh=FaVQnZI6ZMS+IYv1XvD2XTeoW1FyoQAxeBabXsTEqcM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TNF0BJyPTpT2FBMii0iefCjQvlys7EnrIWDi7JAqwMgHnydWoKiYwm4vSiKkKY5s/
	 oLF7NIo0T/feYDVQjJAuugYM23dgQNuhryyyJA4vdDe5oCseq/mhiaKUOEogCedvex
	 Zw0LD5MjgFGFrBeKOH3lHC/Dsd9Df12FyayMeVFo=
Date: Wed, 25 Nov 2026 18:10:29 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Brett A C Sheffield <bacs@librecast.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/990] 6.18.66-rc1 review
Message-ID: <2026112522-prankish-audience-6229@gregkh>
References: <20261125143822.072087159@linuxfoundation.org>
 <awcOeGCwL3jSzG5f@karahi.librecast.net>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awcOeGCwL3jSzG5f@karahi.librecast.net>

On Wed, Nov 25, 2026 at 05:36:08PM +0100, Brett A C Sheffield wrote:
> On 2026-11-25 15:22, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.18.66 release.
> > There are 990 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 27 Nov 2026 14:36:57 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.66-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> > and the diffstat can be found below.
> 
> Similar build failure as for 6.12.120-rc1:
> 
>   LD [M]  drivers/gpu/drm/amd/amdgpu/amdgpu.o
>   AR      drivers/gpu/built-in.a
>   AR      drivers/built-in.a
> make[1]: *** [/usr/src/linux-stable-rc/Makefile:2051: .] Error 2
> make: *** [Makefile:248: __sub-make] Error 2
> 
> Reverting 4d1bfec69f617f91af00b5cb9b86cae8850049ab fixes the build.

Again, can you show the real error?
