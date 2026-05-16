Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BC32AD10
	for <patches@lists.linux.dev>; Sat, 16 May 2026 01:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778896152; cv=none; b=QAQwoLuOYUGpAMTVJi2VNSaX3w3SUoxzMxJvESA5jfVp9LcHw2Wna55rLa+QGHsI38DPQq0JjvyxwrQAh15d+QbBKU0OeI8jqq2YDWgRpezZiBMHnM37NfaY3VKeOAj/m8F2+tXZ8LD1ARoc2YWcGl6v20xXdDcBIfACiOKNAfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778896152; c=relaxed/simple;
	bh=x3HusSs63/SheGN+SpDKAof+n1fySvBPmjTura8Q35Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gTfn8MTv8H8+1KHfjvmUwAbNUORlJBpNcyJNXjH1czYwQZxFYGDu9WV6Lmm0i3jROhQxZDlq2VxPyJNiDphuwe/tF/eCVaOrZ/3cDxUpec1LxxXKbqeV+t0tbl8P+u7n7TTv3DEGZfdRC5xEmy3cZUZVhg83EWa39iMsgh1NagY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=AFl+ys9q; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="AFl+ys9q"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48909558b3aso3781325e9.0
        for <patches@lists.linux.dev>; Fri, 15 May 2026 18:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1778896149; x=1779500949; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=shX0sal4G18TasCZZFTwC/x0WsI5k3GpFQPE1No8c5M=;
        b=AFl+ys9qwJdvbAKLThoEUyiYF59ZCDNWdoEYtN/B+412JUpS65pd5KzL61fBYT6EQF
         O+AQ9LFRs1pEHUNMBkEWEnZbJ6nLKIQepsknUpwmsq8QxgOB0TYlCxDBhWafMpExZN1r
         pCbo+iiXV0oFSVaHfXV6g4mIfNizJKF8t2ETeeejqSJTyY/KYBz64YEnEDUXOnsQGKR4
         XiBcKFIUpJhEWULye88/TeYZPWV3CpH8QfpSwYU3weqXphfCSCiV+guFJIGZ0mSurptQ
         GSiu2dQXcpuSxku85TfgydSMUdhmzws/FYE4aLwyZBcrpbDv+m3sXoCLhiEKR/VnJQrX
         FWlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778896149; x=1779500949;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=shX0sal4G18TasCZZFTwC/x0WsI5k3GpFQPE1No8c5M=;
        b=Citnpu7Efg9KROJuoIjB6IQhO/XnWNEDgslU6Q9LzAy2F7yIEdMt13oiWQTz5bsY8d
         FDVRJgNVtmbCYyy4XPoV4uAF3PrbpqQRHrClXbQhJwjZlrzfBkBofOh/Sa60UJisXlwT
         N+bZIKXGTtWRR3AJV/Y1aCiywqMatI2YgD2IIEaZ6D+opbRhXmQA9IcMaawqlMA+g3rB
         Z0rucU966kTMme9n25nVgFW9VSbxwvVue9pBmY9L0ToFskxL3YY+gdGCZqfpnMk45NhH
         Z4GEkRGMQ2WbY5EO5fBUYggCjEJV2vk6VDjOFD+aDtrnUcKwoEWCSTC+9BlkA0IcvFxp
         phjg==
X-Gm-Message-State: AOJu0Yx8e+Wdpt+qOKau82NtkbczGrfyyEphZVG8FQTzQe95zGnwcCd5
	XLjyffxQJg57Y3VNqnp7XMmuru5Ecijz84LwocsFuXKSUqt2KAKOdl8=
X-Gm-Gg: Acq92OF8goI6Zv+dbLL/5wV8tsaX3n3AoKHhZKqVGVCtLyj55+F9t6i5drm1PNOgA7a
	5kEsgmH4UEBZYviRtIzOkyZxgFp32Qqb8ut2Zv3h65ZpQ4sKUtr4TWUC0RO7DjbWSMDYw49UJ8Y
	3zvH+iJ6QWW3ppB8X566eGFMWwFfWw5sUGpoXbu4TU4LCc25jupfvDXz+mCoNisY/5kdDS+wLRt
	RGp3DVLNwogrOiDik/FGr2mro62q+XJcXPZfsEFKU9nm4kevx4hZk4xdqDclRFsbhATEFyF7GQu
	awYETabXNoUCpUMHIIAcJZN7dcVkrY4ArNdxuyWW4hJG8WcvOqltG0L45AthY3EaStTmnAiF7yk
	otsBykjtFM8aymC+ZeSNzRi3VixvTQ0KQAjduIBwoDhrft2W3yyCHbBXxR7dFWB8dxYxX1WR3f1
	INEE/wr7E3ckXYfa/a3nIRORv/VVfI7Me5YbyyD/jdN3ChU9Zx5QmXF1HyPoITAfJqP9rWvAP/S
	k3OLnP4cLSF3w==
X-Received: by 2002:a05:600c:c116:b0:48f:e230:2a22 with SMTP id 5b1f17b1804b1-48fe6632e84mr69865725e9.33.1778896149200;
        Fri, 15 May 2026 18:49:09 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4b92.dip0.t-ipconnect.de. [91.43.75.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe537ccf5sm96975305e9.14.2026.05.15.18.49.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 18:49:08 -0700 (PDT)
Message-ID: <c4352f1e-c30c-47f0-853d-41ecef2861b6@googlemail.com>
Date: Sat, 16 May 2026 03:49:07 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.0 000/201] 7.0.9-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260515154658.538039039@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 15.05.2026 um 17:46 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.0.9 release.
> There are 201 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

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
