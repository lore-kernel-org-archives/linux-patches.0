Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75616378D94
	for <patches@lists.linux.dev>; Wed, 29 Apr 2026 22:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777500448; cv=none; b=TpV2u07ndYVBJKQycTyrSupmxijWIC9q80hFkuAlkStAn0nWNWNb2ftMsQoXN1bqpH3VEYEm/2SJj/KD21KdiRAs0E4pHRA/3mag5mmN6npfpvecqqBDqoz9+LGt96TciHXVlMdpQ2fkW4esdbIGzqni7bQV4jsJqFb4i885+Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777500448; c=relaxed/simple;
	bh=ne42NLa8SlVX5BWsuc8lLnC9VrKI2mUNQfxbKnQhih8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d5ZD/hsRKJ8wVz3R35hm3xOs09bLdZWgxtGRQrUPth5L4+W7Ws0NPc31Xfwabe+6Gw1y24rNV005Q28e1pmECtrZY4jZBzFdb0bfRow67g3mf2b2t+oMysNiqBzGWLOMYxbkE87FKTIg2soQZ2+V+zljSXvy2jPwDYexQE6P1ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MyplKs3w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MyplKs3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123B0C2BCB3
	for <patches@lists.linux.dev>; Wed, 29 Apr 2026 22:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777500448;
	bh=ne42NLa8SlVX5BWsuc8lLnC9VrKI2mUNQfxbKnQhih8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=MyplKs3wkgjpG8mChDQLZDrwA3bQV+4IGzZ36uZ/h+Jyyh1bOWsPYSTzWk+gF2Zhu
	 ukVQRiwvE5i69uVhm9jTogHyS0mH3XU4C/xKXEZ5vkNryFkjuzSDE7zCKC0O/Lf7lm
	 50lbcddY8BaR1EvVwMeerpncBBBFEIREtm9VS9wFbHDP5QPdL+MH0+WeLdeqwpLSM+
	 XtBHL3QolUJ8mJgCKP5hAWJhzMpS2XmIzyn/Q6nm+xhzehINDetiaa0AXUt6Dz1OL4
	 WQUu5HtCv4EhshLB2MthEgT8XWLnNo0+x5jHgbPjLMlBA8ogrVYgGdaQIjs9DqgMr/
	 wg0rCs64MZPVg==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-678a526f374so548629a12.0
        for <patches@lists.linux.dev>; Wed, 29 Apr 2026 15:07:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+8IiLolPDO9YDGtQo0nOggnCEYxxSerBsSwOd6zXTYAyUpCuZ2semvufSUt/Y5/IpGbsoJ9FWP@lists.linux.dev
X-Gm-Message-State: AOJu0YynUF+F1kzEp529ep5imJx7wBqhX9iu8T3oCb8BB0687bt4vBup
	7x8fpRFJLhY6UtwyPVUSkTAhlAc14+perxaUYnwLRW6xdEYrzPnGlmbv5cy4RZdxe5dRUMWWgml
	C7+JThUuJd9WZUwPsC0YyHTISU/rJzgA=
X-Received: by 2002:a17:907:d706:b0:ba8:cad1:f6e2 with SMTP id
 a640c23a62f3a-bbb6b1901b4mr750066b.23.1777500446684; Wed, 29 Apr 2026
 15:07:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260428-ntfs-fix-sometimes-uninit-rl-v1-1-31e0c8025430@kernel.org>
In-Reply-To: <20260428-ntfs-fix-sometimes-uninit-rl-v1-1-31e0c8025430@kernel.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 30 Apr 2026 07:07:13 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8jNRyXSLHwwxDtiCyQ3m8XkBEFEAse656C-CUszs8Xwg@mail.gmail.com>
X-Gm-Features: AVHnY4IrQ3YDw5liGNuP0fVBNKnM61a-p537gPgc12WMdwTyTAR3CWMFEUfdbOU
Message-ID: <CAKYAXd8jNRyXSLHwwxDtiCyQ3m8XkBEFEAse656C-CUszs8Xwg@mail.gmail.com>
Subject: Re: [PATCH] ntfs: Use return instead of goto in ntfs_mapping_pairs_decompress()
To: Nathan Chancellor <nathan@kernel.org>
Cc: Hyunchul Lee <hyc.lee@gmail.com>, Zhan Xusheng <zhanxusheng@xiaomi.com>, 
	linux-fsdevel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 29, 2026 at 4:21=E2=80=AFAM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> Clang warns (or errors with CONFIG_WERROR=3Dy / W=3De):
>
>   fs/ntfs/runlist.c:755:6: error: variable 'rl' is used uninitialized whe=
never 'if' condition is true [-Werror,-Wsometimes-uninitialized]
>     755 |         if (overflows_type(lowest_vcn, vcn)) {
>         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   ...
>   fs/ntfs/runlist.c:971:9: note: uninitialized use occurs here
>     971 |         kvfree(rl);
>         |                ^~
>   ...
>
> rl has not been allocated at this point so the 'goto err_out' should
> really just be a return of the error pointer -EIO.
>
> Fixes: cad7c6f0a514 ("ntfs: fix VCN overflow in ntfs_mapping_pairs_decomp=
ress()")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Applied it to #ntfs-next.
Thanks!
