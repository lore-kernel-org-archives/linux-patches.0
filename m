Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970BF19CC2E
	for <patches@lists.linux.dev>; Wed, 18 Dec 2024 11:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734521709; cv=none; b=gsqZQuVfkokJY+zP2bok25Ff+eEuyqqvMWVo0o+H+yt3ifusztTzxr0f0lZdLqIYeJgYdalwlmNF0iym452PNFsq65ujauuKRoNs/9yjiK4wLIZcJJ+wHGzJN2sLwEFVWmWHTrG1pvlVg53cm4K8g/VIaCf9Pk4OKwCrOQvK+rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734521709; c=relaxed/simple;
	bh=aHiM00O9sPVhnjzBa4T39lrpaPQJh67gKCPtQH6GivA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CT38eBIifD3Rwom5i1uZUWi2JXPHqRQ+wkbVN9LCQkd6QTwNI3BC7x8utcKfF1Qq4aYZnqBEST6RAIny+OjwJUxmsF7BGGclGztmQvHfR2QeY5mgrJtYEQNU4vbLum5pzPISUR0DxFaIDtOPWxhuSca/OWf3Wg3+aaClFKzv5Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=MC1WCyJ0; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="MC1WCyJ0"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-385e3621518so3276891f8f.1
        for <patches@lists.linux.dev>; Wed, 18 Dec 2024 03:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1734521706; x=1735126506; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BMQcE2ZZYoXW5jzc8/Xpxt/ECmuhV6utjqLaahp++GM=;
        b=MC1WCyJ0IIvV+t9FyZEhPcQAJQqO+0o+ujE5LalFA2141W0QN+cg/ltRCruOR+XLg7
         Yl5xaT3TXTQ11ehPyn/+SvebUcXGrcOTLgJxDe2HZGxOCS3oxdLmBi7FWKl4rTpBnqfE
         91sCMtETM6sIWlGdv1x0ysEV6lzKsTfpRUjZGFBH3xV63ESslUMTZ3dmXispqaows80f
         Xyh9RmZ1vuqFLlkx4TIvBrIZd72F2pGkIadvPUyjXFfYgGKjvJksT+bA5+9WXqSMvuzT
         8liQAOnYrkHp6pSpsinfROcgOxHo/uVwn+SQguso7QNg0AZnGSI5q5djG7iqeX7yrJ7e
         mB7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734521706; x=1735126506;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BMQcE2ZZYoXW5jzc8/Xpxt/ECmuhV6utjqLaahp++GM=;
        b=eUynyIUVe2ms5k7Br/NBJmQ/6W2SuJTuHp1pfAN2JPDWFr+xVs1YWyua6Y89pBrfE+
         dI2bQvsfbmLtYQQuq4kv9UN8CMfwnFKfjYtwzizGkCk65YRVbFD+lusON5jnBHYw0hbQ
         1AWZDIZGe91xODZEbT8GAHm0MoJNoSL64ZHs2uicc90l6bDQCNGQjg/wlRuTLqREYMED
         HdtM6/wCIkUnmzgA3IbFd/kB/1eh25BPXUugUlEjcCSLaJXZ7RCd4GZynU+Gft0575PY
         AhkF+TJ1/zsDu5EjM2Vipr5Xgi18Uim/8ySAkvy9dVcVIcxmAkSuTkhO4+EGNbpfZAIo
         Sulw==
X-Gm-Message-State: AOJu0YybmSXSjLCR7CoCSxQa+5S2kTI+Uo2MwqHeUuiCoYrH/qGVR/wg
	tVxA1et1TXU6+EeiMw8nUddj9wx8m3OAHPDQ1aVq6Xnuym3JNVA=
X-Gm-Gg: ASbGncuSdSQS3+wit62FHWDuDzaV+sme1Hsa3QqF8TBktnEb/w3irDBQ+AnUmkUb1e5
	dHvka+k19SDMNXNZczM1FSY5FMzjWxlB2zz+ihHefM0CvnSL9mzj9jlzIK375px2IyI6kRtYwmd
	8O6f/GtODL1lTq/V5bvcuD6DBjUZSgKhvEKechgC20DB/3d8J4cOpE3E0uCbLXtNKifB/BSu+tl
	KEphMZXZulb5idwje5ew9C/YGWs1JROwOKUc09U+lKpzJAFjJcX12rgkTLZ8JEL929A+XKPekKH
	hmgsXuTLaMn8VqMzCbIAroKnSeaniEA8iQ==
X-Google-Smtp-Source: AGHT+IEXoh1wmiHthWNkV9UXzrTxdGT+QidElNDuBN2fzcUvvTta1ivTlP6H2EY2/C6UZGeIDzwKyA==
X-Received: by 2002:a05:6000:1568:b0:386:4a24:1914 with SMTP id ffacd0b85a97d-388e4da5fb5mr1965645f8f.37.1734521705645;
        Wed, 18 Dec 2024 03:35:05 -0800 (PST)
Received: from [192.168.1.3] (p5b057eb9.dip0.t-ipconnect.de. [91.5.126.185])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-388c8012249sm13666576f8f.10.2024.12.18.03.35.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 03:35:04 -0800 (PST)
Message-ID: <8931ed88-11ed-45ca-9b8c-0a3c605c172d@googlemail.com>
Date: Wed, 18 Dec 2024 12:35:01 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/76] 6.1.121-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241217170526.232803729@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.12.2024 um 18:06 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.121 release.
> There are 76 patches in this series, all will be posted as a response
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
