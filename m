Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1755731352C
	for <patches@lists.linux.dev>; Mon, 27 Oct 2025 16:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761583039; cv=none; b=I+vshWRbnFpupXkZZg5Nj8V66ME1TRUPhqAQV3Ws8PtFZN7ozzGW9Zd9/GmpFbedufVCihcRvoe2jaUNbMvZPlPFWwIhDD5FKDLMvTd5mGdlpgz7yC4R7FxTmqHS2JJaxFbR0ZPRFiBnkC7jy2TwbFs2CsP0bSqAzUSPqN2p4kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761583039; c=relaxed/simple;
	bh=Oi6PnYKu8At7mn2r8bJbw6fE2P/LefHPpppgZI9YhB4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MlKdBN5uh2iVHmuvZKiQybEYDos3adnkD0N48OQB7kv2Sawr2T9B0f0H0nL4qI21FLDrhpMVpY55B0afjeIeSXpq2Gxlh1dUQTeUy0Nza+Cq8FJUaKkyZ/bFo2Zvh2KhkKd+NOFF6j2S0TvnV7su4sy0p2cLRw9VPA+fL/tpVOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qwSttHYz; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qwSttHYz"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ea12242d2eso765701cf.1
        for <patches@lists.linux.dev>; Mon, 27 Oct 2025 09:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761583036; x=1762187836; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QOy3iiebbAqjF3YwXd91msbbmKaBEHmD6+luJVRUSx4=;
        b=qwSttHYzOLVhkQesSzZ/USnkpdZbzeWxL5IbRjBpy+pIHj50Vp3EZvNyKD/sxhDt5o
         E9DeNdsOtNJe1JR69/pv7RbtdKWfLtgysE7AT7w9ZfRT85DNhfFhEjtC0FuwpB73+Tvm
         bXzwbZFd95o+y30gOgrSgE0lQpnaNMgwO8/siwrxhsG0mmHiMSWInSlTz0ru+ACNvHS7
         gwMLozQbVxCGKu2IAHg+259cxYN6zc1pg3V/k6mtATK48EWnTg5oeXZvgLPJ/D0L9eHl
         nRL8U/PUc2Rz/r6mAW0rjttj2+qgVbluL0WbEhVFnht5+RRelSextFenuN7I5NSlAhDx
         eORw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761583036; x=1762187836;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QOy3iiebbAqjF3YwXd91msbbmKaBEHmD6+luJVRUSx4=;
        b=mBXtE+KROC0dRAUBs0sJHSQAsEZffXCEUVfhQCrUd8PsGjC3Umk5VXa0a8RhQVnqCy
         i9ZbuX33gTCt32xZpXf0QajUpU3ZyOlKPb6voHN1Ooaj3cO+swz/jmyhQ1G1AeKPeTps
         UhqL08saC0VshIfChggCrRjikOnYQ5P3rGGWAEQFKgdSX2losRqc2TUuJ5rvest/ABtk
         Ej4hd//OzV9Dsc4fzdnmlYz5kFkblPHtuZSeA1TpXCLNS0aU00F5fCPn4sU9ITWybiv+
         fl/avYVdQ4nXJ7II/0QXLVtxSZiOx1EmLOdXT4sEGAcJUI8kB3hROmswki30vTNe9StZ
         /8gA==
X-Forwarded-Encrypted: i=1; AJvYcCUrr2iJitUp7xLZ0R5yPKNMZ5AlgTLUBHXXOpAtkSEt9qb0Sk8vp2KpYFFB/bryLq8selIcLMLw@lists.linux.dev
X-Gm-Message-State: AOJu0YwgywAWACyAP6Ngmj28AxZ65su0VbwrWIGxF7jajR760kecueoU
	SVMYiIOlDZJhZh7snKUkEFcXmo/MSwHEvSk6nUH3mjcCxCLg1YcwgVTxOeVVPGrhGRs9SQixObv
	S9s+D0QG3yywqIKNz44eyIxww01dSWof2pkA/m6p2
X-Gm-Gg: ASbGncs31PqwdF8ArYAqYhMLLURUdmpwFdsBaNqFjNTHRbfOja8NC7FCBTvcAn+yFSj
	c7AyTmDteD3A+06f4pJp3mQvBRISa9lF8yxzL80aLL81RA8LrALeUpCanxekxW7N6AKG0Y60q52
	/osXTPSBprD0fR4tjyvQ6weCpO8iBK3AHY6Z9L4JfH2YTzD/7qizB/NxQsVlKIDk314Xk/DOkDs
	O6OpXJCnnkOH/R1huVkWdKR98ZEmj+C3bScyUOiZDbep8JFYQKNMuo9/83VFr8YMX3fpLk+cfmH
	QY0wVHy1YrLKYlUesrKVYGWrfw==
