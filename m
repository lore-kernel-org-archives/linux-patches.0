Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F54250FE
	for <patches@lists.linux.dev>; Sun,  4 Feb 2024 19:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707076257; cv=none; b=McvAFrkNgkXA25leJxUAxy9zlt1BRXpBvmpEVbrN1jZlCtpVeQzP7Un9qctexhIhXf3fGQcjHPe5j8//hKiAhY4nS+sELtwUBRSuBW+jUzf3vpYBobz5jj8UtT2qdHNNypWDG767bzhycsIKkP6B0bc/1Tv9ylqLc3xI0hcVuUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707076257; c=relaxed/simple;
	bh=z/w9gfH04zcLQ/sBmHOlNB9L3NpafK6KtBT4WTl7Ep0=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:References; b=OUhrBKRUNmk2MIh6xZeDV0LI1cDbj5XMmMe2Ty7dHsgl+8xU31BaHeRBXyJhpZ4n5Amk6EvCPcZb+Yi0JgF0UvxiQi+UK4W3JVPlnvI1tq23kH9VwaJxqA2bcaQnL/+SwAOZesXj7LCvB50hXL0LaTtUG+wbGbAAlnm6Xzmkz5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=M5N89e1E; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="M5N89e1E"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240204195047euoutp02c71d3cc90ac4700b096807ed47a03dfc~wwM1q7a5f2312323123euoutp02R;
	Sun,  4 Feb 2024 19:50:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240204195047euoutp02c71d3cc90ac4700b096807ed47a03dfc~wwM1q7a5f2312323123euoutp02R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1707076247;
	bh=dKIufDDtVPQlYSp2thM6QZdj7kz3bnoD18HrhNT4Prc=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=M5N89e1EefyadAzegWoHRQ+VkM+d3C+GoaeSt+Cyjtr/5I7bDhUNGo5g9PrqW5XhU
	 VJk7GBX56Y3YeTSAQbdtftYafjItkHGE5C3wFoPYQ77PVJ/kdWK9ej/OeVWfXLI9TZ
	 8BcJGhkNbN6JgRNLl1H+VJelm8rdlU9aehAD2VoE=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240204195046eucas1p2013a68554c0c6944bd7e114bd730f340~wwM0yGwXT0548605486eucas1p2b;
	Sun,  4 Feb 2024 19:50:46 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id A3.FE.09539.69AEFB56; Sun,  4
	Feb 2024 19:50:46 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240204195045eucas1p23ac6f2fd15ab608754e0d5192c0c0308~wwMz36QWp0548505485eucas1p2f;
	Sun,  4 Feb 2024 19:50:45 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240204195045eusmtrp2d46ce8ad2b941acc11f46e5636f4cd3e~wwMz3a5NG0377803778eusmtrp2L;
	Sun,  4 Feb 2024 19:50:45 +0000 (GMT)
X-AuditID: cbfec7f2-52bff70000002543-ec-65bfea9642c9
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id 25.FB.09146.59AEFB56; Sun,  4
	Feb 2024 19:50:45 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240204195045eusmtip2bb69a1e06935b7478e9d3c6b90f4186c~wwMzpXfrZ2843928439eusmtip2G;
	Sun,  4 Feb 2024 19:50:45 +0000 (GMT)
Received: from localhost (106.210.248.184) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Sun, 4 Feb 2024 19:50:44 +0000
Date: Sun, 4 Feb 2024 20:50:42 +0100
From: Joel Granados <j.granados@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>, kernel test robot
	<oliver.sang@intel.com>, Luis Chamberlain <mcgrof@kernel.org>, Sasha Levin
	<sashal@kernel.org>
Subject: Re: [PATCH 6.7 052/353] sysctl: Fix out of bounds access for empty
 sysctl registers
