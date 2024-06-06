Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F2B196C6F
	for <patches@lists.linux.dev>; Thu,  6 Jun 2024 14:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717684411; cv=none; b=e5mMxHo3BPDgMJGaCNaeUreVDA9/IMWJVDE4V3wtavFd9qc+JILSbAUFB8WDhgdzyT4dSK0IK+Lt2EmrRJw3XWrdjOGy2+qwYCeoPneDKAvucl/wRnVXAQupwdX6UQIlPxTfBg5rCb9tlxHgGO6YkKhckg6dD5pxPwGOZl7vT/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717684411; c=relaxed/simple;
	bh=z2aMNW6speFYWYGfqOFRjJMnJn+QHJ2ChisVkcPa20s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iCbOiQfMUTIslLZDzPN5UNzeHQ7IcT6PEpBY73NdMxPJmNWJcyzaova6k9K8s6WrTlohaT136Z7Tc8hbwTsqjH4ayOA+jKrxjHDaHTn7yKwl1xn0rLk9/nihGYzY7cKAnS429CiZnLOx42idzclcHCJpcgAOUn7fq/Zca5VN9BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S7inbVVl; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S7inbVVl"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-795004bd75dso60323685a.2
        for <patches@lists.linux.dev>; Thu, 06 Jun 2024 07:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717684409; x=1718289209; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aXy9ZshJzoipG0WEEKUipDjKLkHhQIDQe2ob1zDmxHs=;
        b=S7inbVVls3bPO+E1dPza/X804DSGBXnlI73i2eMEHtA0qO4lCqP+5aYfY0nZwJ9DxE
         kNdSJGHcrmjfRpAElAD0m0RbZcFYediWygLQhZG1eyo1HwJkBIhCWiBCU6tPHfCcveTs
         MhE+82gvG4OJWKeYEjoPVmF51g7KbRTjyo18H82h41VjEJrOZongayHprMatuwD1qGO0
         ZDJKdLPNliD4nBDax/nR2u8io+BFGMSpGX83e4g+ouVU7owBs+dpbeXPqazxoqsYUUqz
         nmDMREH4AA8D9Y0G6hoO1MjndOzIOO3dAJBdekfUEm5zQ5SfQBry13JZZopnvkMBEJMk
         ZxZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717684409; x=1718289209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aXy9ZshJzoipG0WEEKUipDjKLkHhQIDQe2ob1zDmxHs=;
        b=dStRxGBRi9ppO7RQJock04bwgkXMDpnhJFoYjxs+BSLdUOfWyoe92oFyWW8hu8F1L9
         oP8Wtlqvbo4m+HtyTTY+oG7KJJr4maULop3kW0qdQW4Z6KSeVvwhAM6ZIXK7wzRcHJ/F
         jwVuMYon4NlF7FO8mpdjrvepr4jHlYUNsSksi0eMPGrQawL50oalM9BC1YE2tY/IWUx8
         97CuTSx2cfEg/v3z7RkksZbYyQdsDsEHr1bRVQFp7CKjTqhth8e0xDWRhd9DfJc9W3H2
         hlfkHG3LCioElhECNoqvvsgvf/Jx4yATXrzXjXgSFtMBcTqUKy/BHHXMhJ4ggef2Lo7C
         thEw==
X-Forwarded-Encrypted: i=1; AJvYcCUkYSpg3kW4uIs8Cm1dCtnMMMnuPdOajD8ZgmB7SzlX/KU5Bay4EpP+bYqvNz8GaDEca0wOXB3qZp6XBpERpILAPnEy9vLmgQ==
X-Gm-Message-State: AOJu0YxP5ncrbQ/sADOs8Bo0JImOfai/OK4QH1AHCPEqWqpqTKm/SgOb
	NJbUWV68PqB+Pqs7uk+gX5x/rNd40twpbu6O2q/1XoASOJuAdEzw/2ZijyGbp3vP6lezAPGf8C+
	ffZvpo/WiNV9NoX/niH4nd5VI/jM=
