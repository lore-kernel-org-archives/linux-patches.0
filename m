Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851FD1BD516
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 16:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722444590; cv=none; b=uIoBn3wnrW+Y6o8q6NvuYpkz1M9SWJKqxWMsLFX4tYDZ24yShTwTTxGJthhSCkV8cnNRVfgGePgncJSJuOalaYk0nKtEHA64EksLqs7xKTApDaMfkSnZ+KD01m/fA8ybLyBr1fV4fkCy5VCULqXq7NdbTUi/Wa0i5SGm+OczLO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722444590; c=relaxed/simple;
	bh=8COUR4jon3L8f5VLwM53D1JRLAKJ/oJmYgFrKUa37Js=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p4ecthceMW+wHKxrk/fTgsO1VLz3cHu5xMraXJwvXebbKUCKydoOXsiuSJs75c13JuKVem0LQ+lKhfUQdkBpYw/ar5CQeofKOWk9NXzzQe12naz88erFOtCJyHrwvAra50RHIL7nKYfc43ez5RbHhGcW71Dny6nd1vHD6Jq4PNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lnDQT20z; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lnDQT20z"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-81f932ede28so31813739f.2
        for <patches@lists.linux.dev>; Wed, 31 Jul 2024 09:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1722444586; x=1723049386; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V9Gf2Q4Tk9nOZbWGuUSF4zfICmpYu5ZWAJDD+PJGym8=;
        b=lnDQT20zVaLpOZJ/8QMsCrvuUdYOLwWGYrdSZBZT4/dfY69ex5mVZ0ICkUl0rxgKzl
         o+57ULHGOjhQzAnBxEeWxtZKGs58VvJhWraJ2IunHKc2ENtpavn/tbXJNm983fq8rKPg
         q6jrl5OH+qQV6tF9haZBwLFxLPi1w0ibtc3wdfAzdguob4WwgRVziW42hudPE0gHE3TF
         CJtyfrB8sDm41HIBVSWjeiNPudqZ7ZF1tQy0YEzbFNYm9V+nU+vnfFfX65AnsAqeM5pv
         ogx6XGfrbCIT9coLam5tVp2cBGUNCVMxuG32BoVnQmeskhcjn8i1tKwd9cGkZCZXaMxE
         tHHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722444586; x=1723049386;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V9Gf2Q4Tk9nOZbWGuUSF4zfICmpYu5ZWAJDD+PJGym8=;
        b=TkIMa1VRL0W6iYAKdWV7jl1C1vMeAKcIc5IMbW7rjkrI4UFirLDlk1VobgFawpqvmQ
         6KCOlWRKDMlczp1KFe6/iB876pB24KHQ/WeCPQtVLF3tEyXXbbApPad6zlSOTQzivp9X
         ohbAVCtmqNL2ftXIlbFywpNfge7rzhcqCwiL083Q8HaYDqpJL+lhkfgfrLCazv9vhQZL
         rqiPazVYZ4kyxiDVlBH0hZ3u8I+teJ3BvCacDbrieQEmpCR75mREo7goYJuv2dhHUM/R
         mIIa6+/V8Xj8WhUrlvUSBgpBAj1StcaMc4zD43TJlUXs7POULrcyu4QFNRG3Q/FEcbkU
         6HrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtimgFI2XQaCerg8hpzY+fvbhda923TNVY20deMA9b0W8g3nY0ihGrjldbuvMrBiCWKtkE5dNv@lists.linux.dev
X-Gm-Message-State: AOJu0YyxKQLupwPC2SYO+hPVFYewa6K8pHbUadDwARQVJm9pg4U8V3W0
	+kOoeo1NF8gc7R0LUaMjhPBIMK0kfX2QH6Ak/DQ9tWjlSXBPHmz/nTRXarbjJBI=
X-Google-Smtp-Source: AGHT+IEk+lGB0Kz5JVSDo0ASBT9BQfvixOonepbfiFsTxqUQPKZroqdGrUESKpSIwV9EY/KvPOv8jA==
X-Received: by 2002:a5e:c116:0:b0:81f:9219:4494 with SMTP id ca18e2360f4ac-81f92194514mr1019042139f.2.1722444586625;
        Wed, 31 Jul 2024 09:49:46 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c29fc0a133sm3243209173.125.2024.07.31.09.49.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jul 2024 09:49:45 -0700 (PDT)
Message-ID: <45a5132a-592b-4fcb-abaa-89cec26a0334@kernel.dk>
Date: Wed, 31 Jul 2024 10:49:44 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/440] 6.1.103-rc1 review
To: Dan Carpenter <dan.carpenter@linaro.org>,
 Naresh Kamboju <naresh.kamboju@linaro.org>,
 Anders Roxell <anders.roxell@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 linux-ext4 <linux-ext4@vger.kernel.org>,
 linux-block <linux-block@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
References: <20240730151615.753688326@linuxfoundation.org>
 <CA+G9fYuGGbhKgt6dD2pBCK1y4M3-KUhPZcw21gYtUFzQ32KLdg@mail.gmail.com>
 <ad4543e3-53bf-4e2c-8a3c-1e21b9cfa246@kernel.dk>
 <ea202d37-7460-4e45-9e19-6a2b23ada0a0@suswa.mountain>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ea202d37-7460-4e45-9e19-6a2b23ada0a0@suswa.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/31/24 10:46 AM, Dan Carpenter wrote:
> On Wed, Jul 31, 2024 at 10:13:26AM -0600, Jens Axboe wrote:
>>> ----------
>>>   ## Build
>>> * kernel: 6.1.103-rc1
>>> * git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>>> * git commit: a90fe3a941868870c281a880358b14d42f530b07
>>> * git describe: v6.1.102-441-ga90fe3a94186
>>> * test details:
>>> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.102-441-ga90fe3a94186
>>
>> I built and booted 6.1.103-rc3 and didn't hit anything. Does it still
>> trigger with that one? If yes, how do I reproduce this?
>>
>> There are no deadline changes since 6.1.102, and the block side is just
>> some integrity bits, which don't look suspicious. The other part this
>> could potentially be is the sbitmap changes, but...
>>
> 
> I believe these were fixed in -rc2.  We're on -rc3 now.

OK good, thanks.

-- 
Jens Axboe


