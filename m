Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21207153BE9
	for <patches@lists.linux.dev>; Thu, 18 Dec 2025 03:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766028635; cv=none; b=vGixfbqsGW/shVwKAyXhuJ9jK3QsUzvLCIW1+UKjPI8CZdMl1TI+UURl5XBGJEeivUlJ4xIjeXaQULuEJKbNd27lmRSo55RWpGO36Af9fJeo1WO4bHI5/iRFJyYwiSg495w3ATUA3EJiyYPxk1S4/zI1i2Cwdh46YhSN9wUBLwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766028635; c=relaxed/simple;
	bh=ZuW0HHtMtpR2twFPuMYidJ4Y6icF3skEy3uXtr0ISxM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V66UJLw6fg3jeSu92KTW5djLbE8Touq5qKBq8dSAzoJRnpmVMcG/gyQjMas7GWD+6sfZc6v/+aMO4P/YAYGffXU6muNYnxa+qCmvg3dvSjydnFeGsNSAuywM90GYaj9/NOWEjYeVqq7vlYJBzEZlIkPQccwXdhNWHnTZY0JDRA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=gOjMluT8; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="gOjMluT8"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-42e2d02a3c9so62097f8f.3
        for <patches@lists.linux.dev>; Wed, 17 Dec 2025 19:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1766028631; x=1766633431; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pFXb8Nk8geIO1ZI7yC9fJXWBAudS/MgVgGUkWrMJh6g=;
        b=gOjMluT80wM1DxsvynZVM6Qq+AoapNURTVrLg3FgmCX4XQ2DZZchFjA5iU4NJC6SRC
         WdSIlG/tWbE/Vj04+43Nm2T5IET12B+l3verQJwYvwDHe94lJ7XM4HdiCx/W/7KlJFVl
         YXThcaPSQRZ4TnIcnxE6LZT5FuGjua7fIbvIlQFEd1RTWGuLq0kFdNRMkROjR5JuX4UA
         yYQMUUMmZN1m2wsEuHT/TBPiQtNFgg5JSOQ7FcWlgwMBjjTgVkZL0E9eN4SuvwvAdl/W
         6V3SBXaBEy0DUtB3P4RkyxpfLfeLjNTgUQ249UWScMmftN/uYqjFLAcBau/ctlxy3meC
         4NsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766028631; x=1766633431;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pFXb8Nk8geIO1ZI7yC9fJXWBAudS/MgVgGUkWrMJh6g=;
        b=U5k0GqxeaXF/nglWkO+wobe5BrgLo03WohEarX4P3cw6uoUAzql6UWSz/k369BGqrf
         z+ZzeoC299RELFKq3fo/TYTcC7urM0E6u1XpimFcooX5YEEtNb/+Iy1Mfp5gOEKX1ASC
         DVc4zbMeWWFVgpGaiotbfbWIsUUVMYfNogelec/ZnUnf/XDFtgZNmMRxHHatgE2oqRia
         d5csWqO4S7oL4AxMMy8hoYhOL2RFJUz/6MgGJVk7A9Fy3finlFd0qKAb6GY7aY+9tRGb
         RVEKB5wojp2OgR7SoY1oE3My73k8qfcfRMXtd/uLgxfoBjls2/EHpqvpou1e92l0zj8j
         Nukg==
X-Gm-Message-State: AOJu0YwV7al2OiX0f++l4rFApwdCF3C+UMAf3OpcVOpyTLzaqgVdjc0m
	A+eBgiWBy3uRswFBUkyt1FaVIMzZfIiMdgATSGS+Lc/+cDYkx+FVt1I=
X-Gm-Gg: AY/fxX5r3IyLQJGus66joyiPPeE0qw9s28cYwxwpU78N+mFSFFoD9FPSYJdMNQQAh0S
	XemTn4zqkVJ8ji+KjfLPuVhLuUyTliyu0d8nA0r047vuC04QQXZcL6KVQ+kgkWwn8YHLdjoGlQA
	q0uRy3ocx8quiO112inMNfO317ZxrnrcVwb3y8TB7TboGxiptTrPlIaM6NfhHRIShDsU/BWZl1o
	v3r/ZhEFDYWARAZfF2iJ9GI8uJt8FlnE+PkrPYUgzq9gHQNUFb730DiGhjOZnfPucMog+wKxHRa
	HtVN+GmtJFfFl7lOE0+5BFrSPOnHg+qFGfpjYcguzgiBwa88ytcqbbxjDXtR2aWrg3G2In0U0OG
	gWy7D46lrPg56X8gxMvuUZz7c1U3PeX4JmCYsZH6AHkywiMvVOaQTBC9pMxvIVyvpeuM3UMa+Zy
	2TJcZ77RpivfbRzmbuvmTQ+WoUHEp3jT5g5FU0fOIqo2UfIufAzIj6Jm6vJlYQWkbAi+4j79w7j
	Q==
X-Google-Smtp-Source: AGHT+IHzHfnDgvekUsL5fXyQMEtNxZe7kspWphA1s8Mqlp4zif0GNcKB26q2cSPVHlHfvTRuhf9hzw==
X-Received: by 2002:a05:6000:2909:b0:42b:39ee:2858 with SMTP id ffacd0b85a97d-42fb490eccdmr21068273f8f.42.1766028630989;
        Wed, 17 Dec 2025 19:30:30 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4078.dip0.t-ipconnect.de. [91.43.64.120])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324493fe32sm2410281f8f.14.2025.12.17.19.30.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 19:30:30 -0800 (PST)
Message-ID: <12690fd9-0060-43c0-910a-3dce4e7ac45a@googlemail.com>
Date: Thu, 18 Dec 2025 04:30:29 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.17 000/506] 6.17.13-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251216111947.723989795@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251216111947.723989795@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 16.12.2025 um 12:20 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.17.13 release.
> There are 506 patches in this series, all will be posted as a response
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
