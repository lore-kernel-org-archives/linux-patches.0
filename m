Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B4C23A3
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 08:03:15 +0000 (UTC)
Received: by mail-vs1-f50.google.com with SMTP id i2so13867531vsc.1
        for <patches@lists.linux.dev>; Tue, 13 Dec 2022 00:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=c6c3ok7BNGAyoJuELxPUEc8u5M2aciuCbkFM1L7MAUo=;
        b=RCUvNnbJI+91HkoMedlvWgdf30froxuVO2Gykly/fNsH0pVdS3UepBkhX0mbnY8MYX
         T0b9099z1tqP99dZ3QpkaeKr9l8/zLkU87F83P3ZwaKAa/B/jfPPvTKRF8lRgYe003Mw
         XlBDrvmgpUYpa+qsoBc/MhEGCAgqQx9F5z++C1kAtWg0zT2vA/WyYjssaLFQB9c1py8D
         wf8KDKLTHClwfAT2+dlg5rd1eo4RQraGt4MdHZBSrCROgIJPyyn+sHSgxu4pWxDx8VmB
         1uEdas4MCSHgZ5RjCPbpflVCe0GRe32QaUhChmEOXqEQTCfVvkuopzetn2w+gVpUdGAb
         jrmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c6c3ok7BNGAyoJuELxPUEc8u5M2aciuCbkFM1L7MAUo=;
        b=5syK1lqf82UyrdqcElH5PKxLOW8pNz5+XCz89rVyNdBcVSRkP3LIKxbkZrV3b7tnkc
         Z/MMlH3RpbeQTNR/e7UgQvt9UdB7JGTQoGqwfp8zQqKIMmubgKGKp4CB6td6lCdJblpI
         yhiA4JRmMukTsFNy36iSFg+mkDb6hcUCkyUErPxd/g9pSlQ16pstS4Z90dz3+S7VztMZ
         XsMQgellVXnk29cj4jMTpCyuPDhcN0X9cdi4WME8Km9tpfU0eDg5o/0OYhW7ULRIMQ8V
         RkfEE3rDjku2kge08/LAeqRDeC7AvuEiLd1KxxydM9MxYPF9FWzlLO6GripUJB54K7bq
         w+xw==
X-Gm-Message-State: ANoB5pnBu7zpPtLS9svxTEbDqBXRFxkRLEaH+Cn5UzAjcdz1vg532ubO
	8d4xvdMHHWcuNVu8cvP10iplnF90HmHs3Q0gz1E=
X-Google-Smtp-Source: AA0mqf7JaV7ycT+tYmIfe5eJy63r67PARvNBAv1cVKe2gfEqRf2iR/bLt3sYzlWdoZgIA902+I//YJ8Y0lkX4HMBXdg=
X-Received: by 2002:a05:6102:c8c:b0:3b0:9171:95f7 with SMTP id
 f12-20020a0561020c8c00b003b0917195f7mr32639878vst.3.1670918594043; Tue, 13
 Dec 2022 00:03:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221205190808.422385173@linuxfoundation.org> <20221205190809.690922836@linuxfoundation.org>
In-Reply-To: <20221205190809.690922836@linuxfoundation.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 13 Dec 2022 10:03:02 +0200
Message-ID: <CAOQ4uxhmZ4RnG0mGaMivyQjS43cUykyO-oVtCLX4AFyrnTXrVA@mail.gmail.com>
Subject: Re: [PATCH 6.0 044/124] vfs: fix copy_file_range() averts filesystem
 freeze protection
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Namjae Jeon <linkinjeon@kernel.org>, Luis Henriques <lhenriques@suse.de>, 
	Al Viro <viro@zeniv.linux.org.uk>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 5, 2022 at 9:24 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Amir Goldstein <amir73il@gmail.com>
