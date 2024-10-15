Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E181E284B;
	Tue, 15 Oct 2024 10:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728986980; cv=none; b=YfTDcBdQ12j36YOqgHOIML7Q69hJX757ylATooghGiP0IDU+r/r4S7WI4LXve2oLmc69WFVZOFpjCqwb30b9lZZD+dYYXR2qLU6BWIOI4H67S2Wm+9Z1VcXnd0jKc6a+9JUSCGwLqtOOZOmnySY9z9k2CT/A6AI/R1EZA3PwLD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728986980; c=relaxed/simple;
	bh=TqvnSJXV3j9RkNWTUiQ0uFDiPn7wFtHHCed3S/mgq3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mKPikOtneHpVl9R098oBe2s0ZktYoIkAoiV/3K0t+nftBqieNGk5Cm3CK2PV2PFQ1TRm4CL0CyPy7010iD6n4LkxS26jeHwecGzTBHvPXaortNYBesqCvBGMiYe3zKKtq1q2UFFgav27yee0vRcHBxapY0B5crf1B58E5iLAh9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=ipNVAeti; arc=none smtp.client-ip=212.227.126.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="ipNVAeti"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1728986625; x=1729591425; i=christian@heusel.eu;
	bh=LluSf43iBDjVcn4SXPogw69pZkH2Y2Hb8augyoQ2Pco=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=ipNVAetiHve35gOSaDfYLYdDHszMwOcECvquQl7Vn7/UGgxzoacArc0RR+e03kYn
	 N3YXgbpYdcvzRWYmQzJHyvsJd4otPxJik49QIQ9yavitDyb5FWD19flSs2qY2toIr
	 5H0DGdTz04dhxgAXeme+SQ6H2DkFFD8jByAYYOTsr3HUyXb+vNsEXBYhh8HTmSR5K
	 /r7jzN0anYnOdpfc/mWgtGX4iEvEdoDbVeD1ZnbPpAxL8bOQsK4wBkZ/gCoS/RFPR
	 ZLxmXoSzR9a23U4Flru+R1YUl+Vawh3sxVdazluTpfImRRtwhQH+CB9IHjkEMVTMR
	 hki/WGYCs2LFIbzcnQ==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([141.70.80.5]) by mrelayeu.kundenserver.de (mreue012
 [212.227.15.167]) with ESMTPSA (Nemesis) id 1MVaQW-1tPynF0DHI-00Yg0N; Tue, 15
 Oct 2024 12:03:45 +0200
Date: Tue, 15 Oct 2024 12:03:43 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.11 000/214] 6.11.4-rc1 review
Message-ID: <85fd3225-f909-4d1d-803d-ed5ce2c92f22@heusel.eu>
References: <20241014141044.974962104@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="2uvjal75igfoi3mj"
Content-Disposition: inline
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
X-Provags-ID: V03:K1:TdtyCSlhyLhA+uNGu1VJa5hTYZv3U5Li63uAGn8qCsJ+onydCWJ
 pNbKJLpuhZPU52vTQ+O2Z+XX4sVv1/UvfXxIWrXfGJZKVhUAZAC5L0T0jBhfJ5iRckO13k2
 7Fr77egTMhQf2RdDxSYNQInnI7dQdt1NIOzFAcwxC+CUGbiOf6pQc6LZJ/cab0FefCTsiep
 yMKyni7MjZOqupE7XUZYA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ogEopkvqXQE=;vB1Fl29fkwPuOR26C7NR6m61COt
 Pdodm5WORk/ywdqhR6peZKU/BGU63VpBaqq5ir/6xi35tz/kiHO+XbxKZWzlt5bbaPxGRupNQ
 UlZ1t55vcgSvq+93hDNiwpaG+lAHXfzMRV+og2lwHFlPCm/cQiJYGfAPqwVy4ZQdygpF07Jww
 yAadtdd4M4D7jD6TkDxwUmXG7MaCNQowTZ1LPFsYWJ0/F5oVXxA/bQJh1LH/y2ge98/Et2cMZ
 Q2BBHBxAko7ZQYYZ3xLQmuZVOXKXJmM4HvHMMym58nNCbfPb3wsX1WafPTm5KyMqsoOJ6YEI8
 BtHgBzIGAaSikONzcFgtoiCu5T/HWU7M0RSsrSZhDaWsH+cV6/BgFNubvgzScf8qec/sl8gWg
 cycONUoZpqJZcBSuwyNpX0uCOe4YZHRLjudiGIjhApd8Cja7041igOIkJnCOdcTPdci7UULqe
 NuaGqTRIEcqLsUHhDkA/vxn0A6wULddqnbH4J6OFKpqAJyPsB0xPRtpGLO0S7a8oPC1PBHdaX
 BbGSW0k1qN4wZLFmAPUX9bzxw2sPhzJYn9SV6cWqejtxxWMOVrc06EFkeakFdjTnN2AN3lEYj
 ZwcpbUsdbp7k+oDEd9jG4SftR3255u/uDIu4f7VLXQhpxSh+FEigHZGsWg+mBQVBCIGrPLnP0
 uEv0dDclzJ0euQLy4XPKr9GdEsKydHx23i2WtHiBKvL32olUrwBxoD/b3ZqIayW3zI7pHPYs1
 1yLtpqxWNNmqdUheQyu+gLH6p/a8yc88A==


--2uvjal75igfoi3mj
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH 6.11 000/214] 6.11.4-rc1 review
MIME-Version: 1.0

On 24/10/14 04:17PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.4 release.
> There are 214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Oct 2024 14:09:57 +0000.
> Anything received after that time might be too late.
>

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on the
Steam Deck (LCD variant).

--2uvjal75igfoi3mj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmcOPf8ACgkQwEfU8yi1
JYXDiBAAx8cFLcX5fJ+QpYrrKvtz8/VIC7LlN/0srHCcH0A530UPltZMq5x51a1H
Gl9gr93W+kxVW90K3+5oVn93IICTc/FpRtZLIc6rgZzrtoyxNxphi/aHdUWaDePE
xJPB/rDwoSOPMuWCBAvLtj7Qs4eVdZcs17E52GX5lUfCehjYCKhRUkfX6HHj/v21
TkdJVo+Lvcr4Blu7yc0N/W0+s/twOKX6u8fwgpN8NeMvfotB76j3Jtc37Ys4swDW
zRCUNhYShDysRYlrVUqKf74EiFCH+lQ9KG3UTbXaDcrOkrmf0lefdotHZbW/Jllz
bsT/HRjud6zOyGSRfvzjXRb7gFIggXrrmMm4LgoepqtUPvQl2hE4/Ea3c0pWpsLB
bQ2J0TA6HDvqU81aX1t5PK3/AC9BkE1OktIa1VOPYNIVnbsAKb+lVb8eS1ueGI76
4cQb/3V/FKSkC4MIPKaMCREO2Vrq5w8xwLnYxZXP2PKv58Tnrn9v65jfLHHuhk+p
d2ryGfH+1Lz6fP37TrnYk8vDy/J+NT7lk7vPxHRsnhN846aYkHOFw4Ak0RYQSiPf
6LkVTsTMKisiQzysaommrc/Iq1/JCklHD+6Ux5a3PvWVeasKV0crE9v4CUZvbrBL
kzDEVI+dSFXNjYFligt3qdH7nHlUakClf6tL64Qjobwb9V3PzH4=
=LiVV
-----END PGP SIGNATURE-----

--2uvjal75igfoi3mj--
