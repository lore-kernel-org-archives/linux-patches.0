Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D9D21CC5C
	for <patches@lists.linux.dev>; Thu,  1 May 2025 18:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746124085; cv=none; b=jYryi0DkLCkeLelu169ccgjKQd3yvpoO3EXtxqDebh7E8EYnx9vpBEq8PAtsjTL3c6g2eKuMNN24/NAPT4117ki6/XZf1SS5YgW3i1rg+sp/VO1Htny4etesDcFOgEdIMsSZ5LLWoKc3qtGCkikV8dEGWMDgg+rIY2GWo/AMfkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746124085; c=relaxed/simple;
	bh=OvPMEuQ46il3TskZUAK4+nulnbCgpZ4Cd2OcQ/G8dps=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l9ZBOjY0ciwfdenTkeAFkwnBS4DdMddu9lkLg/7Hjgfl9sxDE2tGIlQpah8SjtVHnXYmxiMudQvz5WvZRxJ8wZOjzVJ8HNnhdc3Hs4pbNV9T+NxDADzkP/KuaDhBDxQWBzNvvQePPQo0FCrI8K3DL6tiW/vXGUB7ZOzlPPePNpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=lYiQ3uha; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="lYiQ3uha"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43ed8d32a95so10173845e9.3
        for <patches@lists.linux.dev>; Thu, 01 May 2025 11:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1746124081; x=1746728881; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ziO8mDy17x0ZX+4RdFsifgUHBBZZisRMepgvXhKJJxg=;
        b=lYiQ3uha2zdd9xMnewJBFCqma6Jw7Luowz3GAlraRtGj18YM6SemUUkIDswTui0chG
         ftkqROeDRK6/2dm9trlc7uPa4f3d92iFlFNaRJWnBJanNhSJdpFRz2xfDQwXTUy8rDHR
         yHIpgagaeVd2+hy3tCJ1WDeuBcrIbWalkBrrlViBkOQfy6E+jdZo1F76YapHCTDSGbZV
         SZkqRnOVIQoAjRg/ZHr3YFjmyYYVjuUpGhWG1Ht5Gkw3rhcl9UdTH33xT3o9Yxd1BgJ2
         paSxiClOQa/YTb1N6W7JaCTY+0ZY5jY8fcq9PB19xDYo35NRD1aLayDaLJK7Qm9De53i
         m2UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746124081; x=1746728881;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ziO8mDy17x0ZX+4RdFsifgUHBBZZisRMepgvXhKJJxg=;
        b=lP9wGswbaFqvMdxoTA1ErLJHPd6gnoOQstEYubyX+lzoPZBZCK7UTQJ0QF8SqWafRS
         HGCIvIpsXigPaH1AXfp3jkNSClFSsF9WB/wjn2dDoYplHUnsOALg4vqxlgnWk63nfSSh
         IRCSxsdqsdM1e3XwWL2GM5vhiF+ne5+amX8HAnsZtliFfbXbiiu5Q5zRE2vaI0AuCYv+
         xlIqSN1hfueYqGawTy4jqexluyHX90UPKqmzk6mtAShxOhaXiKOoPTjzXkGL+2835U2p
         mLwdpP64AByF44wRu8xA7TUf61bvjNfoJxkBMhCe6sBu3vISSm/MdxTdxegTsnFPnNW1
         i3bw==
X-Gm-Message-State: AOJu0Yx2yhIh4f1MV3jSPSM5NLZOIHRsq1jFj4e+bhPeDpffvfwmausn
	PgrP+vmM7Kh3A/VFj0SMnlRc5RKRqN+ZmqzxQVOWgJ1ssUurW24=
X-Gm-Gg: ASbGncvNYY1bGA1H71hcL9nUDlXQ5TMXf35vkUeu8aPTaZVdoO8TXGfRNmFOTWSa/4B
	nj4NLueWe/veo4igYvl5dwqIDwzWRAB0QGw+NJ8dLd1Td2sc68p/0e2mMkLbGb0vihQzgQZs6Qj
	/jrEoPH6LN8Ru807iKqyPjuxZahmzLk5qXyyXxpdU6jTeBFqXizShEuMo6YggNGqUEui09PqKLH
	DO0AEkx2ecOP94c1PrcDBjK8kj70aCVjOoI/DIe0gn+nS+2qjOcdZ7CWFNNOMPKJpRJTqGjbDlH
	4bIconOlEhUksiyMp+JNO3CNEaAZdEAedmQ1wQ8tPP9PFCvDXRdwi3sAC69O5hkVNcqXG/hvCMW
	S6LCATQD5BbLFFEz6tg==
X-Google-Smtp-Source: AGHT+IE0vFV95HheCkKVFzX8joqpHJeWx/EZFT2IHqGfh47jshQk7bRn/7pHku68lkBSbrioTy7maA==
X-Received: by 2002:a05:600c:c89:b0:43c:f81d:34 with SMTP id 5b1f17b1804b1-441b7017eddmr29576555e9.9.1746124081319;
        Thu, 01 May 2025 11:28:01 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4589.dip0.t-ipconnect.de. [91.43.69.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a095a468e3sm1475143f8f.36.2025.05.01.11.27.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 11:28:00 -0700 (PDT)
Message-ID: <704e57d4-ba2e-4afa-9351-cc5496f7030c@googlemail.com>
Date: Thu, 1 May 2025 20:27:58 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/196] 6.6.89-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250501081437.703410892@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250501081437.703410892@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 01.05.2025 um 10:18 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.89 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 
server. No dmesg oddities or regressions found.

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
