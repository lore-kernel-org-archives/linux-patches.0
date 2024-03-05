Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C80FFBE9;
	Tue,  5 Mar 2024 01:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600795; cv=none; b=e6Iin3lLSTCPiNlRDK855ttpgJxDaquH/HA5ea8QrGa0XJWsLTsPzPxZt4G9KptIFe6l4UodURDlnzT11gDkLHphthG+frYYb1gA2hboJCQMpw7etg0lyvKY47QIjvtwoUfpz0sVx6ngzPy50fG1GScTVPsQiX/ehLCA5lx98ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600795; c=relaxed/simple;
	bh=cQCRo+Wv+HOwMH+PV6D9rsq03fTP+dSaHgddNObywro=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VndSJLIZy12TSBnjXMOJdsppL/vHWW+WHkBznPAyeFdlXu/D0J5Sg9coQFq7uTUrhq13QqWbvfA1bKBhZ4nFkdVs+4iQ0ORrLCndbDKSLYuCsxCWneVf9pV0l26dNjhzgD6+ZC7YlgATlGdJXIa8ePFLD+h36p/GVIwf4pg/9fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ztu+anKf; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ztu+anKf"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-29a7951c6faso3330622a91.1;
        Mon, 04 Mar 2024 17:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709600793; x=1710205593; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yh48g1IXDkz3oP+XbtshGQjif6bNyT6W+lSLVq2O+HM=;
        b=Ztu+anKf2Dhx7bskM6sIQctHgkTaRlED3EicpOs9Y1CDiUF4MJVkFPoLnBZob595zt
         2FWRCiFGO1Kv6IuzOpjuBbr9CJriv9kLmqfocdIw57MUG7Q9dOE98mEtVPYV0Q9UcLUf
         RTmzAb4R5O6eafjXdWxRyIMQ1olPDQ9Q+H/x+EAriTEKwvv4d+aGaHlVUFpnbOIyPPPr
         pE2JUo55Ctl5OIPGe4cmqXzfh9juQYvd8eD1RXazadlzBouByjASVFDOe1XlSgaUki/6
         4Q48VhLewNPISkIFKIqMY5T5lLG4q+DZ5MsnJdTSsr7x1x//vBcMOoYiSoBIeNqXUTsZ
         Be6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709600793; x=1710205593;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yh48g1IXDkz3oP+XbtshGQjif6bNyT6W+lSLVq2O+HM=;
        b=hYaLr5owr+1Le/OoUDpQce2PDF2UltfU4J0vCS5KmJFOe2SGpMKqzNJwRySB/6q81u
         qP6J6gvF8+HfIjKwTX/aJKO8Nv9zWFBEY3JGqlg5htqaVWq+ww/TBi6LzejuLF8i2prK
         1+rGl94Flrf4GqsdsO4Meb3ObsDw8D9cvG8VwtNIRaQn1l225KF7b7OfPPXATZ0dYfwJ
         mAd1SsUXtqcGbtFwk8ZT78Xr9BfLPLUNZMSkRHdPydG9+VMVtunim0YZQTct9kbhsXyl
         Z/Ta+sznN5HEeX6PX5eYsYd755d0JAVJEReS1BS8aAVGWxcDjWBa6pA7+Kb2wKPu97Te
         rZaA==
X-Forwarded-Encrypted: i=1; AJvYcCXENKAGmD17T0o93IKDRobG+mh0qtwbFMJs9vBB0IOLL6KySQwMOxqr2vNa+4ckSQa1Mvq9oftoNzWV98A6X2pLdoe96iXm+Tdtwh02OQ4QYMkYdE2ayVG6SmYicnU/
X-Gm-Message-State: AOJu0YxtUf1Bey2XvSpzoKg/GViOJLo6SxajiksKulaOUhdufuKTeoDV
	+yLC5xC21rrgg+Hh1KNGh3BBWDrtGuhDXpVMdrUzFfS5Onb8rC6KzCHgL79BMD4rnvf0LT3+fo2
	gaK59OFvxO+QsP/jSmiGvwAet1uo=
