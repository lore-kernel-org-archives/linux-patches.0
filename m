Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FC2253F16
	for <patches@lists.linux.dev>; Fri, 20 Jun 2025 10:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750417195; cv=none; b=HKFneXz4Uw3/uqqQhoGySagNNPwFU5y+smUo5FxWGB3TpAJOZo+xaCc9hOfZUViuJ6CCwm9NWwmQsn0aZrQCRRqHBwxO6i/iGUVvWBuP2YYlekYXYyZixJNXguP0A4g2II/mAch2JZEOjCUAgfM0rwfjLdnsNjD/BmKxaGkQ2Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750417195; c=relaxed/simple;
	bh=2gU8EEIZAAfhcYfT47CkRmnQBiQNPE9kIIxIsVPU7KA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ElZ2BqVQkGerY80bwbjw37Vp9EFFz426b3glgyiX+MlVt8FpBch/O4kMONMQxjPWFj23sPtQmVAf0C93Np/CtvSN35NBZSkx8z4QFq7zfVwy6qApGqy2TSDWYqJ1z77TtzB5u4GCwb9wDDqPt3MDzUR1rSIFxxEk5af/VymdScY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=OEJJ0qVQ; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="OEJJ0qVQ"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 4C03A102422BF;
	Fri, 20 Jun 2025 12:59:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1750417184; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=pr4bD3VXbD9cW5OWPqjhnCrJAsKqKnK1lCmo/80hWvk=;
	b=OEJJ0qVQ4PPyxEA0psitN85eA/6iRmJYjw0z6eMNpPvT6ekxM6kwFmYEnprTXGKTIETyyI
	MwZUDtSmB+Klo15gb0iJjAb49IFVdN52IZfID3QcucLDyQMagzqDO8qS1EchwsJYHHfBnH
	uK2K+uMnjYlpO2dY4c0wBdEGStVr/k/m9sR9nvig+Gsjq+5TJfycBvKpxX8f8IpE+pUNom
	//6hunKbO4Fvx3IH8Cybkk0Y6X1gVrqf1aK53F79dOMupkWEnNs8OKjY2mIn84nmXJMAOk
	AEQBFtfoFQvG6garl98SHFLRkNY71abaq7sTwAU/DnJMgAAE2pXzqPhyFm5wWw==
Date: Fri, 20 Jun 2025 12:59:35 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Ingo Molnar <mingo@kernel.org>, Dave Hansen <dave.hansen@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Rik van Riel <riel@surriel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>, Brian Gerst <brgerst@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 002/512] x86/idle: Remove MFENCEs for
 X86_BUG_CLFLUSH_MONITOR in mwait_idle_with_hints() and
 prefer_mwait_c1_over_halt()
Message-ID: <aFU/F9MI1DN7f3ld@duo.ucw.cz>
References: <20250617152419.512865572@linuxfoundation.org>
 <20250617152419.622968266@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DhRUw4ilHaOeuHla"
Content-Disposition: inline
In-Reply-To: <20250617152419.622968266@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--DhRUw4ilHaOeuHla
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> The following commit, 12 years ago:
>=20
>   7e98b7192046 ("x86, idle: Use static_cpu_has() for CLFLUSH workaround, =
add barriers")
>=20
> added barriers around the CLFLUSH in mwait_idle_with_hints(), justified w=
ith:
>=20
>   ... and add memory barriers around it since the documentation is explic=
it
>   that CLFLUSH is only ordered with respect to MFENCE.
>=20
> This also triggered, 11 years ago, the same adjustment in:
>=20
>   f8e617f45829 ("sched/idle/x86: Optimize unnecessary mwait_idle() resche=
d IPIs")
>=20
> during development, although it failed to get the static_cpu_has_bug() tr=
eatment.
>=20
> X86_BUG_CLFLUSH_MONITOR (a.k.a the AAI65 errata) is specific to Intel CPU=
s,
> and the SDM currently states:
>=20
>   Executions of the CLFLUSH instruction are ordered with respect to each
>   other and with respect to writes, locked read-modify-write instructions,
>   and fence instructions[1].

This not match stable kernel rules. We lived with limited performance
for 12 years, we should continue.

BR,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--DhRUw4ilHaOeuHla
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaFU/FwAKCRAw5/Bqldv6
8kRtAKCHnlklkVYkK3bi3lCuvQHihhU6gACeNWv1a5HAkQmq3NQZrexospv6Zjw=
=a7Cx
-----END PGP SIGNATURE-----

--DhRUw4ilHaOeuHla--
