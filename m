Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E83A49B5C7
	for <patches@lists.linux.dev>; Wed, 30 Sep 2026 23:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790810962; cv=none; b=lcE1mUR7DVjjQ8zN5PnmjXX10LbSDZ0Dp0jcLfLEc0Qn8ZSCDg/X7TtGEON22349TaYmuUzFk3JYYq7jkpRJ3AKkAi+UYfc/L0gt9E0k1S4OulXpTVVA0Lvk6IiPWr+3BGITZ4TbhEO0E96P21SNxC6GWmsTrLqXE8jDRwKx7ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790810962; c=relaxed/simple;
	bh=0XCyDv6UPcO8RvCbmmapGfvbtQW25yBor2HwWwqLzq8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=btKzdcvfWgINC7711n0eDTBkUmyKKDXqQJD2kzfF6Jp8gcEXC65yG0oebKQceSYNLuJw14WnL2lS5TMbvBkWImBl+lNqfUx8AnDdtSIm1EfXFeTXgb4BahVMTGBh/t6TyZ95XXrPKfx+V2KTNE6CMbVHqzpeFMoI25Hv8rjOzM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=SzEHr1uU; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="SzEHr1uU"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e71cdb22bso43047805e9.2
        for <patches@lists.linux.dev>; Wed, 30 Sep 2026 16:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1790810959; x=1791415759; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7052OrzfNygUb8ruKuPUw8TtJkXiUr4+VNNkJZFWM84=;
        b=SzEHr1uUv5nSby0QnBtvOp4ncTL3PmEbir4+HnAjPKgXjn2kYJLh7SHLkWYIzhkrEB
         XjR0P3o6Zui1uk8Yl8UC+cohZTQ2gGSTWzGHcN0c8pH87kZO5yEOOH7DSYOMbUMPzQAP
         H/VXdDf+gUhKoaoy5093IRU5wF5/E3PM/I+oKXjMjJoQd9Z5bUTvaVe6HOJR4yo196AK
         7ujfvjSJx9RHmEzeL9EBZ91sp7x+Rbbuc1zzGJZFKCVmd+/nMh7kZgR9GObweuUs1X0g
         cxz62Vv+oRcGgoL8zZCuRDTohFY2GFGUvROOlJb34O+uizz5eoUk/gbe5m1S8WtxhSH9
         irUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790810959; x=1791415759;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7052OrzfNygUb8ruKuPUw8TtJkXiUr4+VNNkJZFWM84=;
        b=sbz9tOQ2h8+iUU2B5OVlQaJ8m6jxiSCK/XpkHa6wcHUXL2csvZXlBuqe81N4HG3mYL
         4bjFIcGUlUn4+bgxtVM3hVvTKj0NKPdiZmgfSCMiFXpf381RbBw4BBKSTipu4Xz1xlhI
         fslAnzx2JB1/TH4RWmCXoZ1kvQXfzCp6ldqsvMfrEiNrOENmggDXyOEIlDrFnGca8hqS
         beMhxJcrWWTI0b/OelMzTAlg091klH2JW8NN/qEfa49YgmQKFRKYra8ag0/o4Xt1TRvb
         /tw1vgZjPlz9BlRKpqyrRqXX8GKuMwapdySPURX9YIHDRio800i1EDGclgljS2iMQwzU
         gIVg==
X-Gm-Message-State: AFuF++kYozPLy190G7Cpj7roGiC/X0mktwlITxSISzLyQIjvlHBLnRF5
	l72prz7Af6X81x4xNtaQcutsBGUg4vgVWoQqVFdkmDIy31XcD8iquJs=
X-Gm-Gg: AYBFou1W4/70HKFw/P3ZabLRGgWJ26OSg4wmK1Kd/M5vYOq1bN5cdRBdnWOjvTMAhRs
	Q08X4WFqQurhhkD/PYK7KCUfrsH/EpSHTVVDPUGJZbVU3EPmNoQ/KGjkTwbJxOcK7gGczBql2xA
	JRr0e8M1wdPw9vJjc3lyigLpkmVPftQ56yjeGHo7TlLS/f8amYrs4Li9yLFwjKl+EFVh17/Aswg
	I60tKF+qw12SpIbkKz7OjI3EfgHizX1+S97S8c4WtqnGotInCWf4yRKDbCNKpikBGqrVDPAw8/w
	qnxK27g1tyAdb2bkUxWOxGPLGB7ZILGnh8BpaHt4/x3m4LtMaORj7iu2Hw5iiThn3rQmeRT6KG6
	6GP70NcokzfVuQZFxR5egL5J8rQ+DBEliqIcxmi+ivb7J933qynKt+lQ5M1auBFV6xwoW+5GwU0
	5DrMI92Cgfk+WcH2mgRlSZlNAZGb8nBxfwXd4OsnnSXf11lthhEPAsEKbne6zSwBbuL4p5hNvqW
	q18Gb9ozxQUxjsci4o3hZTOnuHdpQXM8nexdc+Bcdlg4QbSSA==
X-Received: by 2002:a05:600c:8595:b0:4a0:1ebb:bd0b with SMTP id 5b1f17b1804b1-4a01ebbbea4mr12201685e9.8.1790810959254;
        Wed, 30 Sep 2026 16:29:19 -0700 (PDT)
Received: from [192.168.1.3] (p5b057568.dip0.t-ipconnect.de. [91.5.117.104])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01feb7198sm12207775e9.1.2026.09.30.16.29.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 16:29:19 -0700 (PDT)
Message-ID: <b1a58390-305a-4c05-a5e4-28a0279ec080@googlemail.com>
Date: Thu, 1 Oct 2026 01:29:18 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 0000/1193] 6.6.158-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260930152434.301151190@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.09.2026 um 17:11 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.158 release.
> There are 1193 patches in this series, all will be posted as a response
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