X-Google-Smtp-Source: AGHT+IFpV6/Vq+Jfe7DcjTtDFqCk4rpIxn8W10iRhdrmMEwY5BNQvOW6XzuVu7GZ3yutgR0wa9qPxyecGxcsX9KAaBY=
X-Received: by 2002:ae9:f80f:0:b0:792:a92a:2c6 with SMTP id
 af79cd13be357-79523d4abf3mr543437685a.17.1717684408995; Thu, 06 Jun 2024
 07:33:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240606131732.440653204@linuxfoundation.org> <20240606131746.563882173@linuxfoundation.org>
In-Reply-To: <20240606131746.563882173@linuxfoundation.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 6 Jun 2024 17:33:17 +0300
Message-ID: <CAOQ4uxhL59Sz4akfk-DGQXYTRwLu4B1gPUgKOy0J_RehdzkVTg@mail.gmail.com>
Subject: Re: [PATCH 6.6 439/744] splice: remove permission hook from iter_file_splice_write()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Jan Kara <jack@suse.cz>, 
	Josef Bacik <josef@toxicpanda.com>, Christian Brauner <brauner@kernel.org>, 
	Sasha Levin <sashal@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 6, 2024 at 5:18=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.6-stable review patch.  If anyone has any objections, please let me kno=
w.

I have objections and I wrote them when Sasha posted the patch for review:

https://lore.kernel.org/stable/CAOQ4uxgx7Qe=3D+Nn7LhPWAzFK3n=3DqsFC8U++U5XB=
aLUiTA+EqLw@mail.gmail.com/

Where did this objection get lost?

Thanks,
Amir.

>
> ------------------
>
> From: Amir Goldstein <amir73il@gmail.com>
>
> [ Upstream commit d53471ba6f7ae97a4e223539029528108b705af1 ]
>
> All the callers of ->splice_write(), (e.g. do_splice_direct() and
> do_splice()) already check rw_verify_area() for the entire range
> and perform all the other checks that are in vfs_write_iter().
>
> Instead of creating another tiny helper for special caller, just
> open-code it.
>
> This is needed for fanotify "pre content" events.
>
> Suggested-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Link: https://lore.kernel.org/r/20231122122715.2561213-6-amir73il@gmail.c=
om
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> Stable-dep-of: 7c98f7cb8fda ("remove call_{read,write}_iter() functions")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/splice.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/fs/splice.c b/fs/splice.c
> index d983d375ff113..a8f97c5e8cf0e 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -673,10 +673,13 @@ iter_file_splice_write(struct pipe_inode_info *pipe=
, struct file *out,
>                 .u.file =3D out,
>         };
>         int nbufs =3D pipe->max_usage;
> -       struct bio_vec *array =3D kcalloc(nbufs, sizeof(struct bio_vec),
> -                                       GFP_KERNEL);
> +       struct bio_vec *array;
>         ssize_t ret;
>
> +       if (!out->f_op->write_iter)
> +               return -EINVAL;
> +
> +       array =3D kcalloc(nbufs, sizeof(struct bio_vec), GFP_KERNEL);
>         if (unlikely(!array))
>                 return -ENOMEM;
>
> @@ -684,6 +687,7 @@ iter_file_splice_write(struct pipe_inode_info *pipe, =
struct file *out,
>
>         splice_from_pipe_begin(&sd);
>         while (sd.total_len) {
> +               struct kiocb kiocb;
>                 struct iov_iter from;
>                 unsigned int head, tail, mask;
>                 size_t left;
> @@ -733,7 +737,10 @@ iter_file_splice_write(struct pipe_inode_info *pipe,=
 struct file *out,
>                 }
>
>                 iov_iter_bvec(&from, ITER_SOURCE, array, n, sd.total_len =
- left);
> -               ret =3D vfs_iter_write(out, &from, &sd.pos, 0);
> +               init_sync_kiocb(&kiocb, out);
> +               kiocb.ki_pos =3D sd.pos;
> +               ret =3D call_write_iter(out, &kiocb, &from);
> +               sd.pos =3D kiocb.ki_pos;
>                 if (ret <=3D 0)
>                         break;
>
> --
> 2.43.0
>
>
>
