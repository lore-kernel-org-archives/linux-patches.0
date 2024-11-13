Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A290174EFA
	for <patches@lists.linux.dev>; Wed, 13 Nov 2024 18:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731523970; cv=none; b=Ah1UCxp+gzfCkW/7ZIF1Mbo43Pap03VUbFRm+OWJiyGPDkgK1522Uy7hUuLB/N/HTvgTYsheiKGspSZWxIuKRvvQH+Mbjq9bNpBslM2yi6BrZoBOZ5GLDhxK1Js4Vqd+vns2JUqUTZ06JjPYYM3A7/o0Jjy1QGGvETVBW7Nv+bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731523970; c=relaxed/simple;
	bh=y76Nso1T2M53V4Eeii+aDzTYCp9de9LzHPJbPMrvWZo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WqRADifPvEAaPBk0BsVAv9PyiL1ERJjRavfFkJqQoXfwiTTzpMFMLUiN9ff44KpFBc696tiEhn37UYUVVPc3uIqQCk+lKd4rZ6ISifjGatJ3ppcTWKNG+pzENc0T5Gxqiy4kuJpPUmw4cdI/eTWZkmZaBJ8kRoyA24Fq4NMPr1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=eR2K57J2; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="eR2K57J2"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43193678216so68896205e9.0
        for <patches@lists.linux.dev>; Wed, 13 Nov 2024 10:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1731523967; x=1732128767; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nRWZv4RhJ9lTHI4u4MgLnmELohU8mmM5r3pe0UhLjsw=;
        b=eR2K57J2hFJpaWCGEi4++WAbr9rLrcDmZizbrtJKPtCiuXkRqOhdp8HbETWTu4zfW7
         s9+LRZW5HMbwziuWLBP0p8BnsMtBWmONjEP7GKkm47g6pc6ZzIYGqM6XzhZI8H76Mamn
         o1ot/ZwhVT5/4pWTfujOVsw+YcedyFWoDPGYkOHgeTBVF5j8YSmDVlavwJFnh+mDrVPY
         6NEFyLEYT6WBQBigPSf7vV66/V45wWyb+CbrHNvdocYVVLEqiEoLDxJrNbh3VVJXElha
         U7nl3nJVb81zhoGN7X0mh77+aCPHS34Z0VdzFmky8TEsVYALCNitcniSpHYeBmcnq2Rt
         h7Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731523967; x=1732128767;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nRWZv4RhJ9lTHI4u4MgLnmELohU8mmM5r3pe0UhLjsw=;
        b=lrwvgQdFg1Fk8yCqcbem1EIEnBGhHTZrYT+l9zdZxF51IpdhqKmY35bnOc6I5ksGeM
         1jpIq1axi5B1n2C9pLQC9G2hHtNKzdQTPYYlztnHJsneOE38tr8KWU1UtrUkRpuCFAKa
         1wjUKccz/YRw+xsiGDzcIwszakRhz59+N19vNZ2/mNKerhqnyVRtKv245+2atPx1tqth
         i0Fh3oF9wPkwanch661RbHBsxgjg2ixgo6ew1sy8UHrgtGERNhXDmQ20GarI0c46FVON
         ad/1d/VHJz9Wg0dcl21046FNXPJ/MRF3LEA+ndwxTwse4pZb7WV86xX9H18iNRBUK+jW
         cPNQ==
X-Gm-Message-State: AOJu0Yz1aoPJ70nf3ioELdnaFS3zROZ3elH7W5iVoSHm7YbkwhndU4Zl
	nB6HGxaCP5Jo3ll/G0JQTXARCsLt3ysX3YGNWBf+kUE2g1phqd4=
X-Google-Smtp-Source: AGHT+IEWNXC5afJvRa/+8LX+fS+5vNLc0NYIBcQrz9GxYov56SGAiHdFsUILOP3GIYogiLBfzA4m+g==
X-Received: by 2002:a05:600c:3d14:b0:431:12a8:7f1a with SMTP id 5b1f17b1804b1-432b7507c50mr198707125e9.16.1731523966537;
        Wed, 13 Nov 2024 10:52:46 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4ca6.dip0.t-ipconnect.de. [91.43.76.166])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432d5541824sm33198225e9.31.2024.11.13.10.52.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2024 10:52:46 -0800 (PST)
Message-ID: <507efbc7-daf6-4812-ae4b-1abd294cedbf@googlemail.com>
Date: Wed, 13 Nov 2024 19:52:44 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/119] 6.6.61-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241112101848.708153352@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.11.2024 um 11:20 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.61 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
