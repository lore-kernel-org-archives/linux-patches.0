Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5906E255E2F
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 21:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744149523; cv=none; b=S6ydKq17Qk7Y+KMIdsgKcr/NxuUGOblt9Lh5LFTEOINa8WtlSworsQ0G2SVyRi3wbDYu/UQDFW4QlOn805KNbcSKat6rby/KqI5RK4TFbyB5SxPJRrWazJZTIK/t//7ECngdechvfUUvCWvQ+fp1CWYUt/7F0qioidlT013HMWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744149523; c=relaxed/simple;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nWc/ZTpf9wyNILph/n+SFY386mzL9OvTGUP7HUIQ4NUM8nhyq4Of/vCqmdgjRyxH9dZivQixUzWoD5dF8xdVAv+hk7A4EZZgCZORlCl/k0LSwE33SuF2npLLqzYq39Y4xxfzDkT4irIsw19hCPqt9cp1sN5V3RWNyiBYBBfm0Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=LrhAcCGU; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="LrhAcCGU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1744149508; x=1744754308; i=rwarsow@gmx.de;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=LrhAcCGU72NTdllavFWgkIw5YODVitP1AyVrJHQKeCouPKLDuwpAQT+TGkex+qJj
	 C4XIOWakcFlvUQpFC2VOO22X2GfhDjrohJ6s+ppsV1q0S97VlNxMYTAKACgxqbWmS
	 rSvw2PG6I9ZQ4Vunhb5WZTjzydRjYVMedoUJmbla7x7Wvl7SZq6MgeEqlGBcBmVkj
	 sdW9xK2XU3fV4wJVgJuv3os2dAa10tZOpKom3+c9RbdCaxtIqGqy8BgjNEbQsb2d8
	 uefew11tBPTUcmgpfREm7IywqRL83FQj7yc53lfeCxSEtEjaEziQOUvPP2fPUb5zd
	 uRBeDjTX1UgTI8ul3Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.33.88]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M8QWG-1txr7L3Ue0-006dVb; Tue, 08
 Apr 2025 23:58:27 +0200
Message-ID: <d88f1ca2-95bd-49b7-b73b-95d87f18f82b@gmx.de>
Date: Tue, 8 Apr 2025 23:58:26 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/728] 6.14.2-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250408195232.204375459@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250408195232.204375459@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:wSwSTIaSEpoC/UVnroQbBTEhUSqml79b6tWgLqkL9aA2RL99GHb
 gimaCkxDh+/ViSQToStDJWCb1btwstETT7APG9EMzMyoMT6mbCgeqigtLDSoD1G0kgtm/GQ
 Tlkg6BH8qJKwZIAGl2iR/9jZAGZ8MWSjXOmh7AyaLWHRJFnLTsbhi+FEkIxDFp2EZBr9VR2
 iuDKNw8fkyFG028o7kCkA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:99jK/KI/pSc=;5Ur4d1uh1VE+6IBRkhSx6o1HMJV
 YVTEXab7hOPuipwt5s3teW1HVO2gXfYMvUhiotkPtBaT6e4xBVXEfROKWY1g1ORcJ2BOSrG5t
 f6OMrmmrJJllXWC3deGlqma04SOyvvvR4lKhkqNnLYTY1zKWG/VBvnSRNXOGXwG90+ZCfuXXq
 nXfMjfTTGFpfxoH7xE/kjI2osHkvCnTZqIQhQ76lSDJtleL9o1LlrxZS5IFLw28hsnVJr+2F/
 6GBLVtC/ZLlf6kUkD7JUox10I2Z8cKflpB9UF/PmUoHWnO+Pc/6SoIW4WpthZRjlxmprObxgm
 HYhPC2zozPLEH2z1Lmrou05FDZC7X5ySJ0+CUxMRd/GTuYhSCClwhpbhw/0fKBluPQBtbddaG
 3RV2rKx5LY61YmUACxJdYgdYEH9sOI7+EPqf0Su0wvx8dEsekkrt4A8QYMcBvCcg7yd1pPy4B
 Pk6GOx3JHiMJrcS6tqW0gQBHoLW1gtpLmRCk0z9uuZBLJjdw5n93Y2mFKxfCyWOhaU5wHz9QW
 x36AvImowgEtT6B6sxoi6NrDj6EMdqJZ1ny3RXcvQL+RTjGgMCJ3cCTsaFIFEQ4nAtTPDCPg4
 YVlNWFXCbnd/Kd0IDUY16Y8hcaYIudGODPwzEAe44Cg5ftEDdOektzNLq65N4ZKKKDS3HCIL/
 qmbdrr3jTI9cD/AJXkWmjBNTCshX7ONc6P4jEfocwAKjGumwqeHdmfHcBGjoIuhYetjfV6IVF
 WA7Yh76Ac/3Imeqy8+61jdaklU5bARGm65TedESszxARpYHhygMbR2ZJpDIvSY/mk85p/CyLi
 qyTBRQFHWLDv/JSDCyW/bTTTApvLi384VxE8WAyY+UE7tj22YZGu5wzylHGhKS+qPDmq7wfFx
 LoV/hCKvYQ0UeaCHPoVwpgquoCMxwSyyBt/Dl7r8iw2H1LDURqC5gqQoBtaXQNC4dEfzNDznK
 JBaw2pyge4iCQnTZ292WiMNLKRnjR8UOftfG+ogjZBbzQECtCi9hWMJH7sRK6sd9RauEzLxy/
 K8/132ID1ajyx142JWqyjEzBdOyn0GqtfBBN5oMoiGV+bZAcUrP6kpFKBLe5BN4iel09Ho9Hg
 YiByn/9/nIlflTJx6hrjZsfh6/lPcjSP6DhCvcTH55GYEB8xXxQksHFAoLVKyDrwQG0agCi1k
 RjzmOPEQ+aHeXNS0ofkX3qEoeJpQgf6GdKM5JTetQ93b3KgxKx/9DCtfEiEDWYjE3MliE6gvV
 gFsiBxP6Nt6/cQcVOEW7+9IwOCERwFa9tsLGnOBsC37X2bjYlUSgD5cliAC/DRDqzStgJGuCw
 l7CqNcnH9ujfzfouJZuBCq1S67FUL1CcqjLwnXL2T8lWcbGKprq+FpldQUbEVy5nNhvNweD3t
 WbLI7Z5GZPaXHxPPptD+cbiG4/dn8D5zDns0opdzr4SqSCVoClXhmLuMqI5Tl2ap+ECBB4foM
 X0YbjYSs7CUcEtr1j+jt+weB73Uc=

Hi Greg

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

