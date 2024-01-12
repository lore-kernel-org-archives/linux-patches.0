Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE17C1E529;
	Fri, 12 Jan 2024 14:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P3AiCQ/c"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-6ddec7e5747so2250040a34.3;
        Fri, 12 Jan 2024 06:52:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705071150; x=1705675950; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZO45YkzCWML/dfVASjM1WgREcSCHVv4YlKgRi2In5SM=;
        b=P3AiCQ/csTDmT5OQPK0Zfld/vVKrmVSZGQjIdAB+SZcA558bnawiLVKk927qRClBzX
         xiSSLKpC3lcvo5Sl4h+9XWLhctpViy1zU3dZZ7983rEnSR7FKIrlj2ceOfbbwZjru0h2
         ysjwqmi4KGr2pN7JwzlyBvIo3XkIXKn43zmzhtSDAUdzgwKfX/ucn3nDuCLbmJb7aAsP
         1ITQEPVUK257eI59Umu/EWuyVANu4fVEg2TdmnPrBZ3j0ZHvnac7c1X/pGyZzoSKMXHf
         3Jn7FG4VQxMKI+tTaw9ygvWUk5we6mfNKzOUZIh62Rw3AGXXDjpoa9YeQOSh49z9Lg/b
         tZ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705071150; x=1705675950;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZO45YkzCWML/dfVASjM1WgREcSCHVv4YlKgRi2In5SM=;
        b=diJ5uy1bfIZMPkjLUz4ofZCWQk75WUhALEMCfrJZAlakES88r1E9oG/7XnKI49uivE
         Cd9WxXDDjQrWbJ0IPbQx6AsCoLstPdf5UgMjeWXBXWO/FAu9dz/Pn/ox4OKSn5ZQCJMe
         gm5igNE8Z7wQJiwTqkBAsWrgaZoFzt21imN4tbO1Ob3OrAcKNAH16mT7XgoRRnOEQltA
         mE+lw51Gm2vK24WWWnH+E7C7TCpxatwGW6FQJqbSGAHjpLfF9FPZNT3d8sEf49MTlPZq
         nRi9NZfQXC+qb9BsIdgs7cJteTnbv3R93HfmIi3uAxblmoGiKJQVvESeHy9kNKDuMxHS
         VxHg==
X-Gm-Message-State: AOJu0YylSJ83qOI/KqPgnRpV+bA6vFhA1xGkkvvcjL9S0Ltv/qHvQMjJ
	NtfjNKkPKn34QmABDJ6vzfvCrA4a1TryPj5dqVA=
X-Google-Smtp-Source: AGHT+IF3L5IPA3aINLKE1Gh2ONL1jl1iO/jiOLm/9Zoi+Tx7cZA3qsT/gQ+IN9bZafCkSYUcodRd62GQ0tiAxg2qKZk=
X-Received: by 2002:a05:6871:452:b0:206:8691:cc78 with SMTP id
 e18-20020a056871045200b002068691cc78mr1680164oag.34.1705071149757; Fri, 12
 Jan 2024 06:52:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240109-update-llvm-links-v1-0-eb09b59db071@kernel.org>
In-Reply-To: <20240109-update-llvm-links-v1-0-eb09b59db071@kernel.org>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Fri, 12 Jan 2024 09:52:17 -0500
Message-ID: <CADnq5_MVDDR-EvgSEhiw_qPkUDPnV25tjUN0SNYq45Q29BN4EQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Update LLVM Phabricator and Bugzilla links
To: Nathan Chancellor <nathan@kernel.org>
Cc: akpm@linux-foundation.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, 
	llvm@lists.linux.dev, ast@kernel.org, dri-devel@lists.freedesktop.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kasan-dev@googlegroups.com, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, mykolal@fb.com, 
	daniel@iogearbox.net, andrii@kernel.org, amd-gfx@lists.freedesktop.org, 
	linux-media@vger.kernel.org, linux-pm@vger.kernel.org, bridge@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org, 
	patches@lists.linux.dev, linux-security-module@vger.kernel.org, 
	linux-crypto@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 9, 2024 at 5:26=E2=80=AFPM Nathan Chancellor <nathan@kernel.org=
> wrote:
>
> This series updates all instances of LLVM Phabricator and Bugzilla links
> to point to GitHub commits directly and LLVM's Bugzilla to GitHub issue
> shortlinks respectively.
>
> I split up the Phabricator patch into BPF selftests and the rest of the
> kernel in case the BPF folks want to take it separately from the rest of
> the series, there are obviously no dependency issues in that case. The
> Bugzilla change was mechanical enough and should have no conflicts.
>
> I am aiming this at Andrew and CC'ing other lists, in case maintainers
> want to chime in, but I think this is pretty uncontroversial (famous
> last words...).
>

Acked-by: Alex Deucher <alexander.deucher@amd.com>

> ---
> Nathan Chancellor (3):
>       selftests/bpf: Update LLVM Phabricator links
>       arch and include: Update LLVM Phabricator links
>       treewide: Update LLVM Bugzilla links
>
>  arch/arm64/Kconfig                                 |  4 +--
>  arch/powerpc/Makefile                              |  4 +--
>  arch/powerpc/kvm/book3s_hv_nested.c                |  2 +-
>  arch/riscv/Kconfig                                 |  2 +-
>  arch/riscv/include/asm/ftrace.h                    |  2 +-
>  arch/s390/include/asm/ftrace.h                     |  2 +-
>  arch/x86/power/Makefile                            |  2 +-
>  crypto/blake2b_generic.c                           |  2 +-
>  drivers/firmware/efi/libstub/Makefile              |  2 +-
>  drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c           |  2 +-
>  drivers/media/test-drivers/vicodec/codec-fwht.c    |  2 +-
>  drivers/regulator/Kconfig                          |  2 +-
>  include/asm-generic/vmlinux.lds.h                  |  2 +-
>  include/linux/compiler-clang.h                     |  2 +-
>  lib/Kconfig.kasan                                  |  2 +-
>  lib/raid6/Makefile                                 |  2 +-
>  lib/stackinit_kunit.c                              |  2 +-
>  mm/slab_common.c                                   |  2 +-
>  net/bridge/br_multicast.c                          |  2 +-
>  security/Kconfig                                   |  2 +-
>  tools/testing/selftests/bpf/README.rst             | 32 +++++++++++-----=
------
>  tools/testing/selftests/bpf/prog_tests/xdpwall.c   |  2 +-
>  .../selftests/bpf/progs/test_core_reloc_type_id.c  |  2 +-
>  23 files changed, 40 insertions(+), 40 deletions(-)
> ---
> base-commit: 0dd3ee31125508cd67f7e7172247f05b7fd1753a
> change-id: 20240109-update-llvm-links-d03f9d649e1e
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
