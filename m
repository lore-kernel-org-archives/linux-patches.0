Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED041199FC7
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 12:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725538554; cv=none; b=mxwBpYb63RBTs7ZoNYZeTIMr6KbpzKe0aUD3XZdmnqHeqWxA2X0HlB7UfiVDXszCbxF7X5D5CF4egNbo+w+zqE0mcAn5Qr3iCVUc8K98wuR/MDnOespTRYw6MYWg0wWi7NJLRE9sLmmPhj7IA8aTSArkqVFUijOQ5NG7IVv4Ljc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725538554; c=relaxed/simple;
	bh=mUZECu3XD23oLtyR4TiJ+f4tm2Ge2L2URhkjRFEzffs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tCtEZW0GIHmVXjxFaUc/b2S085OMJLmhtP2rLD36zl3l1wsZdiFRhlQw9cDDXn8aykUyfdbUt/P1O4xdIZTzgINk6s5zU7WuOfasQ/Lcu47kxTQX4UrT8TtrlcCp64VnH4Y9/ZXtezHUnqau1B7uTZ2NYP3xZ2Ezb8p2RsPGS1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AV58HHjx; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AV58HHjx"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-846c6b605abso1002065241.0
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 05:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725538551; x=1726143351; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3Qnz+skM7CpabV9IsCJlSuO/xZoEhUXery/iq6oi7kw=;
        b=AV58HHjx9H6bzlQepINEwcKP3AFsC5SrVstMhQk70aKdc7KfJaql0JG/Ytu3sYh7/k
         8U0nRJeTPdmTiDza0qLnkhOsQLYfeD/v7aTz66ZAiwFSpLONtrgPP23RCKiT7KQCE7xB
         1dNUGcACEQr1U1NdAdlsYlkUBavM1ukf9DAJzUovk02gW50kRq12a2U7hV0crHX77T+s
         mCfm2yX57gM6T0dVtlhZ9L5KsrXhhLQjHzyfobWFTG5/EOzcWjOMvnMKG4af+Dhum8cu
         tL7r5NbKO2olObiXYyxRP0WaoNAXzQK9iQ2kDZ/pNafbTQFRZZw9k5HkuSt45NiDowEv
         yLrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725538551; x=1726143351;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3Qnz+skM7CpabV9IsCJlSuO/xZoEhUXery/iq6oi7kw=;
        b=KHq/bSe+QCEFfDvg09uu1fbvYtckdpjCDTNM8di9NR7BU0gfNLt0sWXIzc3XnfMeRl
         BkKrDNEnDExjm4wOabUGjIIbcbBIFnbbGtjfEhiBR+nQIYf7Nh25YgDW4zT9PZUdvlJU
         qcbKbhXDPVqqermDcLb1lpBTnhYcGoRn+83xWBftXkyTXfLainQHifb9UF/fd4sqxdjj
         UlEyjrvTqkl5Qe9h/5wQJTsP49jPoGxaxOJGN9Nncz0WAtcBwuplV6u6WjygIYLTqtCZ
         iz5sC7ligbBoHyOlrkXNLRzmAcHhLeYiyfnTIhwpQfHpElUqFk6BIy476gIxpZNFWtqh
         jw+w==
X-Forwarded-Encrypted: i=1; AJvYcCXo+nrYrJlw+5favMmvWz5qSrhV1c+0IAVC5WaQ7uwLdoMHkAqPJpyMZ1m4JQssNx5FAl5quNdl@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6DuFnWzysBrJ85ueXZMtgihNVqBumZsM4iLREmveoRRHP39vf
	gPHVq3T48a1Cuv29YLxNcJpzoW4jGXGPmx4A9gYQwALf+FPGXLIwwz5Mu8M2VPLPpXiJmRvxlg1
	XlDVMSxqCyEBZKcukxUV5XrR/MN0UH3ubGP8HyQ==
X-Google-Smtp-Source: AGHT+IHNYqKainf94hj2ADROXtyYoaLPTdE2ATA2hVcEBZwn4nrhEx7B/lOd2f8OVgUdvkWrxNqMZsa4q+oGwgZSxhM=
X-Received: by 2002:a05:6122:3b11:b0:501:1aec:d2c4 with SMTP id
 71dfb90a1353d-5011aecd469mr685166e0c.2.1725538550826; Thu, 05 Sep 2024
 05:15:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240905093722.230767298@linuxfoundation.org>
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 5 Sep 2024 17:45:39 +0530
Message-ID: <CA+G9fYtziUjN_J4fdwDH4Sf0RguW4h3X9OEO=ZvJzt3dh9hnaw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/132] 6.6.50-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Sept 2024 at 15:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.50 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 07 Sep 2024 09:36:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.50-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following build errors noticed while building arm64 defconfigs with
toolchains gcc-13 and clang-19 on stable-rc linux-6.6.y and linux-6.10.y

First seen on today builds v6.6.49-133-g18327dd4281a

  GOOD: 8723d70ba720be0b854d252a378ac45c0a6db8a7
  BAD:  18327dd4281aaea9d7639a33a52a7ec57c97f942

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build errors:
-------
drivers/ufs/host/ufs-qcom.c: In function 'ufs_qcom_advertise_quirks':
drivers/ufs/host/ufs-qcom.c:1043:32: error:
'UFSHCD_QUIRK_BROKEN_LSDBS_CAP' undeclared (first use in this
function); did you mean 'UFSHCD_QUIRK_BROKEN_UIC_CMD'?
 1043 |                 hba->quirks |= UFSHCD_QUIRK_BROKEN_LSDBS_CAP;
      |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |                                UFSHCD_QUIRK_BROKEN_UIC_CMD

Build log link,
---------
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.49-133-g18327dd4281a/testrun/25035737/suite/build/test/gcc-13-defconfig/log

metadata:
------
  config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2leCGwTPT1TApOAJ20gB0VL84XW/config
  download_url:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2leCGwTPT1TApOAJ20gB0VL84XW/
  git_describe: v6.6.49-133-g18327dd4281a
  git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git_sha: 18327dd4281aaea9d7639a33a52a7ec57c97f942
  arch: arm64
  config: defconfig
  toolchain: gcc-13 and clang-19

--
Linaro LKFT
https://lkft.linaro.org
