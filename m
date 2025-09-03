Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA192C08CB
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 17:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756919585; cv=none; b=McB5F309ONVPU9BJZt337y4hNj18jrP/hAgShrl05eUPMs+JudI0qjvXGhzOx1j3R4vasco4Lt/Ra38Hs1kZOgr21XqWE2hZUBOySzzWvNS3UvnmCk3synuWP2aHXW7rbEGEWTaFEBLdcaUVTUWDl0dHsvXji3bMiY+O78O8GjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756919585; c=relaxed/simple;
	bh=AdxDf5zeXQhsksmaMXC9EJWtWbesa8BK9ehvgf0lftg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KnplxEPQjyIKSCo+PxLIldSHhaTDrhr9qpzHSYlM8ZKhR4L9hQTmJbb/BjzrlIpls0ryvAwmZ0+nxIv4UvaeSujhvMNL8To8JaoC9bOHCePH1voRtptKPaXv7NH7zL7ReW2n9OoffUndcNvzkjaIB9OqH6i+NGs3bDgw9GaSHnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ndufresne.ca; spf=pass smtp.mailfrom=ndufresne.ca; dkim=pass (2048-bit key) header.d=ndufresne-ca.20230601.gappssmtp.com header.i=@ndufresne-ca.20230601.gappssmtp.com header.b=bNfTZiz0; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ndufresne.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ndufresne.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20230601.gappssmtp.com header.i=@ndufresne-ca.20230601.gappssmtp.com header.b="bNfTZiz0"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7f7381bd1fcso14496085a.0
        for <patches@lists.linux.dev>; Wed, 03 Sep 2025 10:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20230601.gappssmtp.com; s=20230601; t=1756919583; x=1757524383; darn=lists.linux.dev;
        h=mime-version:user-agent:autocrypt:references:in-reply-to:date:cc:to
         :from:subject:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=AdxDf5zeXQhsksmaMXC9EJWtWbesa8BK9ehvgf0lftg=;
        b=bNfTZiz0ildxsjeq930RExPMmq9B4ozbU1TtXVNGSPicwLLiW59KK7m6vQhayO4mkX
         y8u6lzte/QRA1z7Em4l7G4n4SytCjdYYWwMt1SVBisNVsCroNrqEPOfkk9t4g7ntnMNr
         nc5CY9+NPAjSN5c5TgJhKEuZyxrAHtznVcuh2Xpzykp3tlGMWZjDJM2Bz54FsMxJSj1I
         gb6Jpc4e5gLtouRAIwWsXuRKlp3szSE6slruLSP4+erv/eFReJhR+s+kQbMIvGD1xbl/
         0cWkR0ghJl7ADk1DerjEIPOq74V9UOIRKIOJc44LmUtSe8DaHCOCqMzaqj1pr3zoo6Ei
         pWHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756919583; x=1757524383;
        h=mime-version:user-agent:autocrypt:references:in-reply-to:date:cc:to
         :from:subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AdxDf5zeXQhsksmaMXC9EJWtWbesa8BK9ehvgf0lftg=;
        b=eTX7ZLZQqrZgEgV9NTMTajOj/U9hSu+ntwptjPIeOWFVo0XWyjoD442ef08WsU65H0
         veEsq5FpibzFo6RirYsReVIX4ad0DPgBfyipHFtbZvPWWyQPaKDUnLFHP5eQWJDJrLSF
         WnStLPMdCHA9t5gpFfwE7tFCVIZjfZqvR99jGwsqN89G6J7pacocjYdy/A9vPtL2KpVA
         Wbd8MMqcZQCvusAT7xfqPooL4wmsRXYg6WwNEQvHgwtJrT9/iqCdADRIhlF/9mQYeHBH
         f0zbo/9z+cIcU6d6xVdH1eC9dVGg9Lx6++dklTCfvttWbfUA3Z7K1OjaaR7FEykKk7zZ
         APgg==
X-Forwarded-Encrypted: i=1; AJvYcCVoCOIg7B8l6NZFXwzLieqSweXDXoJacKDqu/lqVruuAdTv7CfJheYv2XypcwRlxEBXbVSnHlUc@lists.linux.dev
X-Gm-Message-State: AOJu0Ywbxp8a1b7iHhqi0tw91E+3gl4swFWmgzYuNhIllA8usxuYiTN9
	KFIVS4pI78ebgm/P1lY3JSgvZ/KRtnNkD3E98piweBwTOXin0sTbiaWjS6JI+A5a1vY=
X-Gm-Gg: ASbGncua6iCvTuGtvxyWdTN8s7hz7SlqhUcdE13UpqnyIiFVDlcWK5OB8hK+Nk5HqM4
	5rBqupPD7YzS2YMulugFSyZdPhY00RB/t3/0wa7b4kNrgzPT7nNHwr+NUBvzJpDMW55TpdN9iji
	Z397hHMuSv/XqwuyYuhJzXskHUH1y6N/v09xCEfS9aBCjDwtgj28iZOZV+oSbTozOjfRm6XIcm9
	I4C/uHr783q9mXYalbRvz/hkPJpdcpcCiqwBPCwyTpdpcfCHf0KORNmdXnomGyslZ2fj5iFeUfV
	44RYE5JdSFZPOIsW2O9PI7s8Y+OyyTKSQfxQXUq/lDgg8g/sLBH0+fR5FjS/Juwez4K2Ob/BpRw
	YbqYONt7fcx+3auXCtu22AZ/ooPsSASkhAvRaYA==
X-Google-Smtp-Source: AGHT+IE2gk2cAMApAiK5YzQI79QMXJKlXiHeFQVTEq67x8yVV85XXX2+3+BrCnQSOq7OZa/8/eFoDw==
X-Received: by 2002:a05:620a:6919:b0:7e8:902c:7f90 with SMTP id af79cd13be357-7ff26f9fdc9mr1708337085a.15.1756919582911;
        Wed, 03 Sep 2025 10:13:02 -0700 (PDT)
