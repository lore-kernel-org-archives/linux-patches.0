Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A2B364E81
	for <patches@lists.linux.dev>; Fri, 13 Feb 2026 16:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771001146; cv=none; b=gwEGRqKtdyw+0ZaMbFBObANW6FZUMaud03aHNTXsu4Sf0uq8b3rzkMN5OdGoZh+NQpOfJfJxPidUa7a7aiEZQ43ntPRsJi9O+pyXe7LHBlfHmVH5jbklVws7BFAFhKeluE/G5dUQRskfu2o3Fgf2vObLMQsyLmrKBW3gdbpyZTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771001146; c=relaxed/simple;
	bh=/jc+4+lmzS9c/BTr/Bqx2gnrK4XNe768++k2lJtwDcw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ISjSrJyCaVpHoHkrjBj7uzRMG3HDI3mi/hqLYKs01JdUlHjdVdYWlBRCIP3LQDSBTtbiOqS7tK5dE6sJnS6fC5C/vhMgEQwygjFw26KYnE+Yxthkpfc3RkiKrlOX5BQns2C/ZmZZ9jxLuiLSQDQsdCkePIRlnftuoqsFA+mX820=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=a5+j1UzJ; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="a5+j1UzJ"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4836f4cbe0bso9636005e9.3
        for <patches@lists.linux.dev>; Fri, 13 Feb 2026 08:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1771001143; x=1771605943; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=88WkRtYTP0O2KMDAviJt82507UwMeh5vWMJa5+j8CU8=;
        b=a5+j1UzJd8L0Z/KjiVz0udewYXQNMjj3GcRffi1KFyguNRBs5nYqpHsLJG94hPwQdv
         RQ/+qRC0w05R5eu2pdwyUEYIriWeFnoFCjzdb/uVEOcbSWVjp0B/LdycXz0Xd6jgz9q2
         5lKUAGk6d1P3W1d6z/UXSIa9ZQaujBwGY/QEHTYEwZ5jBslx3doYkkiL048GWZGmiyCF
         jjKOLM1ySCKualCFjkiZLTJYaTpnoP8PqfYz+C+kuVKuUpUQPgOAB544sTb3hBUytMlu
         K7tuZbim90vTJtQA1tphbj7bTZbXrFmx/qS3xv53qFQHV6hd0NzyvYDcLetY0mNUWoMw
         bW0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771001143; x=1771605943;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=88WkRtYTP0O2KMDAviJt82507UwMeh5vWMJa5+j8CU8=;
        b=RiONQpkrVQx5HaLETP+QP0lJKtm87mkfO/ON8E6vqpPfm19pOp8xmAoro2moupLiCp
         p9PXLpyvt/PFXPoMGtExkDQ7G35IQzVbqZiyXH+KjF49TzPpAHE3SlXZtA9D38cFeWog
         PnxOQUgoQWlCZkPuM2u/sj03lXQiFjZ47WnycmVB/z/EtZ7Ags5Mmof/CbZUHLF77s3T
         DJv3LWLFlQ1YUm4KByHijBpMDDvDEeyFpLhghPEnVDY7v9YRHtG5D9T8joVDnp6x8WQv
         ydyOcQw/NC8D5gWiZcQDausuRRoGuRJNqU559q/Bt7yV0n6VS0YIH5FhnpoeeTm8+h+u
         RM/g==
X-Forwarded-Encrypted: i=1; AJvYcCUp9+W59377LDmDCYrQDmlfr/novS8f3aGyybzGC9LDBNvsqU5l/a98AAws8JrjQqlxf36tTX7q@lists.linux.dev
X-Gm-Message-State: AOJu0YySZmDaiiOqXYu/Z7lBR5ifnb82b8k2/4C2D9tmGtnZCVMUaheQ
	6GXjOMd/LGFnE4t1R/11T4PP1qi8PZ9xsW7hVgi+Un5Ny2JgFrroR68=
X-Gm-Gg: AZuq6aLWmsR09hlLUeaK/doYi09Hb4nXi/TcLM9qBRvJGY5SjCPQJImIFSr7gdrqeaA
	lzJor7yfshRwxZ5ZvYtzRj0xeiEWFN1+FBFseD6pbgjlZsgulC6XhmToAAEKVfTtCBdkqX8CPHG
	L6BrKhbZ/SMpkqy9rkuNajIQvbhpH7SR4LaBz4kgEuK+a2ztFURfZtwQNj8Mia2KEyj35F/tIqH
	87h/u+QFKxumTjV+wXZRABXReX3iatgm88tJY4LSRfMB1pAoaNlnG+BeV8t4RAsF6ZglYYHK/IU
	5QlYQCFrzrGtoYzX2Fgtqs8wykGOAaDTVjaLVaU/iAj2mqbMkLMuttPJXkCFnUw1umAK73ZiYjP
	IioqEqGOdRUoCnu22dJF2Ff66snMFAN42gG3apz031KW9uteJgoLLAGy1j8Y/P81TG971ml2hqG
	Wyf1c6jmI4PWNekUbLS0rgdhbPtjxV4Hu1QzgBD9lsYhQtRv1XJrvidKpv/Ox88TgTCczdqE4vB
	as2
X-Received: by 2002:a05:600c:4704:b0:483:3380:ca11 with SMTP id 5b1f17b1804b1-48373a74dccmr42130645e9.33.1771001143042;
        Fri, 13 Feb 2026 08:45:43 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac4a9.dip0.t-ipconnect.de. [91.42.196.169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48370a58721sm26380735e9.7.2026.02.13.08.45.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Feb 2026 08:45:42 -0800 (PST)
Message-ID: <c1d048c9-c662-4709-be49-0e947df31ef1@googlemail.com>
Date: Fri, 13 Feb 2026 17:45:41 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.19 00/49] 6.19.1-rc1 review
Content-Language: de-DE
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Achill Gilgenast <achill@achill.org>, helpdesk@kernel.org,
 stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 sr@sladewatkins.com
References: <20260213134708.713126210@linuxfoundation.org>
 <DGDX0HGRJJ3N.1F1EWJEDMYZND@achill.org>
 <2026021312-magma-dormitory-53af@gregkh>
 <2026021325-repacking-crumpet-5861@gregkh>
 <2026021353-perfume-drum-3776@gregkh>
 <a856f911-c493-4c48-ade8-467d9da1f628@googlemail.com>
 <20260213-manipulative-proficient-robin-fc9c06@lemur>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260213-manipulative-proficient-robin-fc9c06@lemur>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.02.2026 um 17:41 schrieb Konstantin Ryabitsev:
> On Fri, Feb 13, 2026 at 05:26:51PM +0100, Peter Schneider wrote:
>>>> Ok, pushed again from my side, let's see if it propagates properly
>>>> now...
>>>>
>>>
>>> It's a kernel.org mirror issue, it's being worked on right now...
>>
>> It seems only the tarballs are affected?! I could git pull this RC just fine
>> some 10 minutes ago and build it. Adding Helpdesk and Konstantin in...
> 
> It's back in the world of living after a 2-disk RAID6 failure, an LVM cache
> removal gone wrong, lots of futzing with /etc/lvm/archive contents, lots of
> very heavy swearing in all languages known to me, and lots of nailbiting
> as the RAID array rebuilt over 18 hours.


That sounds like an absolute SysAdmin's nightmare. Glad you could fix it!

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
