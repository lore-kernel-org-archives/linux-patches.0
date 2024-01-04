Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6042D61A
	for <patches@lists.linux.dev>; Thu,  4 Jan 2024 23:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="afSfK5We"
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-466f045f8f7so288313137.3
        for <patches@lists.linux.dev>; Thu, 04 Jan 2024 15:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704411123; x=1705015923; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K06Q1APMN9I3ubfokxa70wJJ9uj3roLT3AfjkUnyddg=;
        b=afSfK5We4kY9yjFvdTikgeWnVLiZCAm7F6lPpCTs1MwA7hYWEBV+XPbAfFo8LyXrn6
         3rlmdlVpp7gkKAJFt8sak5MAwzYUUz/BWr9W5AjOrnIuCdeLnojE8evhMDZROUg1FiVZ
         dMNicOWrjErzbdo8OONRAH0reRBF8rmg707kylziZBc8r/dZURxOisjvyPmwPeRNxS+y
         17kkW07rgydKrLSreyhaZe2ho6agdmC+xNU/5rjAP7AcHzHYIF92B3eJPQzOT30qZCKs
         sQpgZGT25oXdmjrxgaUrysdlbVmANHhatXJ2UvnzkU0PEV3HDbM/y3MBc85B5EoV/xzE
         lenA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704411123; x=1705015923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K06Q1APMN9I3ubfokxa70wJJ9uj3roLT3AfjkUnyddg=;
        b=pWiOKcbM4cy73KMx8rsaChjfnU9wyDOavWhC/ivQvBVxygKHWal4JCQ8G8kWSesRI4
         2qFeoxHtHBkxIOIOVtCZdjirTGpHYVs4spPuUpN4ccJrW6bYwV+7gxDse8jGGHK6IWWN
         ffesk+NbaWA3GhRO619IwfJNmZH66vkcn0FJwYjv+N8QdILa8mtmvluI2ifp4tiekqSC
         HHRR8BaEqf1bmlmHaglMx+Pp96iwRLWG5P5efn4oLK2E+NyqeHHLBIruJzJ+sIou0V5o
         UF00IQcypObcR7G5bqJ9LQCIYm509BVipcB5h8qdZHuJDHRuQQU7wVyMaAFxr5DRizta
         bHmw==
X-Gm-Message-State: AOJu0YxeLnAaq0JlT7MTwJSf1sCtdKJ+Q4HmewLBf7jE6QGlLUgsTcrJ
	tDR4kxYK0CBaxVTtBrEVvakBeBAYmk/eSWB41X01Er0Hl9Uu
X-Google-Smtp-Source: AGHT+IEH4GW8DJnq+xTXvD9gNSezHL+DpWB+egTPafpfsthj+1H1yApQ6vdOjwEe1IhySNOjtcl5oA0flihZ+ROGyBE=
X-Received: by 2002:a05:6102:f93:b0:467:abe1:a536 with SMTP id
 e19-20020a0561020f9300b00467abe1a536mr1404665vsv.10.1704411123199; Thu, 04
 Jan 2024 15:32:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240104-intel-uncore-freq-kcfi-fix-v1-1-bf1e8939af40@kernel.org>
In-Reply-To: <20240104-intel-uncore-freq-kcfi-fix-v1-1-bf1e8939af40@kernel.org>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Thu, 4 Jan 2024 15:31:25 -0800
Message-ID: <CABCJKudq4iMHXZ1m+hf_McGVGuwV0Nh8Xph1asMscCrcnG0KLw@mail.gmail.com>
Subject: Re: [PATCH] platform/x86: intel-uncore-freq: Fix types in sysfs callbacks
To: Nathan Chancellor <nathan@kernel.org>
Cc: srinivas.pandruvada@linux.intel.com, hdegoede@redhat.com, 
	ilpo.jarvinen@linux.intel.com, keescook@chromium.org, 
	platform-driver-x86@vger.kernel.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Nathan,

On Thu, Jan 4, 2024 at 2:59=E2=80=AFPM Nathan Chancellor <nathan@kernel.org=
> wrote:
>
> When booting a kernel with CONFIG_CFI_CLANG, there is a CFI failure when
> accessing any of the values under
> /sys/devices/system/cpu/intel_uncore_frequency/package_00_die_00:
>
>   $ cat /sys/devices/system/cpu/intel_uncore_frequency/package_00_die_00/=
max_freq_khz
>   fish: Job 1, 'cat /sys/devices/system/cpu/int=E2=80=A6' terminated by s=
ignal SIGSEGV (Address boundary error)
>
>   $ sudo dmesg &| grep 'CFI failure'
>   [  170.953925] CFI failure at kobj_attr_show+0x19/0x30 (target: show_ma=
x_freq_khz+0x0/0xc0 [intel_uncore_frequency_common]; expected type: 0xd3407=
8c5
>
> The sysfs callback functions such as show_domain_id() are written as if
> they are going to be called by dev_attr_show() but as the above message
> shows, they are instead called by kobj_attr_show(). kCFI checks that the
> destination of an indirect jump has the exact same type as the prototype
> of the function pointer it is called through and fails when they do not.
>
> These callbacks are called through kobj_attr_show() because
> uncore_root_kobj was initialized with kobject_create_and_add(), which
> means uncore_root_kobj has a ->sysfs_ops of kobj_sysfs_ops from
> kobject_create(), which uses kobj_attr_show() as its ->show() value.
>
> The only reason there has not been a more noticeable problem until this
> point is that 'struct kobj_attribute' and 'struct device_attribute' have
> the same layout, so getting the callback from container_of() works the
> same with either value.
>
> Change all the callbacks and their uses to be compatible with
> kobj_attr_show() and kobj_attr_store(), which resolves the kCFI failure
> and allows the sysfs files to work properly.
>
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1974
> Fixes: ae7b2ce57851 ("platform/x86/intel/uncore-freq: Use sysfs API to cr=
eate attributes")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> I think I got the fixes tag right. I only started seeing this because of
> commit 27f2b08735c9 ("platform/x86: intel-uncore-freq: Add additional
> client processors"), which allows this driver to load on my i7-11700
> test system but I think the commit in the Fixes tag incorrectly changes
> the types of the callbacks.
> ---
>  .../uncore-frequency/uncore-frequency-common.c     | 82 +++++++++++-----=
------
>  .../uncore-frequency/uncore-frequency-common.h     | 32 ++++-----
>  2 files changed, 57 insertions(+), 57 deletions(-)

Looks good to me. Thanks for the patch!

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
