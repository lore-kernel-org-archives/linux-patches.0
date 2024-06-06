Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8D045034
	for <patches@lists.linux.dev>; Thu,  6 Jun 2024 19:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717702019; cv=none; b=EzA6/uDwEge8UjSOqfCXtEy3jy6oDOTXc8490bO+t94BfG7s7W3cBECHP4xJLuQmxMaH9GmpPeoqZ3ybE8cn64GwB4YPc+nAzGj/8MOt/trPVk75tpMoFPGxVXNcQdN7ts9eOW5cGNYcwBXRpDgoqPJdMgDJgSeQ1EXXkSn4tEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717702019; c=relaxed/simple;
	bh=dVuS1q5/4ti7TRNqvBw2uyr26mic85V/iOdyK4bX8eA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZoAsfgQ4pSMRff/GPGXSH6vbLM0plvh0jvNg3ONItwxAufvjO2Oatb12DBBoyiBargQflwoTvgJMsct9cA/0b0z5nR/GFtOGhL66ssMh1F9+rtceP6MzcQFU8g64jPp1rxgH05HXyXZBygwJjLHlaeJHy/70OrnBnuwd/aYWRXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RPMy7K1g; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RPMy7K1g"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-52b93370ad0so1851021e87.2
        for <patches@lists.linux.dev>; Thu, 06 Jun 2024 12:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717702015; x=1718306815; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=55/bLsMNm30oQurGMw7I3lX3MCMyuxr0ITVCYbHOYfI=;
        b=RPMy7K1gEXDSAd0RMVBonqVbybRwBSOgQM6bMwJbSHzxXdy2CDaDrcFVejIdslXQ36
         pCoIEiy/497+Ti98AoDDgKqFVD+VHTye0VtBN7iP3u3NeC9eEedWDWx8nOtNLCsAxKsI
         0xzIbISjXJQ1wtKdj0tc132g+x+NkuyysV3DkiOhmp8ngChv2hnFOMnfSboPzHaJ5/tT
         anGQpi2ea+YSqWLqEFIIA6ZTi+VxKe5Hl/eVUdqRQ4e8oLeZFot2MiwmHYpw6S5RME/B
         FI1h+DGOUpvqFwtvbXYnbyojEZNjPBrUiRW/mQ4IEXYf8hPdTGk49jRIpMzG/cSMs4zV
         9lWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717702015; x=1718306815;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=55/bLsMNm30oQurGMw7I3lX3MCMyuxr0ITVCYbHOYfI=;
        b=g7opGLZl38iCQCKVtD34sxlaQLtFNKxFR7Id9HxwzS/ttdmCZdEgboKdyhqwAetiFp
         +aFaXhC8gOv9i4TzCfTCCzfdyjPw8H3mb7DDLOP37+N+Br6lQ1DAyEo/e/w6/r6rdD2Y
         JXvyzz4LqdzVZcJFijLFmbCSgqEc1dgKd6SaGu1pWWD7RT214ZzQHnMZNUqIt9wh33JN
         yu+DqKkYzgIzuQBzn35kqKRavlsWCIIL85rPIgeSP3QnsnoWg5dKKTD2Pgwbkb3nWK2+
         f8jFzG+aqotxuvgum7Pp59HjODdJ4fcMoFsiEQjRU5N31+UepsXeOUn6vG7n8pMnwthN
         OYNg==
X-Forwarded-Encrypted: i=1; AJvYcCUQBMKKanvMfM7fHj/ViPsil7IGp/flnWDCPevztoPDHO0iWG71iBgpkmoHDo9xmBzXJsk1DLMAtHYH6Dd9rcgBdhvvKPeGTw==
X-Gm-Message-State: AOJu0YzqvkmNtDtuNDxayodt/kZ9Fv5GHPxa3T+vnWLtLA8MHqo1kYyW
	xPGI0ZWKdBKyhawXpUw1bE8xmRBJhzTOvCxRiRcdJOvZRbluAb0XQDaCJilSiqlHSmuRM0iGVBg
	y4KFZHLvbWOYvLM7s3B9oWgW4zmE=
X-Google-Smtp-Source: AGHT+IGp6KuLE4Vb2JANeb9mqZayOj5Kud47tzVKppZjuSzB0j9DE9Xr5O3L2zSryd3Wk/HmPMV95+Dbh++gTOuLJOw=
X-Received: by 2002:a05:6512:3d9e:b0:52a:f0e7:65ae with SMTP id
 2adb3069b0e04-52bb9fc5dc3mr515278e87.46.1717702015129; Thu, 06 Jun 2024
 12:26:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240606131732.440653204@linuxfoundation.org> <20240606131752.295435490@linuxfoundation.org>
