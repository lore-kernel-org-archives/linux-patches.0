Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736211E893
	for <patches@lists.linux.dev>; Wed, 10 Apr 2024 10:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712746099; cv=none; b=NNBEYTxTQ50wHWVTopPqiotkKwLam/2wGCn++HKp+prma4AgWvW1S5BlXLatfu3GyKW+zWVX62K4x/qvoPe/dXp9MRg2wWJomW5uUncZgENtFxFzGH2GEonKb9JYrUdf4MdenP8Td0UvFSQiUqe4fQvmxsb19+VHLGawPPD3Tvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712746099; c=relaxed/simple;
	bh=eik9m6cp2uZohOzU8Oz+3bZ4OUinbaNDJ9WanhK7KSg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=srZGwe0TC+Op3lwxX4mND4AEEmZrmqfwMCDJii6GSNMYyTWG1vJgqlpDJzoBp1m7Y7ClQ2r3VarEy8/HCy0cNJz1iqIjZdD+ifQHIbYO+zfWh5ECDDp3hDjn9vbztdOecIE64VxTgy+7NF6liapByzDzbvauq7W3xNr96v1z4L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=3a2Xa+FS; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="3a2Xa+FS"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1e0b889901bso53412905ad.1
        for <patches@lists.linux.dev>; Wed, 10 Apr 2024 03:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1712746097; x=1713350897; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MNqD10j5CZpBny7jQPfQMEvtKqWfKf6kWfbDUoXBuJM=;
        b=3a2Xa+FSiX0rX8HX35R34bi8V5IHOYZPffiNOvcnuXDc1g+s2gqkCYrr/1ZPNG7lEG
         ErTLs9EzoRYdOY8uE5GpbUS4U9tZz1uFZtkJANhSQ3KHiYlhdj0fiPUh2nClxAx7wLBT
         ZSqu2U5pELpKm0xTtqeikMahGGfHyYNsAtUzcR6jAA0HvYVHcDg9QMh4lvzFm7pVrtC8
         AsKhJRYZKsp73/jAGDk7K9pELuJVEOCZuZKfvlkZGQk7210xP3g5My14T1D1T1eSDOB+
         Tr/r6LkMI1q4IKt6XEVPr3VYqKnf07tzsSO4FN5Hsf53CPxZ4IgPsSXidH4fr8z7Cq8l
         RIgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712746097; x=1713350897;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MNqD10j5CZpBny7jQPfQMEvtKqWfKf6kWfbDUoXBuJM=;
        b=BF1rsaVcFg7DFsh+KFi1t5U2XFFCSX1ByKs6lZiSppDC0eGNc9Vjy/NhTaRXQUSbtq
         L/obPD4tRhKYLqMEJW++NkswIxqvO2/0WAs8XMKCG7utXqV2PZi2FbbGdq/orQXoLjIe
         kCNnMKHkwsV9C/sfsgf/D1JZfO+9pgKbf2ovcBfho7ceRsi+5Y4H1u8bGG95SKXjEvlI
         mDWtQEQr/hyXYJ2uFzIgKtRQUkQW5iCiR9TYvZqG5fIJHu/qBL5hCRHUI9f6ZxCgKyso
         6NWOV27F/24klpux/iHFiF6WE752dkcbNsK2SFeXoX+ZBCcmFN7vRNTRtRY4ay3ATg8O
         vobw==
X-Forwarded-Encrypted: i=1; AJvYcCW/GnMVV0kj3wK1GJE/RAp19HAuwa+JU9Q6tooiCIW7ZjaFAisdVaMe1MQaO86P2iqv2L9ZQV5P5FRwoR0lowZEAWxAZCQ7+Q==
X-Gm-Message-State: AOJu0YzWFPWw1Yoiy2C+sqcDrmTqiZCG9QyTY4u4Ov6ER17bSxDa5XfI
	cin/1leieInYk0g/JZy4CUcejlCYijYtQPWf1et0+NBz0IosBOwAWzWIRNU1kXj4YxDYCj7SlP/
	yBOILSRNeMAy8Xz56bevKiOWKpMwykpukk1uXsw==
X-Google-Smtp-Source: AGHT+IEOi7A+jM3agseYiE2tgGFF/lIKAomfhvj5GEMdbiDzHPEJRuS+/3WJ05h17I71ATBjBeaOThBJ5VRShOGE6pM=
X-Received: by 2002:a17:90a:6b07:b0:2a5:3438:a31b with SMTP id
 v7-20020a17090a6b0700b002a53438a31bmr2111883pjj.37.1712746097485; Wed, 10 Apr
 2024 03:48:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240409173540.185904475@linuxfoundation.org>
In-Reply-To: <20240409173540.185904475@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 10 Apr 2024 19:48:06 +0900
Message-ID: <CAKL4bV4Ltkhh=jBBoy4CbnLOG25Eb4eEpLC5usBmeJFXZEf28w@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/255] 6.6.26-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Wed, Apr 10, 2024 at 2:44=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.26 release.
> There are 255 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 Apr 2024 17:35:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.26-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.26-rc3 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.26-rc3rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Wed Apr 10 18:40:29 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
