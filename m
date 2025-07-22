Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7A1285C8B
	for <patches@lists.linux.dev>; Tue, 22 Jul 2025 21:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753219472; cv=none; b=jjVcbxm8bheODLL5CX7gVXAcrt/xWv6Qah6XPyLsZ5zMQK+q6vdljVT7Bgw6Ouc21Z8l2/qHMW/ye7xIGRIKYbI2h4YUjqVB9rUWlmyZzpOvVI79H0B05qIM04urtjYJDatrAMGTXk8UNYCsOIjC0aflXbMDaJ7B3BvLLLqHFIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753219472; c=relaxed/simple;
	bh=r4C21SkimRR08+NTBL+o805O4fZz3IMa1+Az8OJAWJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AuniP0L2t6YV/NW1dZepVBfJiSxlcBznWGNFuKpsoT11sCvH/PuQa9yJXCPOvwZE/rDua1vzaBSq2PbNpCcaPJumvhSvNQ1FjqghF2qKvbnabFKdBta+6I8bolJcOyEbq4LHDEbJSejGmo1tTHNbS6L9zafdAfflVgB1KycWUPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=Td+elVCx; arc=none smtp.client-ip=212.227.126.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="Td+elVCx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1753219461; x=1753824261; i=christian@heusel.eu;
	bh=xi0dLzoPvspJ0Thu656QhGnHYoK1rauDUKPcuEJO+pU=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Td+elVCxBKjTYSaJhdpIiPBKtD/J9VHjQC76tGmPSObcJSGi/ca6/L0MFXBYxvgH
	 +3kO+MZIPBF/c9hfgQ3LflDj5P+fyrRZ3ZO2qHHLGQ+wS+t0769rStE872lop9/3E
	 VHP4CG41yRqY0zFIBD+DkhJDRw8gmQKoGG7udwNKcau64lIGImcOismWdQTL4b/Oo
	 4XC5F4kN7gPRYq101/QEHQP9jwuxF12jFWOC5H3+rKtqLnT0HxwEdlgTGFs8krt7Z
	 WHQvt+17QjiUlKM/GHq5UzlcxJqWPoer0ZPK1AKbtzb+rgdcR2RRVwAGwkIX5xDnl
	 UkCTKnCnBSf5szYWVw==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([89.244.90.40]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MpD7H-1uw04I1HhP-00jFYm; Tue, 22 Jul 2025 22:57:09 +0200
Date: Tue, 22 Jul 2025 22:57:06 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.15 000/187] 6.15.8-rc1 review
Message-ID: <b82800d6-0849-4b88-8026-6a8596ff4276@heusel.eu>
References: <20250722134345.761035548@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nssu6z7k4mv5iuds"
Content-Disposition: inline
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
X-Provags-ID: V03:K1:cUTCdnko56eAGlcXq0rMTE3VMELH5cEz6YWh/nlebymBc0yaR8S
 qkMxzV9k74diggYDMxJkWYgd4RGTKxw2FxRS4P+ig0J8QZu4h8cubKynbFBuK9XrLfXBWMX
 G5v4QPanUeHPjZ7DHvCU8noZP2hj/BuufVjmvBJsrlBuKhQTwKb9IO8z9gZOq6ysrrG3yVP
 KPOPyC1iUG8IVMcN9Orug==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:aJKT+a72dWU=;60FzdMGv7oGWqteEKuYhv0vA4Rz
 8OzwabrhRjMM7cJ+we0ShP49Z8j2ybmSDtULmC6NBaw5rKzmOmRIo1GqMEpWQuibd56vMBEbl
 k9WGJj7/87/VVneRIVlvu3IJG1PQu2oOmubgtiuuNUBD5M0iQFeA5hlAUcsOnGJMZA17+RMpV
 mc3Hntd3jjDRCcHCqIj5yfkLRit3tsHtkQ6ieXlfUvLqkdnXIp8jT9iGDpmWKNBym+OXhD4ns
 Pa4DOB8zi03ocRFh3jnIFddh4mPDrXeaDtOSbjeSVEjxBp8AOTDP5FovMn+E+MdCTV1v8Ykhe
 PzVtZ0qmDWrhawrFKsV+WjKpeope/hw3vwTKhv3fG7eKxMf9sLN+QU9eyQyuHgCqL7n6FpZrg
 UZv7hdyP49FwAopmfbu8M48gklx590sRRvbnq95syC95HEi7ALNinw5pFeHrIsaU9kNfhoP6y
 5SJhOeLecOrbCyFhTIVZ+vJsyj0RFFCLMhVdEBZxa7cIbTRe0AcfBXa82ylwdbViJRCG8wYZQ
 J+eKphL9ZQAO610rZBs9Pm/D6LNSM3jvP9iYTb0Gts1NkTbKbZ2Qia4Sla6xTncAtnIaWn5eR
 vmrCQmPElHtX8rQzI8ILDl7GuF6ZlTGS74J1nrevJI03fQhLlQOpTGhUKQFo4wCPkxjI0uqfv
 AL6mIGM4XuEQxjh9uaGdshEjvRMzAkYxwa6gCGQt0ciGIIyrDIFlmT8TuCz0XHePKRul0pUQk
 zaIfnxlo2maMsHTdXZdqKZ+w0jZJV/SIYzAFEUoQejFtgBUQlBghIBZB24T6E26cKXPSCUlkX
 YjKs8aK7cof7X89UsT5LS4msL65Rmu9RbRvNkkSzBMB4ZImIxpE/IOxlDJ+twJ3u0VLs4nR1s
 7DoI26FrDv9emKbZN35qVyLE6obQJxm4zd0SY0ZdyYr9CNJ3t0MIyDY+3fVG0ipsctFt6zE3w
 sgZo80/f89RhlpUe4x0bshxZf07PXTlw33m/0q69TRJ1oFzFXa4kujRlWlDiy9KDDUadWx9Hq
 9aW5wHeegCx0RyLmnzxF5CJ7AgL3JMEEnouA8NVvGgDJtwIeMo64YsqqgT7vD7+wSqEKX/rRS
 x/qQXwABetS16YUOf58u1HcImpG51N3oBichIowMCKVwod/aV7TSK378kse1v7Wwsa6wpaffu
 uS+BCn9pkt37oE1ZxNOdce1oPQgeW7/wWeXhQzZ+gM54RxC50iHVAHjpwO/2ZgaoIpZCxWqn/
 deioIsNRL+QTplyxNvnRMbqv5TJ3xDadawzlEtFm4M/tWff2YarpmG6aJy/lcgNF0PYudS0DF
 GQQntbxHXImznvpxTJAxgWWtdsPyI801wksgxEv8hukjicHNjnpdofe8S1TMOwUqUYodmvAj3
 5PFRQz70Acb5qdqUnPyIPvCh5U5JUOx4WKavGR506TXPSQ+/yWNqoENQIXDZnSDYPgDSY0T3K
 V7HdUes+eERTpbvJM2RH6IBF4+Oc+RPdx+EjRpXMB8tKG1JeMCEeG4z4Em3/tBhwFPbawtf2O
 RrZdzyCLxwcsxdb+tbrbWskgOkuLOwNBGWgtuR2onETNNusVldy+4Ba2jko0Ew==