>
> [ Upstream commit 10bc8e4af65946b727728d7479c028742321b60a ]
>
> Commit 868f9f2f8e00 ("vfs: fix copy_file_range() regression in cross-fs
> copies") removed fallback to generic_copy_file_range() for cross-fs
> cases inside vfs_copy_file_range().

Hi Greg,

The regressing commit is in v5.15.53.
Please apply this fix to 5.15.y.

I will test and post backports of cross-fs copy_file_range() fixes
to pre 5.15 kernels.
See: https://bugzilla.kernel.org/show_bug.cgi?id=216800

Thanks,
Amir.

>
> To preserve behavior of nfsd and ksmbd server-side-copy, the fallback to
> generic_copy_file_range() was added in nfsd and ksmbd code, but that
> call is missing sb_start_write(), fsnotify hooks and more.
>
> Ideally, nfsd and ksmbd would pass a flag to vfs_copy_file_range() that
> will take care of the fallback, but that code would be subtle and we got
> vfs_copy_file_range() logic wrong too many times already.
>
> Instead, add a flag to explicitly request vfs_copy_file_range() to
> perform only generic_copy_file_range() and let nfsd and ksmbd use this
> flag only in the fallback path.
>
> This choise keeps the logic changes to minimum in the non-nfsd/ksmbd code
> paths to reduce the risk of further regressions.
>
> Fixes: 868f9f2f8e00 ("vfs: fix copy_file_range() regression in cross-fs copies")
> Tested-by: Namjae Jeon <linkinjeon@kernel.org>
> Tested-by: Luis Henriques <lhenriques@suse.de>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/ksmbd/vfs.c     |  6 +++---
>  fs/nfsd/vfs.c      |  4 ++--
>  fs/read_write.c    | 19 +++++++++++++++----
>  include/linux/fs.h |  8 ++++++++
>  4 files changed, 28 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
> index 78d01033604c..c5c801e38b63 100644
> --- a/fs/ksmbd/vfs.c
> +++ b/fs/ksmbd/vfs.c
> @@ -1784,9 +1784,9 @@ int ksmbd_vfs_copy_file_ranges(struct ksmbd_work *work,
>                 ret = vfs_copy_file_range(src_fp->filp, src_off,
>                                           dst_fp->filp, dst_off, len, 0);
>                 if (ret == -EOPNOTSUPP || ret == -EXDEV)
> -                       ret = generic_copy_file_range(src_fp->filp, src_off,
> -                                                     dst_fp->filp, dst_off,
> -                                                     len, 0);
> +                       ret = vfs_copy_file_range(src_fp->filp, src_off,
> +                                                 dst_fp->filp, dst_off, len,
> +                                                 COPY_FILE_SPLICE);
>                 if (ret < 0)
>                         return ret;
>
> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index f3cd614e1f1e..dc24d67d0ca4 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -572,8 +572,8 @@ ssize_t nfsd_copy_file_range(struct file *src, u64 src_pos, struct file *dst,
>         ret = vfs_copy_file_range(src, src_pos, dst, dst_pos, count, 0);
>
>         if (ret == -EOPNOTSUPP || ret == -EXDEV)
> -               ret = generic_copy_file_range(src, src_pos, dst, dst_pos,
> -                                             count, 0);
> +               ret = vfs_copy_file_range(src, src_pos, dst, dst_pos, count,
> +                                         COPY_FILE_SPLICE);
>         return ret;
>  }
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 328ce8cf9a85..24b9668d6377 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1388,6 +1388,8 @@ ssize_t generic_copy_file_range(struct file *file_in, loff_t pos_in,
>                                 struct file *file_out, loff_t pos_out,
>                                 size_t len, unsigned int flags)
>  {
> +       lockdep_assert(sb_write_started(file_inode(file_out)->i_sb));
> +
>         return do_splice_direct(file_in, &pos_in, file_out, &pos_out,
>                                 len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
>  }
> @@ -1424,7 +1426,9 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
>          * and several different sets of file_operations, but they all end up
>          * using the same ->copy_file_range() function pointer.
>          */
> -       if (file_out->f_op->copy_file_range) {
> +       if (flags & COPY_FILE_SPLICE) {
> +               /* cross sb splice is allowed */
> +       } else if (file_out->f_op->copy_file_range) {
>                 if (file_in->f_op->copy_file_range !=
>                     file_out->f_op->copy_file_range)
>                         return -EXDEV;
> @@ -1474,8 +1478,9 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>                             size_t len, unsigned int flags)
>  {
>         ssize_t ret;
> +       bool splice = flags & COPY_FILE_SPLICE;
>
> -       if (flags != 0)
> +       if (flags & ~COPY_FILE_SPLICE)
>                 return -EINVAL;
>
>         ret = generic_copy_file_checks(file_in, pos_in, file_out, pos_out, &len,
> @@ -1501,14 +1506,14 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>          * same sb using clone, but for filesystems where both clone and copy
>          * are supported (e.g. nfs,cifs), we only call the copy method.
>          */
> -       if (file_out->f_op->copy_file_range) {
> +       if (!splice && file_out->f_op->copy_file_range) {
>                 ret = file_out->f_op->copy_file_range(file_in, pos_in,
>                                                       file_out, pos_out,
>                                                       len, flags);
>                 goto done;
>         }
>
> -       if (file_in->f_op->remap_file_range &&
> +       if (!splice && file_in->f_op->remap_file_range &&
>             file_inode(file_in)->i_sb == file_inode(file_out)->i_sb) {
>                 ret = file_in->f_op->remap_file_range(file_in, pos_in,
>                                 file_out, pos_out,
> @@ -1528,6 +1533,8 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>          * consistent story about which filesystems support copy_file_range()
>          * and which filesystems do not, that will allow userspace tools to
>          * make consistent desicions w.r.t using copy_file_range().
> +        *
> +        * We also get here if caller (e.g. nfsd) requested COPY_FILE_SPLICE.
>          */
>         ret = generic_copy_file_range(file_in, pos_in, file_out, pos_out, len,
>                                       flags);
> @@ -1582,6 +1589,10 @@ SYSCALL_DEFINE6(copy_file_range, int, fd_in, loff_t __user *, off_in,
>                 pos_out = f_out.file->f_pos;
>         }
>
> +       ret = -EINVAL;
> +       if (flags != 0)
> +               goto out;
> +
>         ret = vfs_copy_file_range(f_in.file, pos_in, f_out.file, pos_out, len,
>                                   flags);
>         if (ret > 0) {
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 7203f5582fd4..be074b6895b9 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2087,6 +2087,14 @@ struct dir_context {
>   */
>  #define REMAP_FILE_ADVISORY            (REMAP_FILE_CAN_SHORTEN)
>
> +/*
> + * These flags control the behavior of vfs_copy_file_range().
> + * They are not available to the user via syscall.
> + *
> + * COPY_FILE_SPLICE: call splice direct instead of fs clone/copy ops
> + */
> +#define COPY_FILE_SPLICE               (1 << 0)
> +
>  struct iov_iter;
>  struct io_uring_cmd;
>
> --
> 2.35.1
>
>
>
