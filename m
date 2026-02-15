Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9182264C0
	for <patches@lists.linux.dev>; Sun, 15 Feb 2026 08:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771143106; cv=pass; b=Y6/lAFoIluhCWcHdgnrk80ezOV9YHbH+4cK10itVvyO05q9bArnVLgxLwK8oXI+3diMLsde9JeCvIYial7leypueHDd9/MW5dL/86UpjgKQDZhoCQJ58jOKB7q5qtDwr9Q1Y1fmAPPo11LlbRF50aXY8NrxSi+chDU+5rwuNAhw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771143106; c=relaxed/simple;
	bh=DTDk7K5Zkqtnt5fprRdhYF0zEccC1vT/ncnySQAaQkE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VD0E1jD7f2aXlNjYuaFiXf+6tVq9l2lHXKFYszR5paeWPdJvO19YRedGr87YbyMVe77ZY8PtUIBwW+fkLckmQRWlEvRVWVho2DqydhUo1dtaZEZ7KRSWFyf2TlKKGy0GZir60gbl5vaPDk6HzaYxkEdg85vKGkptX2D2c3u1i+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YxU3KU26; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YxU3KU26"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-65bfc858561so186351a12.2
        for <patches@lists.linux.dev>; Sun, 15 Feb 2026 00:11:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771143102; cv=none;
        d=google.com; s=arc-20240605;
        b=N3K3dGSccYubNVcnni1KJrL53PguG5FoAy/9Nt8Zhy9WKvMDWT6LEjTXSo21nBAq08
         ayl3msXIuninryhqdJkWtCIYt9tGEx1chb5UnXKfl+Q85lv3FW8tPtfMFvA439Q0at5X
         PdDnHmZuto6wULbazcbpNHuW63Fk0i11ild89M7v8dB308n0SmE/AnqYctK9uGdrBLs9
         CgLd4EEReXlxIM7zfkOCUgC0RPGd1bIVOiRacPEjct1PurysDB+aqZHbmyaWcVAB5o/7
         m+IxI4nfJcA8v7jT65nIdOoJTTnpX2+af1KfkXoybieOOHZf/PKPXoN2iwEWrO1qbqa0
         zt4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BrfHxdFp7u7ABi54dc0wXHkIQMX2y/VUZ8anXPNSims=;
        fh=n+5ekm51t+7c8z0Hsy0i6cOeT1yYkpsGA1QuKlwFunQ=;
        b=D2L3ppg7L35kvRrB02/wT7YsYoeM3UA2GY+JnhYhPRSRUoU6IoThL/weOOl4WBUqB3
         vWcJFPXu6RMoLQ7TlxS5TgBSgvuTsghb2DLsFrbhY/SPIFDmXs6qRXZrBu7B8i/+Rk7P
         cdYqxO2HCmYyBEzLDuUdCkMFTW83OtTtliRbc0eUwfgmEj/ftALY6SRgAFBEBXM6cV33
         IqF+PZM8z6JnS1RHHQk7i8OlPZcGVmIgeucpLK08Ti5ifnMr4+0NbfHkrsyEpcEWllTZ
         g+70/cnmhRpLfHQM8PYWNtFEWcxvq7jU9ysHOBBNTHGH33f0gJ1dFaQolc69cqSVTRAA
         sp9w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771143102; x=1771747902; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BrfHxdFp7u7ABi54dc0wXHkIQMX2y/VUZ8anXPNSims=;
        b=YxU3KU26e/6ZCFhD9DV2hg8KiLEeNkPuO+18yI7EP1Hm4WTKPL9e3ySQq+LegrAcG8
         mSo4t+ZhK+Sh125mcyJu3HTnQHcorpZXPf+10M5ltfTcLCxDXdKAOVb2vqXtOjwAh99u
         kKTYF9q/psK95DXxwF2ID72HN+MWgwUawUh77W34NOAKbaQlHJKp7mpiFzhGavPXyMV0
         LMNW1ksSW62xOzicuTFRzYMimrUHvUqJ0+l1KP/9CA82rP8e6JQDBWywgO0PAT51WF85
         3fXrwdcDgkwNXFN1CDHobT3mlTagvMYBnrpvpWBzq6hFSbxOaqFU3ec5m0U9dvwhKsQG
         uG1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771143102; x=1771747902;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BrfHxdFp7u7ABi54dc0wXHkIQMX2y/VUZ8anXPNSims=;
        b=uDPudDOGSq0LSQCyOSS1edytURf541vmsU4YiNuIprGPEPeOuWAjFLBywfu8JCM/eh
         CVbbrA9d6o835XbPVYFNlT0zSZz8Nf3KOFCTxnaFX2JL8KU9XfhKvk4CTY3eLOjZzhiw
         aT2ZUbEF9+NL4apdbbIW/sWElr0Ecrnl6Pb0QJ4Ig5nOWi+AJbRcRFyEMxkmaFj8Xd0p
         7yAiAw6u7/jEsJdAKIjWB7gwMbdEAOwdnGB9hWgozKQzEtKVcIuj4kieGiz06yx9+yj9
         cN2ptnlVtm/pzEkwNAQqONjcGg0tLzw73huRdNCMMQFuDggkmdYjUssRSA7aeC3eqXBl
         u9cA==
X-Gm-Message-State: AOJu0YyZoHYdpFV5HtZ25WDUJRFp0psDdaXFDcu7FenhgGamyCbkFt5/
	WCTK67BGtYOEgIDjPVNdjEYFlVCXYDleuRJTinh/F+BmYeUKBPgA4ZrqW0Xc4RcoPeJUZz65XTM
	RXqeXd7M1DBa6USDrJ+al1Ml0/3SUo9U=
