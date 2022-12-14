Received: from conssluserg-01.nifty.com (conssluserg-01.nifty.com [210.131.2.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732A617F9;
	Wed, 14 Dec 2022 06:53:00 +0000 (UTC)
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46]) (authenticated)
	by conssluserg-01.nifty.com with ESMTP id 2BE6qhkH010162;
	Wed, 14 Dec 2022 15:52:43 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com 2BE6qhkH010162
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
	s=dec2015msa; t=1671000763;
	bh=kUp70rP8+WE375gZo6RwGVSoC7tN1va3x0gcuXXmVAc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fWj4uAFnhzIPVRwYJ4AcO3K43yxwwVige5gzPnptks2Dc9KHP0gdXw9ZgqA7lVN/l
	 tBYwl+YsZkBxWNB6vDEkAPbxh+LGu0R8VVXeBNF/q9nkYNMYlt80QOkhs5MKWZLikb
	 4PtdUJLwxzTDWDgGmc4daFosAMPfFbyWowixaKgfddq67sxqKUJo4z/Phn13gitaOo
	 1D6D4U25eKwdG0sxEmLzfJPnw93R5vNJh9rGwzFvRBld/t5o65vDgOWr/byh9tc6U4
	 Hr4F4MOPTsrLu4ux++vp+Dz3LZ7GEgyPxg2Jv94UDbgNnzvr2cunvmVVwmEvgZavlo
	 tF8MkaknFwwOg==
X-Nifty-SrcIP: [209.85.210.46]
Received: by mail-ot1-f46.google.com with SMTP id i26-20020a9d68da000000b00672301a1664so491102oto.6;
        Tue, 13 Dec 2022 22:52:43 -0800 (PST)
X-Gm-Message-State: ANoB5pku2h6v860NZCJpUt95OKDPeNGWUbZXrXlegAwQ0/H4kVVRXZPB
	BOTFUgOtHThU3uSM+TvMUfw132fqSwZePRE/MhA=
X-Google-Smtp-Source: AA0mqf4hyLaZPZqPEZgMASVAcc5qkFLGibxEUKGsAwT9Hi2h9o8TOTn1hbIUpkclYCt2W71rUBR6CM5VPiXHvUbYKqI=
X-Received: by 2002:a9d:282:0:b0:66c:794e:f8c6 with SMTP id
 2-20020a9d0282000000b0066c794ef8c6mr49412729otl.343.1671000762325; Tue, 13
 Dec 2022 22:52:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221213183529.766630-1-nathan@kernel.org>
In-Reply-To: <20221213183529.766630-1-nathan@kernel.org>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Wed, 14 Dec 2022 15:52:06 +0900
X-Gmail-Original-Message-ID: <CAK7LNAR6aPQEM3e_yuq4jgCAAiJ+cr6xGvG1N4uZfw70xk_YSg@mail.gmail.com>
Message-ID: <CAK7LNAR6aPQEM3e_yuq4jgCAAiJ+cr6xGvG1N4uZfw70xk_YSg@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] Fix lack of section mismatch warnings with LTO
To: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Sami Tolvanen <samitolvanen@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Dec 14, 2022 at 3:35 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> Hi all,
>
> Vincent recently reported an issue with lack of section mismatch
> warnings with LTO. This is due to commit 6c730bfc894f ("modpost: handle
> -ffunction-sections"), which ignores all function sections for modpost.
>
> I believe this is incorrect, as these function sections may still refer
> to symbols in other sections and they will ultimately be coalesced into
> .text by vmlinux.lds anyways.
>
> The first patch fixes a warning that I see with allmodconfig + ThinLTO
> builds after applying the second patch. The second patch moves ".text.*"
> into TEXT_SECTIONS so that modpost audits them for mismatches.
>
> I expect this to go via the kbuild tree with an ack from the padata
> maintainers.


Daniel Acked v2.

Applied to kbuild with his Acked-by.

Thanks.


>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
> Cc: linux-crypto@vger.kernel.org
>
> v3:
>   - Stick a comment above padata_work_init() to explain presence of
>     __ref (Masahiro, Daniel).
>   - Expand on problem in first patch's commit message (Masahiro).
>   - Adjust location of __ref within function definition (Daniel)
>   - Fix typo in commit message of second patch (Masahiro).
> v2: https://lore.kernel.org/20221207191657.2852229-1-nathan@kernel.org/
> v1: https://lore.kernel.org/20221129190123.872394-1-nathan@kernel.org/
>
> Nathan Chancellor (2):
>   padata: Mark padata_work_init() as __ref
>   modpost: Include '.text.*' in TEXT_SECTIONS
>
>  kernel/padata.c       | 12 ++++++++++--
>  scripts/mod/modpost.c |  4 ++--
>  2 files changed, 12 insertions(+), 4 deletions(-)
>
>
> base-commit: 830b3c68c1fb1e9176028d02ef86f3cf76aa2476
> --
> 2.39.0
>


-- 
Best Regards
Masahiro Yamada
