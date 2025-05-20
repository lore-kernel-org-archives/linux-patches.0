Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDE7254845
	for <patches@lists.linux.dev>; Tue, 20 May 2025 00:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747700381; cv=none; b=Z9rw1zGgGJzK0rZnY8TPrqFGoYndMbyga8tciup8B2+NotGP1F85tz9b3y1qb5OzVQM3/zQkSpz43r74dxOAlgzRugHF4QeIyO7b3dKNJyOXam9CnNUSjxaYzpK4eH7sDN1b5ncM7J1k1sJzHeK36die4ClvZGJJtc5QjesSAaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747700381; c=relaxed/simple;
	bh=belPEUsapN25iOuGeQPjjn6j/5b2scul4VtAIDngE3I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TYjSkV3Jb3/6XZcvP55S6go71UR178dUC9gvc5OVYTNdw0Tf03i98BS5Pt7/xja2aUZ+Y4qxC3d/Tc1Vat6WZqt9m2zs9FnjWMNgHiUO9rNztPi9N/sFmf51FN81yHbKYL6WUOrDZcoUSIroB92DEWgN0adPbm35+6xSIaYBx0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linuxtx.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=bS6HkpiW; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="bS6HkpiW"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3d80bbf3aefso11386955ab.1
        for <patches@lists.linux.dev>; Mon, 19 May 2025 17:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1747700377; x=1748305177; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pgpucrCznlYo2tETUeAGdqWOxY183+jT5ofeOG3vpwg=;
        b=bS6HkpiWrfmMV4hFOceNgLQmmVA+yB40Aj65E5C4ax+/80y8zTJy88cJ5zzaPvsGjl
         FYXhsLYWFZjBNkrbiomHa6KMHdoAE+1PMushHUi2vLidNXRSg7pYYno4pNWYeN8YG+Mo
         51iPhM87xuJgSYo7KJh+VjQhFdoBB3a3PHz+A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747700377; x=1748305177;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pgpucrCznlYo2tETUeAGdqWOxY183+jT5ofeOG3vpwg=;
        b=V6NvVFCFUT2QC4X5FqryYP15DrJrpE/zOL24k2b0iidReRRRW8YPsL+ddfLe76NxZr
         0g5OU9YseXi7cUleRvuaVS79KU5qN3ewFY3tvxQCzEWzIW2zOKFoUdH4MvDSELsbOc6c
         UYzyPeD3fnnv6D13ad3hO4tB+VtyV3irEuOaS1G50EtMakyjBf4GWppUaR+I9N5GNB6w
         IDOgcEUPtRu+612nfj44MyL5OCcAlpjRy9MZGFW5zLmCnjofkmJdcLRekaZmyHzZJoti
         D0jfssqV6ubGsFXLgq/DXRWme03u6/OX5qZ7z8KU/3MbPz48+S1iDTrcJj2pV2tKFTo4
         4C8A==
X-Forwarded-Encrypted: i=1; AJvYcCXk6XZOCx+AKg8vGpWyitVLe+8EYqt6oI9glbBxnsvJGCOon8DYELAbeWdzo24zdRz6OYV/NwwK@lists.linux.dev
X-Gm-Message-State: AOJu0Yyriahd8I25XiglAfBJMPPXf1+gMjdN+AzUsxaK+TpGxyfCNDHA
	qwjLEk+OsaLmiK6l+fEjR4z9ER4NX5K8GenIH1mX/8MJQrx7Cjbymg63+NCLsxwg+OJfXHha/EE
	nN46io0nzfuni5Ksm7Au2KNrXklKWRMpoPWwp1vwU
X-Gm-Gg: ASbGncuCXc9F9S7wuamaFbguD4+iqq0o3ZUcxFnYo4bwWNcV0adok6/m0MpRZbzB0U9
	ss6n1GdP5fFzE+KIRA5awagwj+/OASvVN9zG0veiIK4DcXST9tuPyu0Mxn3hbMJYUmrhbMg0qzc
	AAZRGTgd8GNb+EcMTYyzEvLbtrGg4WGkw=