X-Google-Smtp-Source: AGHT+IFaxIw83VYwbbIh7Erx5pfEMAgBcg1pYjNg+FGawbKps6jMbAo+rgY9Q7yMQi2Hw2U4lkBfkLGAUfTgx/d+46w=
X-Received: by 2002:a05:622a:5a97:b0:4b7:9b06:ca9f with SMTP id
 d75a77b69052e-4eba2194b2bmr16376531cf.2.1761583035660; Mon, 27 Oct 2025
 09:37:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v7-ab019a8791e2+175b8-iommu_pt_jgg@nvidia.com> <2-v7-ab019a8791e2+175b8-iommu_pt_jgg@nvidia.com>
In-Reply-To: <2-v7-ab019a8791e2+175b8-iommu_pt_jgg@nvidia.com>
From: Samiullah Khawaja <skhawaja@google.com>
Date: Mon, 27 Oct 2025 09:37:03 -0700
X-Gm-Features: AWmQ_bkrPoVQcTl-93AGiukk8qPqil6Um8n3WCq157c9AX6034wo8PiXupkuk_E
Message-ID: <CAAywjhSMnmAaS2vTcHDPfRxbSMSwmQuAUL-bgRNt+wEXi0SAZw@mail.gmail.com>
Subject: Re: [PATCH v7 02/15] genpt: Add Documentation/ files
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Anup Patel <anup@brainfault.org>, 
	Albert Ou <aou@eecs.berkeley.edu>, Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev, 
	Joerg Roedel <joro@8bytes.org>, Justin Stitt <justinstitt@google.com>, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	llvm@lists.linux.dev, Bill Wendling <morbo@google.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Shuah Khan <shuah@kernel.org>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Will Deacon <will@kernel.org>, 
	Alexey Kardashevskiy <aik@amd.com>, Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, 
	James Gowans <jgowans@amazon.com>, Kevin Tian <kevin.tian@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2025 at 11:21=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> w=
rote:
>
> Add some general description and pull in the kdoc comments from the sourc=
e
> file to index most of the useful functions.
>
> Tested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  Documentation/driver-api/generic_pt.rst | 142 ++++++++++++++++++++++++
>  Documentation/driver-api/index.rst      |   1 +
>  2 files changed, 143 insertions(+)
>  create mode 100644 Documentation/driver-api/generic_pt.rst
>
> diff --git a/Documentation/driver-api/generic_pt.rst b/Documentation/driv=
er-api/generic_pt.rst
> new file mode 100644
> index 00000000000000..210d1229aa1c1f
> --- /dev/null
> +++ b/Documentation/driver-api/generic_pt.rst
> @@ -0,0 +1,142 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +Generic Radix Page Table
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +.. kernel-doc:: include/linux/generic_pt/common.h
> +       :doc: Generic Radix Page Table
> +
> +.. kernel-doc:: drivers/iommu/generic_pt/pt_defs.h
> +       :doc: Generic Page Table Language
> +
> +-----
> +Usage
> +-----
> +
> +Generic PT is structured as a multi-compilation system. Since each forma=
t
> +provides an API using a common set of names there can be only one format=
 active
> +within a compilation unit. This design avoids function pointers around t=
he low
> +level API.
> +
> +Instead the function pointers can end up at the higher level API (i.e.
> +map/unmap, etc.) and the per-format code can be directly inlined into th=
e
> +per-format compilation unit. For something like IOMMU each format will b=
e
> +compiled into a per-format IOMMU operations kernel module.
> +
> +For this to work the .c file for each compilation unit will include both=
 the
> +format headers and the generic code for the implementation. For instance=
 in an
> +implementation compilation unit the headers would normally be included a=
s
> +follows::
> +
> +generic_pt/fmt/iommu_amdv1.c::
> +
> +       #include <linux/generic_pt/common.h>
> +       #include "defs_amdv1.h"
> +       #include "../pt_defs.h"
> +       #include "amdv1.h"
> +       #include "../pt_common.h"
> +       #include "../pt_iter.h"
> +       #include "../iommu_pt.h"  /* The IOMMU implementation */
> +
> +iommu_pt.h includes definitions that will generate the operations functi=
ons for
> +map/unmap/etc. using the definitions provided by AMDv1. The resulting mo=
dule
> +will have exported symbols named like pt_iommu_amdv1_init().
> +
> +Refer to drivers/iommu/generic_pt/fmt/iommu_template.h for an example of=
 how the
