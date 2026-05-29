Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1B43AA9E8
	for <patches@lists.linux.dev>; Fri, 29 May 2026 06:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780036766; cv=pass; b=oLdevxpoeZxLbE9bw/GZ3WtfzsUqL1BVmmQWOv6heE+zFXJCvcFBR7OodbI1Kj10YwT44RUChH1hikqSr/Kfx3nYP+LuymS6uB3gL04aG9+V2i1UG1Itk1ICuIug9aPU4+yKiiUSHV04ruK640WGwiFVpocBGTUksYz/fCRW9pY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780036766; c=relaxed/simple;
	bh=U5pGGIgBsbfT2iDz1oVTC2NdzvnHgJCRf8Kw/K4DP9s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PLFK+wKHJ0/xVsu+CDgRfLVamo2SM/6ZK70Kq/4fSLwdTXYaqeGbomdTC5IPKssQ3goCKkpOCNpOsngBCYbHh8CcGoybixP+9xt8OAX9gHoGpAEnltZXu7WE5ANU4PMDOEQkJ8rDgUgrarh9BnBBpCNc/PEBjOSgxtW3/k1rZ7U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FjJN/Bmt; arc=pass smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FjJN/Bmt"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4906238c62eso50350865e9.3
        for <patches@lists.linux.dev>; Thu, 28 May 2026 23:39:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780036761; cv=none;
        d=google.com; s=arc-20240605;
        b=kArEmgqjI62/xeBb4TMHEixUTmN0vhYbxDNYIB1F/al8hpxwjBOWx+gve+dduboStG
         MHlBOHXBPSTyWrfuN050GGh85BUg6syudUWXYsVepTliPZ1cVHV9PvpgLCVJ5ng7aAMx
         QexzPl5b3qM3MYCa/IVYCHmizTCSq7HHhSzepB7wpLFPIDWS9X3mRXUAZLLbW0nDwocJ
         K4VDBKRBkdX2j47Yfn7VjsHs6v1IxYy5bgDLhFG1aj7PZcpt6HcoKtsPiFt9Dkzq8n5l
         VZuplSeRrDKaf4MTrI9VD7FbpKO2P0HhB2Uq/7hXBOU4+f0VKiEtdKs2tY6c6R717uVC
         SPPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=0M9tEWd44B5wfjzjs0kSwo4GiNutlPsrp3val3j4oMU=;
        fh=kCUjqudepi6mK1eAsZuS2YKxYdhGm9tK/F2B4GifoNI=;
        b=cvvWLQvpIcX3TVCH39znpXS5OFOYEiB7P0QiMCRcwxY8Syx+FbLmp9Q/EoO49hnI+B
         9VFz8uJNbOFkPXO2r3WnBBAjhDsoHTT0wBAZeG1siqwpaZPsdlziwMlE6SPDP+jrTRXf
         vGDSXd7BNH6AtaGkF5T0H80aCw3DdBXGtvuGfvXISWYsgwyWL4cqrTyKK95cvktWkbYZ
         QUQGrxD1W/HrDbsjp6+nUtAH8QmAW9l3moWnh6hN/z9u3O+/moXojxiYxkMs4dUsgWgm
         JjEI116nOPzTML89h81Zlv11h+V5oK+Yka7RQmQLr1nR+fvRMtXl5V22Xyx3dH7Mc3/6
         AQ2g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780036761; x=1780641561; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0M9tEWd44B5wfjzjs0kSwo4GiNutlPsrp3val3j4oMU=;
        b=FjJN/BmtiB6M2s/TOFPIfVZZwM890Yal+jgr9d8O+jzs9Pc089SrhKf0Ba3fRA9v/m
         LkKk9VOE9VBh7pvGaJuja/zLabfhxbEmPYWuoIHR1scFzzwqQn0WciAgPcmwZ+5khVUD
         gGTGsk8M4iFtcVRteI7aXD3zo0fA1Xkr+o+6kcASEu0hD7dqyDpGdb8FpPd281F2CytH
         i7uky5+pxCsy8N91YAJaoXwISiHz6F7jR8lwOko2NpEd8s0Ga8Q+p54uXbfR3oKvhFJu
         JYf9BpGT+XZSw8XX6odDYnqXBc/dFNGMkjc5Rn0rXz/NcgSHXiq2efAyA9lrLhs6+LRI
         3auQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780036761; x=1780641561;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0M9tEWd44B5wfjzjs0kSwo4GiNutlPsrp3val3j4oMU=;
        b=VpvvvV5rm7f4XreYOXUjVliEKBYcohoxBiVzV+Ah4qkaKNmv+2piAsIkdiVTD8TWrb
         dkwfrbtPpEQ+vIAoMIuDvtKqXO0gQ2RePwmohWw0ySoVZglGB+rAxyzbthv4DNIypZY8
         S+U0BW2fza20gOrE9YspH8VBaWlcrtEhfUzOMWyUZ5SmNDgrZ7KCM7nSkgRdfLazVWH5
         fa2cDDiTViSCKX2OVcjqMDCPhDLlqZsp3+/Qa0jJA2Rm3FNYOHNMoIGZh7DiG6xFgLsh
         YeYtVMEWUtXpwCS6eco8pPADwO2kVgEzm5Ua42xOAgSE0t56SFIiXJy0peS/9DYuaPTV
         dqcQ==
