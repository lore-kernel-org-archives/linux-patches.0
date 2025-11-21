Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734D71494A8;
	Fri, 21 Nov 2025 15:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763739571; cv=none; b=j+gslcTvSO5RFi5OxVFKSMag3Z7cM8LJSQ+oyCs08MjxDvQOr9zvARajqzeeG2lM6HANsYIAaA5etuapvAc+F3hISU6zm3PJwPhUjVKHjKwg1LJJzDnoBS2qHW/5CC9gbqlK2IPmguVJPF2ZHUCRqCq2IzkyqwC44qzkRroNVVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763739571; c=relaxed/simple;
	bh=GOX6fYKVRys4eYFJ3leUryDR2X27AauSEop1ZhuDlko=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=msrwzv9B9XHM7XYw3T7mR6QzTQdqAhTFa5B2A0/VLT9sZf4yQGB4xTZdq1Zmvw//IjMZM/S39v5CTv6OxJ94iRnln1GsjqslBCev+aJuNivyXX693E5BnFPSnghSM5EoqJeOk8hTcLYeBtnCe7Wbi2MRvV3hISZRhCTyXSOBeGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cr1Rrwy+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cr1Rrwy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61CFC4CEF1;
	Fri, 21 Nov 2025 15:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763739570;
	bh=GOX6fYKVRys4eYFJ3leUryDR2X27AauSEop1ZhuDlko=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Cr1Rrwy+8sHcbDB56REETEjiaellGCk4p3n9cLcz3uZFS7GUGRjNrx5xSq/nXRtOq
	 TrLYuZcLSgzMGBfxQPWGPj/wqFDbiVG/ey9hbG4qFlw94OJ6GMQi0rdyB4uesR9dc/
	 omkUbsYZlOasBaUN1oFmMsseCCfNV2aIjwLSXmidBgUa73u18glZi3Yw/uh9OPZL71
	 yVyngyb2VplPZKeAgdBjxuPSvDYlip6QpNcqaE2mbRGhYZT23lWQEyLICSM0G9U+VM
	 8BEvQiqVnMTqVVLUwwwPB7V95CWoBea2Ic4IT5ATCyReZTSo+bYTpLFzsL1nUfohLA
	 LyD1b+NYHcYnA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Thorsten Leemhuis <linux@leemhuis.info>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  stable@vger.kernel.org,
  patches@lists.linux.dev,  Mike Rapoport <rppt@kernel.org>,  Pratyush
 Yadav <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,  Christian
 Brauner <brauner@kernel.org>,  David Matlack <dmatlack@google.com>,  Jason
 Gunthorpe <jgg@ziepe.ca>,  Jonathan Corbet <corbet@lwn.net>,  Masahiro
 Yamada <masahiroy@kernel.org>,  Miguel Ojeda <ojeda@kernel.org>,  Randy
 Dunlap <rdunlap@infradead.org>,  Samiullah Khawaja <skhawaja@google.com>,
  Tejun Heo <tj@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.17 164/247] kho: warn and fail on metadata or
 preserved memory in scratch area
In-Reply-To: <489a925f-ba57-432d-ac50-dcd78229c2ff@leemhuis.info> (Thorsten
	Leemhuis's message of "Fri, 21 Nov 2025 15:45:35 +0100")
References: <20251121130154.587656062@linuxfoundation.org>
	<20251121130200.607393324@linuxfoundation.org>
	<489a925f-ba57-432d-ac50-dcd78229c2ff@leemhuis.info>
Date: Fri, 21 Nov 2025 16:39:26 +0100
Message-ID: <mafs0ldjz1jkh.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21 2025, Thorsten Leemhuis wrote:

> On 11/21/25 14:11, Greg Kroah-Hartman wrote:
>> 6.17-stable review patch.  If anyone has any objections, please let me k=
now.
>>=20
>> ------------------
>>=20
>> From: Pasha Tatashin <pasha.tatashin@soleen.com>
>>=20
>> commit e38f65d317df1fd2dcafe614d9c537475ecf9992 upstream.
>>=20
>> Patch series "KHO: kfence + KHO memory corruption fix", v3.
>>=20
>> This series fixes a memory corruption bug in KHO that occurs when KFENCE
>> is enabled.
>
> I ran into a build problem that afaics is caused by this change:
>
> """
> In file included from ./arch/x86/include/asm/bug.h:103,
>                  from ./arch/x86/include/asm/alternative.h:9,
>                  from ./arch/x86/include/asm/barrier.h:5,
>                  from ./include/asm-generic/bitops/generic-non-atomic.h:7,
>                  from ./include/linux/bitops.h:28,
>                  from ./include/linux/bitmap.h:8,
>                  from ./include/linux/nodemask.h:91,
>                  from ./include/linux/numa.h:6,
>                  from ./include/linux/cma.h:7,
>                  from kernel/kexec_handover.c:12:
> kernel/kexec_handover.c: In function =E2=80=98kho_preserve_phys=E2=80=99:
> kernel/kexec_handover.c:732:41: error: =E2=80=98nr_pages=E2=80=99 undecla=
red (first use in this function); did you mean =E2=80=98dir_pages=E2=80=99?
>   732 |                                         nr_pages << PAGE_SHIFT)))=
 {
>       |                                         ^~~~~~~~

8375b76517cb5 ("kho: replace kho_preserve_phys() with
kho_preserve_pages()") refactored this function to work on page
granularity (nr_pages) instead of bytes (size). Since that commit wasn't
backported, nr_pages does not exist.

Simple fix should be to replace "nr_pages << PAGE_SHIFT" with "size".

> ./include/asm-generic/bug.h:123:32: note: in definition of macro =E2=80=
=98WARN_ON=E2=80=99
>   123 |         int __ret_warn_on =3D !!(condition);                     =
         \
>       |                                ^~~~~~~~~
> kernel/kexec_handover.c:732:41: note: each undeclared identifier is repor=
ted only once for each function it appears in
>   732 |                                         nr_pages << PAGE_SHIFT)))=
 {
>       |                                         ^~~~~~~~
> ./include/asm-generic/bug.h:123:32: note: in definition of macro =E2=80=
=98WARN_ON=E2=80=99
>   123 |         int __ret_warn_on =3D !!(condition);                     =
         \
>       |                                ^~~~~~~~~
> make[3]: *** [scripts/Makefile.build:287: kernel/kexec_handover.o] Error 1
> make[3]: *** Waiting for unfinished jobs....
> make[2]: *** [scripts/Makefile.build:556: kernel] Error 2
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [/builddir/build/BUILD/kernel-6.17.9-build/kernel-6.17.9-rc1=
/linux-6.17.9-0.rc1.300.vanilla.fc43.x86_64/Makefile:2019: .] Error 2
> make: *** [Makefile:256: __sub-make] Error 2
[...]

--=20
Regards,
Pratyush Yadav
