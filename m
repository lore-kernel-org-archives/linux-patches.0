Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03B36994A
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 15:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708529171; cv=none; b=cZs6YZTblrs9DYKJOYcJ5Y67UMkqGuQhyGJSCRmuPDkjIdRK9/8q1unlJ4vl9KpbyQy+Pm8mrCqUE5CkvPUOAQnGNzVk15355w+ikEpJe341eS0rNNrvVbh+VEcwgpunQsjjKMQaf1T66iIw8B/Er4HAgbGOouH8r26nQ/rXG2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708529171; c=relaxed/simple;
	bh=cci5BOGZK3Spt55yQ2qdW1t58lXnRhMvgGTY0oAAFq0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LL8//iGD9uCvxPlVP9CenyrwsT/SbOHcznHXjc++cVO4pz7n337CzOYEHA4U+f3RNOCQQPrMsVqOFDkQVff4uJZXy9ySm7OCN4QAfeMactRCB1o0LvPDRY4+4Av1r1Cpfdn+CjmnDO4jlUIi0g/ckr80Fsp2xkUvnLedV+6oC5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WnYNr+8O; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WnYNr+8O"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-512a85806fcso823801e87.2
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 07:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708529168; x=1709133968; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c7CFRwEaj5O3n1vig9mmc40S2b7I6iaaWbSwi8GiOwQ=;
        b=WnYNr+8O08AecDr34YvVHekeU/48SY5pX5NsEKAjZTXfhxHL4jU09COjyKbTDxo+rw
         pIJ0hnOAvL1YlCCGk6MT80d/OMz36K1E57xXgRjcNYC4GOy7o9PhUysJ/U4eRuti2YQx
         49daYBXJC9mdf3lHXT0wH0N1z0hg1+KFw+R7BZ/Thf1RdhbVz1QmLAZztoNjf6C7JtHl
         XtlP66byb1TQclVE6lstQ0jR5A25eoIEPRGmwVVRi9mPeDoyOGqdvUelO/I3d/03foCy
         BnUL/h/00w7OmJND8BNUKsqW9NBbsI1sFzfpnspdVItjkZpdd5xce/0DofBm7OKGvPw2
         n6Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708529168; x=1709133968;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c7CFRwEaj5O3n1vig9mmc40S2b7I6iaaWbSwi8GiOwQ=;
        b=bFpwnSOEtqCacPL/HlJHsNCUCqfXxmVVsrV2KtUyF1lGm8j8IPsNL96U2lrjdKjmwr
         Wf6avfXWFhCcMKvcPcRr39kPu+qaNxUXmkFJt7Wc/sVYXkMf4p/rbb98ANLp/6omrnxA
         5wHaRqI0LKVk5mfAOogK7IKfrfZqbAELCbE3nyen6Av9zSfzfN59tAOTBpCGHizRGadn
         j/JzgCRjPTPD4JSYszl2g9VBqJqjia3Ie2G0CgsO7ZWbry2OWFA9SN9GjJqKG6//amWf
         M6D1jSAIoT1XuauZvSCZr53FvF1cf9DyR9a5pvOlgiILrY5gLlsYamlkUFzNs+Ug+seB
         9+Pw==
X-Forwarded-Encrypted: i=1; AJvYcCU8YbaSXcV7kKDPa9QHSHEQKfnb2XLPeCb7xtNhYjbdl3XpHOcPSZvFglH8WNcoBOstgLY5lqiPgbYCxt3rl4k1nX+5mUA/pQ==
X-Gm-Message-State: AOJu0YyifXK0ktw4DenYMhAXQ91ABG+rHAST64VXfmq66pfB9P4SpBKd
	c9C3Sp0NBvoCt6oUXQ5jUU3tJ7POezlQbE5MsSVGULO3gIJUV509/09r1OdLUz+6XoJgpeWPeXk
	mGaghzwJlMTjALHrLIE3TwB5b5gw=
X-Google-Smtp-Source: AGHT+IHKXAczEIV6dUiAdkT+Wz92ctah8iGk2CHccvb9gcB8i8NaBhlm16ApdXAmheuRwLyy/wxvNaN3pXDa62LWkqE=
X-Received: by 2002:a05:6512:6ce:b0:512:cc76:4dab with SMTP id
 u14-20020a05651206ce00b00512cc764dabmr3308659lff.29.1708529167899; Wed, 21
 Feb 2024 07:26:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240221125940.058369148@linuxfoundation.org> <20240221125948.348622258@linuxfoundation.org>
