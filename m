Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4561C315793;
	Thu, 25 Jun 2026 22:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782427027; cv=none; b=fDsAXRg1Smzv8404rVZQfA7nYLzT0Zzm0RF4tg6hNYHG6F47xN9SuWrbV/QbtMwMjw3Vlg9e23dn2kNFJ1mAN0DAecuThSyTrcEVa8J31dD+ba5/R/fpTVbouXgDk5rY8AZzCvz1AhIcRts8q7nta7auZk3ddzUWDt87N/3TGCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782427027; c=relaxed/simple;
	bh=hKaex2wrpfIc9HPsbRGDzLVoyCf0En3NbbKAhpIsNIY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FCBO4JAZlif+rVzpYm8SuWtYIe+pfYJmv5DWc6b/Oa6GaxjknCFuLy1CJUXPCGGTBsxbZImgNW66A4Qn661vr76HPWarQvo1DFD8N+BLlw03Qt35mrK4HzAP67eEjhUc7OpYHLR21VzRN0lftfmnhX5gxTNRna/0yoT4dcY10t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wcsgw-004Mt5-2n;
	Thu, 25 Jun 2026 22:37:02 +0000
Received: from ben by deadeye with local (Exim 4.99.3)
	(envelope-from <ben@decadent.org.uk>)
	id 1wcsgv-00000008k3n-3H30;
	Fri, 26 Jun 2026 00:37:01 +0200
Message-ID: <2ac6b67a0643e111692689daa95dbd8883f16426.camel@decadent.org.uk>
Subject: Re: [PATCH 6.1 470/522] usb: musb: omap2430: Fix use-after-free in
 omap2430_probe()
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
  Wentao Liang <vulab@iscas.ac.cn>
Cc: patches@lists.linux.dev, stable <stable@kernel.org>, Sasha Levin
	 <sashal@kernel.org>
Date: Fri, 26 Jun 2026 00:36:56 +0200
In-Reply-To: <20260616145147.844270971@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
	 <20260616145147.844270971@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-GOfYbWqPx8O8Y9YApBRF"
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


--=-GOfYbWqPx8O8Y9YApBRF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-06-16 at 20:30 +0530, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Wentao Liang <vulab@iscas.ac.cn>
>=20
> [ Upstream commit e194ce048f5a6c549b3a23a8c568c6470f40f772 ]
>=20
> In omap2430_probe(), of_node_put(np) is called prematurely before the
> last access to np, leading to a use-after-free if the node's reference
> count drops to zero. Move the of_node_put() calls after the last use of
> np in both the success and error paths.
[...]

It's not called *prematurely*.  omap2430_probe() shouldn't call it at
all, because it never increments the reference count for np.

Ben.

--=20
Ben Hutchings
[W]e found...that it wasn't as easy to get programs right as we had
thought. I realized that a large part of my life from then on was going
to be spent in finding mistakes in my own programs.
                                                 - Maurice Wilkes, 1949

--=-GOfYbWqPx8O8Y9YApBRF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmo9rYgACgkQ57/I7JWG
EQl7ExAArD0oK/g8UfhA2F+YLH3bmnNB+TJUebGveQunqrmc8NYSR2sLlafLuREH
BuA3TL0iSd0cVL6RE10rgcXJFj+NyrNBhQ5+Q/OGN3b/m13kWt7Bhbnohi9iWWY6
PpCIrUdDcQnPMB+sbXn9o96XV5ydsnhGwkUFzR1COr9/pAZ4sZ/MztGAI1q3xXV8
k6Z6ocqWAuctK3egumgnYN7xc/xeLaHZgg3AxaDeMwMf+8yrbGwOfw0Gnfv08vwP
mFbES3vAEAeCUrBpIPYGxMr4duYin06hvHzRDhNwtSYztG9ZytZluWbBps9Kbs3N
Mvm2nQW4bViA0LM6yYHxnrUb8HIOD8/3VqpXauhXxEoHyrC9aRODcK7b8ix6ppK9
4b/8sMd5Nxkcb8hjv+KQAtQLZj5lR30d0gMJVQ1hy8uN8wUNJ/3HjXz1lHOzy2MZ
lHEvp4D9UDek4+i9eUi6ZdeRPRUbh+gwPYnlZCL16TtvPqMkuvD0LTR+r4b+NKOO
oj2tQEt/2YNnCfJUWfDgqJdvRG51nYdrQjrKMXN6qpfiHDG5jpNR4Hjad0Q5Ox9M
CXL8PH6rCKZgVeXnPRgOXBjU4DH4lOdBkIjz9NO7QbQRkUvTGMJbqRYNXhlYH3+4
XL9j1orpiht4cGPT5SgL1fopHc/EHLY4PLPnjSg+Jr7N/lXTdMg=
=f7q+
-----END PGP SIGNATURE-----

--=-GOfYbWqPx8O8Y9YApBRF--
