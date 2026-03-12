Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576AE38423F
	for <patches@lists.linux.dev>; Thu, 12 Mar 2026 06:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773297328; cv=none; b=jmg+R379RguKjGB2VfSMyG4qh7+IErhog3nlTWogFWdvQIpqq/NOmHsmhKl2s/lFqjCNZRCOd3NE94TcxnijNw8cylLjzbIYeSjIMjQxIowKY6kX3ujrifGaUWWjdCCOLLOCf5Db3dSxYZOGOud2pn68bIokhj4OCFCWElXpapY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773297328; c=relaxed/simple;
	bh=AFwlJ0FtBB4TwlvzrimwzLeSt6l6pknXyQyDEH9TIdo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B3ZxHfsQWO7xQYeGxyNOBiV1hx0ZLAk+iXM6HRTbazsLx7tzZtF1Xk1pEVWTFxlsZfEztscTGq8wztIMpIu3WNJS9L/bR35WWfNVEeH+sVFNTox7fNL7JivfLluvmtkts9SLhoVd+DABBk97uOCIhzBAMJbkZrPUR4LTWEntFT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=V4Om3i2U; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="V4Om3i2U"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-485410a0a8aso5708765e9.2
        for <patches@lists.linux.dev>; Wed, 11 Mar 2026 23:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773297325; x=1773902125; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cu1K73i+ibewnUAZwwBsDvXv8G6/JQt0pmtZSfjPlGw=;
        b=V4Om3i2UDRumbJvKxfkGp9qDbrIgO29X/RB3mE4Madl3XRFuPb23qSW2zG3eUXpHzC
         obhtTI6o5DhRnypwka4xy0rSqWTEo/gDkFKiomzVFWsh/oN+vCFWAGu6Tzu6ZpbeYsQv
         VcqH9zMRpea8TVQbqETSlOnuYKy/BBf8motr0c+ZJ1IdbDTvNQQUVn4RM0tPrx8d1f/m
         bV2NnylqH0oO9aTQNkutaxmWTO9jnKZqFV0+fpeENNpK2Y++0RFk18ocMya1XliXTR0A
         fk3xx8ZSGeio5WWKz4y0dUl2i5dzMngSw0Lm6806uwpf6r9TorbVX+ZZtZgLEXk5P2PV
         8JTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773297325; x=1773902125;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cu1K73i+ibewnUAZwwBsDvXv8G6/JQt0pmtZSfjPlGw=;
        b=i9aWFzGyUNLEs9iELvyZKPrdP/B1WmSS2glRAlHBpjlVXB5bKWt6jDkpk+mPbdxIbg
         t4FAo3GWryty1+faOvWE++lHuv2pDHJsI1qYJE1G5DBxuzU5gO1Jz3/gCpT1ZFqqWGl9
         Lg0/hRmLWwwYUpgpNNgn1rQSYQQUu1OolrXwO8fEQGaCmKfIuqTDA8UjVnloK/zjZk3T
         1RqUPh+MC/8kLI8beI+AAjU/DK7eCUz2bcJt2xgK5OyjK9VABXEXK7IjqykzVaBp85qw
         ocu8uxhzg6oKWiyCF8wL/ecFDfiWrG3eAt+uYstO++jFmtdFIjY8A814txTaVrH276FS
         F4SQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/keO6EbefE9Lmnj9/LIj3cUBLi1X+cMVkQQZrAeYKRBe6NeJFK+N2UOiRKZNRSALbzOLjaXH0@lists.linux.dev
X-Gm-Message-State: AOJu0YzdKdlTkD0OiVkpVqci7FCYR7H60J2w/oGE7NAhRhmPPZZWQtJn
	NYemrHhOt7GxCObuFgyUr522MgVXVBvWDeXIZJDoRyKgW22EcbOuVCEfbRVqzEz8tUk=
X-Gm-Gg: ATEYQzwurrJIuLmGwbVKi/4YD5YUfX3rXvBkVnc07GnD3t9dTZd1qjO7ts8A2rOyw6a
	s280CRiahjSED2baCu4pILHqqqd5dmmSvE/oxlIk4rjQnWu7lbw7MQiNEToF/F3+7ouwDarD0oO
	3ehxWJcD70wQMcc1N9ovBnydY/ZuWTsFPMPWqMtLkp7M0EA5PZpp/cJwu37mPCz3V5eNbwNpgEa
	bu5gukyBz/VaHVr6GYxr4PEwENs/m5FkT/uQesZamMQHjrCk0MrVZ0HqxZBzKP7PTbqPECmbHmc
	p6X+L4XQ2o8SHIhniysenz1Dylb1bcFPfeFrFIDf4vFAFw2e2P7LKAsnIXxlcGBsCUjDG3UdKPo
	UtN1zdNb9AI6rCshOYksVVsHqmyuG8NarovcsH+5jElRV5OU7brMriuZ8vbl7UhXtjg4FmDLmaj
	/5pqvWd+r9LmEot/fJUR8=
X-Received: by 2002:a05:600c:1554:b0:483:6d4a:7e6d with SMTP id 5b1f17b1804b1-4854b12ce27mr80764335e9.30.1773297324473;
        Wed, 11 Mar 2026 23:35:24 -0700 (PDT)
Received: from u94a ([2401:e180:8d68:7358:55be:6563:4437:e6fe])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35a02ba23adsm4152361a91.0.2026.03.11.23.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 23:35:23 -0700 (PDT)
Date: Thu, 12 Mar 2026 14:35:11 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	gregkh@linuxfoundation.org, patches@lists.linux.dev, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/314] 6.18.17-rc1 review
Message-ID: <xbjybmha7fdnnm5gn6p6jyppf4ud2r72rfabvej6egg545ozsu@a4qj43d3iu36>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>

Hi Sasha,

On Tue, Mar 10, 2026 at 07:19:29AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.18.17 release.
> There are 314 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

