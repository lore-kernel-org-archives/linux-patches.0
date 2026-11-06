Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793990900;
	b=kTsPQn+xLsWHBbrTX29aX2C9OsoD7LMaYZ+jcIi0MnVBywwCfKvzk2tRajEEPtDMv9cB
	 bCq3bZZBig6t3rzHqHTCrHE88Ehh5EIQDyDv63jIMHxzrEdUsUpVgidzuyVHKzkdNIeyH
	 HclQYg+iEcVYDVNV6ml4q3RVfISyH69pChSX1zO/Wi2QRcsNqxuhvIwvij75qa+zTkXji
	 AclabsAho4+ta+xmzjDyJH4ZJpvHoP0k3CP+iIrr6rKjP5GGaPO7vWutD4qwMamCijXE5
	 h1z7P3lPYerkNXkGMbUZz5n1QjTCeaZ9CEdZesiYmx/Km4OoRpDJz4bVrSn2m8W1BAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793990900;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Lh7QAjeNlS39ktI+dlJIULFlvwkgAS1H1OKsWGYccyg=;
	b=HijGXngjDn/Y96995HXGhipROQeI+3LKI9zKoU+DutZb5za6iKeWEC+wYWcoQW6qAGSx
	 /Ld3TEco9esvK0H2YNTtm/raO0hQ9C5vNto7mfhchJFrlk0d9cFtuNr9LPBU5A5l3rYqM
	 wtGcv6bdtrNWU8Pq62UknM/zNgTOJVJOdyAayYoSRRi1H8BgtvHPIkvCg58voKScErlMX
	 cweFLAvxiBU5O3eQAg2zxHr1JyVD0wf4Zl1BC8PJdwYiAPtcQKWGG4PnHgduuZ6v1bpS2
	 bHrTH+CZCYuDqE8yHi/hGAxgnuUc9D+8vAnTd+Bdy+0Zo9GXym2z7wmv1N+TbHG993w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JGfUsZ38;
	arc=none smtp.remote-ip=74.125.82.51
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E21606A32C
	for <patches@lists.linux.dev>; Fri,  6 Nov 2026 18:48:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8E21606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JGfUsZ38
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1a2761c69fbso2246831c88.0
        for <patches@lists.linux.dev>; Fri, 06 Nov 2026 10:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793990899; x=1794595699; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Lh7QAjeNlS39ktI+dlJIULFlvwkgAS1H1OKsWGYccyg=;
        b=JGfUsZ38fnObtzX2wV9rrJXdpESKi2KL7sOCSHvfvDUqw0U/fWa54i7wnPhl8Ob/aa
         VYIDERGlOavo/MHokzJCcJKErttie6nZ9xzUq3PT4ZKasmWSOQcSr4ruZDYY9ZeL/XME
         ol9dMTv8plzDpkaOd+Nk7rpnhZ03OzeoGNhVxNwCnzTVI0JdbaiKusMA14mBNz3hWpbP
         jfWSHrWDoP+KB10longh1UEaiq2KUoN3bYho+5UrgyF0Z52xTYcm46FmDupTKiXTbIL7
         3JjCT2Eb39oS2PmmN5gMkxaq9OZoW1cn8+zvrGj/WzesdEam3JDGkh19T98w1w/HZlN7
         0XCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793990899; x=1794595699;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Lh7QAjeNlS39ktI+dlJIULFlvwkgAS1H1OKsWGYccyg=;
        b=ELBJbFxaMuw5hnP2UErqvt5zPFl/wuP6y7uJxEwsG0nGiQpKLrX5GAvRqP18G9YAeu
         viyq7lSytpsTmiaR+B2giFHOv+YZPqPoTPaWJKAW9x7gz0yW2+G0wNDMq5PjqiZoyKav
         u1ZhRnXQMuz8xQkvTgfOdK7OWa3tZErPAik9EvnC2Oy51SMwJuxRoiqlbngJUBmAA4WJ
         URptE7eNAtgMiBjPa55ix3UFg+9NERigvalTsWxmSOOxhDJk55sJFbYM6V5Q4F/y7HLD
         mo5IAVWq88nCwzE9L5R+h4d5Tt3yWCvkWW1yzN9dO9qBtxaZBVVNrFt1Tr38GmG6ekut
         CQ5g==
X-Gm-Message-State: APuU4Z9NAkdCPiucJiKx86ME0YsSfpHh76LxyiOyWOL30GzyhLsTa4/e
	v03L9MVdmCacI92H/+5ly+DW61gup7buBgJFrnMWitL2U6M2cPijs9X/
X-Gm-Gg: AYBFou1QW82fhW65TiZkDYTtnc8PgH+UZE7BvwBrYH059/JpIc3DILlJ86C8EoSr/NC
	NdWsSGh6v4zgGsZ14XP79wCOGQSjq9oPRNERfd6pqb9yULM6K4qY1urLFjwlaOwiUJvl6bNNwhU
	wIYmWWQOIklyCx8gtcmW0Tq9ODTyq+9AYd1qzYaAovJKDBe06pZBzKrK177f6CFtwaIaIj5eX86
	d4P3IH27e7xcj/KHZV4BFDSOFT7tXx32IJd2dauUttB2tws7JSaQk2r/YKLldMIOZ+leZCyEGNh
	8kn9HaaO9bSynWH+L72xN3tB9R45Vhf2gZXExFu5IHyHK2jyjC5id5yFjPergnDqKG963e8z6cu
	Dbp9OOuV7zirhgtz76A92lyfxIji1EoH9O31ptJsey5aV87EJULXLrot2PfaqeYkvO8G5D1qZ0C
	TOV7fmE3EoHD7dvd6uvcTyuIvjDRSeeVScc0MlQ/vOc1MzaHk+Q4B9RNdpdF/pnJJJAPYSCvqt/
	0Xt/XJ7gN+q6SGW2V6okXTjTmkBJ8PAamOVHboNXo8fHfRozbDD5NdC/Dvj0/2MW4SGY/qjid6y
	h28YlpOed3tOuWUJVgz2NVJkTmSSYLIt
X-Received: by 2002:a05:701b:4588:20b0:17d:7b45:f927 with SMTP id a92af1059eb24-1b25d3499d6mr4163431c88.33.1793990898558;
        Fri, 06 Nov 2026 10:48:18 -0800 (PST)
Received: from [192.168.100.6] ([121.144.254.242])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4879adsm8661940c88.6.2026.11.06.10.48.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 10:48:17 -0800 (PST)
Message-ID: <60362312-e40c-4d23-8476-1b554fee19da@gmail.com>
Date: Sat, 7 Nov 2026 03:48:11 +0900
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 000/547] 7.3.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261104211038.406938024@linuxfoundation.org>
Content-Language: en-US
From: Joungmin Lee <leejm516@gmail.com>
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/5/26 6:03 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.2 release.
> There are 547 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Nov 2026 21:07:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on my ASUS Zenbook UM3504DA running Gentoo Linux.

Kernel: Linux 7.3.2-rc1
Architecture: x86_64
CPU: AMD Ryzen 7 7735U
iGPU: AMD Radeon 680M
Compiler: Clang 23.1.5

The kernel builds and boots successfully.
No dmesg regressions observed compared to 7.3.1.

Tested:
- Video output: OK
- Wi-Fi: OK
- Audio: OK
- USB: OK

Tested-by: Joungmin Lee <leejm516@gmail.com>

P.S. This e-mail is sent again to all CCs as I first sent an email to
only Greg by mistake, sorry.

Best,
Joungmin

