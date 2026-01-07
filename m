Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B5523D7FC
	for <patches@lists.linux.dev>; Wed,  7 Jan 2026 12:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767787611; cv=none; b=SuRRE+4MUcqoPKf+fNdFZyRqo1viQDYE3cBoI14BMTL+1U/1lZ1At4g/OVBken4J22uS5EXxfU9g9aJDQXFadH0NGuR/zuYXB3wvRae/geVXppAyjWWlxQNOijpmPYV6Ihb2+T2gwti39+yLWvdXsIw/3vM0HCYujl5/Bsm7egA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767787611; c=relaxed/simple;
	bh=Hd89bWb+jjM+oE+CjvJUy21nuwEQVkLJKh/KDVKNEEA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lonWm19/MP3mZ6wjB8InY2LIUB+xDukLQk/GE0O4WXnFGhrS1HPQ+bxhJVHwBQ7SlUn+ISTIpDCvspiSXt1Ui12M6bwnV/W2pW+rmxT+C1P5ba/nQ6aJpjbZLCAKN3lP0hG6COU33LjToBDS2Fljmjv2azuc2rGzOLhKAprYxSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=1u+pptfj; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="1u+pptfj"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-64dfb22c7e4so1237419a12.1
        for <patches@lists.linux.dev>; Wed, 07 Jan 2026 04:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1767787607; x=1768392407; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6UnvZVvYnzo8W+10RWJ1y7Egy5BvmNWtkYjbI4As+8M=;
        b=1u+pptfjeSBukzKwiX7qTDV7ugg2mClv+Kfxi4S2qsWdiOxqBcYpuik34DSxwRPMUM
         e2NKiCwuEMqnyKiv4Bl1f70t6cIcgorjnHvazMsVCnCOtqY6gYPBL5bPk0CYcle7szMn
         zw1DnBMO3+i1+SAfgVBdztSCkwKUDnjrPlp1hNHeqTrjcC8e80NHLAXLTB06D/w65PxV
         7f6VIDzQrDj1hH7KrcCUHSiT6dTtt/nGs598wY4Z6dqplSPSU6nr+gzcMs0ESd4zel0O
         0UBFCJ8KWTEG/ax3tc44XbVVOl43v3Z00Kng0h2HZ86il/hzU0r+8/5uZN2cvcjufKR+
         /uxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767787607; x=1768392407;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6UnvZVvYnzo8W+10RWJ1y7Egy5BvmNWtkYjbI4As+8M=;
        b=FHaK/kR0WWn8sHvaaoTcg9eycDAVFTXGKYOV5mxNAtO8+gM7fOHQQAtKSQBBtiEPBd
         q9UaltRJXZt3rzOJTAgJW9pvAeiYH1fCVHPqN8gWiWv6EM0XZO3YCccx5hq7lnybrusE
         M7KNTZG7p91yTutPRUeNOTXAQh/WLm+3r6GqXLS9LVkzbo/C7vOHM4mFhMGE/Z/CEvgm
         3FOzR8uZduPOhb6oI3okisIAsnx+OI4mQgchnUdQWEMST6DcW2qDsIV+RjVqG8ILLkP0
         J3UFE5MLo2ZLjlTqI6xN4jue/jA8AgmZNAOUDMtqTqsPVWbprxI1Dv/K3o+YVCqMGAaM
         2KXg==
X-Forwarded-Encrypted: i=1; AJvYcCU5avfYw3soisywEZ2AL8tNqKfX2RYlRJsq/2GtCG4innho35saBBZ3kc1H0Ff9diezhmYvScqO@lists.linux.dev
X-Gm-Message-State: AOJu0YyxCEVBFT3RFTyzS9tLr8h1xO9B9rr0VAr1XT56dHkFdXHbqSX+
	R6QvakIplLXUC9PZB+GrsAQlFAxa10MKtqA/tQFQ5sFC21oKFJcjBQBzFhZOz/swOczklgGvUqs
	4Ns1fPFsy24DnmQADhA9hfXpGT8tJ3nkD6SAMbub3DA==
X-Gm-Gg: AY/fxX56wgGDgZTPP3EVQYYeeJF7nDvB4TiopOtnZuKST/1xtiCTkGGUfoY2z7lKA4O
	7G8HrSibwydwXZ99YUab3hntSX748chDg7MMndSz3+MMHcvJ3gqAxTaYLMGqzvDsb5kfNUZWQ24
	Cjw5xQ8qiE8FIgpwbm1Lrxx64SjLL7EXZzZaKFmrhf7uWlGMXTsz9EWXumYYQqNTCheTD19xPoh
	thTjP27q0bAho1M9HnRDYmLeXebRnPiTqwEVkSzLR8+DxBWUmyeudndejbWcGiakXCZuhUC
X-Google-Smtp-Source: AGHT+IGiNPwS91IqhJ7loX5P6SA0DDVvmKocVd5OKv0zCp1ptz33w7p6z4AP5CbtqxxlpklFx+ngNMmQ1ya+nPqy9XA=
X-Received: by 2002:a17:906:4fd1:b0:b80:40ea:1d65 with SMTP id
 a640c23a62f3a-b8444fd5896mr287633466b.31.1767787607025; Wed, 07 Jan 2026
 04:06:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260106170547.832845344@linuxfoundation.org>
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 7 Jan 2026 17:36:10 +0530
X-Gm-Features: AQt7F2qAKFEdLvUVibydeeDv2ylwdVc8DpGkkpMzFgzL_tgc2FatH9qX5peM0B0
Message-ID: <CAG=yYwn4iTqCyqGucNqMxLyZ_QLjA_TOdj4Lr4+dQP50BOWMig@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/312] 6.18.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

 hello

Compiled and booted  6.18.4-rc1+

No  typical new regressions   from dmesg.

As per dmidecode command.
Version: AMD Ryzen 3 3250U with Radeon Graphics

Processor Information
        Socket Designation: FP5
        Type: Central Processor
        Family: Zen
        Manufacturer: Advanced Micro Devices, Inc.
        ID: 81 0F 81 00 FF FB 8B 17
        Signature: Family 23, Model 24, Stepping 1

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

--
software engineer
rajagiri school of engineering and technology
