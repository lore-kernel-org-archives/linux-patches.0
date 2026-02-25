Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8EF2F7ACA
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 06:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772000132; cv=pass; b=ffJ06sInj8bxwK4gbRNiFf/RpGaHLoIGRFSnNSNvTgfflzf8pJAfHVsf1JJxWjzFeScWcihQV9oKcOihtCHb4USYST77yUZrL18wso8k87ZjVZgIKMz/HHw2UsHAuIAHFzbwJuszkO5ncCMd3bvjFMHCZoVatBbwLJWSCp5rRCI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772000132; c=relaxed/simple;
	bh=6duiW9c2DU7z/mC6LK2GVzrYkzQjoQbV/lc0c0lQsek=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xj8htsv5vbtA0q4Z9tQnc/sOQsBhyveNuaoldaPvADz5yusv3fb9x0ZIYR5Lqc8NqVl76A1imLqcnffAa124hJfFSRwjbjA4Rs/RHCc3Xe9MfDaQ6nqHJwNBqgK/7moJWU/6M2K3T3dLFDui/BxvXPAJZj4P2vJPJd26z+KQnTk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=L+71Vtvu; arc=pass smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="L+71Vtvu"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-436e8758b91so4330476f8f.0
        for <patches@lists.linux.dev>; Tue, 24 Feb 2026 22:15:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772000128; cv=none;
        d=google.com; s=arc-20240605;
        b=Dg22rOu2z+r5Y9yuSQEoeYUKQSk5D4mGLEJ2zXh0LRwx9SMVts+pw9Qk9Mjxt9aOGD
         RmTdMz2tLBnuql/6Ten7kxjSZ1HUC+Opgy7bHcvlx3N2iavuaGi9TNCxEpO71WbCTye/
         qmP6cq5XyQ6CXOSmiMFKlnvrHb0Dc3cLc9elICi5y1RMQw9VSP1Tht9FLKBUkMxmAwYz
         gvFGyGWM1kfs+LeodvuuonAWGzHm4CGiYr96mO4PSfQqVIvnfLiz1mXk/MaBGi2pMD5q
         ta7u+HLIoibH8W3NeCQ5Q71wbOAemdfhr6ODCmSPKgQ6q8z0oq6SvRUzDkE3qJic09ug
         YwTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=fRp4t0j/86MYJauHT8JmZMZ8uXCSwHALvLOqAznr3r0=;
        fh=k3k3fekveyK/+gFVNO5s+yk/iaBKxrNp94atWOYOOUM=;
        b=kMI3b6gG4pEP+sgRowqdXDWnOBxp+O16Hus3pRFPy1UOfN/mXiBN+hCMQIq1UVu+A/
         ZaLVgp/cr3EkAkFS9cuJg4kK9m2o4Ep5h6shbMfhJjJsN6GNMIfziKnFZw6cFYXDuxdy
         qXMJEJpb5Ag4d2BnLnzfuBneDhceMYZEEmOA/YCEkENKxmRnzdfjIPCq0ZeWl9PlXQHY
         gw4LNT1X1+d4w34plJh6JPno44IyAzQcOPAwTJKw4D9Zt1vLadSHkuX5J43jv1R4AbJm
         aj1dXrHcx7cGl2cqSwMSiQs5UkgSIYlBK6yOM0EUJP9SlGj20xpY364Ixrh9apCORVZO
         B5xw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772000128; x=1772604928; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fRp4t0j/86MYJauHT8JmZMZ8uXCSwHALvLOqAznr3r0=;
        b=L+71VtvuzREUsV2CsjilYnuiYUHE1HWAx4D7EqnLHRIYaUPdQTuWMPKkVLZ2HDF2+F
         olSt1kJ4TKvwyg6y4db9lu7WCWkSFkNF57H1UBrzFbPj1FdvKhfGanv6CTMC1i6TPAyD
         IfoxCnanNkhSd7LWK6mgRbF8IJ28+/TZ1BdeZPFrEGhsktufvBL0IfMvYmuIuSOULkMK
         FM+Qa55uu+nBDSCj/IjyMc7Lks1cTYVDclyPqjR8IOHo3S5mgl3DMizIUgjTNrpNOEt3
         sqHGFbPFaj2HpRGXF0jo9lzvUeesPnSSdS/ysbMiSnySemnTNozgswSK4kCobO7q5mnR
         nuNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772000128; x=1772604928;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fRp4t0j/86MYJauHT8JmZMZ8uXCSwHALvLOqAznr3r0=;
        b=q59ZX2pbnoRDwqqdsRXQwhIcEoIUH5kneKEH6WcG9SM7vqQ6UrB+DHiQQDV122BLBP
         +x55RXQyO4hZOtegnv6hPYN5mZlmwQv47PMhpz2dMkPTNEtNPjRhSD/2iUoJQWV5Elet
         tHBocdVxHpF56NjahA4tkLpXT8nLMlpk0tuuSdw2QC/X8IIM4P988wUscfm6WWoUffPt
         2Psh3DTpNfEswi6BbbhpekIEDGsyAZXRDcBnL3T0NqXSXwy/Q5UNtOqRJhxX4teoBsvi
         O7CugWh80JCdXYzIM40hCFI71Pan/Fo97RCHFoUNxSj1hoSkO1ne3Gqu1Ikw2aXN+X70
         Vgqw==
