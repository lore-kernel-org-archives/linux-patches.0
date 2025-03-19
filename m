Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40D718DB01
	for <patches@lists.linux.dev>; Wed, 19 Mar 2025 16:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742402244; cv=none; b=qF/a3Y5fVF4SerfMfuU9IRd2VHgX4wESv/7P81G2zW4Bj3Sefz/CszeC61CYFHoWPmvx4WR82nk9Xx+IgZ3g2c8gHfxvCfq7JXyeEttfQI8Xue4mu7n1WGLe470LYA2Zmfxfa0DJJtphI4v5Gu0FPTO1Gs/tgOq3+aFfIWqayls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742402244; c=relaxed/simple;
	bh=aP0Rl7w80xWkGkqKHRr67yXDm7ulD+sujdgDABoMhX8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lPtnt4/md5fDCPk95hPumyO4hxpOoGffMx+MQyCnl+/O6ZHsXCCIyd/ko7rZM0Vz1/9z2SkaUYhSv4rJE6cMSqsFodQvmMwCn6xk2B6RJTMzD6oj3B9wwJWiI2SQ72HuDkCkBYPR2W9NXSN/8zBKaIYfrmEEr5Q+rILWL+g8N2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SMWlvN/6; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SMWlvN/6"
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3ce87d31480so38962585ab.2
        for <patches@lists.linux.dev>; Wed, 19 Mar 2025 09:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742402242; x=1743007042; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1jhbbYo54FrkdrbzdWrKMeFfQjie6aK1LbfZTGe7VZs=;
        b=SMWlvN/6b55IqVTCis0GRiA4fRxyP7vPD6uw7sAkJbS8FdEK+y0Pqn6ZU2JzlWioF9
         q35MhPptxu+s9Tlsq4ypA+k5H86KVJtuqgEdnsyWd84pKx9CV0NPgxq+aVgdO7EpdABC
         tayJKlg7N1HmCy02cYsIbcaeyO3niyhpElc6BKuBg66c8SKOuET2fVWjs9BMUDYHChCg
         JsC8XLrgpZzS1f55DsPl+L7OdlqKsgZtE/Bipu5AxbQfqWsIhzvK4To1l/xn2UYMOoxC
         A3FNcU7otduH0fcUA/niCLnSutR9JKlWMOYbccy0S0B/+P9W+2yHOYr2F3s0ecEOUBa8
         vBcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742402242; x=1743007042;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1jhbbYo54FrkdrbzdWrKMeFfQjie6aK1LbfZTGe7VZs=;
        b=Flp2/dO4dbOL05/mrjBFDyVN3INyiWcy45YOm9QORJFaFtjwgHS7KA/bXSYCC2Lron
         MlyFMmMZVOjV+78hvj4yNWCNKTB+PUg8/C4amq0N1htE2WxS/RE+27bb2gTHSVbMmqlp
         GoGW+DdyEpRvDZ/6FqaPHLmHXapgHryR9gZXBLOMNOCJ/qT0ys6ZuLpKP6yjgIUptB35
         EFAbivAVwYQiA9qXAfckOsprZN9WY0Q30/tHFsuaAbd9hXINqp4tdrWOoMso7ElAsN4H
         JZcLyjRyEbvS/EztXvrOXST2/6/34exBQFySQU7LF2Aucgc0gYyP/f2VRiOhhaam0/rx
         rUng==
X-Forwarded-Encrypted: i=1; AJvYcCX9rWxsIzq6zevi458fDwiocKJmYDFicAJbJs77CMV7X52pLXOs9kjCkV0MImWdYUK5BTxtJuJY@lists.linux.dev
X-Gm-Message-State: AOJu0YwmxF/0syz+QutEacPOf6YHqP3ufrhky/zE+0hmT7FB3jiXfKRH
	f+yw8z+aBLaRumqoLSdVBKRtvT/cETmvHEIUcJARCpzSRY3RIh2cqJoqmpcuIqM=
X-Gm-Gg: ASbGncv4s3u9FCdj4mw6u6R+LwQtX+Si6TgU+/cD/udXIdWFzMcR/pnB5hiiLqy7iH9
	88EBfyamtPNPjmGKglOICAhT7oZjoEExuKz7rS0t7+7tDeu8pHYsZXEtxWRnp0vN3cMpn6K19Od
	A9eTF665OoQDCLSHTxs7fJqFxjF+wgIJSx8D6PabwMH5ilPYR1D3cviLWKKG8bTpw24ckzJpsWa
	MtYMEw6bv/2/PUZhGXVmoOp+wo8Sh2V06JaxR8iuAhxMjbeHvRr3cxg8/t7Z2+VKuv5W+/RZlnx
	QrjxcwmrnQ3llEve7QEIWqelqheqcrP1NvKEmT41dAkczb9h4qM=
X-Google-Smtp-Source: AGHT+IGaCxxqOmIU5qslU5LzXO4appalUTv0emoln2y9KsdecB1szM6soHATQf4I1FwwkjFCnXzgvA==
X-Received: by 2002:a05:6e02:1d0e:b0:3d4:36c3:7fe3 with SMTP id e9e14a558f8ab-3d586b44302mr26627605ab.9.1742402241910;
        Wed, 19 Mar 2025 09:37:21 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2637fb2b2sm3303066173.94.2025.03.19.09.37.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Mar 2025 09:37:21 -0700 (PDT)
Message-ID: <2deb9e86-7ca8-4baf-8576-83dad1ea065f@kernel.dk>
Date: Wed, 19 Mar 2025 10:37:20 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/166] 6.6.84-rc1 review
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org,
 Pavel Begunkov <asml.silence@gmail.com>,
 Anders Roxell <anders.roxell@linaro.org>,
 Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
 io-uring@vger.kernel.org
References: <20250319143019.983527953@linuxfoundation.org>
 <CA+G9fYvM_riojtryOUb3UrYbtw6yUZTTnbP+_X96nJLCcWYwBA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CA+G9fYvM_riojtryOUb3UrYbtw6yUZTTnbP+_X96nJLCcWYwBA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/19/25 10:33 AM, Naresh Kamboju wrote:
> On Wed, 19 Mar 2025 at 20:09, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 6.6.84 release.
>> There are 166 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 21 Mar 2025 14:29:55 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.84-rc1.gz
>> or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Regressions on mips the rt305x_defconfig builds failed with gcc-12
> the stable-rc v6.6.83-167-gd16a828e7b09
> 
> First seen on the v6.6.83-167-gd16a828e7b09
>  Good: v6.6.83
>  Bad: v6.6.83-167-gd16a828e7b09
> 
> * mips, build
>   - gcc-12-rt305x_defconfig
> 
> Regression Analysis:
>  - New regression? Yes
>  - Reproducibility? Yes
> 
> Build regression: mips implicit declaration of function 'vunmap'
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Ah that's my fault, forgot to include the backport of:

commit 62346c6cb28b043f2a6e95337d9081ec0b37b5f5
Author: Jens Axboe <axboe@kernel.dk>
Date:   Sat Mar 16 07:21:43 2024 -0600

    mm: add nommu variant of vm_insert_pages()

for 6.1-stable and 6.6-stable. Greg, can you just cherry pick that one?
It'll pick cleanly into both, should go before the io_uring mmap series
obviously.

Sorry about that! I did have it in my local trees, but for some reason
forgot to include it in the sent in series.

-- 
Jens Axboe
