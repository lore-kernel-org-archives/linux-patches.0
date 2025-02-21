Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A15B20550D
	for <patches@lists.linux.dev>; Fri, 21 Feb 2025 11:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740138656; cv=none; b=pWYUSLiThJd9XXQsbZXwU3qLc/vZVI+Ds+xCQWAQYKhJOn7/MCLXjDbkEcKMxnNXx0RY3wii5Nuuy57melKBT7WBlUzj7dDt1AMcfHElzVj7PweYq7RKbjZ0rrUt/qszZy7TXFwap29oDUSg7txXj5cNXhhtkiOwSUKd0mWnBww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740138656; c=relaxed/simple;
	bh=4iKGjyET1laEexqZtbAZOOQU2sFeiufZBXLJZpatY10=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tCmd6J7gBpOX2QQulhbFcH13GxcjafTM+6WopJzHhsMscHYfZVb1wHe3EsM3ZZnPgp96uwigi2ta09ixPzbbAWwVbQOqFq/LxZdg8v6Ga9vPvX/02tCIDU9UD2zyHh8/ZcbxvRrBhSBbiowrMhxdqE6kmrSgDuIbL9odRTbq0zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=LBEJ/9Jz; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="LBEJ/9Jz"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-439946a49e1so12765915e9.0
        for <patches@lists.linux.dev>; Fri, 21 Feb 2025 03:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1740138653; x=1740743453; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DCetbYu7M/r5G/cWLg8Lx6IRcaQzJ405eRDRSC8isck=;
        b=LBEJ/9JzSZLLyy/CRlgcQLl0nVsN8NUpzKhP20qTTtJN0wHeMjGZ3H72YxYvJSk5hE
         gNlsn4i5W3AH4t4HNtFJWHZTdA0DUZcWooIcwMVQZav2dlwEK3VnvlWe0/zC0xsAQyo8
         LIELhS5lzJ6xV5YBFWKLlfuf7F96m9heRSAC4K5P/x0q4NfxM6LJxbbjtbbY1rXOqdd5
         lui3PBpEaYdksLWEcl7Tzs0psdPvZ1nY40FhLHRaYFsbzhSmaypF8clBG0MIeddIca1Z
         Irh7aspRNDVH/aT/hn+fDdvSse2KV8PHJKtwqeT2eeux4QI0QwmIYWBX/lYSvA1gc84p
         DWGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740138653; x=1740743453;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DCetbYu7M/r5G/cWLg8Lx6IRcaQzJ405eRDRSC8isck=;
        b=vY9UnxUomcFt4gvDRvJL+QSxPSm8pqTSwsePJnajjOGinJJ09go2Lliu4MhLYRqzED
         ufU8XyakzAtyp1sKEVp+omQKq7bUku6dtd87cSMbWv2jsZhPdIwJn4oQRwbm6SI0z//D
         AMyiwpg9uilQcjqPkKAQr6QeENNm0fxFdISCmY9jxM6JakK61CClyk5Zu9C5R/DcyQnT
         Lj0Ry1C9WlBLS++NhKZe2XScWRxaqSCRbC/rrDGcVvfiVzRXmvfTkiW4FfUw4FwsJZKo
         xQTRlppGsI/HbGQo2LmmfeZWXFIzPcBmuMEERDSVd4jYvNydvC8t/i+OFxQ8kSolKKH1
         pCXg==
X-Gm-Message-State: AOJu0YwqxTXdl0ynRRFeJnLayEaBoF3fXd6mBG0Y6mll+j9hCGUbdYkg
	miqIPylQ3F1zKg4Bomd1P0MBg07Pp3WvOep59jTuVExlbk7plb4=
X-Gm-Gg: ASbGncve8FlOanNFvu/z+bxA9zOV+amfAPj4jMBMVVPEkiZTcnEz4AsPHhyIEbd85Z3
	ztWCAMuQt0OPPtFjeR1Bik2zxRsvulL5QsNDNv2bpRs7FpkltPvJ0T86+HKusVY7OGepAIO/GeG
	Qa9ULyfJteMH3bYkq9Rp0RiGPzCwjmNgr5GCIJpBgjRKxO/SfBpFMSjsO7++DwAEEQd00el5Vcl
	T1DakhEwX021vTD5oHRgEgzgZlmD3rWuCYjI1eOC/uM8kGtyMBnjHD9ocWLl1w/jqaknYwffCEL
	sKn7AjvNRPqng7RueKaqdSeIM9ruNhabinbomoCKfyRzUfinmi4GNTB2R42lT4m99IIggSO+91b
	HpQI=
X-Google-Smtp-Source: AGHT+IHderF5dL8n18p2RisusD5mS+o5hF48IgFJWXe+lSEDsICJsZcv5gmaeGAv2kReqDUuV5QHNA==
X-Received: by 2002:a5d:598d:0:b0:38f:3c8a:4c0a with SMTP id ffacd0b85a97d-38f6e7539b7mr1651006f8f.7.1740138652774;
        Fri, 21 Feb 2025 03:50:52 -0800 (PST)
Received: from [192.168.1.3] (p5b2b437f.dip0.t-ipconnect.de. [91.43.67.127])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258b44a7sm23540504f8f.12.2025.02.21.03.50.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 03:50:52 -0800 (PST)
Message-ID: <370446d6-6668-458a-a472-e7c1595854a5@googlemail.com>
Date: Fri, 21 Feb 2025 12:50:51 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/225] 6.12.16-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250220104454.293283301@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250220104454.293283301@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.02.2025 um 11:58 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.16 release.
> There are 225 patches in this series, all will be posted as a response
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
