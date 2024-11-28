Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C6684A5E
	for <patches@lists.linux.dev>; Thu, 28 Nov 2024 02:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732762643; cv=none; b=L49G9FfnCxqSHx1rmMmVPkzJR2R1NWQlDE4iSBLAL9aYvAEjr20u7lVEdMv2b2lFxIcqWpsirpT8zWLrZPwCu7bbeYoXBGVuSWuKoq2BRhGOCdHGf/Gr+daK7gta/HC728Nr7M4i1eO/0gT4+/hPJ8nnij2P+F3DF6+plO5GKcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732762643; c=relaxed/simple;
	bh=AumNp0CWszK6re/FbqNiKMVbPiWt3+6AwQ71UvOm5b4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gnn4iIxG4xQQaYmHF3yYZvzheSJZYnfKLn7BFMcryJGfGHuRn+VzzBCAuGkN1WYQzzT+O+J0flnbEBJB2uPn8jsAJRQCmjWxnPiS982uAY77xSf1okXJqnZ+CO3kv72ty/m3Y8VmGlU140bjkosBCkFwn0Cn9wePMyR53NqCb60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X/bqYmHK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X/bqYmHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AF4C4CED8
	for <patches@lists.linux.dev>; Thu, 28 Nov 2024 02:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732762642;
	bh=AumNp0CWszK6re/FbqNiKMVbPiWt3+6AwQ71UvOm5b4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=X/bqYmHKsppTSauDkjFlRlFBibq6WPHzk0KlXSGmbWBjQ+pnNl1hJk5ZkmIJzhTe0
	 DnnKMLQMLYHL5pfnSI7vzQhrbbRCtrnfPITZW1fpSA6bc2PBppQQTmXzRXsTobXI2O
	 WjeMORixz2u92cl87Jnl2ZhvUfawkDubl6Dz7IUoG2Swl4xwh5Ner/FhaiR7bFkP52
	 Eswu0Grmo1a7qNoZgI7qKEOkWB+5lO7SzdfgwMojz/l2Vmh/9dn/hjf2q0sYy1A15u
	 PTT+WoCKVd+Fl3aisl6E0ESnRaDOUlbaWjCQpoOAlP1rQPoz6rDDuNWAOGgGbzsnUQ
	 m4b0yDkt41cmA==
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-53df6322ea7so319493e87.0
        for <patches@lists.linux.dev>; Wed, 27 Nov 2024 18:57:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUcM9kcKNUizMxSIqgcbiAGrEf19chtTbK86hApdebAn1/jorF3LPmbTGfRxkBAbglJdXA5HrNR@lists.linux.dev
X-Gm-Message-State: AOJu0YxbO0IylnSC/9EvkVYxwnG8Tv5u/uYRKZgfHHocWURv/WFDCg9v
	R9H5jbbzyhSePvQja0Ab43N6TxeccRSP2YJHPv882xB/DA1vBTpUwVd91/U3iVH9PuvFEihvCaw
	spLeYwgwXEmTosGqu0Hb/1XV+sgk=
X-Google-Smtp-Source: AGHT+IFyLPx7b/0YZkMsxtRCyDhEVZjmhpxBs287ADktIEt/qE1bSEdCwN4mOBE31QFwWV5sZWgL3bF/7rWoKfh5UoE=
X-Received: by 2002:ac2:42d1:0:b0:53d:f09e:9a1d with SMTP id
 2adb3069b0e04-53df09e9c34mr3162118e87.31.1732762641195; Wed, 27 Nov 2024
 18:57:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Z0ZxiLw9hauUynTS@bombadil.infradead.org> <CAHk-=wjCkJsdLageTx6C4n--aYFoO6gSRe0Rwcbk1jQdOdiPfg@mail.gmail.com>
 <Z0eeuCyUGcKgsc5h@bombadil.infradead.org> <Z0eqiayuv1w4a_dc@bombadil.infradead.org>
 <CAHk-=wj+imfGvW73XoYn60bAMzRtPfXFqwFTUqBoEq4=u5_oUg@mail.gmail.com>
 <Z0fT4hC30NISjmi_@bombadil.infradead.org> <Z0fYqZutUzDdxTGf@bombadil.infradead.org>
In-Reply-To: <Z0fYqZutUzDdxTGf@bombadil.infradead.org>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Thu, 28 Nov 2024 11:56:44 +0900
X-Gmail-Original-Message-ID: <CAK7LNARDwBmvKY4fDmr5K=WLEvWLhFgg50ibu7etJykiRxohOA@mail.gmail.com>
Message-ID: <CAK7LNARDwBmvKY4fDmr5K=WLEvWLhFgg50ibu7etJykiRxohOA@mail.gmail.com>
Subject: Re: [GIT PULL] Modules changes for v6.13-rc1
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, samitolvanen@google.com, 
	petr.pavlu@suse.com, da.gomez@samsung.com, linux-modules@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, mmaurer@google.com, 
	arnd@arndb.de, deller@gmx.de, song@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 28, 2024 at 11:42=E2=80=AFAM Luis Chamberlain <mcgrof@kernel.or=
g> wrote:
>
> Now with Masahiro's cleanups, in my testing we don't need the FORCE anymo=
re.
>
>
> From 83497e0e83d81950df54d82461b1dae629842147 Mon Sep 17 00:00:00 2001
> From: Luis Chamberlain <mcgrof@kernel.org>
> Date: Wed, 27 Nov 2024 14:10:57 -0800
> Subject: [PATCH v3] selftests: kallsyms: fix double build stupidity
>
> Fix the stupid FORCE so that re-builds will only trigger
> when really needed. While at it, document the sensible ranges
> supported and fix the script to accept these alternatives.
>
> Also adopt Masahiro Yamada's suggested cleanups on the Makefile.
>
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>


Did you run any compile-test before submitting this?

if_changed requires FORCE.
Your patch introduces new warnings.




mkdir -p /home/masahiro/ref/linux/tools/objtool && make
O=3D/home/masahiro/ref/linux subdir=3Dtools/objtool --no-print-directory
-C objtool
  INSTALL libsubcmd_headers
  CALL    scripts/checksyscalls.sh
lib/tests/module/Makefile:12: FORCE prerequisite is missing
  GEN     lib/tests/module/test_kallsyms_a.c
lib/tests/module/Makefile:12: FORCE prerequisite is missing
lib/tests/module/Makefile:12: FORCE prerequisite is missing
  GEN     lib/tests/module/test_kallsyms_b.c
lib/tests/module/Makefile:12: FORCE prerequisite is missing
  GEN     lib/tests/module/test_kallsyms_c.c
  GEN     lib/tests/module/test_kallsyms_d.c
  CC [M]  lib/tests/module/test_kallsyms_a.o
  CC [M]  lib/tests/module/test_kallsyms_b.o
  CC [M]  lib/tests/module/test_kallsyms_c.o
  CC [M]  lib/tests/module/test_kallsyms_d.o

--
Best Regards
Masahiro Yamada
