Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23547198E6E
	for <patches@lists.linux.dev>; Thu,  6 Jun 2024 14:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717684504; cv=none; b=ttOyXP9lQDw18DvttgtzkOTxE2nqd/lUvDVGzxoKoYsSWWsnINmeROnbrWJO6jVDal1sZuSh8SnTndLyKjIaVjB4DeUeWJYpUguGbNncx1oAoMMUhXulHh8Lkktu/U8vxCi9ZwwNt8aMlHD88VMckx6zbZMp1RQlnVdvg6oZ/Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717684504; c=relaxed/simple;
	bh=h9ZaPrAmxAPQehpDzjStkeIg6YJXxVarWCaYU2WS9kQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VK6Dvdx9XWLGKywPh54WtIFXlnGa89UV/qeAD93/uesoaRJPCOTWb5Txq6ADF725R/hYHvbcQ61Nu8Z4I61ELNdYYSd1M4UU7b8fi7fUSt+lSYy4hjEHloBE+YVSIBjRRCZX3Mz7CgO9EzhPAfv9Qw8EH/4/Qbnp24Wy0vb3NJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PjM4tU27; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PjM4tU27"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-795174a500aso43361985a.3
        for <patches@lists.linux.dev>; Thu, 06 Jun 2024 07:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717684502; x=1718289302; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fk/yBrg3lB0eIyTR1z2aQPbvwHEOsAf8ISJq44rsaRI=;
        b=PjM4tU27xOy1sBva8TPjFwUOqC/INdO0E6rrE7xKKGphCB5vHaRab7N/rQHd4tA8x4
         1iCwbPS+q8fgMVAUZ2DlX115y3js/CrVDz58e1Jpjkr0TNSRQXDzKNNRdkSM908Yv17j
         +nXMalk7PgVBzBgYSZLLsz33UzC28ZKfGRobbbjd9ArNdt8QxMn0C+ecpmUZfiC8CrSo
         9w96bdYgCc2ZSvLxcxfWy3p9eJfB+exhAsPxtLBM+3i80DCJBFfNmxYGGt1hNVbDES4g
         7BbqVKCzZCKofwI+hznOhMvAGTLkWQLJvA4AMEaXSGfA9BVen2c8bvLsbybk31JKAw0A
         57wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717684502; x=1718289302;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fk/yBrg3lB0eIyTR1z2aQPbvwHEOsAf8ISJq44rsaRI=;
        b=V3RKWlE2pIE3COz/iKZS2LYjJ+LGvwzMsU80s7u5M2xa6yGVfR68j5e32DxpvOagoc
         IPi4HoUjQtLX4uZ9wfQlvHn/KfbCbrLFTfDgbCBsOM+g1k0lkHjtgdUit390GE+PNL+h
         d8iMchNMn6rI1pCDVIndqNFI9WkNlNUd1aoOBjntMCJUADEgiSivV0iodJWUENoPw/39
         ZXwkJHzkVTgRbeamlgTxTNAknzqKrjD1yuUFr/5zYRi7E3abG9sG0Dv6MvSsFutcA3j0
         yiXLshNX8XccUs66q8PQHoBVTpiCH/0LtL8i233Ap9n3HcBisHgiNiHrNUMM02XRdMFP
         D1tA==
X-Forwarded-Encrypted: i=1; AJvYcCX84OJ4fvffMqFDVVztqDg0swc9S0rNJs/Xht7YOWkr0dKPZhRsmpL6liS13MA0aI5A5cTo966SEIsBminl5o6Yordoz54yRQ==
X-Gm-Message-State: AOJu0YytE5l4R3wUsvySZvxVtAdb6LiQB3p4trZ6UYupdaDH6PHH+fvW
	LvSKjHBw5nIzhux8w5BLuXev2hGknB89wkZZsiWbixK8Gul1nG+7Ru2ymMUoFlTSOfqGIlo1r3u
	AaTR0xyzJXGzdGkx6/2XadE6uW5c=
X-Google-Smtp-Source: AGHT+IGialW1cgUFYrkwgo6znlv+dlJDrhpohenFUSsh7AtWMA1/F9Ae5x0lyonf7iHbyWTdszun78wPTkmnnYgf2WU=
X-Received: by 2002:a05:620a:2005:b0:792:c683:1f48 with SMTP id
 af79cd13be357-79523d4f6bamr611477785a.36.1717684501908; Thu, 06 Jun 2024
 07:35:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240606131732.440653204@linuxfoundation.org> <20240606131746.600659628@linuxfoundation.org>
In-Reply-To: <20240606131746.600659628@linuxfoundation.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 6 Jun 2024 17:34:50 +0300
Message-ID: <CAOQ4uxifOH00rFOgOb50-XySScixowqa3YfrFLDDcsdfmtEMCQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 440/744] fs: move kiocb_start_write() into vfs_iocb_iter_write()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Jan Kara <jack@suse.cz>, 
	Josef Bacik <josef@toxicpanda.com>, Christian Brauner <brauner@kernel.org>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 6, 2024 at 5:18=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.6-stable review patch.  If anyone has any objections, please let me kno=
w.
>

I have objections and I wrote them when Sasha posted the patch for review:

https://lore.kernel.org/stable/CAOQ4uxg1Ce31UDDeb9ADYgEBvr582j4hqmJ-B72iAL+=
2xsAYzw@mail.gmail.com/

Where did this objection get lost?

Thanks,
Amir.

> ------------------
>
> From: Amir Goldstein <amir73il@gmail.com>
>
> [ Upstream commit 6ae654392bb516a0baa47fed1f085d84e8cad739 ]
>
> In vfs code, sb_start_write() is usually called after the permission hook
> in rw_verify_area().  vfs_iocb_iter_write() is an exception to this rule,
> where kiocb_start_write() is called by its callers.
>
> Move kiocb_start_write() from the callers into vfs_iocb_iter_write()
> after the rw_verify_area() checks, to make them "start-write-safe".
>
> The semantics of vfs_iocb_iter_write() is changed, so that the caller is
> responsible for calling kiocb_end_write() on completion only if async
> iocb was queued.  The completion handlers of both callers were adapted
> to this semantic change.
>
> This is needed for fanotify "pre content" events.
>
> Suggested-by: Jan Kara <jack@suse.cz>
> Suggested-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Link: https://lore.kernel.org/r/20231122122715.2561213-14-amir73il@gmail.=
com
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> Stable-dep-of: 7c98f7cb8fda ("remove call_{read,write}_iter() functions")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/cachefiles/io.c  | 5 ++---
>  fs/overlayfs/file.c | 8 ++++----
>  fs/read_write.c     | 7 +++++++
>  3 files changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/fs/cachefiles/io.c b/fs/cachefiles/io.c
> index 009d23cd435b5..5857241c59181 100644
> --- a/fs/cachefiles/io.c
> +++ b/fs/cachefiles/io.c
> @@ -259,7 +259,8 @@ static void cachefiles_write_complete(struct kiocb *i=
ocb, long ret)
>
>         _enter("%ld", ret);
>
> -       kiocb_end_write(iocb);
> +       if (ki->was_async)
> +               kiocb_end_write(iocb);
>
>         if (ret < 0)
>                 trace_cachefiles_io_error(object, inode, ret,
> @@ -319,8 +320,6 @@ int __cachefiles_write(struct cachefiles_object *obje=
ct,
>                 ki->iocb.ki_complete =3D cachefiles_write_complete;
>         atomic_long_add(ki->b_writing, &cache->b_writing);
>
> -       kiocb_start_write(&ki->iocb);
> -
>         get_file(ki->iocb.ki_filp);
>         cachefiles_grab_object(object, cachefiles_obj_get_ioreq);
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 9fd88579bfbfb..a1c64c2b8e204 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -295,10 +295,8 @@ static void ovl_aio_cleanup_handler(struct ovl_aio_r=
eq *aio_req)
>         struct kiocb *iocb =3D &aio_req->iocb;
>         struct kiocb *orig_iocb =3D aio_req->orig_iocb;
>
> -       if (iocb->ki_flags & IOCB_WRITE) {
> -               kiocb_end_write(iocb);
> +       if (iocb->ki_flags & IOCB_WRITE)
>                 ovl_file_modified(orig_iocb->ki_filp);
> -       }
>
>         orig_iocb->ki_pos =3D iocb->ki_pos;
>         ovl_aio_put(aio_req);
> @@ -310,6 +308,9 @@ static void ovl_aio_rw_complete(struct kiocb *iocb, l=
ong res)
>                                                    struct ovl_aio_req, io=
cb);
>         struct kiocb *orig_iocb =3D aio_req->orig_iocb;
>
> +       if (iocb->ki_flags & IOCB_WRITE)
> +               kiocb_end_write(iocb);
> +
>         ovl_aio_cleanup_handler(aio_req);
>         orig_iocb->ki_complete(orig_iocb, res);
>  }
> @@ -421,7 +422,6 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, str=
uct iov_iter *iter)
>                 aio_req->iocb.ki_flags =3D ifl;
>                 aio_req->iocb.ki_complete =3D ovl_aio_rw_complete;
>                 refcount_set(&aio_req->ref, 2);
> -               kiocb_start_write(&aio_req->iocb);
>                 ret =3D vfs_iocb_iter_write(real.file, &aio_req->iocb, it=
er);
>                 ovl_aio_put(aio_req);
>                 if (ret !=3D -EIOCBQUEUED)
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 4771701c896ba..9a56949f3b8d1 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -865,6 +865,10 @@ static ssize_t do_iter_write(struct file *file, stru=
ct iov_iter *iter,
>         return ret;
>  }
>
> +/*
> + * Caller is responsible for calling kiocb_end_write() on completion
> + * if async iocb was queued.
> + */
>  ssize_t vfs_iocb_iter_write(struct file *file, struct kiocb *iocb,
>                             struct iov_iter *iter)
>  {
> @@ -885,7 +889,10 @@ ssize_t vfs_iocb_iter_write(struct file *file, struc=
t kiocb *iocb,
>         if (ret < 0)
>                 return ret;
>
> +       kiocb_start_write(iocb);
>         ret =3D call_write_iter(file, iocb, iter);
> +       if (ret !=3D -EIOCBQUEUED)
> +               kiocb_end_write(iocb);
>         if (ret > 0)
>                 fsnotify_modify(file);
>
> --
> 2.43.0
>
>
>
