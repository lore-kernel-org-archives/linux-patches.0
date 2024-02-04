Received: from smtp0-kfki.kfki.hu (smtp0-kfki.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC50225CE;
	Sun,  4 Feb 2024 15:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707060737; cv=none; b=Wdp+oW74Gkxa9M59gAsqmJ4eVfaE5bv6Wlinq4QsMUaCoRscuoM6avBCeECQFhGj7TcuEjBtCOfoL7JoVe9AkaE1K0l3Q4bI9oMYK5hamnK2QT44h1tiB45WRjnukj1KTX9etTFVtTmo+RKIZztYpbc6LxypaQ24ENvVeDE3IQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707060737; c=relaxed/simple;
	bh=jwDrZsMZ7TVHMuUi91brQ9rocuIOobyLD6+lUJBnvUI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Jm9KWcGR2JqovajM1X1dERZj6jlC2k/pnWQN8UYEKvxdIEfh2Euw460KdP8vKcuP+h7JEk5G/nN/3Go3xvZ6C76vKy6ZjKu1CSTMHgvXFqN7cY0tXwjdurrQsIyVwoa9mHE+2IB1dnasv1JKOtLIvSvL0MGD0Z5fr9iJgwMPwLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=UwIZHIkR; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="UwIZHIkR"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 2EC836740101;
	Sun,  4 Feb 2024 16:24:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=content-id:mime-version:references
	:message-id:in-reply-to:from:from:date:date:received:received
	:received:received; s=20151130; t=1707060267; x=1708874668; bh=K
	ZFufjh9ilb6Wwl4goYBCX1Sb+SwToj3yoyhFgXKpc4=; b=UwIZHIkRmac2TkFnq
	BWIOmrDIcVMOU4pnzfVeLgbCKHr1OKuudZW06A9akTV5E4LAFT8maDyrdIP6VxbI
	tnZwFGcJpLaNIAaX639XuaGESGuK8u5/kgKlyznhTNdSGO5jD2OSIczVCPvAAAY7
	QXbadrDFsErgTfQ0BKd2Iaa3Z4=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
	by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Sun,  4 Feb 2024 16:24:27 +0100 (CET)
Received: from mentat.rmki.kfki.hu (host-94-248-211-167.kabelnet.hu [94.248.211.167])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id E5A0267400FF;
	Sun,  4 Feb 2024 16:24:25 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 803175A2; Sun,  4 Feb 2024 16:24:25 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 766CF268;
	Sun,  4 Feb 2024 16:24:25 +0100 (CET)
Date: Sun, 4 Feb 2024 16:24:25 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Bagas Sanjaya <bagasdotme@gmail.com>, stable@vger.kernel.org, 
    patches@lists.linux.dev, Ale Crismani <ale.crismani@automattic.com>, 
    David Wang <00107082@163.com>, Pablo Neira Ayuso <pablo@netfilter.org>, 
    Sasha Levin <sashal@kernel.org>, 
    =?UTF-8?B?0KHRgtCw0YEg0J3QuNGH0LjQv9C+0YDQvtCy0LjRhw==?= <stasn77@gmail.com>, 
    Linux Regressions <regressions@lists.linux.dev>
Subject: Re: [PATCH 6.6 295/322] netfilter: ipset: fix performance regression
 in swap operation
In-Reply-To: <2024020441-grumpily-crumb-03c3@gregkh>
Message-ID: <303d8488-312a-9fe3-1115-3fe66ff0e688@blackhole.kfki.hu>
References: <20240203035359.041730947@linuxfoundation.org> <20240203035408.592513874@linuxfoundation.org> <Zb81_PFP54xFYQSd@archie.me> <2024020441-grumpily-crumb-03c3@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1393428146-1326496185-1707060111=:224058"
Content-ID: <ea6c5de-9135-1b16-be4d-405d3051726f@blackhole.kfki.hu>
X-deepspam: ham 0%

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1393428146-1326496185-1707060111=:224058
Content-Type: text/plain; charset=UTF-8
Content-ID: <37e15f1d-6934-d83d-ed3e-f68222c6c4d@blackhole.kfki.hu>
Content-Transfer-Encoding: quoted-printable

On Sun, 4 Feb 2024, Greg Kroah-Hartman wrote:

> On Sun, Feb 04, 2024 at 02:00:12PM +0700, Bagas Sanjaya wrote:
> > On Fri, Feb 02, 2024 at 08:06:32PM -0800, Greg Kroah-Hartman wrote:
> > > 6.6-stable review patch.  If anyone has any objections, please let =
me know.
> > >=20
> > > ------------------
> > >=20
> > > From: Jozsef Kadlecsik <kadlec@netfilter.org>
> > >=20
> > > [ Upstream commit 97f7cf1cd80eeed3b7c808b7c12463295c751001 ]
> > >=20
> > > The patch "netfilter: ipset: fix race condition between swap/destro=
y
> > > and kernel side add/del/test", commit 28628fa9 fixes a race conditi=
on.
> > > But the synchronize_rcu() added to the swap function unnecessarily =
slows
> > > it down: it can safely be moved to destroy and use call_rcu() inste=
ad.
> > >=20
> > > Eric Dumazet pointed out that simply calling the destroy functions =
as
> > > rcu callback does not work: sets with timeout use garbage collector=
s
> > > which need cancelling at destroy which can wait. Therefore the dest=
roy
> > > functions are split into two: cancelling garbage collectors safely =
at
> > > executing the command received by netlink and moving the remaining
> > > part only into the rcu callback.
> >=20
> > Hi,
> >=20
> > =D0=A1=D1=82=D0=B0=D1=81 =D0=9D=D0=B8=D1=87=D0=B8=D0=BF=D0=BE=D1=80=D0=
=BE=D0=B2=D0=B8=D1=87 <stasn77@gmail.com> reported ipset kernel panic wit=
h this
> > patch [1]. He noted that reverting it fixed the regression.
> >=20
> > Thanks.
> >=20
> > [1]: https://lore.kernel.org/stable/CAH37n11s_8qjBaDrao3PKct4FriCWNXH=
WBBHe-ddMYHSw4wK0Q@mail.gmail.com/
>=20
> Is this also an issue in Linus's tree?

I'm going to send a patch in my next email which fixes the issue. Sorry,=20
splitting the destroy operation into two halves was not taken into accoun=
t=20
at every location.

Best regards,
Jozsef

--=20
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--1393428146-1326496185-1707060111=:224058--