X-Google-Smtp-Source: AGHT+IHRjyvh72/+rxY5m65O5F9xKeCVC+PVBi5dxaOltw8gZBkjSmgbOOnICfVNFOXL4flqaNTHun2ihSNOL+Chwts=
X-Received: by 2002:a05:6e02:a:b0:3db:6cc1:36f9 with SMTP id
 e9e14a558f8ab-3db842ec6b8mr183077255ab.8.1747700376902; Mon, 19 May 2025
 17:19:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250512172044.326436266@linuxfoundation.org> <20250512172050.980575013@linuxfoundation.org>
In-Reply-To: <20250512172050.980575013@linuxfoundation.org>
From: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 19 May 2025 18:19:26 -0600
X-Gm-Features: AX0GCFtig-XrQhwkDivLDGH5fqpb7b2HNo1DDX6Sn1rPgLk1vIGe4bFyrdfmYvA
Message-ID: <CAFxkdAq+5ur__TPi6ZW9uoOBv037hgn1d_9906cBeXWE=X3Sgw@mail.gmail.com>
Subject: Re: [PATCH 6.14 162/197] loop: Add sanity check for read/write_iter
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	syzbot+6af973a3b8dfd2faefdc@syzkaller.appspotmail.com, 
	Lizhi Xu <lizhi.xu@windriver.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2025 at 11:51=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.14-stable review patch.  If anyone has any objections, please let me kn=
ow.
>
> ------------------
>
> From: Lizhi Xu <lizhi.xu@windriver.com>
>
> [ Upstream commit f5c84eff634ba003326aa034c414e2a9dcb7c6a7 ]
>
> Some file systems do not support read_iter/write_iter, such as selinuxfs
> in this issue.
> So before calling them, first confirm that the interface is supported and
> then call it.
>
> It is releavant in that vfs_iter_read/write have the check, and removal
> of their used caused szybot to be able to hit this issue.
>
> Fixes: f2fed441c69b ("loop: stop using vfs_iter__{read,write} for buffere=
d I/O")
> Reported-by: syzbot+6af973a3b8dfd2faefdc@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D6af973a3b8dfd2faefdc
> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Link: https://lore.kernel.org/r/20250428143626.3318717-1-lizhi.xu@windriv=
er.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/block/loop.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)

We have had an issue failing to set up loop devices with CI and Linus'
tree since rc6, and once this patch hit stable it proved to be the
culprit.  If I revert this patch, things work as they should. The
problem we are seeing is "

More information can be found in:
https://github.com/coreos/fedora-coreos-tracker/issues/1948
and
https://openqa.fedoraproject.org/tests/3438220#step/_boot_to_anaconda/5

Justin

> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 61ce7ccde3445..b378d2aa49f06 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -504,6 +504,17 @@ static void loop_assign_backing_file(struct loop_dev=
ice *lo, struct file *file)
>                         lo->old_gfp_mask & ~(__GFP_IO | __GFP_FS));
>  }
>
> +static int loop_check_backing_file(struct file *file)
> +{
> +       if (!file->f_op->read_iter)
> +               return -EINVAL;
> +
> +       if ((file->f_mode & FMODE_WRITE) && !file->f_op->write_iter)
> +               return -EINVAL;
> +
> +       return 0;
> +}
> +
>  /*
>   * loop_change_fd switched the backing store of a loopback device to
>   * a new file. This is useful for operating system installers to free up
> @@ -525,6 +536,10 @@ static int loop_change_fd(struct loop_device *lo, st=
ruct block_device *bdev,
>         if (!file)
>                 return -EBADF;
>
> +       error =3D loop_check_backing_file(file);
> +       if (error)
> +               return error;
> +
>         /* suppress uevents while reconfiguring the device */
>         dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 1);
>
> @@ -956,6 +971,14 @@ static int loop_configure(struct loop_device *lo, bl=
k_mode_t mode,
>
>         if (!file)
>                 return -EBADF;
> +
> +       if ((mode & BLK_OPEN_WRITE) && !file->f_op->write_iter)
> +               return -EINVAL;
> +
> +       error =3D loop_check_backing_file(file);
> +       if (error)
> +               return error;
> +
>         is_loop =3D is_loop_device(file);
>
>         /* This is safe, since we have a reference from open(). */
> --
> 2.39.5
>
>
>
>
