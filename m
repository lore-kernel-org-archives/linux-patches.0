Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C303A7D98
	for <patches@lists.linux.dev>; Tue, 16 Jun 2026 22:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781649113; cv=none; b=FDtrRTQLdNwn9R5SmvbvX8rimddw7SZc2vBO4WMN03/xj0NPsSvfxcACmiOwD2y5FebV0iV8xpUinEjOkPMTLwoDe/f3W0K7d3X1AVSSZ0upi+FNeK0xHUNCn71r46uTu8966SVuKhfeLdTLpF6ipEoCcMzrzPgGhkkFYV2oPHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781649113; c=relaxed/simple;
	bh=VU19L9VhBp29ZgoIzQqelLKNU3/ihAvyobAMFTRTZYY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZagFPbrIV/zdFfZEvoAAHtClrYk9FFaPKhiAVLfjjksiCXnKR7Kuca9d9Pm2g92OHhaiJJ+gNmczqQFqpWHOQ3B47FCSuHyiTgNedOprBeZ4QVuuPFhrbfaiBd8rPv9qBFycoHBZXs/yPhn0wZaM4fE2pOA+T89Cl1oo7HXAz0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=networkplumber.org; spf=pass smtp.mailfrom=networkplumber.org; dkim=pass (2048-bit key) header.d=networkplumber-org.20251104.gappssmtp.com header.i=@networkplumber-org.20251104.gappssmtp.com header.b=I1prZ9HC; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=networkplumber.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=networkplumber.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=networkplumber-org.20251104.gappssmtp.com header.i=@networkplumber-org.20251104.gappssmtp.com header.b="I1prZ9HC"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-30bbb1bc064so2254158eec.1
        for <patches@lists.linux.dev>; Tue, 16 Jun 2026 15:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20251104.gappssmtp.com; s=20251104; t=1781649112; x=1782253912; darn=lists.linux.dev;
        h=mime-version:references:in-reply-to:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vEVRhG8WRFRWx8x2gQESmOcBj5/p+0wIVNBHGHrbrIs=;
        b=I1prZ9HCC4PMG4zSQCPQaW+wkQTSxekgkIrkUmJSlYRubpYJA08MZy+xXKUV+yzShN
         rhe9k4lEKTGwZcUXswkkInibHqQP2g7lkHNwtrvc/myRF3vjdagp+zbIu0buvdocn+4B
         uv/jusmgNCggRSKD6Jw/VS2Mylo6DtnZGYU1OoP8HOLQZn9zquNBAkMBPwA5FbZknRid
         AdXKQbEYlQEr6VnDXUK4f8e4I0chHOFej0+UrkNPmUAZHTTx2q68oeAkOPMPXk/n0rwK
         1KeWldC0crPDr2jIDzhCOip8a0oCOkxxj5Xozx+a1MPhqMJKiV7vJtbUleEkn1pUCBse
         Lo+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781649112; x=1782253912;
        h=mime-version:references:in-reply-to:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vEVRhG8WRFRWx8x2gQESmOcBj5/p+0wIVNBHGHrbrIs=;
        b=ksQ/b2lehXWNCeTDyDO5I0zaUJhX+kJumgAXs5fqrSWG9AJ/cWIIv4JjrRerZnniib
         2JDdXuZ3TR433BBXm2/IuwLb94WUInrJzDZrYDepxj/O4FVw/SSutXXRRZSBuWm66a1X
         O0thDrlbZgY/vDe48KLRkc20vEA4YtwUq766j9Z+HWKtZGI4u9MYvkL3qz4n6haFVTis
         nGXYdZ5WdtNkkUwXfsoyQ+Vr4zQyqkh1g6Pu1obr+OgH+UtstPsQKuCOZWeTxzXatqXb
         O0BpCwUZeO622pJqEk/hU3uq0HRTFE0q2gvnBQV7y5BWuyUrUTEE1+Nzt8UTQjHxdJWK
         pRNw==