In-Reply-To: <20240606131752.295435490@linuxfoundation.org>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 7 Jun 2024 04:26:38 +0900
Message-ID: <CAKFNMo=+e+tOPQ4r3ZvyO_wCoCoQw9=OErnKFwkQ9qqovDKSMg@mail.gmail.com>
Subject: Re: [PATCH 6.6 617/744] nilfs2: make superblock data array index
 computation sparse friendly
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>, kernel test robot <lkp@intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 6, 2024 at 11:22=E2=80=AFPM Greg Kroah-Hartman wrote:
>
> 6.6-stable review patch.  If anyone has any objections, please let me kno=
w.
>
> ------------------
>
> From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
>
> [ Upstream commit 91d743a9c8299de1fc1b47428d8bb4c85face00f ]
>

Hi Greg,

I have twice raised the suspicion that this patch should not be
eligible for stable backport because it is not a bugfix (it just fixes
a false positive sparse warning).  And you dropped it the first time
[1][2].

[1] https://lkml.kernel.org/r/CAKFNMo=3DkyzbvfLrTv8JhuY=3De7-fkjtpL3DvcQ1r+=
RUPPeC4S9A@mail.gmail.com
[2] https://lkml.kernel.org/r/CAKFNMontZ54JxOyK0_xy8P_SfpE0swgq9wiPUErnZ-yr=
O7wOJA@mail.gmail.com

On Tue, May 28, 2024 at 3:28=E2=80=AFAM Greg KH <greg@kroah.com> wrote:
> > This commit fixes the sparse warning output by build "make C=3D1" with
> > the sparse check, but does not fix any operational bugs.
> >
> > Therefore, if fixing a harmless sparse warning does not meet the
> > requirements for backporting to stable trees (I assume it does),
> > please drop it as it is a false positive pickup.  Sorry if the
> > "Fixes:" tag is confusing.
> >
> > The same goes for the same patch queued to other stable-trees.
>
> Now dropped, thanks!
>
> greg k-h

Perhaps due to the confusing Fixes tag, this patch appears to have
been picked up again.
Unless the criteria for its inclusion or exclusion have changed, I
think this was selected by mistake.  Please check.

Thanks,
Ryusuke Konishi


> Upon running sparse, "warning: dubious: x & !y" is output at an array
> index calculation within nilfs_load_super_block().
>
> The calculation is not wrong, but to eliminate the sparse warning, replac=
e
> it with an equivalent calculation.
>
> Also, add a comment to make it easier to understand what the unintuitive
> array index calculation is doing and whether it's correct.
>
> Link: https://lkml.kernel.org/r/20240430080019.4242-3-konishi.ryusuke@gma=
il.com
> Fixes: e339ad31f599 ("nilfs2: introduce secondary super block")
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: kernel test robot <lkp@intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/nilfs2/the_nilfs.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
> index 71400496ed365..3e3c1d32da180 100644
> --- a/fs/nilfs2/the_nilfs.c
> +++ b/fs/nilfs2/the_nilfs.c
> @@ -592,7 +592,7 @@ static int nilfs_load_super_block(struct the_nilfs *n=
ilfs,
>         struct nilfs_super_block **sbp =3D nilfs->ns_sbp;
>         struct buffer_head **sbh =3D nilfs->ns_sbh;
>         u64 sb2off, devsize =3D bdev_nr_bytes(nilfs->ns_bdev);
> -       int valid[2], swp =3D 0;
> +       int valid[2], swp =3D 0, older;
>
>         if (devsize < NILFS_SEG_MIN_BLOCKS * NILFS_MIN_BLOCK_SIZE + 4096)=
 {
>                 nilfs_err(sb, "device size too small");
> @@ -648,9 +648,25 @@ static int nilfs_load_super_block(struct the_nilfs *=
nilfs,
>         if (swp)
>                 nilfs_swap_super_block(nilfs);
>
> +       /*
> +        * Calculate the array index of the older superblock data.
> +        * If one has been dropped, set index 0 pointing to the remaining=
 one,
> +        * otherwise set index 1 pointing to the old one (including if bo=
th
> +        * are the same).
> +        *
> +        *  Divided case             valid[0]  valid[1]  swp  ->  older
> +        *  -------------------------------------------------------------
> +        *  Both SBs are invalid        0         0       N/A (Error)
> +        *  SB1 is invalid              0         1       1         0
> +        *  SB2 is invalid              1         0       0         0
> +        *  SB2 is newer                1         1       1         0
> +        *  SB2 is older or the same    1         1       0         1
> +        */
> +       older =3D valid[1] ^ swp;
> +
>         nilfs->ns_sbwcount =3D 0;
>         nilfs->ns_sbwtime =3D le64_to_cpu(sbp[0]->s_wtime);
> -       nilfs->ns_prot_seq =3D le64_to_cpu(sbp[valid[1] & !swp]->s_last_s=
eq);
> +       nilfs->ns_prot_seq =3D le64_to_cpu(sbp[older]->s_last_seq);
>         *sbpp =3D sbp[0];
>         return 0;
>  }
> --
> 2.43.0
>
>
>
