Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC6D9461
	for <patches@lists.linux.dev>; Sun,  6 Jul 2025 07:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751785445; cv=none; b=oXD475qfJtadqkB8mPgNlVkV8d46w78GbcZq+4jwHqG8usTEFdaDzDE6CL22t8BXBucwEpaRCuiHDCWONNnWQiBr1FPxSz6O1laeA9R2pBm+Bl2F5TFK9reB2oiP2nYxr5wbFDofC3+rP/UqPBPlaOf5jhr+ylm0JjIwKvHYXFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751785445; c=relaxed/simple;
	bh=tIW2QsSmNEL+um74Cvk2T6yirueoroXegaoddQJ0WNM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dssNHTs9fPk50NQq+iMMOz9+6oFgWRsG1Szzj+OnZHu94pSufbNYQSFXC5BCV8uiCrlJ9XgRz+fH6t0x3/3ZKi0hhIF8cukfsnJVp5X+wIPpMXUbAjvun/h6AHa+NhfaI2M4R9PSSmlMDE8HfXfybiInFG/ax0zwqRtpkUKBvWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=sRZCiQyd; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="sRZCiQyd"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1751785441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oRqMxkI11n7UBiC0P+Ck7uadJ9+aqSc0JyhAsyyAKn0=;
	b=sRZCiQydf8z3I6Lf7vlw3aBYnpFY4obchhJMu5Sind4mFx3ZfLTOA3/jo08Jb+PVq+MRYA
	fLjsfvjgBFVKwzDg==
Message-ID: <fccfc053-12b9-445d-891d-b17d77993423@hardfalcon.net>
Date: Sun, 6 Jul 2025 09:04:00 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250704125604.759558342@linuxfoundation.org>
Content-Language: en-US, de-DE, en-US-large
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <20250704125604.759558342@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

[2025-07-04 16:44] Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.15.5 release.
> There are 263 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Jul 2025 12:55:09 +0000.
> Anything received after that time might be too late.


Compiles fine for x86_64 with GCC 15.1.1, and runs fine on various physical Intel machines (Ivy Bridge, Haswell, Kaby Lake, Coffee Lake) and in a Skylake VM.

Tested-by: Pascal Ernster <git@hardfalcon.net>


Regards
Pascal