BPF selftest is failing due to backported commit efc11a667878 ("bpf:
Improve bounds when tnum has a single possible value"). The fix is
commit 024cea2d647e ("selftests/bpf: Avoid simplification of crafted
bounds test"). Can you pick that up for both 6.18 and 6.19?

FWIW this failure does not point to actual issue of the codebase, just
that the selftest's expectation not aligning with the kernel.

Full log below:

  /var/git/linux-stable-6.18$ vng --user=root --cwd=tools/testing/selftests/bpf/ -- ./test_progs -n 295
  #295/1   reg_bounds_crafted/(u64)[0; 4294967295] (u64)<op> 0:OK
  #295/2   reg_bounds_crafted/(u64)0 (u64)<op> [0; 4294967295]:OK
  #295/3   reg_bounds_crafted/(u64)[0; 2147483648] (u64)<op> 0:OK
  #295/4   reg_bounds_crafted/(u64)0 (u64)<op> [0; 2147483648]:OK
  #295/5   reg_bounds_crafted/(u64)[0x100000000; 0x100000100] (u64)<op> 0:OK
  #295/6   reg_bounds_crafted/(u64)0 (u64)<op> [0x100000000; 0x100000100]:OK
  #295/7   reg_bounds_crafted/(u64)[0x100000000; 0x180000000] (u64)<op> 0:OK
  #295/8   reg_bounds_crafted/(u64)0 (u64)<op> [0x100000000; 0x180000000]:OK
  #295/9   reg_bounds_crafted/(u64)[0x100000000; 0x1ffffff00] (u64)<op> 0:OK
  #295/10  reg_bounds_crafted/(u64)0 (u64)<op> [0x100000000; 0x1ffffff00]:OK
  #295/11  reg_bounds_crafted/(u64)[0x100000000; 0x1ffffff01] (u64)<op> 0:OK
  #295/12  reg_bounds_crafted/(u64)0 (u64)<op> [0x100000000; 0x1ffffff01]:OK
  #295/13  reg_bounds_crafted/(u64)[0x100000000; 0x1fffffffe] (u64)<op> 0:OK
  #295/14  reg_bounds_crafted/(u64)0 (u64)<op> [0x100000000; 0x1fffffffe]:OK
  #295/15  reg_bounds_crafted/(u64)[0x100000001; 0x1000000ff] (u64)<op> 0:OK
  #295/16  reg_bounds_crafted/(u64)0 (u64)<op> [0x100000001; 0x1000000ff]:OK
  #295/17  reg_bounds_crafted/(u64)[0; 1] (u64)<op> [1; 2147483648]:OK
  #295/18  reg_bounds_crafted/(u64)[1; 2147483648] (u64)<op> [0; 1]:OK
  #295/19  reg_bounds_crafted/(u64)[0; 1] (s64)<op> [1; 2147483648]:OK
  #295/20  reg_bounds_crafted/(u64)[1; 2147483648] (s64)<op> [0; 1]:OK
  #295/21  reg_bounds_crafted/(u64)[0; 1] (u32)<op> [1; 2147483648]:OK
  #295/22  reg_bounds_crafted/(u64)[1; 2147483648] (u32)<op> [0; 1]:OK
  #295/23  reg_bounds_crafted/(u64)[0; 1] (s32)<op> [1; 2147483648]:OK
  #295/24  reg_bounds_crafted/(u64)[1; 2147483648] (s32)<op> [0; 1]:OK
  #295/25  reg_bounds_crafted/(u64)[0; 0xffffffff00000000] (s64)<op> 0:OK
  #295/26  reg_bounds_crafted/(u64)0 (s64)<op> [0; 0xffffffff00000000]:OK
  #295/27  reg_bounds_crafted/(u64)[0x7fffffffffffffff; 0xffffffff00000000] (s64)<op> 0:OK
  #295/28  reg_bounds_crafted/(u64)0 (s64)<op> [0x7fffffffffffffff; 0xffffffff00000000]:OK
  #295/29  reg_bounds_crafted/(u64)[0x7fffffff00000001; 0xffffffff00000000] (s64)<op> 0:OK
  #295/30  reg_bounds_crafted/(u64)0 (s64)<op> [0x7fffffff00000001; 0xffffffff00000000]:OK
  #295/31  reg_bounds_crafted/(u64)[0; 4294967295] (s64)<op> 1:OK
  #295/32  reg_bounds_crafted/(u64)1 (s64)<op> [0; 4294967295]:OK
  #295/33  reg_bounds_crafted/(u64)[0; 4294967295] (s64)<op> 2147483647:OK
  #295/34  reg_bounds_crafted/(u64)2147483647 (s64)<op> [0; 4294967295]:OK
  #295/35  reg_bounds_crafted/(u64)[0; 0x100000000] (u32)<op> 0:OK
  #295/36  reg_bounds_crafted/(u64)0 (u32)<op> [0; 0x100000000]:OK
  MISMATCH true_reg1.u64: 0x100000000 != [4294967294; 0x100000000]
  MISMATCH true_reg1.s64: 0x100000000 != [0xfffffffe; 0x100000000]
  VERIFIER LOG:
  ========================
  func#0 @0
  Live regs before insn:
        0: .......... (05) goto pc+2
        1: .......... (b7) r0 = 0
        2: 0......... (95) exit
        3: .......... (85) call bpf_get_current_pid_tgid#14
        4: 0......... (bf) r6 = r0
        5: ......6... (85) call bpf_get_current_pid_tgid#14
        6: 0.....6... (bf) r7 = r0
        7: ......67.. (18) r1 = 0xfffffffe
        9: .1....67.. (18) r2 = 0x100000000
       11: .12...67.. (ad) if r6 < r1 goto pc-11
       12: ..2...67.. (2d) if r6 > r2 goto pc-12
       13: ......67.. (18) r1 = 0x80000000
       15: .1....67.. (18) r2 = 0x80000000
       17: .12...67.. (ad) if r7 < r1 goto pc-17
       18: ..2...67.. (2d) if r7 > r2 goto pc-18
       19: ......67.. (bc) w0 = w6
       20: ......67.. (bc) w0 = w7
       21: ......67.. (ae) if w6 < w7 goto pc+3
       22: ......67.. (bc) w0 = w6
       23: .......7.. (bc) w0 = w7
       24: 0......... (95) exit
       25: ......67.. (bc) w0 = w6
       26: .......7.. (bc) w0 = w7
       27: 0......... (95) exit
  0: R1=ctx() R10=fp0
  0: (05) goto pc+2
  3: (85) call bpf_get_current_pid_tgid#14      ; R0=scalar()
  4: (bf) r6 = r0                       ; R0=scalar(id=1) R6=scalar(id=1)
  5: (85) call bpf_get_current_pid_tgid#14      ; R0=scalar()
  6: (bf) r7 = r0                       ; R0=scalar(id=2) R7=scalar(id=2)
  7: (18) r1 = 0xfffffffe               ; R1=0xfffffffe
  9: (18) r2 = 0x100000000              ; R2=0x100000000
  11: (ad) if r6 < r1 goto pc-11        ; R1=0xfffffffe R6=scalar(id=1,umin=0xfffffffe)
  12: (2d) if r6 > r2 goto pc-12        ; R2=0x100000000 R6=scalar(id=1,smin=umin=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=0,var_off=(0x0; 0x1ffffffff))
  13: (18) r1 = 0x80000000              ; R1=0x80000000
  15: (18) r2 = 0x80000000              ; R2=0x80000000
  17: (ad) if r7 < r1 goto pc-17        ; R1=0x80000000 R7=scalar(id=2,umin=0x80000000)
  18: (2d) if r7 > r2 goto pc-18        ; R2=0x80000000 R7=0x80000000
  19: (bc) w0 = w6                      ; R0=scalar(smin=0,smax=umax=0xffffffff,smin32=-2,smax32=0,var_off=(0x0; 0xffffffff)) R6=scalar(id=1,smin=umin=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=0,var_off=(0x0; 0x1ffffffff))
  20: (bc) w0 = w7                      ; R0=0x80000000 R7=0x80000000
  21: (ae) if w6 < w7 goto pc+3         ; R6=scalar(id=1,smin=umin=umin32=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=-1,var_off=(0xfffffffe; 0x100000001)) R7=0x80000000
  22: (bc) w0 = w6                      ; R0=scalar(smin=umin=umin32=0xfffffffe,smax=umax=0xffffffff,smin32=-2,smax32=-1,var_off=(0xfffffffe; 0x1)) R6=scalar(id=1,smin=umin=umin32=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=-1,var_off=(0xfffffffe; 0x100000001))
  23: (bc) w0 = w7                      ; R0=0x80000000 R7=0x80000000
  24: (95) exit
  
  from 21 to 25: R0=0x80000000 R1=0x80000000 R2=0x80000000 R6=0x100000000 R7=0x80000000 R10=fp0
  25: R0=0x80000000 R1=0x80000000 R2=0x80000000 R6=0x100000000 R7=0x80000000 R10=fp0
  25: (bc) w0 = w6                      ; R0=0 R6=0x100000000
  26: (bc) w0 = w7                      ; R0=0x80000000 R7=0x80000000
  27: (95) exit
  
  from 18 to 1: R0=scalar(id=2) R1=0x80000000 R2=0x80000000 R6=scalar(id=1,smin=umin=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=0,var_off=(0x0; 0x1ffffffff)) R7=scalar(id=2,umin=0x80000001) R10=fp0
  1: R0=scalar(id=2) R1=0x80000000 R2=0x80000000 R6=scalar(id=1,smin=umin=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=0,var_off=(0x0; 0x1ffffffff)) R7=scalar(id=2,umin=0x80000001) R10=fp0
  1: (b7) r0 = 0                        ; R0=0
  2: (95) exit
  
  from 17 to 1: R0=scalar(id=2) R1=0x80000000 R2=0x80000000 R6=scalar(id=1,smin=umin=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=0,var_off=(0x0; 0x1ffffffff)) R7=scalar(id=2,smin=smin32=0,smax=umax=umax32=0x7fffffff,var_off=(0x0; 0x7fffffff)) R10=fp0
  1: R0=scalar(id=2) R1=0x80000000 R2=0x80000000 R6=scalar(id=1,smin=umin=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=0,var_off=(0x0; 0x1ffffffff)) R7=scalar(id=2,smin=smin32=0,smax=umax=umax32=0x7fffffff,var_off=(0x0; 0x7fffffff)) R10=fp0
  1: (b7) r0 = 0                        ; R0=0
  2: (95) exit
  
  from 12 to 1: safe
  
  from 11 to 1: safe
  processed 28 insns (limit 1000000) max_states_per_insn 0 total_states 3 peak_states 3 mark_read 0
  =====================
  ACTUAL   FALSE1: scalar(u64=[4294967294; 0x100000000],u32=[4294967294; 4294967295],s64=[0xfffffffe; 0x100000000],s32=[0xfffffffe; 0xffffffff])
  EXPECTED FALSE1: scalar(u64=[4294967294; 0x100000000],u32=[4294967294; 4294967295],s64=[0xfffffffe; 0x100000000],s32=[0xfffffffe; 0xffffffff])
  ACTUAL   FALSE2: scalar(u64=2147483648,u32=2147483648,s64=0x80000000,s32=S32_MIN)
  EXPECTED FALSE2: scalar(u64=2147483648,u32=2147483648,s64=0x80000000,s32=S32_MIN)
  ACTUAL   TRUE1:  scalar(u64=0x100000000,u32=0,s64=0x100000000,s32=0)
  EXPECTED TRUE1:  scalar(u64=[4294967294; 0x100000000],u32=0,s64=[0xfffffffe; 0x100000000],s32=0)
  ACTUAL   TRUE2:  scalar(u64=2147483648,u32=2147483648,s64=0x80000000,s32=S32_MIN)
  EXPECTED TRUE2:  scalar(u64=2147483648,u32=2147483648,s64=0x80000000,s32=S32_MIN)
  verify_case_opt:FAIL:(u64)[4294967294; 0x100000000] (u32)< 2147483648 unexpected error: -22 (errno 22)
  #295/37  reg_bounds_crafted/(u64)[4294967294; 0x100000000] (u32)<op> 2147483648:FAIL
  MISMATCH false_reg2.u64: 0x100000000 != [4294967294; 0x100000000]
  MISMATCH false_reg2.s64: 0x100000000 != [0xfffffffe; 0x100000000]
  VERIFIER LOG:
  ========================
  func#0 @0
  Live regs before insn:
        0: .......... (05) goto pc+2
        1: .......... (b7) r0 = 0
        2: 0......... (95) exit
        3: .......... (85) call bpf_get_current_pid_tgid#14
        4: 0......... (bf) r6 = r0
        5: ......6... (85) call bpf_get_current_pid_tgid#14
        6: 0.....6... (bf) r7 = r0
        7: ......67.. (18) r1 = 0x80000000
        9: .1....67.. (18) r2 = 0x80000000
       11: .12...67.. (ad) if r6 < r1 goto pc-11
       12: ..2...67.. (2d) if r6 > r2 goto pc-12
       13: ......67.. (18) r1 = 0xfffffffe
       15: .1....67.. (18) r2 = 0x100000000
       17: .12...67.. (ad) if r7 < r1 goto pc-17
       18: ..2...67.. (2d) if r7 > r2 goto pc-18
       19: ......67.. (bc) w0 = w6
       20: ......67.. (bc) w0 = w7
       21: ......67.. (be) if w6 <= w7 goto pc+3
       22: ......67.. (bc) w0 = w6
       23: .......7.. (bc) w0 = w7
       24: 0......... (95) exit
       25: ......67.. (bc) w0 = w6
       26: .......7.. (bc) w0 = w7
       27: 0......... (95) exit
  0: R1=ctx() R10=fp0
  0: (05) goto pc+2
  3: (85) call bpf_get_current_pid_tgid#14      ; R0=scalar()
  4: (bf) r6 = r0                       ; R0=scalar(id=1) R6=scalar(id=1)
  5: (85) call bpf_get_current_pid_tgid#14      ; R0=scalar()
  6: (bf) r7 = r0                       ; R0=scalar(id=2) R7=scalar(id=2)
  7: (18) r1 = 0x80000000               ; R1=0x80000000
  9: (18) r2 = 0x80000000               ; R2=0x80000000
  11: (ad) if r6 < r1 goto pc-11        ; R1=0x80000000 R6=scalar(id=1,umin=0x80000000)
  12: (2d) if r6 > r2 goto pc-12        ; R2=0x80000000 R6=0x80000000
  13: (18) r1 = 0xfffffffe              ; R1=0xfffffffe
  15: (18) r2 = 0x100000000             ; R2=0x100000000
  17: (ad) if r7 < r1 goto pc-17        ; R1=0xfffffffe R7=scalar(id=2,umin=0xfffffffe)
  18: (2d) if r7 > r2 goto pc-18        ; R2=0x100000000 R7=scalar(id=2,smin=umin=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=0,var_off=(0x0; 0x1ffffffff))
  19: (bc) w0 = w6                      ; R0=0x80000000 R6=0x80000000
  20: (bc) w0 = w7                      ; R0=scalar(smin=0,smax=umax=0xffffffff,smin32=-2,smax32=0,var_off=(0x0; 0xffffffff)) R7=scalar(id=2,smin=umin=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=0,var_off=(0x0; 0x1ffffffff))
  21: (be) if w6 <= w7 goto pc+3        ; R6=0x80000000 R7=0x100000000
  22: (bc) w0 = w6                      ; R0=0x80000000 R6=0x80000000
  23: (bc) w0 = w7                      ; R0=0 R7=0x100000000
  24: (95) exit
  
  from 21 to 25: R0=scalar(smin=0,smax=umax=0xffffffff,smin32=-2,smax32=0,var_off=(0x0; 0xffffffff)) R1=0xfffffffe R2=0x100000000 R6=0x80000000 R7=scalar(id=2,smin=umin=umin32=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=-1,var_off=(0xfffffffe; 0x100000001)) R10=fp0
  25: R0=scalar(smin=0,smax=umax=0xffffffff,smin32=-2,smax32=0,var_off=(0x0; 0xffffffff)) R1=0xfffffffe R2=0x100000000 R6=0x80000000 R7=scalar(id=2,smin=umin=umin32=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=-1,var_off=(0xfffffffe; 0x100000001)) R10=fp0
  25: (bc) w0 = w6                      ; R0=0x80000000 R6=0x80000000
  26: (bc) w0 = w7                      ; R0=scalar(smin=umin=umin32=0xfffffffe,smax=umax=0xffffffff,smin32=-2,smax32=-1,var_off=(0xfffffffe; 0x1)) R7=scalar(id=2,smin=umin=umin32=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=-1,var_off=(0xfffffffe; 0x100000001))
  27: (95) exit
  
  from 18 to 1: R0=scalar(id=2) R1=0xfffffffe R2=0x100000000 R6=0x80000000 R7=scalar(id=2,umin=0x100000001) R10=fp0
  1: R0=scalar(id=2) R1=0xfffffffe R2=0x100000000 R6=0x80000000 R7=scalar(id=2,umin=0x100000001) R10=fp0
  1: (b7) r0 = 0                        ; R0=0
  2: (95) exit
  
  from 17 to 1: R0=scalar(id=2) R1=0xfffffffe R2=0x100000000 R6=0x80000000 R7=scalar(id=2,smin=0,smax=umax=umax32=0xfffffffd,var_off=(0x0; 0xffffffff)) R10=fp0
  1: R0=scalar(id=2) R1=0xfffffffe R2=0x100000000 R6=0x80000000 R7=scalar(id=2,smin=0,smax=umax=umax32=0xfffffffd,var_off=(0x0; 0xffffffff)) R10=fp0
  1: (b7) r0 = 0                        ; R0=0
  2: (95) exit
  
  from 12 to 1: safe
  
  from 11 to 1: safe
  processed 28 insns (limit 1000000) max_states_per_insn 0 total_states 3 peak_states 3 mark_read 0
  =====================
  ACTUAL   FALSE1: scalar(u64=2147483648,u32=2147483648,s64=0x80000000,s32=S32_MIN)
  EXPECTED FALSE1: scalar(u64=2147483648,u32=2147483648,s64=0x80000000,s32=S32_MIN)
  ACTUAL   FALSE2: scalar(u64=0x100000000,u32=0,s64=0x100000000,s32=0)
  EXPECTED FALSE2: scalar(u64=[4294967294; 0x100000000],u32=0,s64=[0xfffffffe; 0x100000000],s32=0)
  ACTUAL   TRUE1:  scalar(u64=2147483648,u32=2147483648,s64=0x80000000,s32=S32_MIN)
  EXPECTED TRUE1:  scalar(u64=2147483648,u32=2147483648,s64=0x80000000,s32=S32_MIN)
  ACTUAL   TRUE2:  scalar(u64=[4294967294; 0x100000000],u32=[4294967294; 4294967295],s64=[0xfffffffe; 0x100000000],s32=[0xfffffffe; 0xffffffff])
  EXPECTED TRUE2:  scalar(u64=[4294967294; 0x100000000],u32=[4294967294; 4294967295],s64=[0xfffffffe; 0x100000000],s32=[0xfffffffe; 0xffffffff])
  verify_case_opt:FAIL:(u64)2147483648 (u32)<= [4294967294; 0x100000000] unexpected error: -22 (errno 22)
  #295/38  reg_bounds_crafted/(u64)2147483648 (u32)<op> [4294967294; 0x100000000]:FAIL
  #295/39  reg_bounds_crafted/(u64)[0; 0xffffffff00000000] (s32)<op> 0:OK
  #295/40  reg_bounds_crafted/(u64)0 (s32)<op> [0; 0xffffffff00000000]:OK
  #295/41  reg_bounds_crafted/(u64)[0; 4294967295] (s32)<op> 0:OK
  #295/42  reg_bounds_crafted/(u64)0 (s32)<op> [0; 4294967295]:OK
  #295/43  reg_bounds_crafted/(u64)[0; 0x100000000] (s32)<op> 0:OK
  #295/44  reg_bounds_crafted/(u64)0 (s32)<op> [0; 0x100000000]:OK
  #295/45  reg_bounds_crafted/(u64)[0; 0x100000001] (s32)<op> 0:OK
  #295/46  reg_bounds_crafted/(u64)0 (s32)<op> [0; 0x100000001]:OK
  #295/47  reg_bounds_crafted/(u64)[0; 0x180000000] (s32)<op> 0:OK
  #295/48  reg_bounds_crafted/(u64)0 (s32)<op> [0; 0x180000000]:OK
  #295/49  reg_bounds_crafted/(u64)[0; 0x17fffffff] (s32)<op> 0:OK
  #295/50  reg_bounds_crafted/(u64)0 (s32)<op> [0; 0x17fffffff]:OK
  #295/51  reg_bounds_crafted/(u64)[0; 0x180000001] (s32)<op> 0:OK
  #295/52  reg_bounds_crafted/(u64)0 (s32)<op> [0; 0x180000001]:OK
  #295/53  reg_bounds_crafted/(s64)[0xffffffffffffffff; 0] (s64)<op> 0xffffffff00000000:OK
  #295/54  reg_bounds_crafted/(s64)0xffffffff00000000 (s64)<op> [0xffffffffffffffff; 0]:OK
  #295/55  reg_bounds_crafted/(u64)[4294967295; 0x100000000] (u64)<op> 0:OK
  #295/56  reg_bounds_crafted/(u64)0 (u64)<op> [4294967295; 0x100000000]:OK
  #295/57  reg_bounds_crafted/(u64)[4294967295; 0x100000001] (u64)<op> 0:OK
  #295/58  reg_bounds_crafted/(u64)0 (u64)<op> [4294967295; 0x100000001]:OK
  #295/59  reg_bounds_crafted/(s64)[0xffffffff00000001; 0] (u64)<op> 0xffffffff00000000:OK
  #295/60  reg_bounds_crafted/(s64)0xffffffff00000000 (u64)<op> [0xffffffff00000001; 0]:OK
  #295/61  reg_bounds_crafted/(u32)[1; 4294967295] (u32)<op> 0:OK
  #295/62  reg_bounds_crafted/(u32)0 (u32)<op> [1; 4294967295]:OK
  #295/63  reg_bounds_crafted/(u32)[0; 4294967295] (s32)<op> 4294967295:OK
  #295/64  reg_bounds_crafted/(u32)4294967295 (s32)<op> [0; 4294967295]:OK
  #295/65  reg_bounds_crafted/(s32)S32_MIN (u64)<op> [0xffffff01; 0]:OK
  #295/66  reg_bounds_crafted/(s32)[0xffffff01; 0] (u64)<op> S32_MIN:OK
  #295/67  reg_bounds_crafted/(s32)[S32_MIN; 0xffffff01] (s64)<op> [0xfffffffe; 0]:OK
  #295/68  reg_bounds_crafted/(s32)[0xfffffffe; 0] (s64)<op> [S32_MIN; 0xffffff01]:OK
  #295/69  reg_bounds_crafted/(s32)[0; 0x1] (s64)<op> S32_MIN:OK
  #295/70  reg_bounds_crafted/(s32)S32_MIN (s64)<op> [0; 0x1]:OK
  #295/71  reg_bounds_crafted/(s32)S32_MIN (u32)<op> S32_MIN:OK
  #295/72  reg_bounds_crafted/(s32)S32_MIN (u32)<op> S32_MIN:OK
  #295/73  reg_bounds_crafted/(u64)[0; U64_MAX] (u64)<op> U64_MAX:OK
  #295/74  reg_bounds_crafted/(u64)U64_MAX (u64)<op> [0; U64_MAX]:OK
  #295/75  reg_bounds_crafted/(u64)[0; U64_MAX] (u64)<op> 0:OK
  #295/76  reg_bounds_crafted/(u64)0 (u64)<op> [0; U64_MAX]:OK
  #295/77  reg_bounds_crafted/(s64)[S64_MIN; 0] (u64)<op> S64_MIN:OK
  #295/78  reg_bounds_crafted/(s64)S64_MIN (u64)<op> [S64_MIN; 0]:OK
  #295/79  reg_bounds_crafted/(s64)[S64_MIN; 0] (u64)<op> 0:OK
  #295/80  reg_bounds_crafted/(s64)0 (u64)<op> [S64_MIN; 0]:OK
  #295/81  reg_bounds_crafted/(s64)[S64_MIN; S64_MAX] (u64)<op> S64_MAX:OK
  #295/82  reg_bounds_crafted/(s64)S64_MAX (u64)<op> [S64_MIN; S64_MAX]:OK
  #295/83  reg_bounds_crafted/(u32)[0; 4294967295] (u32)<op> 0:OK
  #295/84  reg_bounds_crafted/(u32)0 (u32)<op> [0; 4294967295]:OK
  #295/85  reg_bounds_crafted/(u32)[0; 4294967295] (u32)<op> 4294967295:OK
  #295/86  reg_bounds_crafted/(u32)4294967295 (u32)<op> [0; 4294967295]:OK
  #295/87  reg_bounds_crafted/(s32)[S32_MIN; 0] (u32)<op> 0:OK
  #295/88  reg_bounds_crafted/(s32)0 (u32)<op> [S32_MIN; 0]:OK
  #295/89  reg_bounds_crafted/(s32)[S32_MIN; 0] (u32)<op> S32_MIN:OK
  #295/90  reg_bounds_crafted/(s32)S32_MIN (u32)<op> [S32_MIN; 0]:OK
  #295/91  reg_bounds_crafted/(s32)[S32_MIN; S32_MAX] (u32)<op> S32_MAX:OK
  #295/92  reg_bounds_crafted/(s32)S32_MAX (u32)<op> [S32_MIN; S32_MAX]:OK
  #295/93  reg_bounds_crafted/(s64)[0; 0x1f] (u32)<op> [0xffffffff80000000; 0x7fffffff]:OK
  #295/94  reg_bounds_crafted/(s64)[0xffffffff80000000; 0x7fffffff] (u32)<op> [0; 0x1f]:OK
  #295/95  reg_bounds_crafted/(s64)[0; 0x1f] (u32)<op> [0xffffffffffff8000; 0x7fff]:OK
  #295/96  reg_bounds_crafted/(s64)[0xffffffffffff8000; 0x7fff] (u32)<op> [0; 0x1f]:OK
  #295/97  reg_bounds_crafted/(s64)[0; 0x1f] (u32)<op> [0xffffffffffffff80; 0x7f]:OK
  #295/98  reg_bounds_crafted/(s64)[0xffffffffffffff80; 0x7f] (u32)<op> [0; 0x1f]:OK
  #295     reg_bounds_crafted:FAIL
  
  All error logs:
  MISMATCH true_reg1.u64: 0x100000000 != [4294967294; 0x100000000]
  MISMATCH true_reg1.s64: 0x100000000 != [0xfffffffe; 0x100000000]
  VERIFIER LOG:
  ========================
  func#0 @0
  Live regs before insn:
        0: .......... (05) goto pc+2
        1: .......... (b7) r0 = 0
        2: 0......... (95) exit
        3: .......... (85) call bpf_get_current_pid_tgid#14
        4: 0......... (bf) r6 = r0
        5: ......6... (85) call bpf_get_current_pid_tgid#14
        6: 0.....6... (bf) r7 = r0
        7: ......67.. (18) r1 = 0xfffffffe
        9: .1....67.. (18) r2 = 0x100000000
       11: .12...67.. (ad) if r6 < r1 goto pc-11
       12: ..2...67.. (2d) if r6 > r2 goto pc-12
       13: ......67.. (18) r1 = 0x80000000
       15: .1....67.. (18) r2 = 0x80000000
       17: .12...67.. (ad) if r7 < r1 goto pc-17
       18: ..2...67.. (2d) if r7 > r2 goto pc-18
       19: ......67.. (bc) w0 = w6
       20: ......67.. (bc) w0 = w7
       21: ......67.. (ae) if w6 < w7 goto pc+3
       22: ......67.. (bc) w0 = w6
       23: .......7.. (bc) w0 = w7
       24: 0......... (95) exit
       25: ......67.. (bc) w0 = w6
       26: .......7.. (bc) w0 = w7
       27: 0......... (95) exit
  0: R1=ctx() R10=fp0
  0: (05) goto pc+2
  3: (85) call bpf_get_current_pid_tgid#14      ; R0=scalar()
  4: (bf) r6 = r0                       ; R0=scalar(id=1) R6=scalar(id=1)
  5: (85) call bpf_get_current_pid_tgid#14      ; R0=scalar()
  6: (bf) r7 = r0                       ; R0=scalar(id=2) R7=scalar(id=2)
  7: (18) r1 = 0xfffffffe               ; R1=0xfffffffe
  9: (18) r2 = 0x100000000              ; R2=0x100000000
  11: (ad) if r6 < r1 goto pc-11        ; R1=0xfffffffe R6=scalar(id=1,umin=0xfffffffe)
  12: (2d) if r6 > r2 goto pc-12        ; R2=0x100000000 R6=scalar(id=1,smin=umin=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=0,var_off=(0x0; 0x1ffffffff))
  13: (18) r1 = 0x80000000              ; R1=0x80000000
  15: (18) r2 = 0x80000000              ; R2=0x80000000
  17: (ad) if r7 < r1 goto pc-17        ; R1=0x80000000 R7=scalar(id=2,umin=0x80000000)
  18: (2d) if r7 > r2 goto pc-18        ; R2=0x80000000 R7=0x80000000
  19: (bc) w0 = w6                      ; R0=scalar(smin=0,smax=umax=0xffffffff,smin32=-2,smax32=0,var_off=(0x0; 0xffffffff)) R6=scalar(id=1,smin=umin=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=0,var_off=(0x0; 0x1ffffffff))
  20: (bc) w0 = w7                      ; R0=0x80000000 R7=0x80000000
  21: (ae) if w6 < w7 goto pc+3         ; R6=scalar(id=1,smin=umin=umin32=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=-1,var_off=(0xfffffffe; 0x100000001)) R7=0x80000000
  22: (bc) w0 = w6                      ; R0=scalar(smin=umin=umin32=0xfffffffe,smax=umax=0xffffffff,smin32=-2,smax32=-1,var_off=(0xfffffffe; 0x1)) R6=scalar(id=1,smin=umin=umin32=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=-1,var_off=(0xfffffffe; 0x100000001))
  23: (bc) w0 = w7                      ; R0=0x80000000 R7=0x80000000
  24: (95) exit
  
  from 21 to 25: R0=0x80000000 R1=0x80000000 R2=0x80000000 R6=0x100000000 R7=0x80000000 R10=fp0
  25: R0=0x80000000 R1=0x80000000 R2=0x80000000 R6=0x100000000 R7=0x80000000 R10=fp0
  25: (bc) w0 = w6                      ; R0=0 R6=0x100000000
  26: (bc) w0 = w7                      ; R0=0x80000000 R7=0x80000000
  27: (95) exit
  
  from 18 to 1: R0=scalar(id=2) R1=0x80000000 R2=0x80000000 R6=scalar(id=1,smin=umin=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=0,var_off=(0x0; 0x1ffffffff)) R7=scalar(id=2,umin=0x80000001) R10=fp0
  1: R0=scalar(id=2) R1=0x80000000 R2=0x80000000 R6=scalar(id=1,smin=umin=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=0,var_off=(0x0; 0x1ffffffff)) R7=scalar(id=2,umin=0x80000001) R10=fp0
  1: (b7) r0 = 0                        ; R0=0
  2: (95) exit
  
  from 17 to 1: R0=scalar(id=2) R1=0x80000000 R2=0x80000000 R6=scalar(id=1,smin=umin=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=0,var_off=(0x0; 0x1ffffffff)) R7=scalar(id=2,smin=smin32=0,smax=umax=umax32=0x7fffffff,var_off=(0x0; 0x7fffffff)) R10=fp0
  1: R0=scalar(id=2) R1=0x80000000 R2=0x80000000 R6=scalar(id=1,smin=umin=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=0,var_off=(0x0; 0x1ffffffff)) R7=scalar(id=2,smin=smin32=0,smax=umax=umax32=0x7fffffff,var_off=(0x0; 0x7fffffff)) R10=fp0
  1: (b7) r0 = 0                        ; R0=0
  2: (95) exit
  
  from 12 to 1: safe
  
  from 11 to 1: safe
  processed 28 insns (limit 1000000) max_states_per_insn 0 total_states 3 peak_states 3 mark_read 0
  =====================
  ACTUAL   FALSE1: scalar(u64=[4294967294; 0x100000000],u32=[4294967294; 4294967295],s64=[0xfffffffe; 0x100000000],s32=[0xfffffffe; 0xffffffff])
  EXPECTED FALSE1: scalar(u64=[4294967294; 0x100000000],u32=[4294967294; 4294967295],s64=[0xfffffffe; 0x100000000],s32=[0xfffffffe; 0xffffffff])
  ACTUAL   FALSE2: scalar(u64=2147483648,u32=2147483648,s64=0x80000000,s32=S32_MIN)
  EXPECTED FALSE2: scalar(u64=2147483648,u32=2147483648,s64=0x80000000,s32=S32_MIN)
  ACTUAL   TRUE1:  scalar(u64=0x100000000,u32=0,s64=0x100000000,s32=0)
  EXPECTED TRUE1:  scalar(u64=[4294967294; 0x100000000],u32=0,s64=[0xfffffffe; 0x100000000],s32=0)
  ACTUAL   TRUE2:  scalar(u64=2147483648,u32=2147483648,s64=0x80000000,s32=S32_MIN)
  EXPECTED TRUE2:  scalar(u64=2147483648,u32=2147483648,s64=0x80000000,s32=S32_MIN)
  verify_case_opt:FAIL:(u64)[4294967294; 0x100000000] (u32)< 2147483648 unexpected error: -22 (errno 22)
  #295/37  reg_bounds_crafted/(u64)[4294967294; 0x100000000] (u32)<op> 2147483648:FAIL
  MISMATCH false_reg2.u64: 0x100000000 != [4294967294; 0x100000000]
  MISMATCH false_reg2.s64: 0x100000000 != [0xfffffffe; 0x100000000]
  VERIFIER LOG:
  ========================
  func#0 @0
  Live regs before insn:
        0: .......... (05) goto pc+2
        1: .......... (b7) r0 = 0
        2: 0......... (95) exit
        3: .......... (85) call bpf_get_current_pid_tgid#14
        4: 0......... (bf) r6 = r0
        5: ......6... (85) call bpf_get_current_pid_tgid#14
        6: 0.....6... (bf) r7 = r0
        7: ......67.. (18) r1 = 0x80000000
        9: .1....67.. (18) r2 = 0x80000000
       11: .12...67.. (ad) if r6 < r1 goto pc-11
       12: ..2...67.. (2d) if r6 > r2 goto pc-12
       13: ......67.. (18) r1 = 0xfffffffe
       15: .1....67.. (18) r2 = 0x100000000
       17: .12...67.. (ad) if r7 < r1 goto pc-17
       18: ..2...67.. (2d) if r7 > r2 goto pc-18
       19: ......67.. (bc) w0 = w6
       20: ......67.. (bc) w0 = w7
       21: ......67.. (be) if w6 <= w7 goto pc+3
       22: ......67.. (bc) w0 = w6
       23: .......7.. (bc) w0 = w7
       24: 0......... (95) exit
       25: ......67.. (bc) w0 = w6
       26: .......7.. (bc) w0 = w7
       27: 0......... (95) exit
  0: R1=ctx() R10=fp0
  0: (05) goto pc+2
  3: (85) call bpf_get_current_pid_tgid#14      ; R0=scalar()
  4: (bf) r6 = r0                       ; R0=scalar(id=1) R6=scalar(id=1)
  5: (85) call bpf_get_current_pid_tgid#14      ; R0=scalar()
  6: (bf) r7 = r0                       ; R0=scalar(id=2) R7=scalar(id=2)
  7: (18) r1 = 0x80000000               ; R1=0x80000000
  9: (18) r2 = 0x80000000               ; R2=0x80000000
  11: (ad) if r6 < r1 goto pc-11        ; R1=0x80000000 R6=scalar(id=1,umin=0x80000000)
  12: (2d) if r6 > r2 goto pc-12        ; R2=0x80000000 R6=0x80000000
  13: (18) r1 = 0xfffffffe              ; R1=0xfffffffe
  15: (18) r2 = 0x100000000             ; R2=0x100000000
  17: (ad) if r7 < r1 goto pc-17        ; R1=0xfffffffe R7=scalar(id=2,umin=0xfffffffe)
  18: (2d) if r7 > r2 goto pc-18        ; R2=0x100000000 R7=scalar(id=2,smin=umin=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=0,var_off=(0x0; 0x1ffffffff))
  19: (bc) w0 = w6                      ; R0=0x80000000 R6=0x80000000
  20: (bc) w0 = w7                      ; R0=scalar(smin=0,smax=umax=0xffffffff,smin32=-2,smax32=0,var_off=(0x0; 0xffffffff)) R7=scalar(id=2,smin=umin=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=0,var_off=(0x0; 0x1ffffffff))
  21: (be) if w6 <= w7 goto pc+3        ; R6=0x80000000 R7=0x100000000
  22: (bc) w0 = w6                      ; R0=0x80000000 R6=0x80000000
  23: (bc) w0 = w7                      ; R0=0 R7=0x100000000
  24: (95) exit
  
  from 21 to 25: R0=scalar(smin=0,smax=umax=0xffffffff,smin32=-2,smax32=0,var_off=(0x0; 0xffffffff)) R1=0xfffffffe R2=0x100000000 R6=0x80000000 R7=scalar(id=2,smin=umin=umin32=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=-1,var_off=(0xfffffffe; 0x100000001)) R10=fp0
  25: R0=scalar(smin=0,smax=umax=0xffffffff,smin32=-2,smax32=0,var_off=(0x0; 0xffffffff)) R1=0xfffffffe R2=0x100000000 R6=0x80000000 R7=scalar(id=2,smin=umin=umin32=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=-1,var_off=(0xfffffffe; 0x100000001)) R10=fp0
  25: (bc) w0 = w6                      ; R0=0x80000000 R6=0x80000000
  26: (bc) w0 = w7                      ; R0=scalar(smin=umin=umin32=0xfffffffe,smax=umax=0xffffffff,smin32=-2,smax32=-1,var_off=(0xfffffffe; 0x1)) R7=scalar(id=2,smin=umin=umin32=0xfffffffe,smax=umax=0x100000000,smin32=-2,smax32=-1,var_off=(0xfffffffe; 0x100000001))
  27: (95) exit
  
  from 18 to 1: R0=scalar(id=2) R1=0xfffffffe R2=0x100000000 R6=0x80000000 R7=scalar(id=2,umin=0x100000001) R10=fp0
  1: R0=scalar(id=2) R1=0xfffffffe R2=0x100000000 R6=0x80000000 R7=scalar(id=2,umin=0x100000001) R10=fp0
  1: (b7) r0 = 0                        ; R0=0
  2: (95) exit
  
  from 17 to 1: R0=scalar(id=2) R1=0xfffffffe R2=0x100000000 R6=0x80000000 R7=scalar(id=2,smin=0,smax=umax=umax32=0xfffffffd,var_off=(0x0; 0xffffffff)) R10=fp0
  1: R0=scalar(id=2) R1=0xfffffffe R2=0x100000000 R6=0x80000000 R7=scalar(id=2,smin=0,smax=umax=umax32=0xfffffffd,var_off=(0x0; 0xffffffff)) R10=fp0
  1: (b7) r0 = 0                        ; R0=0
  2: (95) exit
  
  from 12 to 1: safe
  
  from 11 to 1: safe
  processed 28 insns (limit 1000000) max_states_per_insn 0 total_states 3 peak_states 3 mark_read 0
  =====================
  ACTUAL   FALSE1: scalar(u64=2147483648,u32=2147483648,s64=0x80000000,s32=S32_MIN)
  EXPECTED FALSE1: scalar(u64=2147483648,u32=2147483648,s64=0x80000000,s32=S32_MIN)
  ACTUAL   FALSE2: scalar(u64=0x100000000,u32=0,s64=0x100000000,s32=0)
  EXPECTED FALSE2: scalar(u64=[4294967294; 0x100000000],u32=0,s64=[0xfffffffe; 0x100000000],s32=0)
  ACTUAL   TRUE1:  scalar(u64=2147483648,u32=2147483648,s64=0x80000000,s32=S32_MIN)
  EXPECTED TRUE1:  scalar(u64=2147483648,u32=2147483648,s64=0x80000000,s32=S32_MIN)
  ACTUAL   TRUE2:  scalar(u64=[4294967294; 0x100000000],u32=[4294967294; 4294967295],s64=[0xfffffffe; 0x100000000],s32=[0xfffffffe; 0xffffffff])
  EXPECTED TRUE2:  scalar(u64=[4294967294; 0x100000000],u32=[4294967294; 4294967295],s64=[0xfffffffe; 0x100000000],s32=[0xfffffffe; 0xffffffff])
  verify_case_opt:FAIL:(u64)2147483648 (u32)<= [4294967294; 0x100000000] unexpected error: -22 (errno 22)
  #295/38  reg_bounds_crafted/(u64)2147483648 (u32)<op> [4294967294; 0x100000000]:FAIL
  #295     reg_bounds_crafted:FAIL
  Summary: 0/96 PASSED, 0 SKIPPED, 1 FAILED
