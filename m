Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4A5286410
	for <patches@lists.linux.dev>; Tue, 30 Sep 2025 19:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759260461; cv=none; b=uC8RhZPKVE/KzDOnQo7wKgyJwyAd5mHL9LHzlNtor6Epo1vZVjVsr7IDwTUj/pfdIBUg2HzvsneuT/KICRCPuZluCaihnVp5IoiIYOhAnZh9uiwLdi0ZxMFqzeEi+7S1S+MASrHlSCX9fp7UOe3WMdXh2NZ2AJYYYk3dzJtN5oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759260461; c=relaxed/simple;
	bh=0kyHnmwQ/a13Xmqwsp8Z7wPblzDgblhkclYLzTai/nk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CpmKUSIiUHiybXU5RBbNhFbJ7gkEpKtUzGN+7A2ZqgtTBoZyqnn2UftBuek5EPwRmi8qVWfCessAuXTAMq7lcRl5VWNswwOV4UvvOfeG+OWfzMHuwiMgDEWtZlt7vOEw9NSY/zGpLsg0oaiJZ139O9/1hsZKzaTcxRxWqRB0Ek4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WEN17Gld; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WEN17Gld"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-27d69771e3eso51485645ad.3
        for <patches@lists.linux.dev>; Tue, 30 Sep 2025 12:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759260459; x=1759865259; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nQxDxajR/Sam1KSYzGdudBRiapg5rl5sWBWoYDLBG+c=;
        b=WEN17GldR0UnMajht3Z4+Ir/cqoGiJ42gbib3Pi8Rpa2LntYaiVp9qeC35rHHoV1BY
         gl+9EZ1zxFCSZjbplUwwpX2d3n+C6E9jvvRDjBAtGaXQoTcrfBVUAkFZEm+Le8BftjDn
         pw5PvMQoz7kWqVey3VyF4AUKMT8Zh7nakzZ7beJuOifk1TsA0E4AI+nh3vuTKzncbXD4
         u/+SW2biWzSoQGZG2xapD09xO4zK/Z8J6boyDcubEJvUEFyaFfsFthUIPU1KallchOVu
         jZtuaJ6CtqzGLZ+1AyfzQejemnXY6g8a6yQfcOuBUg+KWbxFuIa5Sn/3OFnv/Z7AVhKj
         ciiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759260459; x=1759865259;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nQxDxajR/Sam1KSYzGdudBRiapg5rl5sWBWoYDLBG+c=;
        b=TsMf8JheTGevA22nbNS8k9/CYElVo6E0ok6Hdc825CdqKRnOle47Z1dUaVJuQN2nGo
         tsl3r0a+9Elh892R3liGlJEcyJfwGzB0fJApWfQ/DFCmL6MoHcenpLCT6okhJWBPJQCm
         KMDLp0iK03gDnzQxSGj6e0nEAkMqAZiAIwgEroH0W+alcUF4yPgcgFgfYW09gOACemxA
         YfvKJhvhvBJDce2GkkaeCAzN3yQFngMpPZVWXh0WB1R76dxiP6ZALgwcWFW8d/yIWCm1
         OCS4nUOljFA6TUrDgbrw7RMxYIZahbqQUgvPNqySWn9PpEXARmyzX7Di9m0ZLWAOivYp
         MJjw==
X-Forwarded-Encrypted: i=1; AJvYcCVCo3RfHUSLCKDWjmjp4pJhW/wbQ4w2+7qOT6XQcCf7PlLJqu3b86+s5gCtJxDnXc+2KsV+by/F@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0wbkOMUsrhOVTSJqM4TQUYYoiVaDNj3eFwMVhK1HsRsf5/JBH
	x7rSNmcLtnQ+OiYgzcx5y+43aQsEf/U2CvWTYIoinFVzLEXpWGOBy0aYeaOP8dvrfP8rTnZuzni
	5vrQZ+tMQrxIQWc8Yj4AfHKnfr4DRxPgHmEzrH2QkEw==
X-Gm-Gg: ASbGncvRgOXoaH46uQqty+aL7qACSSnDSrfkI/BpYO7YpCNL72M/cVWvZMaKfEWWA1p
	WvMbo8rlQDtAHNTISmQKQ6C//m+zDClRHcsdYeAcSMMMKS78f2QZd7WHVtf/l3cggcN4Er06AwF
	6rpwmZjtrL7ApCjAa0SxkHeVsQUWCZJo6BcVcI+C5ZLByhe0yx05WLC+nWi0xN7OLs6x7qQodRT
	DAi3po4EHqql3jtygtfLrc6lstiD0ZbuQUWMX80tdiEXKkmbO7dtq1sv47joL5gIwDs6GRLYARK
	7cmyx4CQ4B5iitrZsPkVapYQLkbhBv0=
X-Google-Smtp-Source: AGHT+IFaFh/dbgGIksQ/VwhgUOF+6SoIM70lxC8KuMuId9DIvXVuvWGEyxJOxgnRTVPkkVHSTJPrNd0WRWY/7Oxyd88=
X-Received: by 2002:a17:903:2f08:b0:288:5d07:8a8f with SMTP id
 d9443c01a7336-28e7f2a3ba2mr10180705ad.24.1759260459391; Tue, 30 Sep 2025
 12:27:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250930143822.939301999@linuxfoundation.org>
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 1 Oct 2025 00:57:27 +0530
X-Gm-Features: AS18NWAq2VDGjJYBroUXlLCPyC3gOIxToosJNMH6IsWUcf3ow_eF-wBXPZYh-6E
Message-ID: <CA+G9fYvhoeNWOsYMvWRh+BA5dKDkoSRRGBuw5aeFTRzR_ofCvg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/122] 5.10.245-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	linux-fsdevel@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 30 Sept 2025 at 20:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.245 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.245-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following LTP syscalls failed on stable-rc 5.10.
Noticed on both 5.10.243-rc1 and 5.10.245-rc1

First seen on 5.10.243-rc1.

 ltp-syscalls
  - fanotify13
  - fanotify14
  - fanotify15
  - fanotify16
  - fanotify21
  - landlock04
  - ioctl_ficlone02

Test regression: LTP syscalls fanotify13/14/15/16/21 TBROK: mkfs.vfat
failed with exit code 1

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

We are investigating and running bisections.

### Test log
tst_test.c:1888: TINFO: === Testing on vfat ===
tst_test.c:1217: TINFO: Formatting /dev/loop0 with vfat opts='' extra opts=''
mkfs.vfat: Partitions or virtual mappings on device '/dev/loop0', not
making filesystem (use -I to override)
tst_test.c:1217: TBROK: mkfs.vfat failed with exit code 1
HINT: You _MAY_ be missing kernel fixes:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c285a2f01d69
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bc2473c90fca
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c45beebfde34a
Summary:
passed   72
failed   0
broken   1
skipped  0
warnings 0
<8>[  868.434017] <LAVA_SIGNAL_ENDTC fanotify13>

## Build logs
 * Test details:
https://regressions.linaro.org/lkft/linux-stable-rc-linux-5.10.y/v5.10.244-123-g9abf794d1d5c/ltp-syscalls/fanotify13/
 * Test log:  https://qa-reports.linaro.org/api/testruns/30062041/log_file/

--
Linaro LKFT
