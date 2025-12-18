Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A5C2248A0
	for <patches@lists.linux.dev>; Thu, 18 Dec 2025 00:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766018095; cv=none; b=YTQAKbIheFSzewdbDTk8ZDUkAfUW0OHtG1UreMOxMGL97WD+Lm9vQjQAbEos1mdGvU6phs8ACpZNVBznOeUotEnXfQAD0LdX9NyRo8VNA15NlU5jsF2gf2+Lof07g1ItKOnLSBJj53FF6n4ua1ACjpbEEnIUFQje3+syCY+p0yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766018095; c=relaxed/simple;
	bh=FO8LIM9dc/mVTDnts2nMeCTvf4v1hrbMfsp44QYmZqU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KkSQSHGqxeYck5ewjcdn14ArdR/eNQBxy0UyOnrT4BSuwZgaSTKxBr9ZmYUM6imz9tsipwj1+LcyBczlM2lIGcdx1Gg2U3y2ZiSIQyl3a6vKGCbFpjFE6GcnzfIx7ZOHjpMrl0I8p4d6NflwUdgHxWQD2FBwtZrBPoj3CEW61AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=fQI+9XOY; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="fQI+9XOY"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-477b198f4bcso546025e9.3
        for <patches@lists.linux.dev>; Wed, 17 Dec 2025 16:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1766018091; x=1766622891; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/xEWnjAIItWQZkv8o2Fx3PveWA3cvN39KVpWlhYgkBA=;
        b=fQI+9XOY0PQn9ZO8IOFYi/uATiG5cbRhaTMJ1St8mtcrEoDwV6UbTs8j0wYHsBY85R
         6oCxIwYsJvc2u9vdSdCFMxWUcnUcKsFMA5ycZvN7pqFgx+o7BgC1BHIArunLeaHfBKxf
         A9sNxSjKz9EOCZGb8FPh2bndsPnErOWjg8pRV+fW8sR9heFTawyR8wR09a6PXUzPqLQG
         PYad0GPEc7kfFDNMcTkgvNpBcz7HNJWa6w8XynIUjANq3I2Kw//k3Ok7DsICw5+PAto1
         2nTTYFAwtfVB66/Nwi8foI2PRW05UFm3EFz0Zs8aIXHZf13X3k/cPY1B7r03Y7wmr6kQ
         TXaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766018091; x=1766622891;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/xEWnjAIItWQZkv8o2Fx3PveWA3cvN39KVpWlhYgkBA=;
        b=a2NW4aY7vE8+Mu1v58FbH2/NZ8XPmQTt6Wu3Gxrh6lGgglbs7m3pK29ByjIONSdX/F
         9ezLRunWC8RHNXBmrsPIOQa7dQDfEmSGNQr/yiUBH3UvwVOOgDglLA93bEG0WjaCpNcl
         20+MvU+PtPPhlmvVqoQIe8u82IMU5XGABHAm6bQ8+VpVBwQkgWKC9S8icWo/lpXFQ9zg
         Yo0QeWptTa1sWxs2De/ejn5dWnHKa9gcaGKNO0f0cl5Nis8g5wKpPercfOwDYqkDJnMz
         xtqA2du+2Z2gIeKYC6z7sMqsMs11/S97S/KV3h8T/RFdscuv5Y5gmRHVPt0sBMwFYwvq
         sJFA==
X-Gm-Message-State: AOJu0YwrpouKI9RaIj8fWAPdsKYab+m1tXyheJQcvHcI1KIM6jlVnc1r
	wLYnF1E302PuhGpr2LYXv/PpYPNQoGWRhLFpDXqtX6WX0eF69AyUhwc=
X-Gm-Gg: AY/fxX7BmSnligemYFKZt1BRTx+/bc+d8BQsKwNS/Z4KhDoRDqgZIaUH33GNvUR4oDL
	JTuYO0tkn8S48OcgBhO4NH6ulv1Ukg0t4Qrtucpi0mos19ij/uDtZsjc2FAPnBo7Cnth1/l7QLR
	Ry9JYhrJMQVX/YJv60UiTViZ9kPXiBKNFgqCybE9qWZR52Mbje4Zwq/lybmIhVQYJj/Tj0yjfBW
	MnwJE5j0eqX4Jdv3ugecn8mkaugBZBsS060e7LnqOq+TxQW+RvWKqxR41IpG2qkaqvSQp0BHlsh
	eIsDi8UmCghnul9w5oxTZTxTPU7y6wVLdu7h7seVj3rnSEU+91tbsiAghRdFkM7hbHX58BCIj95
	OREQsAmBVYdPpn9lJ2ykn1segaSBbjnryblSLvK5PBTAFfq73n+jnepgJc2INgVRbx0JdoynMFj
	J8iDMVrdBMMCFEa9+jVsSzxJwKzcn7EDaDWzoZPJD5WTec3FmbcVPIYpNYwFjp+FDFmeM27i4RY
	g==
X-Google-Smtp-Source: AGHT+IEC68J9z/knR6wBoufrtFqrl7wLOpE4FGQAXdxT50dVt91U6bBsTviAWFR33gVm6l/I6He+HQ==
X-Received: by 2002:a05:600c:4f84:b0:477:7b16:5f88 with SMTP id 5b1f17b1804b1-47a8f8a7f7amr204721985e9.6.1766018090846;
        Wed, 17 Dec 2025 16:34:50 -0800 (PST)
Received: from [192.168.1.3] (p5b057c69.dip0.t-ipconnect.de. [91.5.124.105])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be3aa7cd0sm3149355e9.8.2025.12.17.16.34.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 16:34:50 -0800 (PST)
Message-ID: <35c5e0a8-6134-4d65-9fe4-1778b22c8d50@googlemail.com>
Date: Thu, 18 Dec 2025 01:34:49 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/354] 6.12.63-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251216111320.896758933@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 16.12.2025 um 12:09 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.63 release.
> There are 354 patches in this series, all will be posted as a response
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