X-Forwarded-Encrypted: i=1; AFNElJ8ljTEBVS6RQ6rZ4B6VtAWiTotP/WwUVADF6AYIW7u5jsU/lUxpgb3B2p3XvQ0y2eGED2G+/+kU@lists.linux.dev
X-Gm-Message-State: AOJu0Yzs9Ao/nid5+Rxm27Qx/JR2kLy43NQJWAKMW0QvGV2nLB1AwCpv
	w+z9irqM4FUP4hwZAYoEaiKFeDqsPFkcidpAherw6BmEETJQ5nbDXLbD8A/6R461s/Tom6Fgl0+
	/NNRvUoAo356qZq6LJdmBit5NuYyohjYzS6mVfNnCqQ==
X-Gm-Gg: Acq92OGSbLjVzPtPJPkYsIwCs2WeLskJFHFo3h26YoQpaVKBrFf8nhHpfbZj6dupEg/
	NWQh8MUNPuVmqhxla8oxBp3Yfy8n48IBzyIbBEip5PGzkstJBmw2vKPAoff8Wk6y+zH2XWAGyAD
	KJ5q3lJT4MNkJx3TgskHWOSxx7awsJ2AGx82ngAM9SlPfuDkwUwKrdOCFUGTMtjKOVBlnfsbgXC
	gYDqkz0r1cvabQjZiVbSrOuDl7rpewPBj8BuTgRfI3Swaqj/JBQzv5iMtOMc4mNjth+nOa5y7tJ
	PMUHdsTyantHfTM1VIXza0L9LWImqwS3+wEy9sMXLyNmCOKv4T6MCiwfU4Mey96+UDE/NLAXk6J
	L0gEp4VBF3qX+ECE=
X-Received: by 2002:a5d:624c:0:b0:45e:9db6:89ab with SMTP id
 ffacd0b85a97d-45ef144d201mr1909429f8f.25.1780036761413; Thu, 28 May 2026
 23:39:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260528194638.371537336@linuxfoundation.org> <20260528194647.015775177@linuxfoundation.org>
In-Reply-To: <20260528194647.015775177@linuxfoundation.org>
From: Daniel Vacek <neelx@suse.com>
Date: Fri, 29 May 2026 08:39:10 +0200
X-Gm-Features: AVHnY4LzXZrnviXUAYv5jwpNYGW2RF4f9XnR-Hbr64WGSPyNVFs6kGFmNdIkT-Y
Message-ID: <CAPjX3Ff-a8JHxeMr1Hk83BmQX9YLGNR+g+7waygn43ZD7pWMHg@mail.gmail.com>
Subject: Re: [PATCH 6.18 299/377] btrfs: dont search back for dir inode item
 in INO_LOOKUP_USER
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, Josef Bacik <josef@toxicpanda.com>, 
	David Sterba <dsterba@suse.com>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 28 May 2026 at 22:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.18-stable review patch.  If anyone has any objections, please let me know.

