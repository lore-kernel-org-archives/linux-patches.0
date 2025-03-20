Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2731DED5E;
	Thu, 20 Mar 2025 12:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742474583; cv=none; b=HvcX+jrTTVNE6d1YVr0Y/H1oEUStzwbXZE0co5ZGSiVXZx2kDX18jnMmEyK5LdFx/Se0CW8pHfpwC2ZLbkrEui92mc1yKXHOl3kSsdlrfuJbxnbtL6gRCWTAJmeTUxrRxm/SH9AgOkWPrXZeRVSeorWJm6rlmGV4R4f0ba1bM9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742474583; c=relaxed/simple;
	bh=wTdaPTDa0jCwylQO/d7LcQaRxibO4+U7IE3VzJvXwMA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZCZ78/gXRKax6xjUlvJ4UaebsSOFs6xhlku4hxW4R1wHlH5ok314isZSOKp9R8mwS+yU3vq8tu/ChOY/F6osv2b4F4XRlgQIQh2uwNPIKOJrGmA5okRlOmZgEbi8uutoU+S2qT6Kgkkeqhl06HtvVKg8mrjPxuaowknUeO5J60Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FJUVoMUN; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FJUVoMUN"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-301493f45aeso1160749a91.1;
        Thu, 20 Mar 2025 05:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742474581; x=1743079381; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+uL3IGjTjiuqrVnOz2Ww5dOwcBX+a3DDkjY6XFGUpLc=;
        b=FJUVoMUNX/HdTsSRXgOGMk3ooGfm7bWCZw8M141pcwlFQy73PApEbikYyJ9cf0zoR+
         FII/ZNUb8OIQGYzVMJhaa/ZKm99KRt/rET0gCgQlGAQUi/+8KGDdl0/w2d5dRWzxHfsE
         K4qDt2gDPwobemqI8e608SlE6rhnP1Ur+BdLtMcGz4Xzo4XCjjeCMuzKgXYYYZjH5OS+
         nMKfQqShmL8wYjiKWKLad++Ds5thJKn/VVOuo9WQqBKbBLsOnPPC8Jr7NdfQor3Mj55f
         VxcUXX7laV745ChygBc7ku8HSNR/eFE6oWkW4GDNoC5nnA/KancS/GoacSQH2aUZukdh
         qPqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742474581; x=1743079381;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+uL3IGjTjiuqrVnOz2Ww5dOwcBX+a3DDkjY6XFGUpLc=;
        b=HlZmtTDWNiB72yjRsZRnxmE4wYpLtLiG1fGXGoS3LcFxMaK2Q9AkkEaa7qlNqE8/+6
         HDdLS5EpVd3h3kChTApDaRVIvSq5FP3oCt6EOQ5FOnSVlI6mZm5tcF697x1ThGjKIG5X
         rCSEUE+klnj+i8DUr68meyMO5X0RT7+o4rhiOROn6st6hSFpkG48sA4WzVaZzk6eUvv+
         RbVa1Yz47i78/PmfbIlio0bHo/an1AN90f9VkeHF82hPIBsV+lS11TS0ACotFVPdAUoI
         vNKxz8crXAcAs3R/eFi4EFeSZ2soJfokfgrPOv8/JS3wfbHZZLnWVAY5HmBHRJCXEdpF
         8/EQ==
X-Forwarded-Encrypted: i=1; AJvYcCVc5zDuf4Xa8LH1jx0swUO9ZULh0aAQHcamT6E7OA4g1LPYIxMPYyVvilW8iQprVD4dJU0ZXA==@lists.linux.dev, AJvYcCWqq5Xesnkgavlul6kFPxj8xIin+QNa9sBWD9g36S8/IuEGpn/VGYtt0+cvIaJRjhpXgXw9r86WhA==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywm59QucdeewdIM+mQo+6+amPXYIgsV6GMWmCqkkexiMgAaestB
	nOLW3Ooj/TCOSJB7feQadc187BqA/aAdkoc+eybol4pepkq4GWmH0Wp+2/0myJ1LJYKpKC+VuJa
	OxaaXKzGTW7t0usJlChy8BP4Q68I=
X-Gm-Gg: ASbGnctel9QDWyS8TeaVP0UUkOnwdg3sD7tXhignFlFNtw8R5elN5jH0aoP2aMMIfj5
	DI+m7y1BsMLaiR5CIY6jPI2pNsUvs7cuzRB9McOCHXL/sNXWOZXWf3GKMxwhSvKfNIbZpN53e84
	vmtGGDzAT/B0MLGOOAA4oMZPrZ5KQ=