Message-ID: <20240204195042.lwu5m7cuxl44z5ly@joelS2.panther.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="2srs24doz5lghcwb"
Content-Disposition: inline
In-Reply-To: <20240203035405.449492305@linuxfoundation.org>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsWy7djPc7rTXu1PNbi3mc+iefF6NosbE54y
	Wiz49JfF4vKJS4wWm9ZcY7NYsPERowObx+I9L5k8Nq3qZPPYP3cNu8eLzTMZPT5vkgtgjeKy
	SUnNySxLLdK3S+DKaN20kL1gsnzF8rvXGBsYT0l1MXJwSAiYSLxr9+pi5OQQEljBKPGuI6KL
	kQvI/sIocXjNaXYI5zOjxJ2VW5lBqkAaVn7czwaRWM4ocW3LA2a4qrVHrjBCOFsYJf7MW8YG
	0sIioCJx/NksRhCbTUBH4vybO2CjRASMJfrPzgLbwSywllGit38GO0hCWCBO4sP2ZWBFvAIO
	Euc2zmWCsAUlTs58wgJiMwtUSLy+to8J5AlmAWmJ5f84QMKcAtYSCz6+Y4c4VVli1rIGqLNr
	JU5tucUEsktCoJ9T4sz740wQCReJDfNfskHYwhKvjm+BapaR+L9zPlTDZEaJ/f8+sEM4qxkl
	ljV+heq2lmi58gSqw1HizM92Nkiw8knceCsIcSifxKRt05khwrwSHW1CENVqEqvvvWGZwKg8
	C8lrs5C8NgvhNYiwjsSC3Z/YMIS1JZYtfM0MYdtKrFv3nmUBI/sqRvHU0uLc9NRiw7zUcr3i
	xNzi0rx0veT83E2MwBR2+t/xTzsY5776qHeIkYmD8RCjClDzow2rLzBKseTl56UqifBOEN6b
	KsSbklhZlVqUH19UmpNafIhRmoNFSZxXNUU+VUggPbEkNTs1tSC1CCbLxMEp1cAkl/shuDlp
	/olSDtEPRzzTp/udTNY/n15VKvM8Z9m+h5H7tB1fHX+fdnvNihsXv6ReLq5Le7M98eq9cyIt
	U+Tk1n/jb3m9IlLtdyjTsw0v3dZ9kWxiXPTQyaHvpFmex4L+7dZuvVrHlWZafZt4682HhU93
	bu6oOe6tlxasq3DI9aTzpLtecxkMngZui9/9vXTpz+n//SxkRLt4VKW9Z71azZr7VtP75pGk
	hKh/liuOPkzmYrQ9c9kjXHN+S2H76jvsq/dp3V2xznJFeITB/Fj2f288Vh9S414WOtVu2QyF
	4PKJk3w81Jcuk5BmSTExNfI5YXCoVWWO4EKhmdX+F652+P55lb2l9+wB9cyMJNYkJZbijERD
	Leai4kQAQOAcu9wDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t/xe7pTX+1PNfiynseiefF6NosbE54y
	Wiz49JfF4vKJS4wWm9ZcY7NYsPERowObx+I9L5k8Nq3qZPPYP3cNu8eLzTMZPT5vkgtgjdKz
	KcovLUlVyMgvLrFVija0MNIztLTQMzKx1DM0No+1MjJV0rezSUnNySxLLdK3S9DLuP34NGPB
	RPmKCV0fGBsYT0h1MXJySAiYSKz8uJ+ti5GLQ0hgKaPE9Nn/mSESMhIbv1xlhbCFJf5c64Iq
	+sgosfHVclYIZwujxJdrO8A6WARUJI4/m8UIYrMJ6Eicf3MHLC4iYCzRf3YWO0gDs8BaRone
	/hnsIAlhgTiJD9uXgRXxCjhInNs4lwli6n5GiWcn70AlBCVOznzCAmIzC5RJXHp9DqiIA8iW
	llj+jwMkzClgLbHg4zt2iFOVJWYta4B6oVbi899njBMYhWchmTQLyaRZCJMgwloSN/69xBTW
	lli28DUzhG0rsW7de5YFjOyrGEVSS4tz03OLDfWKE3OLS/PS9ZLzczcxAmN527Gfm3cwznv1
	Ue8QIxMH4yFGFaDORxtWX2CUYsnLz0tVEuGdILw3VYg3JbGyKrUoP76oNCe1+BCjKTAYJzJL
	iSbnA5NMXkm8oZmBqaGJmaWBqaWZsZI4r2dBR6KQQHpiSWp2ampBahFMHxMHp1QDU+qmYP1j
	revsq2yK4p8KfvJeLtq83EBnmrX3s399lza9vuT07GVt67m8Kk2duI8ZOsuvP8xSeb5EprWq
	j2+u8ovsfaf/3LzG8MtWb56wZ5yreGpB3mrOdb7yj6yaBQR+ZhZyt98K+LNzB8MxlYg1+mer
	rmbkaEWU2OR8OuFz9axS+oZVSx8st3dOVG6zDq565dshtOP4hgfJcha1Eax/0kP+TvtbNHF3
	odGCe72RjR2G7tGRhXF2KzncJ2gbKE54vKxQLkDjhuLN+eerZ53WXNthVy6Yv+qcXl+szHW+
	f70fvxpWTyp9YqUWzZC25NG1r2IHthiGVP04JdvQ1K3jKle5webiF5P8EC7dJ0ZKLMUZiYZa
	zEXFiQBFS3XUegMAAA==
