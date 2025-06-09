Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E2F28030B
	for <patches@lists.linux.dev>; Mon,  9 Jun 2025 07:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749453192; cv=none; b=nf4uhHVAO+byD0KgUR/S4+SrKv6rn9fVETjBHBumr3oyypje0eNMKxOIURkIOGw7zgejCYf9cUFSC0fHqrwEadSnS6YEnM2cHNBIgBxYQL2A4S/Af4HZ08aV44Zb2uYf+rrs9dHzj4IvkwaDVNxsyeOVlwbXjsZUYeatP6dkREM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749453192; c=relaxed/simple;
	bh=fi1paGJdgHDlXNfaHrXiU9rQB8m/XbjUbFl5aP8Odrw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=GCLX1C6+9UsV/m8+zHKFjDHP/nff8G9batk3MPSu2zcL6W7mq0Oz2I4thYg68YpWAvO4BNCmpdZhyKhudDdwVQpPdG5rWhZwnVxIWPvTjB2mroyKJbaS0yeFNwgQvt94zjsPNzDb0J07u/vuYesstl8NSrCQHKBwrESqsQTRlHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cSJNMR9R; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cSJNMR9R"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-606b6dbe316so3128865a12.3
        for <patches@lists.linux.dev>; Mon, 09 Jun 2025 00:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749453189; x=1750057989; darn=lists.linux.dev;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QWarZ9ZMdObeBZ49vJa9NkdLfUndOrCRlVd7nNHjgkE=;
        b=cSJNMR9RjVftBvLlu708WZAvLesMbyHR8TlMIRxbTTjF/dkdxHVaGPWEuLgwMDjAM5
         Vzpy1ifZRpszWbNHsfDdykAYw10gTmJfR3lS6DRp5KYAlwte/hCrnSkFsAyrBuXqzmqY
         b1f4/Vw9p0R1w2vf70ue7tFJFlIqFqojfb+whAbIvdHSprLCnWiLxNZ8mfESFVnZxrI7
         uiLP5z0lrMEjfY7ES+3zPnknRgaBraOupuLbVG30X6VQxsfkp+yYkJ/LuLHkBcn8uR7U
         tzjnU8KKq0g4Leo3RgKLqeaUN0JO2LxgWJBGeb0bHMmelQupnvA8xh2/Wgqobj2bjpPL
         gzuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749453189; x=1750057989;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QWarZ9ZMdObeBZ49vJa9NkdLfUndOrCRlVd7nNHjgkE=;
        b=NrXQVhCkfGtcYNflON5rKnhw1NaAvlndH8khcuVPPW6qH8wOKs7+oqILOCYbxcrtRX
         4NazZR2KITXMJxCRMITjO+/ATNR/cufQIjIlGVFMzn6NyxeG61yW5xY9+L35NRUgg6Wx
         362I2W04XoSrHkaOhkG84veoIcnKDn6ygbahOCf9FDGepR2q9mGt1U+JUDOhzECy8aBH
         MPP7WcYYiOOnYeq4iWGAd/WfAbPqcXmiHUVKubelYgeEqpIfBicWuve3Srrt6wyEcdYw
         dB7geBOOcyClA8MxrOJecoikLXHTb/65K/FHNrA9hYZrh8pao7gBEBr8uJxz0esAgWs2
         7eTw==
X-Gm-Message-State: AOJu0YxVJ5eIC39jBcOb0Hde1LPctZZgC6n+kMyYEIABakWHUi/Smp31
	p7rLmuoc1fD2xPZB9quz2TJW46TW0wpsk52OsNr1wmQSC+fnF6BRhdmeTlu8MQcZvgYgaQw2s70
	SQuv1ofS3UkqqTnaLbayy/xJ6BavpQxoSSw==
X-Gm-Gg: ASbGncvLsFke7dzHGSQsySON3JJCacyYbw/69X/IVLLiPjjr/O5BBvvD1YtI3JqVs8j
	mx7weC37JiHLNZB2Fbcx0gpkppZ1Wp3vUF6Z9kHT2rexkV+gMzTupq8lxWoc0Y1AroL9JFCDTqX
	Ff+2a1ZM7ag2KUz/FiBC773rTCqqXIKzAD7qSF0i+Ba8raPx9Fo+iiLA==
X-Google-Smtp-Source: AGHT+IEJH7AWdzIKuU271At2s5quZavoLb/6M5/tI0nZJPjOLf79/ZHTdUAAH5cMVXTU8slyGRg5Del9trG3mu3ak64=
X-Received: by 2002:a17:907:9694:b0:ad8:a9fc:8146 with SMTP id
 a640c23a62f3a-ade1a9e82c8mr951947166b.44.1749453188693; Mon, 09 Jun 2025
 00:13:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250606154350.548104-1-sashal@kernel.org> <20250606154350.548104-3-sashal@kernel.org>