Received: from ?IPv6:2606:6d00:11:5a76::5ac? ([2606:6d00:11:5a76::5ac])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-80aac237b51sm135862385a.61.2025.09.03.10.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 10:13:02 -0700 (PDT)
Message-ID: <699dae8715b77f20f075452ecbaf03c2e0876186.camel@ndufresne.ca>
Subject: Re: [PATCH] media: s5p-mfc: Always pass NULL to
 s5p_mfc_cmd_host2risc_v6()
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Andrzej Hajda
	 <andrzej.hajda@intel.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org
Date: Wed, 03 Sep 2025 13:13:00 -0400
In-Reply-To: <20250730005212.GB2984390@ax162>
References: 
	<20250715-media-s5p-mfc-fix-uninit-const-pointer-v1-1-4d52b58cafe9@kernel.org>
	 <9650d2e240a9170175069e3a4f6d6d9512d62aa3.camel@ndufresne.ca>
	 <20250730005212.GB2984390@ax162>
Autocrypt: addr=nicolas@ndufresne.ca; prefer-encrypt=mutual;
 keydata=mDMEaCN2ixYJKwYBBAHaRw8BAQdAM0EHepTful3JOIzcPv6ekHOenE1u0vDG1gdHFrChD
 /e0J05pY29sYXMgRHVmcmVzbmUgPG5pY29sYXNAbmR1ZnJlc25lLmNhPoicBBMWCgBEAhsDBQsJCA
 cCAiICBhUKCQgLAgQWAgMBAh4HAheABQkJZfd1FiEE7w1SgRXEw8IaBG8S2UGUUSlgcvQFAmibrjo
 CGQEACgkQ2UGUUSlgcvQlQwD/RjpU1SZYcKG6pnfnQ8ivgtTkGDRUJ8gP3fK7+XUjRNIA/iXfhXMN
 abIWxO2oCXKf3TdD7aQ4070KO6zSxIcxgNQFtDFOaWNvbGFzIER1ZnJlc25lIDxuaWNvbGFzLmR1Z
 nJlc25lQGNvbGxhYm9yYS5jb20+iJkEExYKAEECGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4
 AWIQTvDVKBFcTDwhoEbxLZQZRRKWBy9AUCaCyyxgUJCWX3dQAKCRDZQZRRKWBy9ARJAP96pFmLffZ
 smBUpkyVBfFAf+zq6BJt769R0al3kHvUKdgD9G7KAHuioxD2v6SX7idpIazjzx8b8rfzwTWyOQWHC
 AAS0LU5pY29sYXMgRHVmcmVzbmUgPG5pY29sYXMuZHVmcmVzbmVAZ21haWwuY29tPoiZBBMWCgBBF
 iEE7w1SgRXEw8IaBG8S2UGUUSlgcvQFAmibrGYCGwMFCQll93UFCwkIBwICIgIGFQoJCAsCBBYCAw
 ECHgcCF4AACgkQ2UGUUSlgcvRObgD/YnQjfi4+L8f4fI7p1pPMTwRTcaRdy6aqkKEmKsCArzQBAK8
 bRLv9QjuqsE6oQZra/RB4widZPvphs78H0P6NmpIJ
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-pzsAHyLPvNQykWC7D2G9"
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0


--=-pzsAHyLPvNQykWC7D2G9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mardi 29 juillet 2025 =C3=A0 17:52 -0700, Nathan Chancellor a =C3=A9crit=
=C2=A0:
> Hi Nicolas,
>=20
> On Tue, Jul 29, 2025 at 10:24:22AM -0400, Nicolas Dufresne wrote:
> > Le mardi 15 juillet 2025 =C3=A0 15:13 -0700, Nathan Chancellor a =C3=A9=
crit=C2=A0:
> > > From what I can tell, it seems like ->cmd_host2risc() is only ever
> > > called from v6 code, which always passes NULL? It seems like it shoul=
d
> > > be possible to just drop .cmd_host2risc on the v5 side, then update
> > > .cmd_host2risc to only take two parameters? If so, I can send a follo=
w
> > > up as a clean up, so that this can go back relatively conflict free.
> >=20
> > It seems so yes. For this specific patch, I would probably rename "args=
" to
> > "__unused" to make the reading faster. But does not matter so much if y=
ou
> > later
> > remove it.
>=20
> Yes, after this change is picked up in a maintainer's tree, I do plan to
> send a patch to remove the "args" parameter altogether. If you really
> care, I can certainly rename the parameter in this change to "__unused"
> as suggested but if you don't, I will just leave it as is to make
> backporting this a little easier.
>=20
> > Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
>=20
> Thanks a lot for taking a look!

While applying your patch, I realized the Hans merged another version of th=
is
fix, but made by Arnd. It covers the remaining too, so I will mark yours as
superseded now.

https://gitlab.freedesktop.org/linux-media/media-committers/-/commit/7fa37b=
a25a1dfc084e24ea9acc14bf1fad8af14c

thanks for your work,
Nicolas

>=20
> Cheers,
> Nathan

--=-pzsAHyLPvNQykWC7D2G9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTvDVKBFcTDwhoEbxLZQZRRKWBy9AUCaLh3HAAKCRDZQZRRKWBy
9En1AQD1tAsHKQWAylP0KeFD1yHx0HsU6uwqceGeGAr1Nc5pkwEAgs/En9h0xvlo
EVQVqh/acb6D4sGssLO0+X1Rreu8sAM=
=sQoA
-----END PGP SIGNATURE-----

--=-pzsAHyLPvNQykWC7D2G9--
