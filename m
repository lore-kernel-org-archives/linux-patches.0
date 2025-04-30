Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137D078F44
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 01:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745978202; cv=none; b=CbiZWET4quF4/4z82wwSfX9y5OSbYnIme01RsEeyfVrVo/hzDdjdtnS3+mg5L1QTR4U28zjXXaGSKpRjYNJC9GyfZNvJUrcH4+V+ezyLm5JAp3k2X7ekLL5zOfBu3ynqypS0JjUDuJHuonu5RE6xf1K1atyEwSZVN7aYb2PcSxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745978202; c=relaxed/simple;
	bh=+KfHjPK5yIR7Je8kKXT7ZbpVESHoHpgIj07gDqmJzUQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VXr8V7QoccyBPu/7jP3REWH8bhMZbTS26iPkPdSpePlgl+rK4j/vFvfryh8OSt0KJalcz9btPnFon81u+0XXHswzKeDrdPX5iwmyvsTrO6t1R/YuHv6jhyxLa9ObL78sBTclzBXRIGbN9uWqLw4lF2zEcwEeHsZo3RaOfU6n/xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=mZpI1mps; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="mZpI1mps"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43690d4605dso51297545e9.0
        for <patches@lists.linux.dev>; Tue, 29 Apr 2025 18:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1745978199; x=1746582999; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MpsYOY6/z+Z1DTeFAke43VvZPd6wkIifXztjpmPpqaM=;
        b=mZpI1mpspLly34XijW7LxxkL+5ao8x6HggDkU91xlsWLn19lVefoqc4lWzFiXy+djo
         NUEO6eJfG0fCN+uyr1wywoLJTppzrc1uvFQxvzURgbTjm4puIccQ3RkipsF9XpWUv4tP
         f0G3nuS8Wew6hkUBZtBdYA6N+tdMCGqSr2BUP8OfYEi7V2m6w00zokdqk4lRhz71e2+h
         Hh3QPf0rWOeJQwr2lp3c3/q51Way7p4bSbWam+OEBMr6PxwXsGyWhSbHLw+zbt9h9nb5
         RYJ9bkIa9xMxzrDeUstTGgtPM21sWvqToFn8nDl+yMsPQToOf7V9ESQ/xPJSgjP4iDh6
         S4QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745978199; x=1746582999;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MpsYOY6/z+Z1DTeFAke43VvZPd6wkIifXztjpmPpqaM=;
        b=C55AS1GJ4fteSUerjhsLeXpKyi/glCaWn0XOIKxH5aR23p53EV/vu3cGlZypbk2lHE
         RblpLjMj//7FFcw70EdSycbLA/b1a6u6qE0cp04bnQPhZ9bwcW97FoQgsXKPB1Or1h6A
         PxxFjv+2cqmx+Ix9oG2f1iHe/AQJeVV6WddfauXRavg9XwF0zRhmGAjYAlj8TDTpwqpo
         B9DESFjHnJi0l+nRfkM6p0gmIGF91+csZmfYgWwyi8Bk//W2gN70zJgYw/VwsrCAolw+
         +2sJdpddpB0RmNQFGxmHk4W3kpwcgC/RW81E7CwFL/FFTei72/HIxJyI+sZXVw1eoJJQ
         Uh+Q==
X-Gm-Message-State: AOJu0Yx/C4ASWZcwCTNbSzqK0wvLw3N5SXnabkI9fW9B/of3xStPMGHC
	CfimPohlaa2sjzZzIkBO6FNoJ1c688O0jMxrxSOl5dpn1b+zq08=
X-Gm-Gg: ASbGncvsKUmVdNfz7uLssbbJNjju6oQ/qqNy42jgfZfMneRxHzz0Bqw9bz69xajuRyI
	7Tqt29Lo0xceQMGTbFT/V58BTJa+4eNyeHoleiQ06yGoS61Q6NqhR+1cDLpYgApMZdrnUv1t9nK
	NOU7G6u+TTOsTcxQsPRaZ/nn3B2DwWpP+fPdzY8QdV6xKSzgMB17P8FdsI6VeJVOtwYfvMVN4J1
	q8NZvKDtHFPiWZB3+VDqCtjzm21H0mrSoATtgCQglsnBuOqrAv+XaGrB/R7bSbmVoN6OINA9YXA
	+pWPZvPOpz2Q/AkIuNyhTKZ6Gz/KM/x6hEspXKFfCyQct2sgEfoBowKnUgrUe6HVUx8ojX/XohK
	nWdb047LijtAJ4uOlL9o=
X-Google-Smtp-Source: AGHT+IG2NrJCRDLN9FWQaP9OFYSF4SIsI76/UxFWwjgAlCOpjR+ekqLFJ/p8Fv/eZLk1OIzUutk6OA==
X-Received: by 2002:a05:600c:1f11:b0:440:6a1a:d8a0 with SMTP id 5b1f17b1804b1-441b2634d64mr5263105e9.7.1745978199061;
        Tue, 29 Apr 2025 18:56:39 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac6c7.dip0.t-ipconnect.de. [91.42.198.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441b2aecc89sm6717535e9.9.2025.04.29.18.56.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 18:56:38 -0700 (PDT)
Message-ID: <f3247312-d88e-4075-b27f-9c73998b82b0@googlemail.com>
Date: Wed, 30 Apr 2025 03:56:37 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/280] 6.12.26-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250429161115.008747050@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 29.04.2025 um 18:39 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.26 release.
> There are 280 patches in this series, all will be posted as a response
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
