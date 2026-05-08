Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA58C2C027F
	for <patches@lists.linux.dev>; Fri,  8 May 2026 08:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778227644; cv=none; b=bxGirQsIuQmwHw084XC+srXOQacQBagy7WkYFu1EOiYWcIjY1UgcbZJ8Nh2sjnjnohnykkNWuqKZ74unJAB0tROzy17UlSosH1hMZXNRW/wQtinLEw66YHFz4Iu+GQnuI5H7IvdApSK0ocYw9mso0sf3AlHtSjN6X74WGPW6J1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778227644; c=relaxed/simple;
	bh=c3xHH694o+zphEIQVN9RVAb0WxSsn7choMJU73Az8Kg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=MQQkXjo95kI1ksSc1zQBxckGWC8P1SuN+4KhAGHDdEZd5vj/XSW9EdtzsfeW04y4msmdioK5rTBrAdDs+YRZNZsmsAO0arIrY38Xkj58zOEmgUNTxdQaR8BnApjSXi3S0JhH38BKRDzF7wC6u++ADyB7PXcvk3teSRIx/P1BPOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=Hc+dUiRz; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="Hc+dUiRz"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ba4a1a0325so11929765ad.0
        for <patches@lists.linux.dev>; Fri, 08 May 2026 01:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1778227641; x=1778832441; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NE9SvXJ/p2OOR2/6OIE6c5VL6XNI0jB0FPluXe8xKDk=;
        b=Hc+dUiRzAUqBIIq5Gc2br8YFSrXcl9wPHCEX3Ydg5BARArOLUpNUvXCNMUcTUozHMd
         NpcOcHKze3hjk1yl3tB7fBFn+8vqifH2XAZsw//18P7BldK6KHTWHwFifOolYVFS/rtq
         HXsciC7PXjgEq4T9lB5Q84gpMZQ+HqZy7I4GKrP6HwEkTx0ipJhbyNsoob/wFiUuMnRR
         WfC/+dhywG5Xli4bDAFrOOf6oeVmKmePpFO3FyNmukb/EkuhC3hCLBXrglDoLPE0Lyd5
         UF/Qapv9ZdjO6Gsxgzmlg8u6VqMpt5JXEl5WHAQcabCs+wZ/SlI6l46uyAHz5QtevENb
         rUvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778227641; x=1778832441;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NE9SvXJ/p2OOR2/6OIE6c5VL6XNI0jB0FPluXe8xKDk=;
        b=CspCfOXjRJKzo9A1FL6JN4N0CduVTRgGmFibV/uYLgJkdlN2GFA8ys7aBCpCCs39e+
         i+sVmjvhwsyZRXlZd5wAzTJ2RyHTvf3DPYVQFEe0ahaurR1bx7xzcWSpuhyeM4ZIHrzk
         8YQH8N2fYHrYJI4HTXoSjfsxIS33BnGKHPBdxRq2pFi0WHO39vCOI7AMlV0VRWXNX7Jh
         k2x6SO4ozB8GctZVLw5b7RAf0tro1di3lmVIyrv7Bie5Qvcqxh1Q8X25xNiyuWiFNfly
         6K/3U+S3zktC/143x8eHqHa7rfac5DCvNPBmWAFJ+T1I/vCkw3Gd+2raA/BBZc4yFQWN
         VzVA==
X-Forwarded-Encrypted: i=1; AFNElJ8nzPi1j+6+wv4nwOzYdmuwdBfVSJEuaYby8OyRf7cVRikT0/y6sG3EB2US9JqzFkrVSWniVDT+@lists.linux.dev
X-Gm-Message-State: AOJu0Yyn0FqDNlDuA1vfMXBd27ksaYT6FH2zmnlYs2BPmKKCi1DwG2n7
	iru4RHlCKzRwYKTUEiOxmq62ecJOMT7IjvuOo/WJ5PedkCEL45tRd2t5Fx6l0ejsTQI=
X-Gm-Gg: Acq92OERDlei90MmzzwE5oEDI7EI5bqcNuKzoLDiqNr+mei2EPSPBrgj7RXE8KMIm5L
	+hHEkED2Y96OlogswqBq6Bi5sWHHC30+te4iXgibaolgLoFiklTPSDt+yowXy0rKOl+COlvo4Mv
	QgYbPvyZA1fIg7Lgyx4ARErutYp39Xh/aVQ91jhUMWUPWS0xWmQWrNg1K1Id4pU1mLbN6yS2uZE
	lG8oq4BJ7w4RkCEVfykTfmP9SsGXSr1wke+ScLGZi+WBnmRH+X1eFPq3NXwPRwwWBvUFKxj2QO0
	gejZpjadmbL1Twufv2JRKdIEB7Ugw6Q+a/gJoMVzEWVKaMgDB1/NupK5wvqsfUQKhSy4vGspICu
	VH4PQDmQ1nIg7A0ng8RR6zcOhfGcpxPMzFV59IGByl+aE3bMfsLHbqaJYXsJ6HU4ekmwlOkLhc6
	FdmFo8UtCRxTok/F4KYqtFsE16VFGcEnmnHzBEGXCEfzdnNDGcpuJJ8bF4pEayRynHaM//i5qIr
	5T4sg==