> +IOMMU implementation uses multi-compilation to generate per-format ops s=
tructs
> +pointers.
> +
> +The format code is written so that the common names arise from #defines =
to
> +distinct format specific names. This is intended to aid debuggability by
> +avoiding symbol clashes across all the different formats.
> +
> +Exported symbols and other global names are mangled using a per-format s=
tring
> +via the NS() helper macro.
> +
> +The format uses struct pt_common as the top-level struct for the table,
> +and each format will have its own struct pt_xxx which embeds it to store
> +format-specific information.
> +
> +The implementation will further wrap struct pt_common in its own top-lev=
el
> +struct, such as struct pt_iommu_amdv1.
> +
> +----------------------------------------------
> +Format functions at the struct pt_common level
> +----------------------------------------------
> +
> +.. kernel-doc:: include/linux/generic_pt/common.h
> +       :identifiers:
> +.. kernel-doc:: drivers/iommu/generic_pt/pt_common.h
> +
> +-----------------
> +Iteration Helpers
> +-----------------
> +
> +.. kernel-doc:: drivers/iommu/generic_pt/pt_iter.h
> +
> +----------------
> +Writing a Format
> +----------------
> +
> +It is best to start from a simple format that is similar to the target. =
x86_64
> +is usually a good reference for something simple, and AMDv1 is something=
 fairly
> +complete.
> +
> +The required inline functions need to be implemented in the format heade=
r.
> +These should all follow the standard pattern of::
> +
> + static inline pt_oaddr_t amdv1pt_entry_oa(const struct pt_state *pts)
> + {
> +       [..]
> + }
> + #define pt_entry_oa amdv1pt_entry_oa
> +
> +where a uniquely named per-format inline function provides the implement=
ation
> +and a define maps it to the generic name. This is intended to make debug=
 symbols
> +work better. inline functions should always be used as the prototypes in
> +pt_common.h will cause the compiler to validate the function signature t=
o
> +prevent errors.
> +
> +Review pt_fmt_defaults.h to understand some of the optional inlines.
> +
> +Once the format compiles then it should be run through the generic page =
table
> +kunit test in kunit_generic_pt.h using kunit. For example::
> +
> +   $ tools/testing/kunit/kunit.py run --build_dir build_kunit_x86_64 --a=
rch x86_64 --kunitconfig ./drivers/iommu/generic_pt/.kunitconfig amdv1_fmt_=
test.*
> +   [...]
> +   [11:15:08] Testing complete. Ran 9 tests: passed: 9
> +   [11:15:09] Elapsed time: 3.137s total, 0.001s configuring, 2.368s bui=
lding, 0.311s running
> +
> +The generic tests are intended to prove out the format functions and giv=
e
> +clearer failures to speed up finding the problems. Once those pass then =
the
> +entire kunit suite should be run.
> +
> +---------------------------
> +IOMMU Invalidation Features
> +---------------------------
> +
> +Invalidation is how the page table algorithms synchronize with a HW cach=
e of the
> +page table memory, typically called the TLB (or IOTLB for IOMMU cases).
> +
> +The TLB can store present PTEs, non-present PTEs and table pointers, dep=
ending
> +on its design. Every HW has its own approach on how to describe what has=
 changed
> +to have changed items removed from the TLB.
> +
> +PT_FEAT_FLUSH_RANGE
> +-------------------
> +
> +PT_FEAT_FLUSH_RANGE is the easiest scheme to understand. It tries to gen=
erate a
> +single range invalidation for each operation, over-invalidating if there=
 are
> +gaps of VA that don't need invalidation. This trades off impacted VA for=
 number
> +of invalidation operations. It does not keep track of what is being inva=
lidated;
> +however, if pages have to be freed then page table pointers have to be c=
leaned
> +from the walk cache. The range can start/end at any page boundary.
> +
> +PT_FEAT_FLUSH_RANGE_NO_GAPS
> +---------------------------
> +
> +PT_FEAT_FLUSH_RANGE_NO_GAPS is similar to PT_FEAT_FLUSH_RANGE; however, =
it tries
> +to minimize the amount of impacted VA by issuing extra flush operations.=
 This is
> +useful if the cost of processing VA is very high, for instance because a
> +hypervisor is processing the page table with a shadowing algorithm.
> diff --git a/Documentation/driver-api/index.rst b/Documentation/driver-ap=
i/index.rst
> index 3e2a270bd82826..baff96b5cf0ba4 100644
> --- a/Documentation/driver-api/index.rst
> +++ b/Documentation/driver-api/index.rst
> @@ -93,6 +93,7 @@ Subsystem-specific APIs
>     frame-buffer
>     aperture
>     generic-counter
> +   generic_pt
>     gpio/index
>     hsi
>     hte/index
> --
> 2.43.0
>
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
