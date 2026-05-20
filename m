Received: from mail-43100.protonmail.ch (mail-43100.protonmail.ch [185.70.43.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA6034216C
	for <patches@lists.linux.dev>; Wed, 20 May 2026 16:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295935; cv=none; b=UaW/G7p7YNjaoqgIIeNHS7AlgKsU1J8Klj+H9c9AGAJ2k0MSYCSMNLZ6I2JhtrQJS6pQPyxZolmQgoFWvLv4L0JItYMnoNS/gxyoTxAx1aFz1TBm9hoF4yJi0U+4KdxSFKIpDOZ469Y8AMkgb9u+s0FJN6inmh0RNzAC0VZmmKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295935; c=relaxed/simple;
	bh=+Rr0ISzy0ssrmZl04gRbEuVRjYfX8LKr4q0WEoB66Dg=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tF1p8ANnt5EZSsV05aeiUSFcr8PHlVqDlQFHQ8+XLMz8j/faz/bhK+vmBFWZkwbREiRLurr3jAogJARi02oYuC/vCKs7gG/+SHU8XzBL/7/CsQh2Ew/OrrD1wCzzQqHLu8yTBntrlXaIEmQyZkiVOBQ/AxIZ+mU/Y0VLvN6BTZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=bkzGvkgq; arc=none smtp.client-ip=185.70.43.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="bkzGvkgq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1779295923; x=1779555123;
	bh=P9sCHsSL31H/tsSPytPmPu0bk1prX7Ymi40wZ1txJcU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=bkzGvkgqNyUM1mMJZkvLp5HnQqwhqEJcGyV2dRqWceRljkJKjt5TMcH4xm3SrACaP
	 5lWCfjZdYeZAWAYbrYWPrclmOv2TXitc+hiG2m1pHOqi/dJKP6INtWhBHI7QTwPPzC
	 q3EsN1w5pE/kMG2nEvVi0rIMYQsHpDNh78ggpOHZ/eMG/T5m7TQ2HuMEl3Z8XnnML8
	 EYTsIZZqeiCPHZl1d42I2tVh0neVEvzyHs8eZNxc+DmtGOc+Jg5B/E7sBAzM1dY/8D
	 3KGHWTglyTTbttEIQ28mtzS3TL3O42poAOzrLRcehZMSXcWWgpU70yHy0UQvKr1OsB
	 wpEsmmuYlXw+g==
Date: Wed, 20 May 2026 16:51:57 +0000
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
From: Tj <tj.iam.tj@proton.me>
Cc: patches@lists.linux.dev, Chen Cheng <chencheng@fnnas.com>, Paul Menzel <pmenzel@molgen.mpg.de>, Yu Kuai <yukuai@fnnas.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 7.0 0002/1146] md: suppress spurious superblock update error message for dm-raid
Message-ID: <e08a970e-777d-49af-9981-6dde0ced4738@proton.me>
In-Reply-To: <20260520162148.451131860@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org> <20260520162148.451131860@linuxfoundation.org>
Feedback-ID: 113488376:user:proton
X-Pm-Message-ID: 171538a3e7a1fb733f50972d0ad093ebcbee26f2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Tested on v7.0.9 - looks good:

$ journalctl --dmesg --grep md/raid1
May 20 16:48:56 sunny kernel: md/raid1:mdX: active with 2 out of 2 mirrors
May 20 16:48:56 sunny kernel: md/raid1:mdX: active with 2 out of 2 mirrors
May 20 16:48:56 sunny kernel: md/raid1:mdX: active with 2 out of 2 mirrors
May 20 16:48:56 sunny kernel: md/raid1:mdX: active with 2 out of 2 mirrors
May 20 16:48:56 sunny kernel: md/raid1:mdX: active with 2 out of 2 mirrors
May 20 16:48:56 sunny kernel: md/raid1:mdX: active with 2 out of 2 mirrors
May 20 16:48:56 sunny kernel: md/raid1:mdX: active with 2 out of 2 mirrors
May 20 16:48:56 sunny kernel: md/raid1:mdX: active with 2 out of 2 mirrors
May 20 16:48:56 sunny kernel: md/raid1:mdX: active with 2 out of 2 mirrors
May 20 16:48:56 sunny kernel: md/raid1:mdX: active with 2 out of 2 mirrors
May 20 16:48:56 sunny kernel: md/raid1:mdX: active with 2 out of 2 mirrors
May 20 16:48:56 sunny kernel: md/raid1:mdX: active with 2 out of 2 mirrors
May 20 16:48:56 sunny kernel: md/raid1:mdX: active with 2 out of 2 mirrors
May 20 16:48:56 sunny kernel: md/raid1:mdX: active with 2 out of 2 mirrors

Tested-by: Tj <tj.iam.tj@proton.me>

On 20/05/2026 16:04, Greg Kroah-Hartman wrote:
> 7.0-stable review patch.  If anyone has any objections, please let me kno=
w.
>
> ------------------
>
> From: Chen Cheng <chencheng@fnnas.com>
>
> [ Upstream commit eff0d74c6c8fd358bc9474c05002e51fa5aa56ad ]
>
> dm-raid has external metadata management (mddev->external =3D 1) and
> no persistent superblock (mddev->persistent =3D 0). For these arrays,
> there's no superblock to update, so the error message is spurious.
>
> The error appears as:
> md_update_sb: can't update sb for read-only array md0
>
> Fixes: 8c9e376b9d1a ("md: warn about updating super block failure")
> Reported-by: Tj <tj.iam.tj@proton.me>
> Closes: https://lore.kernel.org/all/20260128082430.96788-1-tj.iam.tj@prot=
on.me/
> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
> Link: https://lore.kernel.org/linux-raid/20260210133847.269986-1-chenchen=
g@fnnas.com
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/md/md.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 3ce6f9e9d38e6..c2cc2302d727d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2788,7 +2788,9 @@ void md_update_sb(struct mddev *mddev, int force_ch=
ange)
>   =09if (!md_is_rdwr(mddev)) {
>   =09=09if (force_change)
>   =09=09=09set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> -=09=09pr_err("%s: can't update sb for read-only array %s\n", __func__, m=
dname(mddev));
> +=09=09if (!mddev_is_dm(mddev))
> +=09=09=09pr_err_ratelimited("%s: can't update sb for read-only array %s\=
n",
> +=09=09=09=09=09   __func__, mdname(mddev));
>   =09=09return;
>   =09}
>
> --
> 2.53.0
>
>
>


