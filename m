Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371681A071C
	for <patches@lists.linux.dev>; Sat,  2 Nov 2024 17:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730569329; cv=none; b=tnI4YZzJbPypDddrMy7HlvPgrhvIwKPneOlg0ckKnKb5snQljEoYfwZ0RgfZMw0U8fr7EiDiZ5dI33+kw7sfL7DRXxekFsKjYTgQDOZ+bVWnbzy2iCH/qP5kAhwKum+NDeDGZ3Klx12+vk/5LzLcRkeGofKRHTb11m1Gjb+afuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730569329; c=relaxed/simple;
	bh=X4PrgvNqEsLsZEbibqbp3Ijd028HuCte3GboZT13m5o=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=o9AAo2DPNucfzZQBumFPP3u3+tUwMWdoXn03uV79a4yJwKvFqpVJTykC5vAKruYgw3KxHPbHFHiibnPocpqBVuek5Sc2dRCq/HzJpp5tqMT5KakOSt4PFL8PxQrAusNTRwVE21ZuheFxoKffzIVEnaEZy1XIN5eK8cQOn9AGJDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=sls2Cemi; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=0o0nSDAS; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="sls2Cemi";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="0o0nSDAS"
Date: Sat, 2 Nov 2024 11:41:53 -0600 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1730569326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X4PrgvNqEsLsZEbibqbp3Ijd028HuCte3GboZT13m5o=;
	b=sls2CemiRYb5Ux+HsOjX5+N1Yf9SeYmGhvBdflkdiFQMXw/8oIm5zfTj0WQRrslJMBCSps
	DZSFAyl9rNy94nCJkxAvh13f63Mem4tfuLJTUm67HNm1aTxOiQsfz9QDxpjgN/bM5+/b9j
	6wWcbbtJqUKqqG9h7B+Mn2BHXr5C1D8gZ8zsaR5gz4RPbP9YDJQ+J1h4gn85jwsY7KJa5o
	ioShtT+woy1O50iWRN7rC71NNYE6BFr2RxS+Fjq3EcZZOKi5ek1g+8MktgIIq+9htPd303
	0FeLBxAKIaOAmp9gs9c4lj7cRhdCU+7ZALMjYRsNpOIPBlGM350SH6KkERuQ9Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1730569326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X4PrgvNqEsLsZEbibqbp3Ijd028HuCte3GboZT13m5o=;
	b=0o0nSDASgsZhfyGUztEdwoCduh7Tb7cQSyshIjff1zxZdYOo6p0/Lf7ZLw1i+vgpDOvvCq
	Z/Amq+q54YBMhoAA==
From: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <d32d5890-34a8-4362-8feb-218182583083@linutronix.de>
In-Reply-To: <9c54d0ff-15d3-4868-afba-ae3ccde28a41@roeck-us.net>
References: <20241028062258.708872330@linuxfoundation.org> <9c54d0ff-15d3-4868-afba-ae3ccde28a41@roeck-us.net>
Subject: Re: [PATCH 6.1 000/137] 6.1.115-rc1 review
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <d32d5890-34a8-4362-8feb-218182583083@linutronix.de>

Hi Guenter,

Nov 2, 2024 10:46:38 Guenter Roeck <linux@roeck-us.net>:

> On 10/27/24 23:23, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.1.115 release.
>> There are 137 patches in this series, all will be posted as a response
>> to this one.=C2=A0 If anyone has any issues with these being applied, pl=
ease
>> let me know.
>> Responses should be made by Wed, 30 Oct 2024 06:22:39 +0000.
>> Anything received after that time might be too late.
>>
>
> [ ... ]
>
>> Tiezhu Yang <yangtiezhu@loongson.cn>
>> =C2=A0=C2=A0=C2=A0=C2=A0 LoongArch: Add support to clone a time namespac=
e
>>
>
> This patch triggers:
>
> Building loongarch:defconfig ... failed
> --------------
> Error log:
> arch/loongarch/kernel/vdso.c: In function 'vvar_fault':
> arch/loongarch/kernel/vdso.c:54:36: error: implicit declaration of functi=
on 'find_timens_vvar_page'
>
> because the missing function is not generic in v6.1.y.
>
> Reverting the patch on its own does not work because commit a67d4a02bf43
> ("LoongArch: Don't crash in stack_top() for tasks without vDSO") depends =
on it.
> Reverting both patches fixes the problem.
>
> Copying the authors of both patches for advice.

Thanks for the heads-up.
FYI there seems to be another patch fixing the build failure for 6.1. [0]

FWIW my patch "LoongArch: Don't crash in stack_top() for tasks without vDSO
" is not critical and can be reverted if that is the chosen path to handle =
this.


Thomas

[0] https://lore.kernel.org/lkml/20241102033616.3517188-1-chenhuacai@loongs=
on.cn/
