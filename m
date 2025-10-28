Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D7727EFFA
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 03:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761623132; cv=none; b=j6DXkACBa8fsd6Sx+vsbtHsbFn1rhflk97EkY0kICSFdA0Dyc3cUWa9N2eq5GY5xevA1pd3GluQa2JreAQEMey64ZPjZFZOkS2AIR6fV4TdYovo80wAHug7gWUa0YNsqNxKvtI/h+J1iaz6J/5JGN1R/gaY6HFzq860TLmnc6p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761623132; c=relaxed/simple;
	bh=KidjVKGLgarQNpGF00q4EvUkNmscuvzAOEAk0l1/r60=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nmb4d9UpHBMyhdc7wgG/PapxpV1QlBMK5EDk26CLloFukX0co1YMLofnQ0G5yalFL8sc/UZeDgZG+aezO0wtwTZZ0laiCuvDEwYyxhH3c+rdlr2ay0aTisIcq+B0CpdtZzRpFRyiEmsKl5NwOVJJedgCLvRQ99j57sjG4N1WI8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=c8wBA5Fi; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="c8wBA5Fi"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-63c0eb94ac3so9702728a12.2
        for <patches@lists.linux.dev>; Mon, 27 Oct 2025 20:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1761623129; x=1762227929; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T7GVt1v7G0WDNnH1zdoaYHuIyxA4YtNvwpKhFghPiGA=;
        b=c8wBA5Fi7kAPVyjqKF7iL19scuAasYJKrdAVyUovx9N6qhAqDHbjLK559McTkBxweS
         c/NtlwPO+gcwzafloYXpscwHAUZRMa+VdkuXXlNR7zrPLH3zkEjnxD84I8J4Zk8+SV2Q
         AOneXyueAaeHmFNJkxP8veKUA46l0Ap0h2+KWCt/OGHr/qVKLR+bjg3C2s6h5t/UaFI0
         mFQ0rbQ8vqpRPIRmMCEl2Rxd1yqQSRj1tiAPSW4PNfHxXfNMt4J06vA8+3lKXJeZ7Ydr
         ai/0S455Ix1+bFhr+Sn2RsunBzPVOgP3RbRxSLY90VaW83z0PSdVMXvcO/e+b6WAXqCZ
         JShQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761623129; x=1762227929;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T7GVt1v7G0WDNnH1zdoaYHuIyxA4YtNvwpKhFghPiGA=;
        b=n0UdgcQeZQhxnInLGycAk8KdU9gW1jSXzb1Fo2iwWiNer00aSwjFkdh9USMB65gURi
         Mn+FuISSBfCJ8QXVXj9gIbK28RO897dVYSP36K80q5Brn6cuEvgUXIseRBdVxieVc+na
         wvv8EGOc0v1s9K4jURz7hJgUh3ofDIEH+2TpryACO8DEoF1qZ8s/TG/X/9SlnbdoiOdx
         0xCkv7TtsIkh4KV5ixP3R7jyieoYINpgL0iXYgA+w/V9ybClORZMWAmnpAogDMuH3Cio
         OtTmY3eDv2poIrL8QofMsJC8DrhUhYOQIq5Z5NXlfwzgkTzCVaHdvjKnla2zySFacsCH
         mSbA==
X-Gm-Message-State: AOJu0YwO00A78mDgdZOskc21O+8+g79CsaYMysaQQdiNMbjEEbEdo66A
	cfmkG4Dk8w0nVUKnFpb8ZZENruW8lrr85xOCntvLsBNog/bDZ6cjZgE=
X-Gm-Gg: ASbGnctcw9wgHPqEiSvfBVRqzmjW+TprhcmvkA9NsLpJpnUsM0V00TzihGS/BIdfycB
	jIJ3qT7TUsC1umk2L04/uD7O545JlYaHeMLwkZsZPFgB70XDco8SiMLsb3mrWQjbZGahWDWdYbP
	oGYFfTSvYbILgyRBkDf1FOeOh2vjC7LnBCXawKDGPwz2LVmcPiP2YnNvEFucH3Q5tauyYNApc76
	2Ku24jmNvTXhq8uR2W0USRnagYeVV6MUxhZdl+pAsIT9ZCxrObQ1ioTRW6TSSew5Dr8O8QYTOjf
	W2pfqjw17qbQ0LXXHK24UM+HQWFJ70SAsxtlQi3Wn53iYnHJhRMP8sigNLhjDHPeo6YzvAjWB1Z
	hFzhC2rj6AZB9VXAZxyX0KFhwDu/lkGu3sYBOIc7w12VQHiXDJDA/D9L3mAMx7fuL4YPaLgUe3y
	TX5aLiv+7I2TyCkX5fNBZHLosfMVsilS0oKoN1blWuhr2Oaxdbz8+MupS+9Sving==
X-Google-Smtp-Source: AGHT+IEgy5yJL7k/IoRzMRfSxNY+mDkwZoZ4I8NMwRQxjmEkNkrb1HgCSFuIbsQrLU16vjMdJiSsag==
X-Received: by 2002:a05:6402:5cb:b0:639:720d:743 with SMTP id 4fb4d7f45d1cf-63ed8269cb7mr1758049a12.31.1761623128606;
        Mon, 27 Oct 2025 20:45:28 -0700 (PDT)
Received: from [192.168.1.3] (p5b057a53.dip0.t-ipconnect.de. [91.5.122.83])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63e86c6d7d3sm7445083a12.27.2025.10.27.20.45.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 20:45:28 -0700 (PDT)
Message-ID: <cbc3e356-9d9b-4aab-9a2d-4e2b96d76987@googlemail.com>
Date: Tue, 28 Oct 2025 04:45:27 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/84] 6.6.115-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251027183438.817309828@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 27.10.2025 um 19:35 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.115 release.
> There are 84 patches in this series, all will be posted as a response
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
