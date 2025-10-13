Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F272641FC
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 23:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760399362; cv=none; b=RrDhUfDff2C7crBubfR7VxpBSIZUlLqd7FXvtxfTRi6jR+a5W0UzwyqZ0OzqKKvfKdc5VRj8+2h8Z7kuS8Lb3dZeLwEnyvG+ku4TRke6NmOJ/ZuT3kpEoVu/CQbxrsQ3zxaL5oDMCMQ3JPRZBodlmlRGHm4d+J7L/RpEMENbc1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760399362; c=relaxed/simple;
	bh=DPqPKVJKoM3S17XqAq8bmlRdURRM8F4tonrV/c7MP2g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CepHPW3G/TrXk8Z39oJnbMtLwe04e9SstUC/oxFwqcnimFgNU9VCechqcb9ku3zgicLklek7lOIMuqWe1DS7EttGW9IvCl7m8y7wy5H/5zdb7vQ++wUpi1Xfuu+HR0TH8lXW2Hw20DGgFqWU4TVzdrflkYOQK6Fcr9ZcOI/7bHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=NQeYYku/; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="NQeYYku/"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3ee12807d97so3192014f8f.0
        for <patches@lists.linux.dev>; Mon, 13 Oct 2025 16:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1760399359; x=1761004159; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q5IQjhjUeRhdsqvIEklKbDkjqGDRUGHZz22zuYo2k2I=;
        b=NQeYYku/2EkNFzDB1PaXTvqHBJNJcF2e6h6XiJEKuL5eBDfampR8tpK7lBxwIgE9t7
         zwB8LoDSXMQ/c/rroKqjYJ1kJ+aVI0ET4De+RPeVJ3wg2fN1BYRBhImdWd7nA8zWVvwE
         b98501cBo0ZrtpVZDFDLg7HSfRmnCG0ZZOsfVESB2lbiVYYpwISZdOAnwU8CXTQWLKAC
         ZS+SGWbwvXR9AkzpbawyESzmosmw+Lk4jOQdPYvgxgOHv1xVek9wPJ+CXKBryEe6oW8k
         qwckRZb2zXyaSoknQ4a0SLhgvdOENXWVZTOd7Y0c+l3e2lBfT+EYUiMt5gDBPyG4qCvE
         nGLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760399359; x=1761004159;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q5IQjhjUeRhdsqvIEklKbDkjqGDRUGHZz22zuYo2k2I=;
        b=VBZB/ZhRNBGzTGseSTAlgMNO3d0JQbWxF4p+IVwZGR2QYS+08FEz7fRud3Z9WL22ME
         WbCldYPxWkzk+UEBdrmlD0r+//L+HstEHjLEw/SOdiEYD0oWb7iax2dm8tLiM++1dhvL
         RefFzajmzCYrOj2UsxdWun7Qm9i8/nqvFzThYOkpL62Upg4BXFeb3OL39TYCKApmOokf
         GR290rRP6obDmOOe1TQ7IEY1yvVBoMxYQlcFIz4pUpQRSqMeOA+QDOIfpYNZHw+RVB17
         rYkYgKijGDzqKHhEU2BkI4qbQk2tGg9y+Yu2dV1KVa5Y0CPYV3dI5gjV5EVxwPy5NtFg
         Spgg==
X-Gm-Message-State: AOJu0YwC1FfB3L0lpE2BLBFK27WCIbiqkZswnnUD7CGtXTwZhFmDHR9r
	Cp1ZG9ApnunSyX9D5HOOvh0k+EMNMf4g0TNVCGF2Xy/5YI1JjLPqpiY=
X-Gm-Gg: ASbGncvsOxcB/K7SbwOF3vZrjzkcvfpkBLeSI/w/qiInu4hjzxZ9rBg+P65b/9WE1RI
	9bZyPEniUIPfV5qZsUTBN8U+4ZeYB1IDzuK4Xca4J2vhdC27kvRZFJ20l4wwhvNo+eKhGS9NUIK
	ZSmwb173qmAE0kL+b2RH+DkTncOi9HvaPy9kxwsqB2pAWTJ6mZetn5QSSWHU2KyZZ/f4T7Y4eyM
	i2e1y7SUuHlvbsAMy2Cet9Dw36lGfNQ0pi8zGH7TUNvWb5VzZyRhdUA1jAHo7KbPMbzO++5/rrH
	NLVejCg/e01DbwwoIi3TdV/Kf1/Q1w7KIzSeDNiGUL/glEaazjYCLAprXQj8BCuBV5m/YeABQrZ
	r9zj0UM7GfbenBuGpvuMWGmtLHWrIapItu+EFAxmJwX/InT+XxqSxSgd3WmMzCbci3YnPku61LJ
	owMjAEokT/EoxA2BXVZ0w=
X-Google-Smtp-Source: AGHT+IEcseHOVdvzwVXHr2ecTf0F6oIMAJeswTeWEHpm7pkR4PH0JeeBnX2ghP7A6wl1XDa7xCODQA==
X-Received: by 2002:a5d:5d08:0:b0:3f8:8aa7:464d with SMTP id ffacd0b85a97d-4267260e155mr15648973f8f.42.1760399359433;
        Mon, 13 Oct 2025 16:49:19 -0700 (PDT)
Received: from [192.168.1.3] (p5b2aca8d.dip0.t-ipconnect.de. [91.42.202.141])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5e1284sm20457300f8f.45.2025.10.13.16.49.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 16:49:19 -0700 (PDT)
Message-ID: <831459fa-ab4c-4b64-b8c0-eb47a919d7f8@googlemail.com>
Date: Tue, 14 Oct 2025 01:49:18 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/196] 6.6.112-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251013144315.184275491@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.10.2025 um 16:43 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.112 release.
> There are 196 patches in this series, all will be posted as a response
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