X-Forwarded-Encrypted: i=1; AJvYcCUnWsFLg5e9//xmLEJWtvvOveGn4lzqjcTsqPjXFVI6Mw5bBwM/5aga97BVaZOJBajLPa2PAmch@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6RKCrDM/abVVBzjxqsFgWaFZoowb2si3yYycyMy7OdLv/BWh6
	9g2H08AHr6J10pnaBlOJLLfGB3zcRSnu7HWLsnUKnyb3bwvp5p9cCULKmSfLezhTy4QZXS1EzCj
	vbe1rYob2YHySFX6Zv9B/7xUyKmU1snaoxOEwjNFTr89v8QEySRWg
X-Gm-Gg: ATEYQzwFhKobNZ7JqFHt7D1txfKQWGb15TVUeKbLtUa922Zgh0TeYBs56dY0xSXrsDN
	TmAL2catCm3WKjRJAahsPwxkXGoHQlAyexFuPwFemTMEtI6jUuD+LsvNjOoLX5QK5AeFmIsjg3K
	V9qkqjNHYeYy/GnS3F09jlPTyVxgM1hQmFjELGzjpoI+Z1icHCkqKicuykhPMZ0BPmYr8RTDBie
	kdJXZD6y9uB1LT6JGo42HquOQ242CVXfxRqUtt44h+3SRsUpQUS53LwQUJiPxcVhdGhU7gpycrv
	MoKOJaPkPL1Ll4HreT9xnvGg/6r+oZQx10wSustdma2ZJYo0aetrrOP7BdbLO6ia8gFM9tmdSTj
	FAi/t
X-Received: by 2002:a5d:5f82:0:b0:436:233c:c7c2 with SMTP id
 ffacd0b85a97d-4398fa8f511mr1672763f8f.16.1772000127528; Tue, 24 Feb 2026
 22:15:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260225012348.915798704@linuxfoundation.org> <20260225012349.617596661@linuxfoundation.org>
In-Reply-To: <20260225012349.617596661@linuxfoundation.org>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 25 Feb 2026 07:15:16 +0100
X-Gm-Features: AaiRm50BRHVY9dnqLA8QxSQ_aFijAWbIo40KFzJUtey0yViutItZBb79eS6PYcU
Message-ID: <CAPjX3Fe8XOkja2L8dv30s4pnzSQDsAExXY5Nh8MFQoPreQUeAQ@mail.gmail.com>
Subject: Re: [PATCH 6.18 026/641] btrfs: add orig_logical to btrfs_bio for encryption
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 25 Feb 2026 at 02:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.18-stable review patch.  If anyone has any objections, please let me know.

Hi Greg,