--nssu6z7k4mv5iuds
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.15 000/187] 6.15.8-rc1 review
MIME-Version: 1.0

On 25/07/22 03:42PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.8 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
> Anything received after that time might be too late.

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and a
Framework Desktop.

--nssu6z7k4mv5iuds
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmh/+yIACgkQwEfU8yi1
JYVD2w//SHeaSPH5JVhapqeMyaq7CZhnD4yWi2do1hgNshN0JSPiYUDb5Nc9FxaP
licsd1ulDwLVdRynevsqrsyKs+vrpmK1cKE6eYifcSovRknsCoN8lurmNtKMuYU6
250Fq8nkjPQeLZ/H5pAHYVNxI1LfBwfNHfM3ZD5XQegTsUM8cqe7EroDbHAhqUgm
uTKQLejWSKNw4Ln01qLRysSa5j6ie/Zd7v/yHAlJFJcERg9T2nTFjf6MKp+KSVGK
ewD+6dMElbUU4RKxm2upzkqGuArCWl2JO6Ozpe1pRr3sJ1qbjAtT7ToUvOGTq7BZ
sMjFODvNQ/nTOsi7msEVG+v7p8BGOBgqb/MqTqSy9ZYFGt+C3QIXjltAgxm/JmMq
xfoaXTdP94HnzZN/9gnDGpqlXAfHycP4Kw0DFGl9IFzXmWoc2uPawuRosBc3SxXd
MY2YNdQNVSg7qlTIrl/eZFC/d63TNCUD53ELNwrenfwZ8rgEtEgWpSex9zRKui4v
qO/nJNSk8C37SjfrrH5kswiSUhddkQMnzFGTw+iOjm74il9AGkcDOILu5hXdPp+D
j7gFoVlFt+u1srsT43A8xfqrVt/v3mVmOHYkrnIjXMymDfTLmaKTrIPHLTirAHqE
hd3OnzmX7BjGYJqvC2iI0xTttkXViT77pBlNMaxVUQQmprLVR9o=
=iD6y
-----END PGP SIGNATURE-----

--nssu6z7k4mv5iuds--
