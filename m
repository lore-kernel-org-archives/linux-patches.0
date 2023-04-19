Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598E428F2
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 09:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681897885; x=1713433885;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2++nSSrT5nniK9fpVTuV0DgPyzRh8rJXu8hMOLI8idU=;
  b=VA05lxDbclBsysN0TpMq7MbnU8K6aQ5I/YrhfW1x3neki0m0V54ja1Cm
   GAo9JkJEYeUtVfM5rAk6wJm/JRvXaX8Qv4HrPeZt2cJedf1fPHLETQxTE
   QopCKl58e4YJ5aY12oP+WaFgIfmUZgWO9+mzPNjCSb0pszExCFeBElDXT
   8SJEBmw0BCutmk/QJPXQQAUbNVX6WTNv6my8JjX4d1GFtRiVlLS1MbZWe
   qboU8bJYxiatyYCZKP9avf8y8TSHnvkrCyeZ8CFCMTPhDuwo5Bov3K1/2
   nRQLKg6A72jHjXhqryi04Z5DDc9EpnZZOXOqZZqHHGS6Wgt3TmQakhbkQ
   w==;
X-IronPort-AV: E=Sophos;i="5.99,208,1677567600"; 
   d="asc'?scan'208";a="147827089"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Apr 2023 02:51:23 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 19 Apr 2023 02:51:23 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 19 Apr 2023 02:51:22 -0700
Date: Wed, 19 Apr 2023 10:51:05 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>, Alexandre Ghiti
	<alexghiti@rivosinc.com>, Palmer Dabbelt <palmer@rivosinc.com>, Sasha Levin
	<sashal@kernel.org>
Subject: Re: [PATCH 6.1 129/134] riscv: Move early dtb mapping into the
 fixmap region
Message-ID: <20230419-unpeeled-squabble-986a9e40e4d5@wendy>
References: <20230418120313.001025904@linuxfoundation.org>
 <20230418120317.673170852@linuxfoundation.org>
 <20230418-tactile-cocoa-4242e87bf994@wendy>
 <2023041948-overthrow-debtor-289d@gregkh>
 <20230419-uninstall-fragile-51c326b1adbc@wendy>
 <2023041918-stammer-subgroup-fbd1@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="mUfhQeVO79oV2LO/"
Content-Disposition: inline
In-Reply-To: <2023041918-stammer-subgroup-fbd1@gregkh>

--mUfhQeVO79oV2LO/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 11:36:43AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Apr 19, 2023 at 08:55:34AM +0100, Conor Dooley wrote:

> > However, this patch ("riscv: Move early dtb mapping into the fixmap
> > region") did end up getting applied to 6.1.y and 6.2.y, despite what the
> > email I got said for 6.1.y!
>=20
> That's because Sasha backported the dependent patches to get it to
> apply.

Should probably send out a notification of success then, no?
At least, I didn't see one land in my inbox.

> Let me just drop all of them, that makes it simpler and then if anyone
> wants them applied, then they can send us an explicit set of patches.

Perfect, I should be able to do that.
Some time here might actually work in our favour, as I don't think this
stuff has been tested yet by anyone using XIP and I had expressed some
concerns that we would cause them issues.
I already owe you one set of non-urgent backports that I have yet to
get around to...

Cheers,
Conor.

--mUfhQeVO79oV2LO/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZD+5iQAKCRB4tDGHoIJi
0k8PAP9Ga8BokGT94OnNEo5zIe3wIG15iuTSZOPBTQU0v2hREAD/f6iO7wunKFqW
Mp64sgBtnDTckllraDvN0Zj8h06JeQE=
=ddbG
-----END PGP SIGNATURE-----

--mUfhQeVO79oV2LO/--