In-Reply-To: <20240221125948.348622258@linuxfoundation.org>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 22 Feb 2024 00:25:51 +0900
Message-ID: <CAKFNMonCSHt1ziZo=UcUvRSRfoARYUT+YycnoF2jQx78XENOyA@mail.gmail.com>
Subject: Re: [PATCH 5.4 258/267] nilfs2: replace WARN_ONs for invalid DAT
 metadata block requests
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	syzbot+5d5d25f90f195a3cfcb4@syzkaller.appspotmail.com, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 21, 2024 at 11:30=E2=80=AFPM Greg Kroah-Hartman wrote:
>
> 5.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>
> ------------------
>
> From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
>
> commit 5124a0a549857c4b87173280e192eea24dea72ad upstream.
>
> If DAT metadata file block access fails due to corruption of the DAT file
> or abnormal virtual block numbers held by b-trees or inodes, a kernel
> warning is generated.
>
> This replaces the WARN_ONs by error output, so that a kernel, booted with
> panic_on_warn, does not panic.  This patch also replaces the detected
> return code -ENOENT with another internal code -EINVAL to notify the bmap
> layer of metadata corruption.  When the bmap layer sees -EINVAL, it
> handles the abnormal situation with nilfs_bmap_convert_error() and finall=
y
> returns code -EIO as it should.
>
> Link: https://lkml.kernel.org/r/0000000000005cc3d205ea23ddcf@google.com
> Link: https://lkml.kernel.org/r/20230126164114.6911-1-konishi.ryusuke@gma=
il.com
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Reported-by: <syzbot+5d5d25f90f195a3cfcb4@syzkaller.appspotmail.com>
> Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  fs/nilfs2/dat.c |   27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
>
> --- a/fs/nilfs2/dat.c
> +++ b/fs/nilfs2/dat.c
> @@ -40,8 +40,21 @@ static inline struct nilfs_dat_info *NIL
>  static int nilfs_dat_prepare_entry(struct inode *dat,
>                                    struct nilfs_palloc_req *req, int crea=
te)
>  {
> -       return nilfs_palloc_get_entry_block(dat, req->pr_entry_nr,
> -                                           create, &req->pr_entry_bh);
> +       int ret;
> +
> +       ret =3D nilfs_palloc_get_entry_block(dat, req->pr_entry_nr,
> +                                          create, &req->pr_entry_bh);
> +       if (unlikely(ret =3D=3D -ENOENT)) {
> +               nilfs_error(dat->i_sb,
> +                         "DAT doesn't have a block to manage vblocknr =
=3D %llu",
> +                         (unsigned long long)req->pr_entry_nr);
> +               /*
> +                * Return internal code -EINVAL to notify bmap layer of
> +                * metadata corruption.
> +                */
> +               ret =3D -EINVAL;
> +       }
> +       return ret;
>  }
>
>  static void nilfs_dat_commit_entry(struct inode *dat,
> @@ -123,11 +136,7 @@ static void nilfs_dat_commit_free(struct
>
>  int nilfs_dat_prepare_start(struct inode *dat, struct nilfs_palloc_req *=
req)
>  {
> -       int ret;
> -
> -       ret =3D nilfs_dat_prepare_entry(dat, req, 0);
> -       WARN_ON(ret =3D=3D -ENOENT);
> -       return ret;
> +       return nilfs_dat_prepare_entry(dat, req, 0);
>  }
>
>  void nilfs_dat_commit_start(struct inode *dat, struct nilfs_palloc_req *=
req,
> @@ -154,10 +163,8 @@ int nilfs_dat_prepare_end(struct inode *
>         int ret;
>
>         ret =3D nilfs_dat_prepare_entry(dat, req, 0);
> -       if (ret < 0) {
> -               WARN_ON(ret =3D=3D -ENOENT);
> +       if (ret < 0)
>                 return ret;
> -       }
>
>         kaddr =3D kmap_atomic(req->pr_entry_bh->b_page);
>         entry =3D nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
>
>

Hi Greg,

Please drop this patch for 5.4 as well as the patch for 4.19.
(same reason as the review comment for the 4.19 patch)

I will send an equivalent replacement patch.

Thanks,
Ryusuke Konishi
