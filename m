Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CFF2564
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 07:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681890959; x=1713426959;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Tmiv+bvfyAu8uzdYcuyPDQm+D/3/w6RVOrvqVGyyxAs=;
  b=o6fnqYrqtSq7BoGFbkBHDs7aYKGkKXFdtwEDub2CiVkuPdu45YMo6JXR
   /v1T3tGZYFXnQwc1OLM/tX+BtdqejXZ7lKtI+V6iAiwhUkbnEX73Z3ufl
   uc3Z+Y1swB0RXjMZnfiRBflIvOsXJiZONyD+g7+w/xPQwZl4sorKqbkVR
   y7VU3SqcmutFhOKjQUuEzvz1svgGqldtV0ySyDUiTxSSvJQ2UXUht1nlm
   RIK2kzCsh/twkZSsIbUPiKl4fcB2LxAZGJw7gfZxOx9y6T0xfTfnTN5mV
   ptFq7GX7YohfncV1dOF3agLkClz4ZHGqxsSa9wNYrLEh6N1Yz52F/UEEG
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,208,1677567600"; 
   d="asc'?scan'208";a="210212416"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Apr 2023 00:55:53 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 19 Apr 2023 00:55:51 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 19 Apr 2023 00:55:50 -0700
Date: Wed, 19 Apr 2023 08:55:34 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>, Alexandre Ghiti
	<alexghiti@rivosinc.com>, Palmer Dabbelt <palmer@rivosinc.com>, Sasha Levin
	<sashal@kernel.org>
Subject: Re: [PATCH 6.1 129/134] riscv: Move early dtb mapping into the
 fixmap region
Message-ID: <20230419-uninstall-fragile-51c326b1adbc@wendy>
References: <20230418120313.001025904@linuxfoundation.org>
 <20230418120317.673170852@linuxfoundation.org>
 <20230418-tactile-cocoa-4242e87bf994@wendy>
 <2023041948-overthrow-debtor-289d@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="NefkzzouBJ6fRXAL"
Content-Disposition: inline
In-Reply-To: <2023041948-overthrow-debtor-289d@gregkh>

--NefkzzouBJ6fRXAL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 09:27:04AM +0200, Greg Kroah-Hartman wrote:
> On Tue, Apr 18, 2023 at 02:10:54PM +0100, Conor Dooley wrote:
> > On Tue, Apr 18, 2023 at 02:23:05PM +0200, Greg Kroah-Hartman wrote:
> > > From: Alexandre Ghiti <alexghiti@rivosinc.com>
> > >=20
> > > [ Upstream commit ef69d2559fe91f23d27a3d6fd640b5641787d22e ]
> >=20
> > Hey Greg,
> >=20
> > Please check out <e3a6656c-0ec4-9d54-b262-1af08c292ed5@microchip.com>
> > (I can't find a lore link for stable-commit@vger stuff)
> > as I am not sure whether it is okay to backport this in isolation.
>=20
> I'm confused, what is needed to be done here?

Originally I got an email saying that some patches had failed to apply:
FAILED: patch "[PATCH] riscv: Move early dtb mapping into the fixmap region=
" failed to apply to 5.15-stable tree
<2023041706-esophagus-evacuate-b5a7@gregkh>
FAILED: patch "[PATCH] riscv: Move early dtb mapping into the fixmap region=
" failed to apply to 6.1-stable tree
<2023041708-sinless-rectangle-f480@gregkh>

I replied to:
Patch "riscv: No need to relocate the dtb as it lies in the fixmap region" =
has been added to the 5.15-stable tree
<2023041741-dirtiness-canon-8104@gregkh>
Where I said that without the failed patches, the above should not be
applied to 5.15.y or 6.1y. You said you would drop it from all stable
trees.

However, this patch ("riscv: Move early dtb mapping into the fixmap
region") did end up getting applied to 6.1.y and 6.2.y, despite what the
email I got said for 6.1.y!

I don't think that either of the patches can be backported in isolation,
so either:

a) drop ("riscv: Move early dtb mapping into the fixmap region") from all
   stable trees & queue it up alongside (riscv: No need to relocate the
   dtb as it lies in the fixmap region) for the next stable update

b) pick ("riscv: No need to relocate the dtb as it lies in the fixmap
   region") up in such a way that it sits immediately after ("riscv: No
   need to relocate the dtb as it lies in the fixmap region") in the
   history

I am the original reporter of the issue and I have a workaround in place
so personally the backport is not urgent (to me at least), so which
option you go for doesn't matter to me.

In case it helps, the patch to pick up for b) is commit 1b50f956c8fe
("riscv: No need to relocate the dtb as it lies in the fixmap region")
upstream.

HTH,
Conor

--NefkzzouBJ6fRXAL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZD+edgAKCRB4tDGHoIJi
0vP0AP9zcctLl0hGKMITfe5ZWxeg6B7Pu4tbBNThqfPWPamWOgD/fZodP+wh+LfC
Xid2MfHq0NFkOw7mugbxE/ICHSS+BgE=
=vEoJ
-----END PGP SIGNATURE-----

--NefkzzouBJ6fRXAL--
