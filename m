Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059136;
	b=35t0o4ohUrbLslcgdscoiGhZ90TT6aLKpX/5+3OSPGw+z/9Vl34iC1h3LypuEfkPzx3M
	 5LJRM5ADqqX+VBatTh3eBRUwhiemKe7AEvLk24NyAsdIHIuIizvcAU8bJ9em5iT78ej1p
	 rHF22EGrOZ6HBv3bguZUGXLHn2TMDLBg/ju9T0RZXx+dkU/vZ7Fzs6pcovWuf7LdwM900
	 a7kTNQhL9ZID0hXjyvBRmEhFJX2qY53cAimQVZEup/zR5oca7k9PVCiZxBImtrr9SDbnv
	 BRLqgHIDzugSd53y0tZdA7mjmdfOMQJAlmygiBXSWbgfHIDlW49wD4Ds54IWBPBmPvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059136;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=pAo0sgsxAqoikRuu4Qee0vGiWqDOqsoV6WEE8Ptn/HY=;
	b=ak/bnNIY2hHE2OPI+PmCPYc73BP+6fR0bV/Wl1kqpRFf0EMMoYTcpXGO89s/au2Ba4OW
	 Pb9vlFrKMcv8mtmN0CwbaCzFZr3mtmYNF6V3qRCRR9vx8endW9CO0lqcZ68Zo8gIG0Ihw
	 v9CNMFECMknU2HaL+cD6uuuerfOsLA8JAL0eTYWAb3BZKUGdKhnA50+NznusK0T7uiiqR
	 K8RmzG00UMf8oHuRNlHezZRWBQd+eEetlahIjdXScl8gR6b/1zeA2yhw5BRSYx6Fu33Wf
	 LANrGyab+fEwiiQ2ZLLKBZDuIRJWMJRB0+2/1TAyi6pC85CEaosPLy40tAuMVu+JP8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=ySyqDPo8;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75D6606A320
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 03:32:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D75D6606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=ySyqDPo8
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a35ac4475dso13210755e9.2
        for <patches@lists.linux.dev>; Wed, 18 Nov 2026 19:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1795059134; x=1795663934; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pAo0sgsxAqoikRuu4Qee0vGiWqDOqsoV6WEE8Ptn/HY=;
        b=ySyqDPo8joUTmlU6RyOlXtDqcATdptsQDcP1kpJ2hW0qkMGbh1LOeqrsNSCx54ZZs4
         zc3mneJ6ZigErrpgkgCh+n41iA78WtQPQrDCy89Qyqo6T4W32kZ4OIaSgL1kCbBURio2
         jMhYZ8e4QfZz+sdWID/qJSikoqrXuNFIgL5HGz8xBLvA10F8+YNSrXnMVeKin4KP0dXZ
         tcog9E3k2xIe2mG9OfSqczfwo+GlI7weqNfhvRh2HEvr86TyGVaM6D2KODmGXeqn1RJR
         I63iy+pZGagyZtILe6CZ7cixycmY2vK8EhtMLwx09GYJWwxWU13hJsYA2U9bxos139yw
         /OAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795059134; x=1795663934;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pAo0sgsxAqoikRuu4Qee0vGiWqDOqsoV6WEE8Ptn/HY=;
        b=LGi0Jh5aO2EYDyBPlJfS/YUYnHo2w0mo55wR/B822L4UPh5V888Dqa4PMK1nYeQUkN
         Fhy8uOlG3kcRr1ze/s/+IkkYr8IHaIL1xT2DpmXCTR4IzYl2WCW5toqUOSvMwHp3J9uu
         vVJp2rwyw/l3BFe65hxXdfeAtSNio8DnFoe0OZplOMQWEYWFCadkyGMQBATPCsVUKoOP
         aBOAMtf0ErlVzUBLBbVxY0SABx/3CCiCAaDiq/cUAJL65sd1COl+WVAn2pQOwhffWFgb
         e14U0RueAPKRGnuu5AkJ11BZT/DxQQOy0TePTfw/LVIXrxND1jnbabDRE/GyfJz+dpht
         Ks/g==
X-Gm-Message-State: APuU4Z9RCpEfbOjELwApfESqpR6Sa/NOrYqGep0aNukSPk/KqfrWmHfJ
	n/mo4wUEs5G29FrNsLhA740IZ+jHWK9Oxs4cNflOBSGJ9+kFglLCA6A=
X-Gm-Gg: AYBFou2T7SZIlABFhdUzknqi2eeoeLERsgOwxDtCosWcMAFiO8MuTkGbb0ev0hNG2SW
	+4+Mv4dwQyGsZs328AONeFn1RmeRHIZ1+QrsHvxWZZKTXmj3y55reQteyLAHsqilQs1Zlel+sPc
	jre/67aacWlD93VsIdV2qpUxI/brQEp2RXJ4oqbzi70X72e5LMm2zan6LLBIQiSaVKpe5vZ0uUx
	/Vf5TchSHpjiipKQpg1DEvlMsfiuCad29xt9doBeK2T4Zo6DD3Jj4eQE35OcGRvoXMkB3r4r1Y4
	+viRpbETEYUYjdVcThQIKjhg7nnqmAS2nHY+NBh9K+lJt4+or2kBsAHiUd4p+bZuW4c7vbIKKvw
	JyACLZ/FtG9faOJFuV7BC+Fe5YkwyEtvVOnxdYFPE/8/+19Iclp6ZZ2bY+Ad1TBU01YQ32e1K7g
	UsvrFKI6g+trOaeFyZm1buloVyUTuIOGhfWDAm1HgDb9LwU11zonU3b4GzCxb/mx6eReG2Wx42+
	L07gX6sm4fUDoZkJh8bjjISRypvmfpTq7tz9Ihrzf2VVZS+1fIuHSyNJta0Nz7rQ5Z9QZwnKcBX
	vhj7h8qo7VLRofBq1qhV7on1ELb9vPmwUo8YiR7ZaUlk1Nm5BHHSFwvx3n/8LQ5eTbUEMp7znDr
	gGaao
X-Received: by 2002:a05:600c:3e0c:b0:4b7:6b96:e431 with SMTP id 5b1f17b1804b1-4bb7da458eemr92432145e9.28.1795059134175;
        Wed, 18 Nov 2026 19:32:14 -0800 (PST)
Received: from [192.168.1.3] (p5b057d66.dip0.t-ipconnect.de. [91.5.125.102])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8532f1a9sm3566085e9.3.2026.11.18.19.32.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 19:32:13 -0800 (PST)
Message-ID: <8a4f9aed-be54-41a3-acd9-d25458885ea7@googlemail.com>
Date: Thu, 19 Nov 2026 04:32:13 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.3 0000/2651] 7.3.6-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261118150247.972732815@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 18.11.2026 um 15:20 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.3.6 release.
> There are 2651 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
