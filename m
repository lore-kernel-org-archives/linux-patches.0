Received: from mail-4319.protonmail.ch (mail-4319.protonmail.ch [185.70.43.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC3D315D34
	for <patches@lists.linux.dev>; Sun,  7 Sep 2025 21:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757280840; cv=none; b=OAcLn/p7ld8MeavN7wAuxXPWG9zJZVQfgIa0QFs+QJ6KK7b3B4bt3Z3THBdx8c/a+Krjr61owA0P1vRywcmQHP3l6PH5YHmy8Oap2LXAaH8PcYvgqoZWCk4o3pVwtFiLaxrUXkhCwXGmceG3RDD0sxKM6J+FpN8y0Us5NIl+EhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757280840; c=relaxed/simple;
	bh=FyYr5/hk/gRito92bDyVwZ11iYwx4loOSjAlYoXIGrw=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iU22qaWj4f9etbfmf0VoAjFWXDDF7D+HlYaon24vowOUVc5T+geEej7oDfhYphHImoAK9HHmjGo79fDjjY8oEjQWEvTK/BkPQ+kA11Q0/LwO5ygCIXPBtp3bvkRn5MKwW0n+fzUJc2+wYygeFn1cWvg+q6D0nMy2OSMYMoxuz78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=g2aZz41L; arc=none smtp.client-ip=185.70.43.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="g2aZz41L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1757280830; x=1757540030;
	bh=FyYr5/hk/gRito92bDyVwZ11iYwx4loOSjAlYoXIGrw=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=g2aZz41LVjuGNXuCwSPbm2cef71gAq6OQ23fXNnPxIMgA38icF/yh/SI6c4jFXbWG
	 LcqIy0AYR1VBSyoaEc0czcg/K8Rtc5RaXOmgzWF5TgU3Owkfo5XU4ud3OrR1knSqxD
	 bAuuiFvx1YzJ1xyUHjicGWjfpBGNKSVn1GJZwZNuHvCOx1onEYF3RfsyPLLgGuR0Rx
	 t8PKbPMBxwtNG7JGTKJ0UHM4phZ852aJn//wZw9Bh0Zpn6+M7XpfMUKBLjxRP6cHuG
	 8305Ii7drQ1bXH/aw0rAUOa6xJNJkHk8+S/PHvcqCp/0Q5tH4tUIeeNgG1Vkv4NEpx
	 6MbFLVqDKLm5w==
Date: Sun, 07 Sep 2025 21:33:47 +0000
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Diederik de Haas <didi.debian@cknow.org>, Andy Yan <andy.yan@rock-chips.com>, Heiko Stuebner <heiko@sntech.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 013/175] drm/rockchip: vop2: make vp registers nonvolatile
Message-ID: <H3KxvGMniMkMPiHrpRDqCn2F7QdfdhNgkc4MJ2dt4y0L4ddta0HvB8xscoZLISq01mLVFg_o1tpoeLCBf8LgvfgIFWH_xBKxgOHerf-l9Dk=@proton.me>
In-Reply-To: <20250907195615.203313380@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org> <20250907195615.203313380@linuxfoundation.org>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: 8006cb735122e7bbb13204512b174b10fa93d2d4
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sunday, September 7th, 2025 at 10:27 PM, Greg Kroah-Hartman <gregkh@linu=
xfoundation.org> wrote:

> 6.12-stable review patch. If anyone has any objections, please let me kno=
w.
>=20

Hello,

Gamma LUT support in vop2 was added in 6.14[1] and even though this bug fix
does not explicitly depend on vop2 gamma LUT code, the bug won't happen
if gamma LUT is not implemented.

[1] https://lore.kernel.org/all/CAPM=3D9tw+ySbm80B=3DzHVhodMFoS_fqNw_v4yVUR=
Cv3cc9ukvYYg@mail.gmail.com/

Best regards, Piotr Zalewski