X-Forwarded-Encrypted: i=1; AFNElJ8/1k2jTD4m48RCoKvgaqx9v1U3ftHDk2QAK9aXUujU0L5T3Ibzle8bSV1Au6TVpv9Ok1PBJz4k@lists.linux.dev
X-Gm-Message-State: AOJu0Yw4u427NwnEeRijZdiIl7p8S1MCdcS3Hz87CQ5tnMCuHI817Nni
	TPRrBkZUlv2wpKMgCdTmpz/m3f/JkaxVuE+TMtou2tpIa7Abi5QLX0IY5PobBSyrHqY=
X-Gm-Gg: AfdE7cmlZJsnaPnphcqw+i5h3hNbhnNcBKcwxDnOel3ZB9tpcmWW/xcNt/D63CnAfBG
	sKNgHjlVkbAl6HaNWHxsQzdTlTxIBI8Y1I+aWksNjBpnVgwKxAWOjQPudj2X3NeOKfopkBrAguj
	3OFW/L5ZeB7NDI/OA65RMq6qeX0BztGB8vZOmdoQ/0Kn5s2OfQxniT5moJn5a/p5jbhE1wfzmPa
	Ddp3qnZhTba5qFsfr997WOMTrVPOHyep9Vv/ZBynWHpPNLLTkwwFWz25lsralZaDFWsxOkNm2G2
	BMX/Gwd6QD3pU6a/h2ln2eJjrXVBpNA+K+ag884vkWk+/wRZclEP50wIaisjAdAJd/H3cP+ANFf
	wkkt6KagIAOf0fUz+uY1+N4nawRS9Dpd1/uvCfpq+v44D6f6IWV7lzWt5zJBrBmLZ2JhcISdwmA
	vQgZG3Y075aU+nhtrDrPn4z32a7yjsHJz6DFxsAb1cCNg+dSXKKD8XwN3E1u1bvpU+2CeXiVXkK
	6I=
X-Received: by 2002:a05:7300:6ca7:b0:304:819f:502b with SMTP id 5a478bee46e88-30bc9ab09e6mr845994eec.9.1781649111684;
        Tue, 16 Jun 2026 15:31:51 -0700 (PDT)
Received: from phoenix.local (204-195-96-226.wavecable.com. [204.195.96.226])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30bbcb11310sm2679964eec.14.2026.06.16.15.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 15:31:51 -0700 (PDT)
Date: Tue, 16 Jun 2026 15:31:46 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, Ji-Soo Chung <jschung2@proton.me>, Gerlinde 
 <lrGerlinde@mailfence.com>, zyc zyc <zyc199902@zohomail.cn>, Manas Ghandat
  <ghandatmanas@gmail.com>, Jamal Hadi Salim  <jhs@mojatatu.com>, Paolo
 Abeni <pabeni@redhat.com>, Sasha Levin  <sashal@kernel.org>
Subject: Re: [PATCH 6.1 033/522] net/sched: Revert "net/sched: Restrict
 conditions for adding duplicating netems to qdisc tree"
Message-ID: <20260616153146.461b425c@phoenix.local>
In-Reply-To: <cb2e59a48887f106a57c3fbef66d5a164b8e2f5f.camel@decadent.org.uk>
References: <20260616145125.307082728@linuxfoundation.org>
	<20260616145127.216541751@linuxfoundation.org>
	<cb2e59a48887f106a57c3fbef66d5a164b8e2f5f.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/RosCjQZuwVCz_GAYjA0uSf/";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/RosCjQZuwVCz_GAYjA0uSf/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Jun 2026 00:17:03 +0200
Ben Hutchings <ben@decadent.org.uk> wrote:

