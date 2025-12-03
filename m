Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4C13254B9
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 23:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764803246; cv=none; b=m3B3gq0k8Oy+VAITPDNU4Ttd17RO8NGjeOErGYMy0zfsKS4XxH7pHQIrEiGKppfDP/8LvXVxrTrIR5U0X+P0MJdpk4qckCuy5/UXEfL+RuHX/dIRwTQSbEkY12s+qVWHQhBiwOpARcPWH9HFFnz/3pun6fIbUr1ky8h5qKzFWEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764803246; c=relaxed/simple;
	bh=ARjBU24hBcskgb7NtDM1BJQCy1LB2oT4dOF6omBJasE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LCEpe6aSAtPMZg5QV5bX7d01vicw6MCyzL+G1rwjV6Dl2a9DuXdDpXAU8zsFxr6YGWrH2gLuDtVgoUKwvdSlkFlSInWzwoz5Vqq5eGPCwjw7bd2UtfPxZbpakwZb6h8U2FLiO+QQaFWs52W0MvJ1+AW6mt9QjTUijjnf8CCsq6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eMzqghwY; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eMzqghwY"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4edb6e678ddso4505461cf.2
        for <patches@lists.linux.dev>; Wed, 03 Dec 2025 15:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764803244; x=1765408044; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ARjBU24hBcskgb7NtDM1BJQCy1LB2oT4dOF6omBJasE=;
        b=eMzqghwY7rT5LpsTjc/rTrHho3RCmIy68pLMyHTUjNsbz13A8VaBp7nC4uOOWsa/7R
         i2MF4ap+9Nw4Zky6+Usf93Z18U4D6UgyZi5kUiUZ8WdJwsWUD0kDqW5nH371Hmuu9GyE
         lN5y4JbhYZHBUv7AwZUSgwXG+xsQFQ9M6DTRGhoXypPqUm2SPBbQayg0AhChKEwHCbPY
         51cS8r7OMFsNHbH97nQowptRqo51UoglEzpZtcMdFNEIBJuITDjRJg+TCCEE/Jff+ndC
         FHh8NPzgRS5IncjV2HsWK8JhTFwgld6XcErEbDBT2saQmMjb40xnEsSy1PIsVVV2fRUk
         9L4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764803244; x=1765408044;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ARjBU24hBcskgb7NtDM1BJQCy1LB2oT4dOF6omBJasE=;
        b=TWHbqDvmeXmbl9MEjhzuct24d0arS1pZS74YfC+kiGvFbdNmxTnkcITsuehdZ7+0pA
         VEoLvdm33sbh4vfZ73xOgeqJdCXXI7bvnMGjmzNq5Z4C3hMBSO0De9HP2d0hv+mL3UmH
         4wL+tuVs3CiwqwQmiZRWwZBo93rji9tNUDnR9v6CTmrjUWY5jb50uPJ7ejATK1a53YZt
         nDDhBXgZKZk3l7nkjXupisQNpX+iDp83x4qCdB3mmTTt4C1mOtvMpuZCBStIIUljkEaU
         7YmJJY5W41u1loWLm4tBIrEOJwzCi5b473J/bBd/YUg5zwsvzOyWGoXsBBV/BDS/sGUB
         b/8A==
X-Gm-Message-State: AOJu0YxV8SSMk3+wwxupGZB/rpfJUV2Ye3jlPdVytCfu5I3x5xVcum+N
	5OB/EZ/qtUdanjM4UQ5PiUnswKumhzn4+L6przNrtZeOFcI9jGiufn2psF0dPHPk1PDnuuApq0b
	z4grQFElc80dls6hbWtmid/S6j+gct7k=
X-Gm-Gg: ASbGncuxrBxCPcn1sqi1xMeMgjwpkfhtSVTlrIhqCq8QuVyPnCgOHOw7YKZEnMu+aGt
	bfOrmWYWVC3TU6H3K8OaBhfDHpyZmnsXGqoTDYyjYdE5VxS4CL2gTPKRa6XFLbvmVvN3t8xJX5u
	nXOHhipduGiDZRt5zzsL6U6I0KfFflPpsqAu/6wv6vAD02bBXkH6PsC5TXhtFObSWM7ENOKa2BM
	WERHnVeGuO0oKk3wV6umWSqOsJFrMGp3Asxbd1X6cehEl7QejitYWcdi5Ug1y2fCl2aM+w=
X-Google-Smtp-Source: AGHT+IHeXlWltuajJrx5d5zaBmOs+3Uu+5HXat5Ce2MX4X5ZPI8oXVau0JJuFiDWUeYCCz9yKCjgfAUsfswBi07X5PE=
X-Received: by 2002:a05:622a:3cc:b0:4ee:1b0e:861a with SMTP id
 d75a77b69052e-4f017592726mr59846181cf.13.1764803243439; Wed, 03 Dec 2025
 15:07:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251203202839.819850-1-sashal@kernel.org>
In-Reply-To: <20251203202839.819850-1-sashal@kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 3 Dec 2025 15:07:12 -0800
X-Gm-Features: AWmQ_bmqhNk5StWxxmTMDLwKPZbVHBIiLQfZnv8DcnlEQfJufs1LWeozSv_ldNk
Message-ID: <CAJnrk1aSf+bTiRE40BSM72y8p_0CZjeJ4AHF78QbxxPicmPMXw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.18-6.6] iomap: adjust read range correctly for
 non-block-aligned positions
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, 
	syzbot@syzkaller.appspotmail.com, Brian Foster <bfoster@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 3, 2025 at 12:28=E2=80=AFPM Sasha Levin <sashal@kernel.org> wro=
te:
>
> From: Joanne Koong <joannelkoong@gmail.com>
>
> [ Upstream commit 7aa6bc3e8766990824f66ca76c19596ce10daf3e ]
>
> iomap_adjust_read_range() assumes that the position and length passed in
> are block-aligned. This is not always the case however, as shown in the
> syzbot generated case for erofs. This causes too many bytes to be
> skipped for uptodate blocks, which results in returning the incorrect
> position and length to read in. If all the blocks are uptodate, this
> underflows length and returns a position beyond the folio.
>
> Fix the calculation to also take into account the block offset when
> calculating how many bytes can be skipped for uptodate blocks.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> Tested-by: syzbot@syzkaller.appspotmail.com
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>
> LLM Generated explanations, may be completely bogus:
>
> Now I have all the information needed for a comprehensive analysis. Let
> me compile my findings.
>
> ---

I don't think any filesystems had repercussions from this. afaik only
inlined mappings are non-block-aligned and the underflow of length and
the overflow of position when added together offset each other when
determining how much to advance the iter for the next iteration. But I
have no objection to this being backported to stable. I think if this
gets backported, then we should also backport this one as well
(https://lore.kernel.org/linux-fsdevel/20251111193658.3495942-3-joannelkoon=
g@gmail.com/).

Thanks,
Joanne