X-Received: by 2002:a17:903:3887:b0:2ba:83f8:7b7b with SMTP id d9443c01a7336-2ba83f87cfcmr106624425ad.33.1778227640861;
        Fri, 08 May 2026 01:07:20 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e72668sm13300185ad.58.2026.05.08.01.07.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 May 2026 01:07:20 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH 6.6.y] ext4: validate p_idx bounds in
 ext4_ext_correct_indexes
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260508065845.3031006-1-jianqkang@sina.cn>
Date: Fri, 8 May 2026 02:07:08 -0600
Cc: gregkh@linuxfoundation.org,
 stable@vger.kernel.org,
 tejas.bharambe@outlook.com,
 patches@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 tytso@mit.edu,
 linux-ext4@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1C2F44AA-6D22-4AB1-9653-68DDDAFB3E06@dilger.ca>
References: <20260508065845.3031006-1-jianqkang@sina.cn>
To: Jianqiang kang <jianqkang@sina.cn>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On May 8, 2026, at 00:58, Jianqiang kang <jianqkang@sina.cn> wrote:
>=20
> From: Tejas Bharambe <tejas.bharambe@outlook.com>
>=20
> [ Upstream commit 2acb5c12ebd860f30e4faf67e6cc8c44ddfe5fe8 ]
>=20
> ext4_ext_correct_indexes() walks up the extent tree correcting
> index entries when the first extent in a leaf is modified. Before
> accessing path[k].p_idx->ei_block, there is no validation that
> p_idx falls within the valid range of index entries for that
> level.
>=20
> If the on-disk extent header contains a corrupted or crafted
> eh_entries value, p_idx can point past the end of the allocated
> buffer, causing a slab-out-of-bounds read.
>=20
> Fix this by validating path[k].p_idx against EXT_LAST_INDEX() at
> both access sites: before the while loop and inside it. Return
> -EFSCORRUPTED if the index pointer is out of range, consistent
> with how other bounds violations are handled in the ext4 extent
> tree code.

Thank you for your patch.

Do you have an image with this corruption in place?  Does e2fsck fix
the issue? If not, then ext4 will abort the filesystem when this issue
is hit, and if e2fsck can't fix it then it will just be hit again.

Cheers, Andreas

> Reported-by: syzbot+04c4e65cab786a2e5b7e@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D04c4e65cab786a2e5b7e
> Signed-off-by: Tejas Bharambe <tejas.bharambe@outlook.com>
> Link: =
https://patch.msgid.link/JH0PR06MB66326016F9B6AD24097D232B897CA@JH0PR06MB6=
632.apcprd06.prod.outlook.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@kernel.org
> [ Minor conflict resolved. ]
> Signed-off-by: Jianqiang kang <jianqkang@sina.cn>
> ---
> fs/ext4/extents.c | 15 +++++++++++++++
> 1 file changed, 15 insertions(+)
>=20
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 7626cf2b07f1..a94798e23c1a 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1743,6 +1743,13 @@ static int ext4_ext_correct_indexes(handle_t =
*handle,
>  	err =3D ext4_ext_get_access(handle, inode, path + k);
>  	if (err)
>  	return err;
> +	if (unlikely(path[k].p_idx > EXT_LAST_INDEX(path[k].p_hdr))) {
> +		EXT4_ERROR_INODE(inode,
> +				 "path[%d].p_idx %p > EXT_LAST_INDEX =
%p",
> +				 k, path[k].p_idx,
> +				 EXT_LAST_INDEX(path[k].p_hdr));
> +		return -EFSCORRUPTED;
> +	}
>  	path[k].p_idx->ei_block =3D border;
>  	err =3D ext4_ext_dirty(handle, inode, path + k);
>  	if (err)
> @@ -1755,6 +1762,14 @@ static int ext4_ext_correct_indexes(handle_t =
*handle,
>  		err =3D ext4_ext_get_access(handle, inode, path + k);
>  		if (err)
>  			break;
> +		if (unlikely(path[k].p_idx > =
EXT_LAST_INDEX(path[k].p_hdr))) {
> +			EXT4_ERROR_INODE(inode,
> +					 "path[%d].p_idx %p > =
EXT_LAST_INDEX %p",
> +					 k, path[k].p_idx,
> +					 EXT_LAST_INDEX(path[k].p_hdr));
> +			err =3D -EFSCORRUPTED;
> +			break;
> +		}
>  		path[k].p_idx->ei_block =3D border;
>  		err =3D ext4_ext_dirty(handle, inode, path + k);
>  		if (err)
> --=20
> 2.34.1
>=20


Cheers, Andreas





