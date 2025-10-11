Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC77259CBD
	for <patches@lists.linux.dev>; Sat, 11 Oct 2025 19:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760210683; cv=none; b=NQXmCf9RvFrj1eBl26RqmHC7WIPGmBb7Eni/d2+ZbTt9hwF+vTmB6UrLujxmOfUwkglWq1ywDCs6YefyCyxZp28JL0yzPqVKFr2a9rrmUbspELmTtmJW2jkJERLBubIVq6HqpyNaGltbG120YQpLPUcRrsosu99Swy4Ze8FI6g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760210683; c=relaxed/simple;
	bh=HWo0rnjmqiObnqt8aaSDDNvEmppp34tQnFy/FsL8dlg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rpsauqB1+tUpFoWuOruzlIDs7WlUOpxudgkAPu8OeE7aFHmBz3YOepXhugiKuD0TfYrZS5TM3Rw84npYnDlBvvUC7PMSnOzIkSeavZr09fez9jQOXfLmEvdd1pIY8Hb0+4d7fs2DCcrypFJ7gXzqcg68+ekZ1/s4W31V/t2GRck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Wvg+h+TX; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Wvg+h+TX"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-46e326e4e99so19811665e9.1
        for <patches@lists.linux.dev>; Sat, 11 Oct 2025 12:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1760210679; x=1760815479; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6eByIpXYuNkGA4vMeyFPW1nCJy+/bsqVrEyTS/rcOmE=;
        b=Wvg+h+TXMNeU4dCG5UBjEVny3gWQG2+gR1J+jAG0Xl72ONQVBeXRFI/Dftp5CvTz5Q
         EjfrlitF+VyyZIq30ilGaWtA9iQMLbW4cvNH3n2Sq+ZaObsKnU2dPW+TS6X5l8DZKK0W
         1SA8XO4kCtZ21GQCItE++GnJ+FbPZ0NQ6fFnqrNiE371u4ztZw/6Lkbzj+yVdyj0/HaH
         imWJWjuIpLk8V0xlkVT5WfMBb0iLsfdjmD2f0BQkLWWJ1p86/SbLSfakWJDY/2s6zKCE
         abY5q0zbIvFWR27iVxKfEIA2TpMpoAVXE7RjObIAt4VSGipXH0tREirshbPO0OM/u2Qp
         eXzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760210679; x=1760815479;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6eByIpXYuNkGA4vMeyFPW1nCJy+/bsqVrEyTS/rcOmE=;
        b=hvtmwmJh2JAllkv2H67fo2KkFzPD9ytGAv3bz3ADXuqGsFItc8PQlyl7lCtacZE67H
         7BbmEK7kUWEXOvZnem3enmY+YKPDUS0vKnltTzZEDQqksDwcy9hRFG5W7405hBCm3Wdq
         28CvXpmRgggR1Z2MXwbIXCQHGF7V1FdmJErvii1HR0BDTGLqVvGnGgtfzDl5QWq4o8+R
         BCMyNEmTghKPv5JDEf4kuuT7saqu8Gi6SFob2TTk+ls2rEzbLE61wNSOEgebrRGBWrYn
         hldO6Aco4e7kmxiWK7qnVYGgZqkx2pCljWdZLaafjupnf8j6sJbg3CHfyu1sOXrUtX4B
         YZpQ==
X-Gm-Message-State: AOJu0Yw0TFIXw7ROJGU2lnPArQI+mPtqsvLi00oa1OU62Dx8KNuf5NWc
	v4wVFR08lgKZkqGRRhEGwjR7zXbOudOjuWuRAya40oj6q2UHxm3H0n65p6yClfY=
X-Gm-Gg: ASbGnctHB2hCdqttdrJBIet1i1tfs798bfqJcWOUIeaRgX29jAI00ok2xHlaAj5TvVo
	NjXtaq2TaPqeCbmby4k1vNoua0sYtUplXro2RBiJOT7rxp28hZW2aDxqepjyzpHJc7+TYagC87r
	HMrt1KobpPzEHfDxK4/+fMdNI5cqb6CNrK1A18hngz1Ep4CO1OCdOXjNoP/HjHkIXIrKJzvqibi
	RDeEA7A/pd8LUOpDvaXi869+NwTQyx+S+cuRtoDzvU7ZGkm2SSacE8y9QS62f0Cdv/xJ7WhAikq
	jLklU/Ykh0HbnfIYr1eczYSoGeqzUUd8NCFD0BwdAmKxG4J/EPbxtiHDWFhVgarE7d9Mcnu4IiV
	+KpjjDu0sc2QVCyfDAzL8R1gAU0kNvIqb26E0tXlxeQDBqdlenOG4uNijL1PzMcxITco2VyM/ib
	OBW5tiM8a/vDpFoBxo63lRo9UNDVZUVMsjUjPY5P4=
X-Google-Smtp-Source: AGHT+IF9Ep4er0sxE++lYcipoxpJCMsv+akfvA7XXiL+g3pOZ2ul1BTLiah3UVqQK13BxZKbTh7cpw==
X-Received: by 2002:a05:600c:b96:b0:46e:59bd:f7e2 with SMTP id 5b1f17b1804b1-46fa9ebe245mr116787055e9.11.1760210679150;
        Sat, 11 Oct 2025 12:24:39 -0700 (PDT)
Received: from [192.168.1.3] (p5b057b9b.dip0.t-ipconnect.de. [91.5.123.155])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5e10e8sm10016181f8f.39.2025.10.11.12.24.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Oct 2025 12:24:38 -0700 (PDT)
Message-ID: <e753c8a2-4af8-4e95-bc86-18baf7d2670d@googlemail.com>
Date: Sat, 11 Oct 2025 21:24:36 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/28] 6.6.111-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251010131330.355311487@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251010131330.355311487@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 10.10.2025 um 15:16 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.111 release.
> There are 28 patches in this series, all will be posted as a response
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