Hi Greg.

This is not a bugfix, rather, it is a cleanup.
Even though it's kinda small and limited to a single function, I'm not
sure it's worth the stable backport.
Is there any specific reason you picked this patch?

--nX

> ------------------
>
> From: Josef Bacik <josef@toxicpanda.com>
>
> [ Upstream commit 70085399b1a1623ef488d96b4c2d0c67be1d0607 ]
>
> We don't need to search back to the inode item, the directory inode
> number is in key.offset, so simply use that.  If we can't find the
> directory we'll get an ENOENT at the iget().
>
> Note: The patch was taken from v5 of fscrypt patchset
> (https://lore.kernel.org/linux-btrfs/cover.1706116485.git.josef@toxicpanda.com/)
> which was handled over time by various people: Omar Sandoval, Sweet Tea
> Dorminy, Josef Bacik.
>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Daniel Vacek <neelx@suse.com>
> Reviewed-by: David Sterba <dsterba@suse.com>
> [ add note ]
> Signed-off-by: David Sterba <dsterba@suse.com>
> Stable-dep-of: 1e92637722ae ("btrfs: check for subvolume before deleting squota qgroup")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/btrfs/ioctl.c | 23 +++--------------------
>  1 file changed, 3 insertions(+), 20 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index c0691e93e0a58..41e549d37aac8 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1832,7 +1832,7 @@ static int btrfs_search_path_in_tree_user(struct mnt_idmap *idmap,
>         struct btrfs_root_ref *rref;
>         struct btrfs_root *root = NULL;
>         struct btrfs_path *path;
> -       struct btrfs_key key, key2;
> +       struct btrfs_key key;
>         struct extent_buffer *leaf;
>         char *ptr;
>         int slot;
> @@ -1887,24 +1887,6 @@ static int btrfs_search_path_in_tree_user(struct mnt_idmap *idmap,
>                         read_extent_buffer(leaf, ptr,
>                                         (unsigned long)(iref + 1), len);
>
> -                       /* Check the read+exec permission of this directory */
> -                       ret = btrfs_previous_item(root, path, dirid,
> -                                                 BTRFS_INODE_ITEM_KEY);
> -                       if (ret < 0) {
> -                               goto out_put;
> -                       } else if (ret > 0) {
> -                               ret = -ENOENT;
> -                               goto out_put;
> -                       }
> -
> -                       leaf = path->nodes[0];
> -                       slot = path->slots[0];
> -                       btrfs_item_key_to_cpu(leaf, &key2, slot);
> -                       if (key2.objectid != dirid) {
> -                               ret = -ENOENT;
> -                               goto out_put;
> -                       }
> -
>                         /*
>                          * We don't need the path anymore, so release it and
>                          * avoid deadlocks and lockdep warnings in case
> @@ -1912,11 +1894,12 @@ static int btrfs_search_path_in_tree_user(struct mnt_idmap *idmap,
>                          * btree and lock the same leaf.
>                          */
>                         btrfs_release_path(path);
> -                       temp_inode = btrfs_iget(key2.objectid, root);
> +                       temp_inode = btrfs_iget(key.offset, root);
>                         if (IS_ERR(temp_inode)) {
>                                 ret = PTR_ERR(temp_inode);
>                                 goto out_put;
>                         }
> +                       /* Check the read+exec permission of this directory. */
>                         ret = inode_permission(idmap, &temp_inode->vfs_inode,
>                                                MAY_READ | MAY_EXEC);
>                         iput(&temp_inode->vfs_inode);
> --
> 2.53.0