X-CMS-MailID: 20240204195045eucas1p23ac6f2fd15ab608754e0d5192c0c0308
X-Msg-Generator: CA
X-RootMTR: 20240203041601eucas1p12b671517d5c94b25fbf7f0870ac4be55
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240203041601eucas1p12b671517d5c94b25fbf7f0870ac4be55
References: <20240203035403.657508530@linuxfoundation.org>
	<CGME20240203041601eucas1p12b671517d5c94b25fbf7f0870ac4be55@eucas1p1.samsung.com>
	<20240203035405.449492305@linuxfoundation.org>

--2srs24doz5lghcwb
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Looks good to me=20

This patch depends on 53f3811dfd5e39507ee3aaea1be09aabce8f9c98  "sysctl:
Use ctl_table_size as stopping criteria for list macro" and
1e887723545e037b5e200e77edf79802f58fc818  "sysctl: Add ctl_table_size to
ctl_table_header" which are both in 6.7 and 6.6.

Best

On Fri, Feb 02, 2024 at 08:02:50PM -0800, Greg Kroah-Hartman wrote:
> 6.7-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Joel Granados <j.granados@samsung.com>
>=20
> [ Upstream commit 315552310c7de92baea4e570967066569937a843 ]
>=20
> When registering tables to the sysctl subsystem there is a check to see
> if header is a permanently empty directory (used for mounts). This check
> evaluates the first element of the ctl_table. This results in an out of
> bounds evaluation when registering empty directories.
>=20
> The function register_sysctl_mount_point now passes a ctl_table of size
> 1 instead of size 0. It now relies solely on the type to identify
> a permanently empty register.
>=20
> Make sure that the ctl_table has at least one element before testing for
> permanent emptiness.
>=20
> Signed-off-by: Joel Granados <j.granados@samsung.com>
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202311201431.57aae8f3-oliver.sang@=
intel.com
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/proc/proc_sysctl.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index 8064ea76f80b..84abf98340a0 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -44,7 +44,7 @@ static struct ctl_table sysctl_mount_point[] =3D {
>   */
>  struct ctl_table_header *register_sysctl_mount_point(const char *path)
>  {
> -	return register_sysctl_sz(path, sysctl_mount_point, 0);
> +	return register_sysctl(path, sysctl_mount_point);
>  }
>  EXPORT_SYMBOL(register_sysctl_mount_point);
> =20
> @@ -233,7 +233,8 @@ static int insert_header(struct ctl_dir *dir, struct =
ctl_table_header *header)
>  		return -EROFS;
> =20
>  	/* Am I creating a permanently empty directory? */
> -	if (sysctl_is_perm_empty_ctl_table(header->ctl_table)) {
> +	if (header->ctl_table_size > 0 &&
> +	    sysctl_is_perm_empty_ctl_table(header->ctl_table)) {
>  		if (!RB_EMPTY_ROOT(&dir->root))
>  			return -EINVAL;
>  		sysctl_set_perm_empty_ctl_header(dir_h);
> @@ -1213,6 +1214,10 @@ static bool get_links(struct ctl_dir *dir,
>  	struct ctl_table_header *tmp_head;
>  	struct ctl_table *entry, *link;
> =20
> +	if (header->ctl_table_size =3D=3D 0 ||
> +	    sysctl_is_perm_empty_ctl_table(header->ctl_table))
> +		return true;
> +
>  	/* Are there links available for every entry in table? */
>  	list_for_each_table_entry(entry, header) {
>  		const char *procname =3D entry->procname;
> --=20
> 2.43.0
>=20
>=20
>=20

--=20

Joel Granados

--2srs24doz5lghcwb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmW/6pIACgkQupfNUreW
QU9fBAv/WsbQklydWYRQrG6WYUPhaOpVQ8UL1ILg3zcSTZ3Aq/zeBopoE2Sf6hHG
EeN6EKxUY6BYZocV/NFsGQHn1Nrx9fpLScX8L0Mpnbu2pQkM/fFuoKOFSvRInb3m
RH5yzb6D3VZ/KmFCkwBj84wbF3of+qermlfPMr3DqknWXxeWBkkYPwQpNlNXY+E7
Q+oL+SGpkdGDpCm2gFlABMKV2dKePBNijIRaSUV0ZpYyMnNxVr9M3DE3iz0euXnd
h/mwbg3nQeyUiC9ZLCz0b7TdqhBlRjkF4v/W+ri+T4Pqxppw/TumXYJLnS4HyByj
LoBqkmdwaibVLLgI+VT3tb5mAuTyA2Tu4sewnbiwsuSLK309ZJb9LhMiUvAOAStv
3dyAh/uhmY3TiL3TRH8pkK0r5upMVQHT3nzIROomMNud+sm6ypPNTRo2x1K6nO5Y
1dUDlo1lOsPhlUTgG4BErCo5TmECqQd0yhTx7/LH4Rfu5S9mNqNP/GVC7luBoVRl
r3FzGnCU
=z+07
-----END PGP SIGNATURE-----

--2srs24doz5lghcwb--