This one is a preparation for new feature development, it's not really
worth the stable branch. Backporting it makes no sense.

Have a nice day,
Daniel

> ------------------
>
> From: Josef Bacik <josef@toxicpanda.com>
>
> [ Upstream commit bd45e9e3f6232f76fa9bd0e40c1e3409e4449f5e ]
>
> When checksumming the encrypted bio on writes we need to know which
> logical address this checksum is for.  At the point where we get the
> encrypted bio the bi_sector is the physical location on the target disk,
> so we need to save the original logical offset in the btrfs_bio.  Then
> we can use this when checksumming the bio instead of the
> bio->iter.bi_sector.
>
> Note: The patch was taken from v5 of fscrypt patchset
> (https://lore.kernel.org/linux-btrfs/cover.1706116485.git.josef@toxicpanda.com/)
> which was handled over time by various people: Omar Sandoval, Sweet Tea
> Dorminy, Josef Bacik.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Daniel Vacek <neelx@suse.com>
> Reviewed-by: David Sterba <dsterba@suse.com>
> [ add note ]
> Signed-off-by: David Sterba <dsterba@suse.com>
> Stable-dep-of: b39b26e017c7 ("btrfs: zoned: don't zone append to conventional zone")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/btrfs/bio.c       | 10 ++++++++++
>  fs/btrfs/bio.h       |  2 ++
>  fs/btrfs/file-item.c |  2 +-
>  3 files changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> index 1286c1ac19404..c3d860a2bca42 100644
> --- a/fs/btrfs/bio.c
> +++ b/fs/btrfs/bio.c
> @@ -94,6 +94,8 @@ static struct btrfs_bio *btrfs_split_bio(struct btrfs_fs_info *fs_info,
>         if (bbio_has_ordered_extent(bbio)) {
>                 refcount_inc(&orig_bbio->ordered->refs);
>                 bbio->ordered = orig_bbio->ordered;
> +               bbio->orig_logical = orig_bbio->orig_logical;
> +               orig_bbio->orig_logical += map_length;
>         }
>         bbio->csum_search_commit_root = orig_bbio->csum_search_commit_root;
>         atomic_inc(&orig_bbio->pending_ios);
> @@ -726,6 +728,14 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
>                 goto end_bbio;
>         }
>
> +       /*
> +        * For fscrypt writes we will get the encrypted bio after we've remapped
> +        * our bio to the physical disk location, so we need to save the
> +        * original bytenr so we know what we're checksumming.
> +        */
> +       if (bio_op(bio) == REQ_OP_WRITE && is_data_bbio(bbio))
> +               bbio->orig_logical = logical;
> +
>         map_length = min(map_length, length);
>         if (use_append)
>                 map_length = btrfs_append_map_length(bbio, map_length);
> diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
> index 9a44b86d561b1..488cdbdd9e2f8 100644
> --- a/fs/btrfs/bio.h
> +++ b/fs/btrfs/bio.h
> @@ -59,6 +59,7 @@ struct btrfs_bio {
>                  * - pointer to the checksums for this bio
>                  * - original physical address from the allocator
>                  *   (for zone append only)
> +                * - original logical address, used for checksumming fscrypt bios
>                  */
>                 struct {
>                         struct btrfs_ordered_extent *ordered;
> @@ -67,6 +68,7 @@ struct btrfs_bio {
>                         struct completion csum_done;
>                         struct bvec_iter csum_saved_iter;
>                         u64 orig_physical;
> +                       u64 orig_logical;
>                 };
>
>                 /* For metadata reads: parentness verification. */
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 4b7c40f05e8f9..48f444bde5fa9 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -815,7 +815,7 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
>         if (!sums)
>                 return -ENOMEM;
>
> -       sums->logical = bio->bi_iter.bi_sector << SECTOR_SHIFT;
> +       sums->logical = bbio->orig_logical;
>         sums->len = bio->bi_iter.bi_size;
>         INIT_LIST_HEAD(&sums->list);
>         bbio->sums = sums;
> --
> 2.51.0
>
>
>
