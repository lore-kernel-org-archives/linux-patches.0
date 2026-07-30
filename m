Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF8D3AB5B2
	for <patches@lists.linux.dev>; Thu, 30 Jul 2026 17:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785433311; cv=pass; b=IyjGsrwMEX+q9pQGc76+6mq8DDJN5YaTYrch6r4RDGjURHQbxm/HkP1MMi4mp/juTBO9QfcJPk7qdgmSUwkjs13fn1n2Otydc9rl0CatO/ZAwn7sO6OmH51v/1rOd/Ed57PAtMg3yR8/ul0qeLZPp+UUekK+YynSe97w93YQlQU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785433311; c=relaxed/simple;
	bh=38Rgp+sQ19WuXaGsYOlOkyRAeVrqXuzbNNqpV6hl1Qs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AF7ERZ3E36CRHGYb+kbb1nrUU4T33AlMvBtvEFmHvzh+MYMA1BqIhrV8byq5Tq6jNH5My0NrWBt6B5ncFR3Gkpm7SYx6LIBQS8ZdHrSZMHe/3cOCFDgZO6wccze7cSoFA1EsDkrbHN8A/ebUqimohUzmWvDyYIYJkFfFwEcurVg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fr+NEw8U; arc=pass smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fr+NEw8U"
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-74ae4c75b20so642247137.1
        for <patches@lists.linux.dev>; Thu, 30 Jul 2026 10:41:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785433309; cv=none;
        d=google.com; s=arc-20260327;
        b=E9lOL4FMEC02riTvv2DP22vLw4aJTUb7rM0KUhYiDBAGkNMVtfqQK/yeAgeihCgX3p
         pglp8xH8Xw5rK8MbFdajPcC7qnVyMCXK10CxhSJL7gANlQzYHHXuXELWFUBK9ezFjWqJ
         DbSgZLI4OayCZyAxzanvhUldsTdEchq9jfSu+78qAyoWqiMUQk/kvILIUwftC2rDStMg
         W0FiSinLqSVIuWuTno6tYOu67UiA0pggHaVwFf9AoDrinOeW2C59v6Pvjn83JCpWQaTY
         O0gfFMSgbFfMlKV9aToP0jtVBaB1gNeOw3O3bx1R3uNDU+RMa9vEaFy1H+nYqZq+rfeb
         UXFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V4Kqw/TkLVkzGuwHe/UF+DyDxAHM6IdVuvV/MKWb3Xk=;
        fh=d5C+5Vb9CZTckpadHGm3ipm8qNXNoCDc4U5FBMLXlg0=;
        b=Av7JNQbwdLsla/FviXVV5Q3WYqTNFfRsWDpu5w7wo0p3O8J/Q03rgQSP/6xouVoeA7
         JQag7boX2DwxX7Jr2XAOqS+FPOdC+9Vm7pf/rQiuyhHfG1OQIHXvFidR6nHWpgH/TDeD
         eSZ8X9BIr6rO03v+aZUL5yZvEqLM1lvrplxA6PHy8aFqRlJmYbcWqCxJhu2DeR3+BDOf
         yFfCUTIIC3vMQl5V8lw+92D70vDgtDMOxPpC3HyRcn0ED7+AYzxUmRlnbj33XF3zylu0
         5F2fgD+mhCTsYOtGuB5nf+OLofAy02DlxuCezh9p7pdpkDneYjt7QtGmscfOcqY86Is1
         QybA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785433309; x=1786038109; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=V4Kqw/TkLVkzGuwHe/UF+DyDxAHM6IdVuvV/MKWb3Xk=;
        b=Fr+NEw8Urn6e/R6C4PhfDayePv/GTt7EOxMe3BJtM60NkHSchTwiueq5frpmpj0YYX
         gl5AFk7uXF0a6NkoBU521vkL0K35xpGzFcm2id/9aywtS8Diq0797DmvFuAa0VT2U8dZ
         kfzJukHs+APddpR0QFT6/tnzGhmABugrq2q5wk9PnTWP+5osjDoMBHonNBUIb2KdoLVv
         HPR0L/jXFh6FFISG0D8IsleiIka0erS6zkZbC+qK8RP43ATNSAkkgmcZA7q0bdg17QwO
         nHCfQHgjGxnSk1fpIWgvUyTI9O2Eul3B17gLEG7g1PJ09c2CCTCUIn1lUKbvlQknSNao
         0xvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785433309; x=1786038109;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V4Kqw/TkLVkzGuwHe/UF+DyDxAHM6IdVuvV/MKWb3Xk=;
        b=LdgR82klCVB4h9E9Nl2oBX1CBXFOjfO+QgUK6hTidmOCWvck4M7cnqHc698O8IQYZC
         BcAN0NpOGGBdqT0qMl0FzSt3QFs/PuK+1fbBPZdW68zaKEYq1QivQdq7N0CClvozxTsW
         OPEjtuWIMQHHRCgxUfHRw2sn41C1vMaYx2KmzDP4jsL2manA6n1CdT9GVqAbZWCfjfX/
         GWmFnR9vxsNln6qOOb6WAPvySSb7vEUZl/JkRmNtMBpomXidxm2c0E9uh/CG8JY/Wqcp
         2S5mhPzzqGRY4K1vzVP8tQpQx7RUYgRYZf+df3vQi4XUHcFxakiE3eTG3EdtXiN+MCtJ
         D+Vg==
