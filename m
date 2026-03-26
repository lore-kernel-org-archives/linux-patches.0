Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176D41E2834;
	Thu, 26 Mar 2026 13:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774530815; cv=none; b=cEIr+OAV5dl8N862I8TG2bN4FZWKBryBRplLlJdLPz1NwGbnqDx3tIOEkWuWo1YfOcqTHbbvnjG4aPVEqG4FqFL2ccJ+PrSv6YH12fIjr+eYg3XOFsd8brN4fmV4mHFXqMBsr71LbcPld0iClmJfXveil2bf5HDc3mwo7yYvSTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774530815; c=relaxed/simple;
	bh=wcZPEj3KhU0bhzKLJ+c6QP97jsQ7Iaql8YCNi/kvDJg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UVhezQNN1NHsKnoCEAL907Mo1moCeAWFLU/qyFnq7PrmjcJVO5e+6A7as8P2AOwC+Fz58Qw1+zzKYVrociXaCztvbN89XHasGst4gXrB/WdgH/ajTl9jXSX6uAVz091xZGA2XRJwg6BYeewAVNMd4NR1ymYicH2wxPqrM3Sh2VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1w5kWZ-001svC-2K;
	Thu, 26 Mar 2026 13:13:22 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1w5kWX-00000000JEH-0vGB;
	Thu, 26 Mar 2026 14:13:21 +0100
Message-ID: <607a6e7f86abd50273cd8af3c08ae7ee51e22ccf.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 000/334] 5.10.252-rc2 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, 	shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, 	pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, 	sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, 	broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
Date: Thu, 26 Mar 2026 14:13:15 +0100
In-Reply-To: <20260302161007.2523181-1-sashal@kernel.org>
References: <20260302161007.2523181-1-sashal@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-HguhDMPYvc51dwp+GxDJ"
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


--=-HguhDMPYvc51dwp+GxDJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2026-03-02 at 11:10 -0500, Sasha Levin wrote:
[...]
>   Bluetooth: l2cap: Check encryption key size on incoming connection

This causes a regression, fixed by commit c82b6357a546 "Bluetooth:
hci_event: Fix not using key encryption size when its known".

[...]
>   lan78xx: Fix memory allocation bug

This causes a regression, fixed by commit 03819abbeb11 "net: usb:
lan78xx: Fix double free issue with interrupt buffer allocation", but I
see that won't apply cleanly.

[...]
>   fbdev: vt8500lcdfb: fix missing dma_free_coherent()
[...]

This depends on commit 63a11adaceb8 "fbdev/vt8500lcdfb: Initialize
fb_ops with fbdev macros" from 6.8, but that doesn't seem to be
backportable.  This should either be reverted on all older stable
branches, or fixed up to use the screen_base field instead of
screen_buffer.

Ben.

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice - John Levine

--=-HguhDMPYvc51dwp+GxDJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmnFMOsACgkQ57/I7JWG
EQkIsg/+MqA7pnTHGgSH7h6n6cSifc5pmxSNVJHLAx1kE/8ixZlPUvn3qsZOHLH3
YNW2KcznEWUbbwVCdFct7WBsTKn/awr9zrT4+YE3ziR0YjCHpFpc73UFUx2f1BJA
xZ8k0o7LsMXo4xAKeYuOmLM5qyZ9EsODRHGw6mGdYMFOvJ3cWXeMWBdDE3sQTtnx
13iQUWIwZ3G7JCEgj0NjLg2ywnwWBW0CqaXZ2n4oDlNM8f2ctTytKNz+bSi4XxOH
FpYgra2MyI61PPLnx7s6pYIW6UIDSyyI/bb7lcZWauLHWK4ed5t5+wxPx+JzJSCW
CtKLn5SF/H83k26IzVHU1Dx2s0cvB0b/cYW8wXahMLgJ7UPSrA3UfTw7cjfeQl3c
x4t+Cy82Nr4N3fv/Ww3u/9DMdC+DTZCfeksx+W9QAotff53ZuY1eO+VbB1m5KmZ2
jOGdJrFOKtcvWIdzh4VucMh8PeSF0G/kisahSXcSo5wEvm2wE5UcMZSloDDxSTaM
dqu9OvakmXVTtI0Omytf9evgvDa6fUf21OJyE26NwEBZPgXmdkEtIISymsMqL/PX
pj0ZH0OxLCGVg87RM4HX+0bSodnOlqg1wE8xpcmsbOzh439/xiuAt6M6p+HcjTtv
rIzlegvTXHTGW8R/Pe92EAau1oKAy6JI8iFJZNbx1ENO0D/CUw8=
=uEz7
-----END PGP SIGNATURE-----

--=-HguhDMPYvc51dwp+GxDJ--
