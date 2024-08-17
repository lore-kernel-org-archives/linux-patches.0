Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD0F84DF1
	for <patches@lists.linux.dev>; Sat, 17 Aug 2024 05:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723874157; cv=none; b=rlFtv91Ns1RhSW41bdZMIPh1yeAyyj3Jq3gHSWujWMx2zy4a6hDZlxCPbWYYymC0nG82mYV4DbiVBzcvcEdeWraQs08h6+WbvtQVdKnrGC9q6tfesd8Bz+WZD8tfZ6+3FpaKn4Ii92pSWJ5++t4RRVkW+FHg60ozrSsnUMhy/9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723874157; c=relaxed/simple;
	bh=x0tjE7zHG6lY5cEzWOOeiKPc6Ssm8TTI/c6m7gLX1m0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AMFTQCEzLZKXtKkGYjNoPL/WTw0oJLpXx8gCs3D3X7veaC/pgF2Im6b2DLUxmSPSwkoS0NNfush79IhOKlm54DbiuNdkwEzFNx1raR7MKAgTDUa5lJwSAMtjvq50gbHwlqQTFdfAXdsPt0FRNXKtfhBhuG/egbXQAwVfeR8k4ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Qj4GWpQl; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Qj4GWpQl"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6bf6e17cc2bso14235446d6.1
        for <patches@lists.linux.dev>; Fri, 16 Aug 2024 22:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723874154; x=1724478954; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zO5DfF0viHSdHtAQMPfC+hUUBY2ki1Sd9boOM/ZvnhY=;
        b=Qj4GWpQlvtAxXJ3LLD80jG1eXGIHFGlrteNZHd+YDeDHpFwTK02Zs+pFTOHQYt1o++
         8381Sm5GL2nEcuk8o5lgtItzuQMPcGSCOltfRKpdwsHDemsyLRZEbn++aS9Y54iMnsDB
         brHdEKOkDjmKtXBMXvJraVVpmy8n3pJDtQmTPnZ+FrL95TUz1y77ltiY6/G4bAqTmkGl
         /wIA3eOW15i+UvvV9sd5mNEcyw0VePczFApKDLT65gy0u28qSsb5ce+5fS6Fj8KL4dOG
         74WkZgSNXNpk0GWpceXOrIjYAVWQhC1A8zoeSNWebmIdWtN2DFxTWE14OGGdDOkyc66m
         dWIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723874154; x=1724478954;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zO5DfF0viHSdHtAQMPfC+hUUBY2ki1Sd9boOM/ZvnhY=;
        b=sHWt/U5six4jJqXZ3Dey51FVvy9OzOvXiPB4VFK1UklhWjLt/CPVJC4XSBZmB/qKy+
         /em0youTjStEbeVi13boTiTtAvaMgSoXnVyyraVKGMU2uzr/zhHHVoUU+4PthQqkc0oS
         Xu7XVOBf0bg1bMlGsHv6KcLzkODHvI8aWSGacJZXhCSvmbmhRAVU0fBhTMfJYDwWRPht
         TRTR7RJixIz3OnVdFS4H6TA68k72UVZ5yhztMBP2nRH2e7w40zDuP919lVbKNJH12cn3
         NyXuSsV295sbkKCDp5F26Cw8KBPWdYVd8tnOKiVhZuHVdldOaxnrE3v2oOn3bP1v1r4u
         aacg==
X-Forwarded-Encrypted: i=1; AJvYcCVUdh9O1+LBLJkAVkJg6jBuO8H1nAWPBX7+hSu5PsOeT/OcVuMNnW3TeoMIb2WoFIPkzsTrZx6H@lists.linux.dev
X-Gm-Message-State: AOJu0YzaI4/BdAuNTn4iwRNioR4x7O2jSq0l8BKfyY9R32jrey/LpYSS
	Bcghb9+8gMAL5siwfDW/ma6UmMjcySeH2UhcxLLwedW7G6UBlIcoLHfGnEmatikCnCMeZnXa5TQ
	/yLk9u+wG1hj3TsEEtDBIqI0Da4vIaXdsZT3hyw==
