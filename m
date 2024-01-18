Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671BA2C693
	for <patches@lists.linux.dev>; Thu, 18 Jan 2024 16:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705595750; cv=none; b=goFT01aCF3Ik85FwqRrZh+JEQ/YCV6/94X67GTGFrFz3Fsb2dxzVUH4GNHYAFq5OWpx4gNBl8qaZlH2JJVeognakxq7+EWr6Xog5PZUW1W6VAEyU8OJiaPf3ffry0J2Wp6HWrjmDtU28KCnV8h8e1mzC+K4reYatuYIKhPv8Gd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705595750; c=relaxed/simple;
	bh=HVtIWULhKgdre+jmToxGqERh4Fcm+IoYq7p6h7HkQ6E=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:Message-ID:Subject:To:Cc:
	 Content-Type; b=cGSHvjCfExbhDB/nAiAb3EGDufSM7Qi2SPUWoQXe9h7S+VpgF465t3BTbu5mAGCHNMh/xocNb0NIxXJWMdN6HW0ySsQp3hXUaYSCYlqLkvTc9KuVZ8CiiIiWkfdltXpufWt+QNu9ev2BUQ5cv9l6OxrKyomSXf6+yX1b4hSxr3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UYxLGlkR; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UYxLGlkR"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-7cd4d77e2ebso3505303241.3
        for <patches@lists.linux.dev>; Thu, 18 Jan 2024 08:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705595748; x=1706200548; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gpvBWl64BM2U+Fa3xxlD+umyFQJyzuRde12Sfj64vBo=;
        b=UYxLGlkR59zT7uMTs5LakHNm6oMfOsqe7DkSoohK5/1Gy9jrfkSZ7IhCsmplN0f22J
         CFKd/eQjTUUlvFaRAeBgDzh97R+lMRVkl8GO7g/ONlcxG5CXLZYLaKPbVfHV/4lSGaX7
         p4Ihwjw789Xi4tyoMQNvlG97DykBCpNNM0aSFMbk37RwgdPQtOIROZE2yopybjNyIB+f
         sXFW+8P1HhJwmhtCBLYBpZTipE2ZjEmpHDEtIiN5MdpDpps0nwwniNNXZd54U1rwC2Wg
         u6rTrkekb+hP6vXEz7uOTjqulZdl2EnDvxw4Pgj3Psb8dZQqrUJB036L1tQX43G3ZCQA
         GRfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705595748; x=1706200548;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gpvBWl64BM2U+Fa3xxlD+umyFQJyzuRde12Sfj64vBo=;
        b=RFqV9Fde3SuqiJ0GbtvxR6IQi4tINyWxY2EYz3f6nMMhSxT0EVto3uVy1uHDs+f7nU
         5mC1IKa7eu1BCGNdfQg/28V3vV833hgjFGmPg5bhF2XXev3UsBQExLuGYiOL2LlR+Mwb
         wTvNNo5LcFKk0HQ5Wxh/GsiKMcXgAX/D3ez+SUb7opTs6oHdUs52yv/hlynz9n5lVHD1
         PaBut5jAa4Bm8VFnaxgjpC42+aXUWylDQz7UKfIxyfyAAulJgokIM58jXppflbZhcY7w
         VadwwpXH/754p2wShY3rEG5HChQZ3jxTVSUeSCBMYaT9sFtC6zfTLUWefiFIUbI7GFk+
         ETTA==
X-Gm-Message-State: AOJu0Yx/6p1odGTV7uQhdoj+P89AmpAKBSfVYBPeYkzdkfl6sKIQyL1h
	tLmEH2vGK/u2E4nQ/GxETB5tXfLwNE7BfhiU3WhiQfsdYemN0+fCmDjQ6lOxYsTEIULwQ8+XyQQ
	daGnh0hdl1K0UHLp2jmvbZHFk96E=
X-Google-Smtp-Source: AGHT+IGMs6yZyS34Oap5tc2ZDXBJhIXQx0gOhbO4B68g+nsccnaReqwgyA/t+qBdbyFSF6xrgOnuxZep/LYYPo8vPfA=
X-Received: by 2002:ac5:c8ac:0:b0:4b6:d3f2:6d26 with SMTP id
 o12-20020ac5c8ac000000b004b6d3f26d26mr726202vkl.26.1705595748326; Thu, 18 Jan
 2024 08:35:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240118104301.249503558@linuxfoundation.org>
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Thu, 18 Jan 2024 08:35:37 -0800
Message-ID: <CAOMdWSLdLSOMpNb24CWDDOf2qH9ZLw+7_+vOmAiDWB6St_XnBA@mail.gmail.com>
Subject: Re: [PATCH 6.7 00/28] 6.7.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.7.1 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 20 Jan 2024 10:42:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
