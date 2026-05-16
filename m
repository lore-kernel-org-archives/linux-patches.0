Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F09A25B0A7
	for <patches@lists.linux.dev>; Sat, 16 May 2026 21:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778966784; cv=none; b=N8NntuKuzz1rVb2QUFPTBB9nrTK69XfX5kSGd3aCgDumxsANpGTlGnD9rIkPGKpwZvx4JX9V0c1eW8ppAQ+ag6mpSx+spSO4SOQ9JWt5rrQMEJj3h/+3sluypLCVOuLxBq6DgybOjlOT9VcODUGKYKT9pUkvMN1hC4DilAPx7cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778966784; c=relaxed/simple;
	bh=DZi5scrotk+VzCgoggHRCvfMYji/o7bbV7H6h77ID3s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EXt6yvcngOzGQF+4xho/0NlizkG/Bk1EQiKgYNDLs/sHttdNDN6dX9A5qsePqWJE5DdzKE2q2jdgtJZT5f6+kWQAfoWNl8IzcHQXzSAvhgIb+55C1urjnKeQajUw63tvg1xEZsL++y9IEQoLaU6h83rK6osgAIqumXYjhKDfRXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ArDkRSjA; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ArDkRSjA"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-448528f4e69so506217f8f.3
        for <patches@lists.linux.dev>; Sat, 16 May 2026 14:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1778966781; x=1779571581; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B5swWv+ewNOWZXjeGYieof7efRBZ0EKwIg5DXna6RSk=;
        b=ArDkRSjA5O4NGd6qjBvcN6bVKKb4HdFFQJlhtt+0I0VyVxE+A3NE73brE4ptkPmMqE
         P8STmD/r0p20yd59XLdPuY+nJBRofPi02oTn7R3SmZ2BOCO5iRloCEfio526B2S10XJX
         j9cNc4Wjha/zWtK7aUSumGZ8rnOeYG1QKozJsyzWgf05CNFIA7hN1K1pDqweeJf64mFq
         GF5I4k7IZ0cGyd6Z7exR6QEeciwiFY29xh0xOiNzZDkYpGMi87fwdTvrYHCXNL5k4r/r
         bLng/jSggU0DPGc2jTreNB4kEZb1s+JARrvf9iuYNyXQI5EUS7yUgB25hgIePvo96lHz
         DE0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778966781; x=1779571581;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B5swWv+ewNOWZXjeGYieof7efRBZ0EKwIg5DXna6RSk=;
        b=VSJFap7hcuz486nUH1PjyQBSwBl+uZX9eeNsxhmUWqVQN+xGHuuE/ExWcyZeQVhFb0
         Ui39tpEhR4PkVKLGOycCxUAKACah5GbUdNnttTvgivUJM3IlsbGdmw3bt9B7EObIGBfo
         wIium11S3ppoy9iZhNfAaUWEeJCGFr++NcFjLM9vMOSPtsjkRitggtB06ulTXXlZWGTz
         ZfcpuwITyX1GctB6yWKe0P6Zf7que1/wiP4lXkbtnE/TKrusU1nQoxhLFVz8o5sW+LS2
         /1CPWJSzeT5U/yJnnJAE4miX1gEbuINfBdV+RaBz7JDZ/Z8+OLxfjW9D7XXJ689hUYHP
         I9iA==
X-Gm-Message-State: AOJu0YxmJc8NYvdvzcclOtx/0bpT3wmCsZoybnXplvC0IgZxYC0turKJ
	G7D8kXkKU7Vv6Dm3Jnd8NU2Hqg5yAcHlvKmNd8bODs1KxEKszKOHp0E=
X-Gm-Gg: Acq92OH8GuAYZS2l3/9rs6p5+y6ycAm9vY4kr4veqOSH+H4dw/FPwjsvqBGNUZQAg2M
	GZc65abZKrBAswBtbPgdPrw+uzgGkFCAwJtSIsvMeJ3arPAVshXMsnAOSdzCSCBLSOmQBxr0nnk
	pmaLsW2oAR5eWOKwVf98z0FpnelAnXG1wmejHjKVCT6xa+R3tlBuAMLATUAT//pB7cdZeTegxeM
	cFzlxChVGGc1xljhXoMc95DWQNoob0OXps5hvtSBodP646oI6/vNqwy+rG7SGbDwxykEfCNOFXJ
	94OHzWb6BoQd9iJsuy9dVSwqCV6pxy1IthZtKBNEmyPisXH6OXDfIZLArLj4Wb5K5If9tqTxRWy
	oMQTYFP5k4z6RM2JFdJcmHIVdPBuPo2SxVPBKeiHGCoPNqo9VCQlmc84lsO7bvUIfLgatu2xan8
	8xQMfqe695Yq1gfb9KrGfRwR2Umdj53APrE6LCLrWUzFjBp8GVOIW2qPv2TCSH/t/A41FE4WD2Q
	Hc=
X-Received: by 2002:a05:6000:24c5:b0:43f:dd40:bbc8 with SMTP id ffacd0b85a97d-45e5c5bf9c9mr14343287f8f.24.1778966780739;
        Sat, 16 May 2026 14:26:20 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4b92.dip0.t-ipconnect.de. [91.43.75.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0a17a22sm25852485f8f.22.2026.05.16.14.26.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 May 2026 14:26:20 -0700 (PDT)
Message-ID: <9ce16528-b20a-4241-a607-3f891cc4ae2a@googlemail.com>
Date: Sat, 16 May 2026 23:26:19 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/143] 6.12.90-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260516102210.570453769@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260516102210.570453769@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 16.05.2026 um 12:30 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.90 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found. And 
this time, I have tested with both CONFIG_SCHED_CLASS_EXT=y and CONFIG_SCHED_CLASS_EXT not set.

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