X-Google-Smtp-Source: AGHT+IG3IAgXvK8pSWNiHSoRiODV5fRdTOwPg8f+TG2YtMLkTzQixdJdL1YxVKheImSCU2oRd0FUdqQX1TmgTyEHAIg=
X-Received: by 2002:a17:90b:4a92:b0:2ee:74a1:fba2 with SMTP id
 98e67ed59e1d1-301bdf93ed2mr10044571a91.20.1742474580671; Thu, 20 Mar 2025
 05:43:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250319143027.685727358@linuxfoundation.org> <20250319165703.51651-1-sj@kernel.org>
In-Reply-To: <20250319165703.51651-1-sj@kernel.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Thu, 20 Mar 2025 12:42:48 +0000
X-Gm-Features: AQ5f1JpMvwcK-1U-hbVAN0-qz9U6SBJvwStCRYbt1diHejdo2BJVf9HMKmOCCEk
Message-ID: <CADo9pHg+iuBtM_cz1jJKS82Cw1oP4G7KoJiaRwFzed1Af1uWCw@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/241] 6.13.8-rc1 review
To: SeongJae Park <sj@kernel.org>, Luna Jernberg <droidbittin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Works fine on my Dell Latitude 7390 laptop with model name    :
Intel(R) Core(TM) i5-8350U CPU @ 1.70GHz
and Arch Linux with testing repos enabled

Tested-by: Luna Jernberg <droidbittin@gmail.com>

Den tors 20 mars 2025 kl 02:40 skrev SeongJae Park <sj@kernel.org>:
>
> Hello,
>
> On Wed, 19 Mar 2025 07:27:50 -0700 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> > This is the start of the stable review cycle for the 6.13.8 release.
> > There are 241 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 21 Mar 2025 14:29:55 +0000.
> > Anything received after that time might be too late.
>
> This rc kernel passes DAMON functionality test[1] on my test machine.
> Attaching the test results summary below.  Please note that I retrieved the
> kernel from linux-stable-rc tree[2].
>
> Tested-by: SeongJae Park <sj@kernel.org>
>
> [1] https://github.com/damonitor/damon-tests/tree/next/corr
> [2] 14de9a7d510f ("Linux 6.13.8-rc1")
>
> Thanks,
> SJ
>
> [...]
>
> ---
>
> ok 9 selftests: damon: damos_tried_regions.py
> ok 10 selftests: damon: damon_nr_regions.py
> ok 11 selftests: damon: reclaim.sh
> ok 12 selftests: damon: lru_sort.sh
> ok 13 selftests: damon: debugfs_empty_targets.sh
> ok 14 selftests: damon: debugfs_huge_count_read_write.sh
> ok 15 selftests: damon: debugfs_duplicate_context_creation.sh
> ok 16 selftests: damon: debugfs_rm_non_contexts.sh
> ok 17 selftests: damon: debugfs_target_ids_read_before_terminate_race.sh
> ok 18 selftests: damon: debugfs_target_ids_pid_leak.sh
> ok 19 selftests: damon: sysfs_update_removed_scheme_dir.sh
> ok 20 selftests: damon: sysfs_update_schemes_tried_regions_hang.py
> ok 1 selftests: damon-tests: kunit.sh
> ok 2 selftests: damon-tests: huge_count_read_write.sh
> ok 3 selftests: damon-tests: buffer_overflow.sh
> ok 4 selftests: damon-tests: rm_contexts.sh
> ok 5 selftests: damon-tests: record_null_deref.sh
> ok 6 selftests: damon-tests: dbgfs_target_ids_read_before_terminate_race.sh
> ok 7 selftests: damon-tests: dbgfs_target_ids_pid_leak.sh
> ok 8 selftests: damon-tests: damo_tests.sh
> ok 9 selftests: damon-tests: masim-record.sh
> ok 10 selftests: damon-tests: build_i386.sh
> ok 11 selftests: damon-tests: build_arm64.sh # SKIP
> ok 12 selftests: damon-tests: build_m68k.sh # SKIP
> ok 13 selftests: damon-tests: build_i386_idle_flag.sh
> ok 14 selftests: damon-tests: build_i386_highpte.sh
> ok 15 selftests: damon-tests: build_nomemcg.sh
>  [33m
>  [92mPASS [39m
>