In-Reply-To: <20250606154350.548104-3-sashal@kernel.org>
From: Lionel Cons <lionelcons1972@gmail.com>
Date: Mon, 9 Jun 2025 09:12:00 +0200
X-Gm-Features: AX0GCFsxY7OzBcgpJK9l9zP2o22SfTR5S4GY1r-zW8DY02hwxwakmpIBcXS9kdc
Message-ID: <CAPJSo4XSoTNVvH8MpZWD4W50u=U4bw6YBCnNeiJZpe2LT-YNYg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.1 3/9] NFSv4: Always set NLINK even if the
 server doesn't support it
To: patches@lists.linux.dev, stable@vger.kernel.org, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 6 Jun 2025 at 17:48, Sasha Levin <sashal@kernel.org> wrote:
>
> From: Han Young <hanyang.tony@bytedance.com>
>
> [ Upstream commit 3a3065352f73381d3a1aa0ccab44aec3a5a9b365 ]
>
> fattr4_numlinks is a recommended attribute, so the client should emulate
> it even if the server doesn't support it. In decode_attr_nlink function
> in nfs4xdr.c, nlink is initialized to 1. However, this default value
> isn't set to the inode due to the check in nfs_fhget.
>
> So if the server doesn't support numlinks, inode's nlink will be zero,
> the mount will fail with error "Stale file handle". Set the nlink to 1
> if the server doesn't support it.
>
> Signed-off-by: Han Young <hanyang.tony@bytedance.com>
> Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>
> Based on my analysis of the commit and the kernel source code, here is
> my determination: **YES** This commit should be backported to stable
> kernel trees. Here's my extensive analysis: ## Critical Bug Fix Analysis
> ### 1. **Root Cause Understanding** The commit addresses a critical
> issue where NFSv4 mounts fail with "Stale file handle" errors when the
> server doesn't support the `fattr4_numlinks` (NLINK) attribute. Looking
> at the code: - In `/home/sasha/linux/fs/nfs/nfs4xdr.c:3969`, the
> `decode_attr_nlink` function initializes `*nlink =3D 1` as a default -
> However, in `/home/sasha/linux/fs/nfs/inode.c:556-559`, the current
> logic only sets the inode's nlink if `fattr->valid &
> NFS_ATTR_FATTR_NLINK` is true - When the server doesn't support
> numlinks, the `fattr->valid` flag isn't set, so the inode's nlink
> remains 0 (from initial inode allocation) ### 2. **Impact of Zero
> nlink** From `/home/sasha/linux/fs/nfs/dir.c:1578-1582`, I can see the
> critical check: ```c if (inode->i_nlink > 0 || (inode->i_nlink =3D=3D 0 &=
&
> test_bit(NFS_INO_PRESERVE_UNLINKED, &NFS_I(inode)->flags))) return 0;
> else return -ESTALE; ``` When `i_nlink =3D=3D 0` and the
> `NFS_INO_PRESERVE_UNLINKED` flag isn't set, NFS returns `-ESTALE`,
> causing "Stale file handle" errors and mount failures. ### 3. **Backport
> Suitability Criteria** **=E2=9C=85 Fixes important user-affecting bug**: =
Mount
> failures prevent basic filesystem functionality **=E2=9C=85 Small and con=
tained
> fix**: The change adds only 2 lines: ```c else if (fattr_supported &
> NFS_ATTR_FATTR_NLINK) nfs_set_cache_invalid(inode,
> NFS_INO_INVALID_NLINK); +else + set_nlink(inode, 1); ``` **=E2=9C=85 Mini=
mal
> regression risk**: Setting nlink=3D1 as fallback is safe and follows the
> NFSv4 spec (fattr4_numlinks is a "recommended" attribute, so emulation
> is appropriate) **=E2=9C=85 No architectural changes**: This is a targete=
d fix
> within existing error handling logic **=E2=9C=85 Follows stable tree rule=
s**:
> It's an important bugfix with minimal risk ### 4. **Comparison with
> Similar Commits** Unlike the provided similar commits that were marked
> "NO" (which involved more complex nlink management, cache invalidation
> changes, or feature additions), this commit: - Fixes a fundamental
> compatibility issue - Prevents complete mount failures - Is minimal and
> defensive - Addresses server interoperability problems ### 5. **Server
> Compatibility** This fix ensures NFSv4 clients remain functional with
> servers that don't fully implement all recommended attributes, which is
> critical for real-world deployments where server implementations vary.
> The commit directly prevents mount failures that would otherwise require
> server-side fixes or workarounds, making it essential for stable kernel
> trees where users expect reliable NFS functionality.
>
>  fs/nfs/inode.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
> index f2e66b946f4b4..e774cfc85eeed 100644
> --- a/fs/nfs/inode.c
> +++ b/fs/nfs/inode.c
> @@ -555,6 +555,8 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, =
struct nfs_fattr *fattr)
>                         set_nlink(inode, fattr->nlink);
>                 else if (fattr_supported & NFS_ATTR_FATTR_NLINK)
>                         nfs_set_cache_invalid(inode, NFS_INO_INVALID_NLIN=
K);
> +               else
> +                       set_nlink(inode, 1);
>                 if (fattr->valid & NFS_ATTR_FATTR_OWNER)
>                         inode->i_uid =3D fattr->uid;
>                 else if (fattr_supported & NFS_ATTR_FATTR_OWNER)

How can an application then test whether a filesystem supports hard
links, or not?

Lionel