X-Forwarded-Encrypted: i=1; AHgh+RoQQhn6xudYAvGaFq+41kLt9oLYYWWPVBP4wQyvNZsbl4yWkbwI+sFY3CcrMSHN0HdeH26jfLLG@lists.linux.dev
X-Gm-Message-State: AOJu0YzbfrQtRxmV5d1f5ShgUEVsMpYVg5Gyjubi+kBSxWf9/N1qjEL5
	WrEa006LB7jaYkdNFOFUfLK8/6dkbXFC3A4xNJsldWnmra0T7v8e3nzsIic1GHii8LLfJQlMT5D
	pgIsSUFjPZKfz4sSEzcdvd3Avlt4TZh8Jki66
X-Gm-Gg: AR+sD11aRneLgMuSITPLyxgbbG6vrAveBzOIwm2jBUW+siKMBSD2h+J4kMJbHXQytnO
	CuaBgw/gKWbXF+OmYnl1E/Po5Q72h/5+HhwdcVnFYVCjxXajbi0ZvGsnSP2RJktbMTDTKvmMqCw
	en6vX2xNsr6+Nrkw1hxBv6+LKc7mBQeBCFxCTcLbdjiBOd/bTDOBQ7GU+FVU4YWDFlOjJZIWXYJ
	7UIkpros0RJfe2BwoU4/FEgmSTXvcIV8DMYPUr6UrqgpcKZC0awqX/RvVMxgZwxw6DBoKQYU2/M
	BQBdzU/XrJjphvFTGr0xYGVMAC6X/F3e4omiqTARyjuxabDUmH7xueSYg3N8rROXXvmkhY2RmIc
	kog==
X-Received: by 2002:a05:6102:3e8f:b0:632:5db8:f672 with SMTP id
 ada2fe7eead31-758300e81famr516959137.6.1785433309303; Thu, 30 Jul 2026
 10:41:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260730141423.392222816@linuxfoundation.org> <20260730141430.052514003@linuxfoundation.org>
In-Reply-To: <20260730141430.052514003@linuxfoundation.org>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 30 Jul 2026 19:41:37 +0200
X-Gm-Features: AUfX_myUUlw1bvUmv3g2cpqmr_-9siqhv-Ltr18YbAgaPtiHVfgJ-bmln_uFUIU
Message-ID: <CAOi1vP_PpsJ_Zfe2YsqHOE6E9OCZvW712e+DBCdJve3pXwMJXw@mail.gmail.com>
Subject: Re: [PATCH 6.6 302/484] ceph: add owner/capability checks for CEPH_IOC_SET_LAYOUT*
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Max Kellermann <max.kellermann@ionos.com>, Xiubo Li <xiubo.li@clyso.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 6:10=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.6-stable review patch.  If anyone has any objections, please let me kno=
w.
>
> ------------------
>
> From: Max Kellermann <max.kellermann@ionos.com>
>
> commit cee38bbf5556a8e0a232ccae41649580827d7806 upstream.
>
> These permission checks were already missing in the initial
> impementation of these ioctls.  This Ceph allows any user who owns a
> file descriptor to manipulate the layout of any file, even if they
> don't have write permissions.
>
> It might be a good idea to guard other ioctls with permission checks
> as well or even disallow regular users (even if they own the file) to
> manipulate layout settings completely, as this may be abused to DoS
> the Ceph servers, but right now, I find it most urgent to have setter
> checks at all.
>
> Cc: stable@vger.kernel.org
> Fixes: 8f4e91dee2a2 ("ceph: ioctls")
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> Reviewed-by: Xiubo Li <xiubo.li@clyso.com>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  fs/ceph/ioctl.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> --- a/fs/ceph/ioctl.c
> +++ b/fs/ceph/ioctl.c
> @@ -72,6 +72,9 @@ static long ceph_ioctl_set_layout(struct
>         struct ceph_ioctl_layout nl;
>         int err;
>
> +       if (!inode_owner_or_capable(&nop_mnt_idmap, inode))
> +               return -EACCES;
> +
>         if (copy_from_user(&l, arg, sizeof(l)))
>                 return -EFAULT;
>
> @@ -142,6 +145,9 @@ static long ceph_ioctl_set_layout_policy
>         int err;
>         struct ceph_mds_client *mdsc =3D ceph_sb_to_fs_client(inode->i_sb=
)->mdsc;
>
> +       if (!inode_owner_or_capable(&nop_mnt_idmap, inode))
> +               return -EACCES;
> +
>         /* copy and validate */
>         if (copy_from_user(&l, arg, sizeof(l)))
>                 return -EFAULT;
>
>

Hi Greg,

There is a concern about the correctness of this patch, please drop it
for now.

Thanks,

                Ilya
