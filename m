Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371A41D7E5C;
	Mon, 13 Apr 2026 20:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776112612; cv=none; b=UiXvzNVgXByD3t/h3do37Q0oc5Gu1Sw6WT8G3z81sBuZ83ay1To5cj4TK0F6zcFeKsf6a+qtvq1pJQtKPF9eExXsWaWRNHVmlPd4OeUgkvwYH/iKBbUUGbdU03tQGyOtAIEDDFH6z7u7E9NFTUZqhvsGCvYQk+m55TEvEN5QQT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776112612; c=relaxed/simple;
	bh=7igEk5LlGaHvAIFJjUzN60iNrULKtkSkCfkWpZvv9Fk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dF2bpwLMvd5NV417pt5lwmxql+9cmUwNptvHDrVyoeIQf0hv3SUf4MQzhJXD6LAbvs5jIV6Ut1VvlNeJYLjAwF8MzEFBbtp5CuuA2hveM9+jxuxKDGxePXxO8SDuStEdj6wym5qiCpmxgqlh8JolcM2KCXOFOTu7txEgXGOZhzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wCO1Y-004mwT-2j;
	Mon, 13 Apr 2026 20:36:47 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1wCO1W-00000002fvn-0t0F;
	Mon, 13 Apr 2026 22:36:46 +0200
Message-ID: <d23195793d7f1cec4c8ea1b1a5e29fb6051211ef.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 419/491] mm/hugetlb: make detecting shared pte more
 reliable
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Miaohe Lin <linmiaohe@huawei.com>, Lukas
 Bulwahn	 <lukas.bulwahn@gmail.com>, Mike Kravetz <mike.kravetz@oracle.com>,
 Muchun Song	 <songmuchun@bytedance.com>, Andrew Morton
 <akpm@linux-foundation.org>,  "David Hildenbrand (Arm)"	
 <david@kernel.org>, Sasha Levin <sashal@kernel.org>
Date: Mon, 13 Apr 2026 22:36:40 +0200
In-Reply-To: <20260413155834.712660018@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
	 <20260413155834.712660018@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-kVxSadBaUdsS41IkQu67"
User-Agent: Evolution 3.56.2-9 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-kVxSadBaUdsS41IkQu67
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2026-04-13 at 18:01 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Miaohe Lin <linmiaohe@huawei.com>

Missing "commit 3aa4ed8040e1535d95c03cef8b52cf11bf0d8546 upstream."

Ben.