X-Gm-Gg: AZuq6aKsblgif+iHj49ILOqPydd+p0BiZneO51QXTfnIP1mCSTjva7zDGd17vlzFQ6h
	4cAgs3YVc8avBmaYTHqMdhVR3LFEbZO+vzXfXARvMK3FkYWtGpGiQXVrJQXTeyGvVMrdmlprFVf
	vqDo/eAIwhrBiR/3FYp16soMYP+rJn1EaFSlJucwmpWInlIiPk/Mpw7tXarHLFHXJ77DmTzrx2X
	JQTIAslUHKo9uuDlhS9JyRwVatN3jqc/OxWx5Q1zX9Vvia1KTi1wt0M6t0LZ2b7Qg90ntbsMby2
	VqVyuiiOxlZEMlxp25J+X816+ut01mkVdw8dJZbOIw==
X-Received: by 2002:a17:907:3d9e:b0:b8f:a724:8704 with SMTP id
 a640c23a62f3a-b8fc3c7d456mr241918966b.42.1771143101677; Sun, 15 Feb 2026
 00:11:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260214212452.782265-1-sashal@kernel.org> <20260214212452.782265-85-sashal@kernel.org>
In-Reply-To: <20260214212452.782265-85-sashal@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 15 Feb 2026 09:11:30 +0100
X-Gm-Features: AaiRm50iIi5RwEAw9dxYIy_zWbg5mNMrBSmlP3CQ0mExJK-TzLN3fgMTeFhoPa4
Message-ID: <CAOQ4uxgKwp2FSAUwqhHN-kTBcy0DsFmLstGUY+zJWppOzTAmHA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.19-5.15] fsnotify: Shutdown fsnotify before
 destroying sb's dcache
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Jakub Acs <acsjakub@amazon.de>, Christian Brauner <brauner@kernel.org>, viro@zeniv.linux.org.uk, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 14, 2026 at 11:27=E2=80=AFPM Sasha Levin <sashal@kernel.org> wr=
ote:
>
> From: Jan Kara <jack@suse.cz>
>
> [ Upstream commit 74bd284537b3447c651588101c32a203e4fe1a32 ]
>
> Currently fsnotify_sb_delete() was called after we have evicted
> superblock's dcache and inode cache. This was done mainly so that we
> iterate as few inodes as possible when removing inode marks. However, as
> Jakub reported, this is problematic because for some filesystems
> encoding of file handles uses sb->s_root which gets cleared as part of
> dcache eviction. And either delayed fsnotify events or reading fdinfo
> for fsnotify group with marks on fs being unmounted may trigger encoding
> of file handles during unmount.

In retrospect, the text "Now that we iterate inode connectors..."
would have helped LLM (as well as human) patch backports understand
that this is NOT a standalone patch.

Sasha,

I am very for backporting this fix, but need to backport the series
https://lore.kernel.org/linux-fsdevel/20260121135513.12008-1-jack@suse.cz/

I don't expect major backport issues to kernel >=3D 6.10 with commit
07a3b8d0bf726 ("fsnotify: lazy attach fsnotify_sb_info state to sb")

Backporting below 6.10 will require more dependencies.

Thanks,
Amir.

> So move shutdown of fsnotify subsystem
> before shrinking of dcache.
>
> Link: https://lore.kernel.org/linux-fsdevel/CAOQ4uxgXvwumYvJm3cLDFfx-TsU3=
g5-yVsTiG=3D6i8KS48dn0mQ@mail.gmail.com/
> Reported-by: Jakub Acs <acsjakub@amazon.de>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Reviewed-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>
> LLM Generated explanations, may be completely bogus:
>
> The function is present and the code structure in the current tree
> matches what we see in the diff. This function has been in
> `generic_shutdown_super()` for a long time and would exist in all active
> stable trees.
>
> ### 8. SUMMARY
>
> | Criteria | Assessment |
> |----------|-----------|
> | Fixes real bug | YES =E2=80=94 NULL deref / crash during unmount |
> | Obviously correct | YES =E2=80=94 simple reorder, reviewed by 2 top
> maintainers |
> | Small and contained | YES =E2=80=94 1 file, ~6 lines, moving 1 function=
 call |
> | No new features | Correct =E2=80=94 pure bug fix |
> | Risk of regression | Very low =E2=80=94 only slight performance impact =
|
> | User impact | HIGH =E2=80=94 affects any system with fsnotify watches d=
uring
> unmount |
> | Reported by real user | YES (Jakub Acs) |
>
> This is an excellent stable candidate: a small, well-reviewed fix for a
> real crash that affects common operations (filesystem unmount with
> inotify/fanotify watches). The fix is trivial to understand (reorder one
> function call), reviewed by the subsystem and VFS maintainers, and
> carries essentially no risk of regression.
>
> **YES**
>
>  fs/super.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/super.c b/fs/super.c
> index 3d85265d14001..9c13e68277dd6 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -618,6 +618,7 @@ void generic_shutdown_super(struct super_block *sb)
>         const struct super_operations *sop =3D sb->s_op;
>
>         if (sb->s_root) {
> +               fsnotify_sb_delete(sb);
>                 shrink_dcache_for_umount(sb);
>                 sync_filesystem(sb);
>                 sb->s_flags &=3D ~SB_ACTIVE;
> @@ -629,9 +630,8 @@ void generic_shutdown_super(struct super_block *sb)
>
>                 /*
>                  * Clean up and evict any inodes that still have referenc=
es due
> -                * to fsnotify or the security policy.
> +                * to the security policy.
>                  */
> -               fsnotify_sb_delete(sb);
>                 security_sb_delete(sb);
>
>                 if (sb->s_dio_done_wq) {
> --
> 2.51.0
>