X-Google-Smtp-Source: AGHT+IE4NLwh8x7jkAD5qeEydFjXAvMqjpo1AYsohti1aJ34BobyyvHRtsg9vDMC6fL2JjEowvp/KEyN3vfinKM5lRY=
X-Received: by 2002:a17:90a:ea87:b0:29b:41aa:1673 with SMTP id
 h7-20020a17090aea8700b0029b41aa1673mr4128895pjz.23.1709600793370; Mon, 04 Mar
 2024 17:06:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240304211549.876981797@linuxfoundation.org> <20240304224858.73401-1-sj@kernel.org>
In-Reply-To: <20240304224858.73401-1-sj@kernel.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Tue, 5 Mar 2024 02:06:20 +0100
Message-ID: <CADo9pHh4Xk8dzehYQnOpqNGx4QyGQzgUKgBtGWnZuLqPeyWi5w@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/143] 6.6.21-rc1 review
To: SeongJae Park <sj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, allen.lkml@gmail.com, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Den m=C3=A5n 4 mars 2024 kl 23:49 skrev SeongJae Park <sj@kernel.org>:
>
> Hello,
>
> On Mon,  4 Mar 2024 21:22:00 +0000 Greg Kroah-Hartman <gregkh@linuxfounda=
tion.org> wrote:
>
> > This is the start of the stable review cycle for the 6.6.21 release.
> > There are 143 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.21-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> > and the diffstat can be found below.
>
> This rc kernel passes DAMON functionality test[1] on my test machine.
> Attaching the test results summary below.  Please note that I retrieved t=
he
> kernel from linux-stable-rc tree[2].
>
> Tested-by: SeongJae Park <sj@kernel.org>
>
> [1] https://github.com/awslabs/damon-tests/tree/next/corr
> [2] 5f9255b6ac45 ("Linux 6.6.21-rc1")
>
> Thanks,
> SJ
>
> [...]
>
> ---
>
> ok 1 selftests: damon: debugfs_attrs.sh
> ok 2 selftests: damon: debugfs_schemes.sh
> ok 3 selftests: damon: debugfs_target_ids.sh
> ok 4 selftests: damon: debugfs_empty_targets.sh
> ok 5 selftests: damon: debugfs_huge_count_read_write.sh
> ok 6 selftests: damon: debugfs_duplicate_context_creation.sh
> ok 7 selftests: damon: debugfs_rm_non_contexts.sh
> ok 8 selftests: damon: sysfs.sh
> ok 9 selftests: damon: sysfs_update_removed_scheme_dir.sh
> ok 10 selftests: damon: reclaim.sh
> ok 11 selftests: damon: lru_sort.sh
> ok 1 selftests: damon-tests: kunit.sh
> ok 2 selftests: damon-tests: huge_count_read_write.sh
> ok 3 selftests: damon-tests: buffer_overflow.sh
> ok 4 selftests: damon-tests: rm_contexts.sh
> ok 5 selftests: damon-tests: record_null_deref.sh
> ok 6 selftests: damon-tests: dbgfs_target_ids_read_before_terminate_race.=
sh
> ok 7 selftests: damon-tests: dbgfs_target_ids_pid_leak.sh
> ok 8 selftests: damon-tests: damo_tests.sh
> ok 9 selftests: damon-tests: masim-record.sh
> ok 10 selftests: damon-tests: build_i386.sh
> ok 11 selftests: damon-tests: build_arm64.sh
> ok 12 selftests: damon-tests: build_m68k.sh
> ok 13 selftests: damon-tests: build_i386_idle_flag.sh
> ok 14 selftests: damon-tests: build_i386_highpte.sh
> ok 15 selftests: damon-tests: build_nomemcg.sh
>  [33m
>  [92mPASS [39m
>

Works fine on my Arch Linux server with Intel(R) Core(TM) i5-6400 CPU @ 2.7=
0GHz
after the Arch Linux manual intervention for new mkinitcpio settings
and version in Arch

Tested by: Luna Jernberg <droidbittin@gmail.com>
