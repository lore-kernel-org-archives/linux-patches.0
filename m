Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE01330337;
	Thu, 16 Apr 2026 17:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776362337; cv=none; b=RETg2khi18Q8b5BQCMUyIwYf4yJAJr9eAnemxySzM01SRspeH5hlHjYgbyazD+fCH+3lBJzQOsrhHDAHSdidjYD6Tr/tRNihEesOk1RTnajHbEEDw9x8ITnFf804+YPj5jUUurrdk9t8HnvJQ8jly9bineQCIGJF7LFYOpEMp/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776362337; c=relaxed/simple;
	bh=0JACJp6W3JWNi3elfrIRQllRmaC8F9tPq2XiV4d1VBQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qYU0XDok/S1nxlET+ZvzL+6JQetR5ikEUX5IojvZa0G+mybtpxaTGngaK4QyVGtYLc11Y1krnL0MUtYIoJiKxeAm2KYqjSIYHTfA2aQrg/BDgYkDTZGpqHiZphzRzLWwl3s0FaU/sIBMa83+M0TgRFpkVBGyR+QkjzTcbxiEgHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wDQzI-005E1y-0a;
	Thu, 16 Apr 2026 17:58:47 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1wDQzF-000000040uz-2PTM;
	Thu, 16 Apr 2026 19:58:45 +0200
Message-ID: <e4bf9ba9ceba4f2e23483b4aa0ebcff8251c0b73.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 311/491] dmaengine: xilinx: xilinx_dma: Fix
 unmasked residue subtraction
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Marek Vasut <marex@nabladev.com>, Vinod Koul
	 <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Date: Thu, 16 Apr 2026 19:58:40 +0200
In-Reply-To: <20260413155830.683657586@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
	 <20260413155830.683657586@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-P+lFHIIF8nBTP5w8MmGH"
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


--=-P+lFHIIF8nBTP5w8MmGH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2026-04-13 at 17:59 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Marek Vasut <marex@nabladev.com>
>=20
> [ Upstream commit c7d812e33f3e8ca0fa9eeabf71d1c7bc3acedc09 ]
>=20
> The segment .control and .status fields both contain top bits which are
> not part of the buffer size, the buffer size is located only in the botto=
m
> max_buffer_len bits. To avoid interference from those top bits, mask out
> the size using max_buffer_len first, and only then subtract the values.

This change is harmless, but the problem it claims to fix does not
exist.

Ben.

> Fixes: a575d0b4e663 ("dmaengine: xilinx_dma: Introduce xilinx_dma_get_res=
idue")
> Signed-off-by: Marek Vasut <marex@nabladev.com>
> Link: https://patch.msgid.link/20260316222530.163815-1-marex@nabladev.com
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/dma/xilinx/xilinx_dma.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_=
dma.c
> index ca80a1dee8489..a89a150be3284 100644
> --- a/drivers/dma/xilinx/xilinx_dma.c
> +++ b/drivers/dma/xilinx/xilinx_dma.c
> @@ -964,16 +964,16 @@ static u32 xilinx_dma_get_residue(struct xilinx_dma=
_chan *chan,
>  					      struct xilinx_cdma_tx_segment,
>  					      node);
>  			cdma_hw =3D &cdma_seg->hw;
> -			residue +=3D (cdma_hw->control - cdma_hw->status) &
> -				   chan->xdev->max_buffer_len;
> +			residue +=3D (cdma_hw->control & chan->xdev->max_buffer_len) -
> +			           (cdma_hw->status & chan->xdev->max_buffer_len);
>  		} else if (chan->xdev->dma_config->dmatype =3D=3D
>  			   XDMA_TYPE_AXIDMA) {
>  			axidma_seg =3D list_entry(entry,
>  						struct xilinx_axidma_tx_segment,
>  						node);
>  			axidma_hw =3D &axidma_seg->hw;
> -			residue +=3D (axidma_hw->control - axidma_hw->status) &
> -				   chan->xdev->max_buffer_len;
> +			residue +=3D (axidma_hw->control & chan->xdev->max_buffer_len) -
> +			           (axidma_hw->status & chan->xdev->max_buffer_len);
>  		} else {
>  			aximcdma_seg =3D
>  				list_entry(entry,
> @@ -981,8 +981,8 @@ static u32 xilinx_dma_get_residue(struct xilinx_dma_c=
han *chan,
>  					   node);
>  			aximcdma_hw =3D &aximcdma_seg->hw;
>  			residue +=3D
> -				(aximcdma_hw->control - aximcdma_hw->status) &
> -				chan->xdev->max_buffer_len;
> +				(aximcdma_hw->control & chan->xdev->max_buffer_len) -
> +				(aximcdma_hw->status & chan->xdev->max_buffer_len);
>  		}
>  	}
> =20

--=20
Ben Hutchings
It is easier to change the specification to fit the program
than vice versa.

--=-P+lFHIIF8nBTP5w8MmGH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmnhI1EACgkQ57/I7JWG
EQk28Q/+PKU1WTvT54/v/5q1f7t1BjwMUSEEwEkYAXVZy85u4/7VqajZGXuz/tEB
ZtiOu69Tuv8Mp1Tp7urFaFfWmXSckglhno+gSJ85+ni99j3Wd6uxUCRotq4/14hh
6f+BcVZvDGyfDJO4miHtp63QcZKNy9KzXyYd3rMJDEVccKj568U/E6L9rnqCeM0O
j19E0vvtiKID8P51HuW52+/iM0NDe2WfkC5aiXRFozMVy2BYpOegxG157Nys6wAF
A7AYmkHZ2nk28qWbROIH+3NF0fwrt3CfKpdFHnQwCf2eD8NtTB3dGvfn5/3XkgRP
lXGEVx1tWr4+2ISX+4EvIWbooRMYXb8cuvUVpey26IpHHoiadMUByk1LahUCpE34
00maV3HKlFUtjre36WSyNFJ/CeXGtqHtt8S8L7OIvZi157L3Y8sDIVJWIekQRxAo
laC+C5YvStwpu3Ajt4Dz7lLTm7XfVAYZBo0NA3gUoe0Xkvij5NRx97qGnGFgd5NJ
m26ZAzu9Kk54yiC+aFS1NgT21cyaJx0WaS19nHFE2lYZdXEJuNhK7pCEvRISc1lk
DPAPk2t7a2WQabTrJoCMzPqdDpdDXWIgWTtJoZmccWAzhoTpJDBcQ1LD9ytoxxFP
r6sW+JCkximMnaMTROqMESYECOdF60rPZq4GLGTUV+fZ8JaTt4Y=
=Q5w/
-----END PGP SIGNATURE-----

--=-P+lFHIIF8nBTP5w8MmGH--