X-Google-Smtp-Source: AGHT+IGxPjrv7dCSE/Do/bjou+Y4IoMXg01+vIkSYQmvAsJPrtNyj03mz3wUw+BiG/VwsTp6/e075xN4f1duRl7HfrE=
X-Received: by 2002:a05:6214:3f86:b0:6bf:6127:98a7 with SMTP id
 6a1803df08f44-6bf7cf1c06cmr51142686d6.56.1723874153746; Fri, 16 Aug 2024
 22:55:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240816101524.478149768@linuxfoundation.org>
In-Reply-To: <20240816101524.478149768@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Sat, 17 Aug 2024 07:55:42 +0200
Message-ID: <CADYN=9KMRjaxqtcc-Yo9ZDK3b2HH7gzJiwTrUXz7t0x0TO6=uA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/483] 5.15.165-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 16 Aug 2024 at 12:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.165 release.
> There are 483 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 18 Aug 2024 10:14:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.165-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following S390 build failed on stable-rc 5.15.y with gcc-12 and clang due
to following warnings and errors [1].

s390:
  build:
    * gcc-8-defconfig-fe40093d
    * gcc-12-defconfig
    * clang-18-defconfig


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

The bisect points to 85cf9455e504 ("KVM: s390: pv: avoid stalls when
making pages secure")
as the problematic commit [ Upstream commit
f0a1a0615a6ff6d38af2c65a522698fb4bb85df6 ].

Build log:
--------
/builds/linux/arch/s390/kernel/uv.c: In function 'make_page_secure':
/builds/linux/arch/s390/kernel/uv.c:219:19: error: 'UVC_CC_OK'
undeclared (first use in this function)
  219 |         if (cc == UVC_CC_OK)
      |                   ^~~~~~~~~
/builds/linux/arch/s390/kernel/uv.c:219:19: note: each undeclared
identifier is reported only once for each function it appears in
/builds/linux/arch/s390/kernel/uv.c:221:24: error: 'UVC_CC_BUSY'
undeclared (first use in this function); did you mean 'SIGP_CC_BUSY'?
  221 |         else if (cc == UVC_CC_BUSY || cc == UVC_CC_PARTIAL)
      |                        ^~~~~~~~~~~
      |                        SIGP_CC_BUSY
/builds/linux/arch/s390/kernel/uv.c:221:45: error: 'UVC_CC_PARTIAL'
undeclared (first use in this function)
  221 |         else if (cc == UVC_CC_BUSY || cc == UVC_CC_PARTIAL)
      |                                             ^~~~~~~~~~~~~~
/builds/linux/arch/s390/kernel/uv.c: In function 'should_export_before_import':
/builds/linux/arch/s390/kernel/uv.c:249:40: error: 'mm_context_t' has
no member named 'protected_count'
  249 |         return atomic_read(&mm->context.protected_count) > 1;
      |                                        ^
/builds/linux/arch/s390/kernel/uv.c:250:1: error: control reaches end
of non-void function [-Werror=return-type]
  250 | }
      | ^
cc1: some warnings being treated as errors


Build log link:
--------
[1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.164-484-gaff234a5be72/testrun/24890486/suite/build/test/gcc-12-defconfig/log

metadata:
--------
* kernel: 5.15.165-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: aff234a5be72ef6e0a85246b992f6ec19cd59812
* git describe: v5.15.164-484-gaff234a5be72
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.164-484-gaff234a5be72
* arch: s390
* toolchain: gcc-12, clang
* config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2kjlB8pPtrlqwxjAoqVX8sFQDpN/config
* download_url:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2kjlB8pPtrlqwxjAoqVX8sFQDpN/

--
Linaro LKFT
https://lkft.linaro.org
