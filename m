Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.160.73.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795333175;
	b=EOSQecmHV9BE9axx1niVgb52q4I7FTowyENsBcSjSqsza+vBqldffUNedKPM1GhFUkbm
	 fiderFpTKBepua0d6olfDxbtZB3gCfq/GI0xYbK3NTA27G0yu4U4gkqhsi+v8CzJZ+KLO
	 MGd9vXrgVmlkm8Rly18Ykpz+rvsO90V8aGIXm0hj/9VBh1EuVcarXgshMB42/Ez04vq03
	 YkM3ncOZj1lpo0JYJA0lWden2fhy7Zky68qQWlp8bvbTSsqR7ALnp/s4p64bPHRUF/qjF
	 tmr7e3XutvaYxxtvH8HBDfRXHWmlci2o3mx2dWBYSJ1+8bAoBZJowtoAhPn6/CCs/NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795333175;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:Content-Type;
	bh=bGJ0He+CFqKKITgfeT5yY/QNsxp8dPrI9FvnnrbFMIE=;
	b=kguXO11U5JYszhI8TrhHIkbUas0SWklh1eamYJbCXVRLkTcEH6gPruPY/vN26OpWRGSz
	 rcOUujc7mXGjpLArxFkfiV/ZgpELjDQzxVTPrsoDCQBmXHSZ5HFctEjGrpj73IQqsZH0p
	 55ZPwLOasz4/VRdgQsiVEIcwmnE6Pa2OFmwHUfNKWrBtSuHoR0ofizXL0t0k/hZRE65ZD
	 R0UHY89uGkFIhXht3NsDgdmZL7wRESChnuUMVDEqh/cQJGTPlU6ZloImZZ/pE9K8XC5Bk
	 8w/EwbEFWYZmfAFU1GMlON9mt+KQ2kQCnEPzFbGZT10udXENZ/FVIgQfM23kEiGxciA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=narfation.org;
	spf=pass smtp.mailfrom=narfation.org;
	dkim=pass header.d=narfation.org header.i=@narfation.org header.a=rsa-sha256 header.s=20121 header.b=Kw4HI3RR;
	arc=none smtp.remote-ip=213.160.73.56
Received: from dvalin.narfation.org (dvalin.narfation.org [213.160.73.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA0F606A32C
	for <patches@lists.linux.dev>; Sun, 22 Nov 2026 07:39:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CA0F606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=narfation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=narfation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=narfation.org header.i=@narfation.org header.a=rsa-sha256 header.s=20121 header.b=Kw4HI3RR
Received: by dvalin.narfation.org (Postfix) id 739091FD16;
	Sun, 22 Nov 2026 07:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
	s=20121; t=1795333167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bGJ0He+CFqKKITgfeT5yY/QNsxp8dPrI9FvnnrbFMIE=;
	b=Kw4HI3RRkoJTYQmYG7XSon0MSE9h/iL8rAfrNY3mu8tZ0lrbF9lUKIHaQGvzKsdoLPGPR5
	kzjqOOPMH/fDYvcvGsOXUM2RsbjWEKi/Nhc/FDDGYhB1epANxzpwvpFylPp3d5UEc7jfw8
	4s9l2IefvdkZs3WZGgxj9PUfFgF911Q=
From: Sven Eckelmann <sven@narfation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Sasha Levin <sashal@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
 Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>, sw@simonwunderlich.de
Subject:
 Re: [PATCH 5.15 0966/2214] batman-adv: tt: send ROAM_ADV on each roamed back
 client
Date: Sun, 22 Nov 2026 08:39:20 +0100
Message-ID: <3073076.e9J7NaK4W3@sven-desktop>
In-Reply-To: <2026-11-21-2-daily-reply-0020@kernel.org>
References:
 <254e49b8-c3b9-41b8-8692-bd5d9f04f7a4@oracle.com>
 <2026-11-21-2-daily-reply-0020@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3443466.aeNJFYEL58";
 micalg="pgp-sha512"; protocol="application/pgp-signature"

--nextPart3443466.aeNJFYEL58
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
Date: Sun, 22 Nov 2026 08:39:20 +0100
Message-ID: <3073076.e9J7NaK4W3@sven-desktop>
In-Reply-To: <2026-11-21-2-daily-reply-0020@kernel.org>
MIME-Version: 1.0

On Sunday, 22 November 2026 04:39:03 CET Sasha Levin wrote:
> > Maybe we should take commit bbfb0d2cf035 ("batman-adv: tt: remove only
> > the entry which was looked up from the hash")
> 
> bbfb0d2cf035 needs its follow-up 597c0f2f69c0 ("batman-adv: tt: only
> queue local del event after successful unlink"), and that one doesn't
> apply to any stable tree: batadv_tt_local_remove_now() only exists from
> v7.4-rc1. So I haven't queued either of them.
> 
> Could someone send stable backports of the two?

It basically requires most of the work which went into v7.4(-rcX) - which then 
triggers the "AI" to request stuff which is pending in net-next and this is 
then triggering the request for things which are pending for net-next in 
batadv/net-next. No, I will not go down this rabbit hole again.

If it makes you (or the "AI") feel better to have no back-ROAM_ADV working 
then please drop this patch. The patch is intended for normal back-roaming 
clients but not for the "I try actively to break the TT states" client and 
therefore will never fulfill the requirements of the "AI" to have a perfectly 
"consistent state TT" implementation which is simply not there (yet) and still 
requires massive changes to get there.

Regards,
	Sven
--nextPart3443466.aeNJFYEL58
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQS81G/PswftH/OW8cVND3cr0xT1ywUCawKcKAAKCRBND3cr0xT1
y3JpAQDVFfuGE92Vmr9R/KXpW6G2V/8n8GQfmV4jti1Fu246pQEA2XeNgCU4DLpB
FSxD++CzHWC3e/xtQ6X4f/inV9eg3gM=
=MSxw
-----END PGP SIGNATURE-----

--nextPart3443466.aeNJFYEL58--