> If the pagetables are shared, we shouldn't copy or take references.  Sinc=
e
> src could have unshared and dst shares with another vma, huge_pte_none()
> is thus used to determine whether dst_pte is shared.  But this check isn'=
t
> reliable.  A shared pte could have pte none in pagetable in fact.  The
> page count of ptep page should be checked here in order to reliably
> determine whether pte is shared.
>=20
> [lukas.bulwahn@gmail.com: remove unused local variable dst_entry in copy_=
hugetlb_page_range()]
>   Link: https://lkml.kernel.org/r/20220822082525.26071-1-lukas.bulwahn@gm=
ail.com
> Link: https://lkml.kernel.org/r/20220816130553.31406-7-linmiaohe@huawei.c=
om
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> (cherry picked from commit 3aa4ed8040e1535d95c03cef8b52cf11bf0d8546)
> [ David: We don't have 4eae4efa2c29 ("hugetlb: do early cow when page
>   pinned on src mm", so there are some contextual conflicts. ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  mm/hugetlb.c | 19 +++++++------------
>  1 file changed, 7 insertions(+), 12 deletions(-)
>=20
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 99a71943c1f69..a2cab8f2190f8 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3827,7 +3827,7 @@ static bool is_hugetlb_entry_hwpoisoned(pte_t pte)
>  int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src=
,
>  			    struct vm_area_struct *vma)
>  {
> -	pte_t *src_pte, *dst_pte, entry, dst_entry;
> +	pte_t *src_pte, *dst_pte, entry;
>  	struct page *ptepage;
>  	unsigned long addr;
>  	int cow;
> @@ -3867,27 +3867,22 @@ int copy_hugetlb_page_range(struct mm_struct *dst=
, struct mm_struct *src,
> =20
>  		/*
>  		 * If the pagetables are shared don't copy or take references.
> -		 * dst_pte =3D=3D src_pte is the common case of src/dest sharing.
>  		 *
> +		 * dst_pte =3D=3D src_pte is the common case of src/dest sharing.
>  		 * However, src could have 'unshared' and dst shares with
> -		 * another vma.  If dst_pte !none, this implies sharing.
> -		 * Check here before taking page table lock, and once again
> -		 * after taking the lock below.
> +		 * another vma. So page_count of ptep page is checked instead
> +		 * to reliably determine whether pte is shared.
>  		 */
> -		dst_entry =3D huge_ptep_get(dst_pte);
> -		if ((dst_pte =3D=3D src_pte) || !huge_pte_none(dst_entry))
> +		if (page_count(virt_to_page(dst_pte)) > 1)
>  			continue;
> =20
>  		dst_ptl =3D huge_pte_lock(h, dst, dst_pte);
>  		src_ptl =3D huge_pte_lockptr(h, src, src_pte);
>  		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
>  		entry =3D huge_ptep_get(src_pte);
> -		dst_entry =3D huge_ptep_get(dst_pte);
> -		if (huge_pte_none(entry) || !huge_pte_none(dst_entry)) {
> +		if (huge_pte_none(entry)) {
>  			/*
> -			 * Skip if src entry none.  Also, skip in the
> -			 * unlikely case dst entry !none as this implies
> -			 * sharing with another vma.
> +			 * Skip if src entry none.
>  			 */
>  			;
>  		} else if (unlikely(is_hugetlb_entry_migration(entry) ||

--=20
Ben Hutchings
When in doubt, use brute force. - Ken Thompson

--=-kVxSadBaUdsS41IkQu67
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmndU9gACgkQ57/I7JWG
EQlogw//b7pJ4gSJapYq5tv/C7l//byOD0CtEBJsy5B0NmMnfwhiiIXXX2ULeB0C
xWuJCLnWpvDJL4zRHB/3l6HxYfeuzQ2S/hrtrvxKL1jLSABcKBnZ52q8SVhcYKmZ
Mdjg/MduBWo3G4in/8rw2SktuhCkoyWvBq5gVsGDgbPPu8k1u4jTL2gzJ8CjFf0D
LLpggR2z348DhNbi1JUEESAhutQLLjMp64viZAkkvNZTQimg/7dMmRVrPGK5peKQ
/xlU71zEOxzliIh5hRsyVnpRusu7iuWnjvUmA+ALUP8AuotLbanPxsI0j8wPruBw
qURfvo9PC2fMHhWc3TXTFJ5Yd3supuefxXuipE6WYmAkLxWiIQPm3qUTaqb0SOjc
Q9IP5hg5uyqZnOWOSHX8mvtXV16R2fIKPWtQ6/XxkBdJYm6oGiKvq7o1v92eW0cm
0qFJ7XExts4vPnUcKRw3S6MKtiO1ze4kkfBJjtf0p/1u5t3i2qt0FsYpBQyc+wJ6
PSxbXIn4cSvjHIc7yGWXHYodXlt91c0oML73bA/Kebn5fGzCpQZy3bMdRYqrewwd
XBh+7UxXg4ysIiPpqz47EAlmVS8VwHiYtKTmPhU8Pesaix9dk7/YFbu18IP2EzPz
ONxfKaek5he5Cep8Ubnr1/IC24J8H4KMqefW0wdnjbGEeSYscHo=
=KQ13
-----END PGP SIGNATURE-----

--=-kVxSadBaUdsS41IkQu67--