> On Tue, 2026-06-16 at 20:23 +0530, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Jamal Hadi Salim <jhs@mojatatu.com>
> >=20
> > [ Upstream commit eda0b7f203bb166c98d1418b204135bd566ac83b ]
> >=20
> > This reverts commit ec8e0e3d7adef940cdf9475e2352c0680189d14e.
> >=20
> > The original patch rejects any tree containing two netems when
> > either has duplication set, even when they sit on unrelated classes
> > of the same classful parent. That broke configurations that have
> > worked since netem was introduced.
> >=20
> > The re-entrancy problem the original commit was trying to solve is
> > handled by later patch using tc_depth flag.
> >=20
> > Doing this revert will (re)expose the original bug with multiple
> > netem duplication. When this patch is backported make sure =20
>                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > and get the full series. =20
>   ^^^^^^^^^^^^^^^^^^^^^^^
> [...]
>=20
> That whole series was applied as:
>=20
> 98b34f3e8c34 net: Introduce skb tc depth field to track packet loops
> eda0b7f203bb net/sched: Revert "net/sched: Restrict conditions for adding=
 duplicating netems to qdisc tree"
> b213a4c6074f Revert "selftests/tc-testing: Add tests for restrictions on =
netem duplication"
> 9552b11e3eda net/sched: fix packet loop on netem when duplicate is on
> db875221ab08 net/sched: Fix ethx:ingress -> ethy:egress -> ethx:ingress m=
irred loop
> a005fa5d7502 net/sched: act_mirred: Fix blockcast recursion bypass leadin=
g to stack overflow
> e80ad525fc7e net/sched: act_mirred: Fix return code in early mirred redir=
ect error paths
> d38dc56a0225 selftests/tc-testing: Add mirred test cases exercising loops
> 0f6e00aa5f65 selftests/tc-testing: Add netem test case exercising loops
>=20
> You included most of those in 6.12.93 and 7.0.12, but for the older
> branches and 6.18 I'm only seeing this one.
>=20
> Ben.
>=20

LGTM
The important part is to pick up the packet loop detection in netem and mir=
red

--Sig_/RosCjQZuwVCz_GAYjA0uSf/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEn2/DRbBb5+dmuDyPgKd/YJXN5H4FAmoxztIACgkQgKd/YJXN
5H5rQQ/9EqFJenoJAur59VabAcRXTLuA8lRW/OlsDkt9hwJyzJmZQsKEgKcWYfEs
j3j3fLcdTq1VjVlFn1KlB4TDGSOqgIMGXNS9Pq2xJZBuZBIYZ58uq6sM0ys+W+6g
sARfFmcsRwQh2C3j8Kv5qmEXukQ7LnHInQZMPuC1DnsBK1KYxhAmSNA7PUoNh9s9
M91rhiIscfu3d8Qakh49JYsHMb8kn35brnJtYIE+qWFTS9f+QCMJRvdq7+EFt3qo
nrCPduyKfeMMBCI5Tmi7h9jA8W58thSZ6CPApNdkoXjU6K6XLI9HvM5y/clVTk7F
J1dE+LbTMixoSQJvom41mtQQaBk8m0st/xOM2oYzDkYLryYyNuuaWa6QMPDCEcwx
BUqI1CvW8kf2mQjfU+rxsnUboI88YlwygIPN2+WuANMZ6dKg7YsGq6TyJdEqpAqe
wwt67NQ7xrzDzt4Eh6UZzh6eO79LuPuw5lx501WueOWLWjmbhXVjpccqPaTmAKGO
UTE7/s60yWnLWKWBzb24V4omkpeqBjn9BFPPvBbtwJimJXFUd5ZDNi1YotglkG63
dQW7jhhfWI01zMBm444a9ypvvA2S/BpuGbedhr+1CGAdeCu9gsleHdBT+2xPYyf7
drrS9ZPXBeLrCHHahsOQQ7TGmfgMyLl6/nl8cQL2XF5EF/6GE70=
=Ynb8
-----END PGP SIGNATURE-----

--Sig_/RosCjQZuwVCz_GAYjA0uSf/--
