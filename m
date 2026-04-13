Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC651D95A3;
	Mon, 13 Apr 2026 20:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776113622; cv=none; b=adCNCxH8n7LXeUSi3BhDfxZRKacMAdz8JF2OSaQQsOLijLgHcJpn/KHiHzU4KEyAFmBZ5FW8bKrNHYHjXEVJq4qZEA+8HTkznprSiSwX7O1dRVaCXAPr3j09wyETjH7Zga7bRFGkCv+QRLRWjRrcJQfjZ3bbwyg8+5RNLajiQpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776113622; c=relaxed/simple;
	bh=IYjYLeJroBuUCahe5jafcSSBfWsSzetiWFc219Rcs8U=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rQAdjTtywC+fL9PGpAejzfev06fdYf5MmwKr7SR7CqxdnpKavy9sKzzkIXhX4weOjoiuHqCfoFKF1/oz5VJF91ntthc17ulIR9kN388iQKrDcdNbt1gh6r/n17Wgr7sGox5Jn6wpLTXEVuCUfduThTwTi0NxVWftUS9ATXK6tZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wCNie-004mtF-2t;
	Mon, 13 Apr 2026 20:17:16 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1wCNic-00000002eOM-24Qq;
	Mon, 13 Apr 2026 22:17:14 +0200
Message-ID: <dce92963d28f3419e014c428a0b243f4fe638109.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 290/491] ACPI: EC: Install address space handler at
 the namespace root
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, webcaptcha <webcapcha@gmail.com>, Heikki
 Krogerus	 <heikki.krogerus@linux.intel.com>, "Rafael J. Wysocki"	
 <rafael.j.wysocki@intel.com>, Hans de Goede <hdegoede@redhat.com>, Mario
 Limonciello <mario.limonciello@amd.com>, Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>, Sasha Levin	 <sashal@kernel.org>
Date: Mon, 13 Apr 2026 22:17:08 +0200
In-Reply-To: <20260413155829.901289649@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
	 <20260413155829.901289649@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-j1G0dLA27Kob4bewxve2"
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


--=-j1G0dLA27Kob4bewxve2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2026-04-13 at 17:58 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>=20
> [ Upstream commit 60fa6ae6e6d09e377fce6f8d9b6f6a4d88769f63 ]

It appears that this can cause regressions, which were fixed by commits
71bf41b8e913 ("ACPI: EC: Evaluate _REG outside the EC scope more
carefully")=C2=A0and 0e6b6dedf168 ("ACPI: EC: Evaluate orphan _REG under EC
device") upstream.  I didn't check whether those would apply and build
cleanly here, but if not then this may have to be dropped.

Ben.

> It is reported that _DSM evaluation fails in ucsi_acpi_dsm() on Lenovo
> IdeaPad Pro 5 due to a missing address space handler for the EC address
> space:
>=20
>  ACPI Error: No handler for Region [ECSI] (000000007b8176ee) [EmbeddedCon=
trol] (20230628/evregion-130)
>=20
> This happens because if there is no ECDT, the EC driver only registers
> the EC address space handler for operation regions defined in the EC
> device scope of the ACPI namespace while the operation region being
> accessed by the _DSM in question is located beyond that scope.
>=20
> To address this, modify the ACPI EC driver to install the EC address
> space handler at the root of the ACPI namespace for the first EC that
> can be found regardless of whether or not an ECDT is present.
>=20
> Note that this change is consistent with some examples in the ACPI
> specification in which EC operation regions located outside the EC
> device scope are used (for example, see Section 9.17.15 in ACPI 6.5),
> so the current behavior of the EC driver is arguably questionable.
>=20
> Reported-by: webcaptcha <webcapcha@gmail.com>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D218789
> Link: https://uefi.org/specs/ACPI/6.5/09_ACPI_Defined_Devices_and_Device_=
Specific_Objects.html#example-asl-code
> Link: https://lore.kernel.org/linux-acpi/Zi+0whTvDbAdveHq@kuha.fi.intel.c=
om
> Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Stable-dep-of: f6484cadbcaf ("ACPI: EC: clean up handlers on probe failur=
e in acpi_ec_setup()")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/acpi/ec.c       | 25 ++++++++++++++++---------
>  drivers/acpi/internal.h |  1 -
>  2 files changed, 16 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
> index 10f7e3ef58791..1d7e7e47ea0e4 100644
> --- a/drivers/acpi/ec.c
> +++ b/drivers/acpi/ec.c
> @@ -1514,13 +1514,14 @@ static bool install_gpio_irq_event_handler(struct=
 acpi_ec *ec)
>  static int ec_install_handlers(struct acpi_ec *ec, struct acpi_device *d=
evice,
>  			       bool call_reg)
>  {
> +	acpi_handle scope_handle =3D ec =3D=3D first_ec ? ACPI_ROOT_OBJECT : ec=
->handle;
>  	acpi_status status;
> =20
>  	acpi_ec_start(ec, false);
> =20
>  	if (!test_bit(EC_FLAGS_EC_HANDLER_INSTALLED, &ec->flags)) {
>  		acpi_ec_enter_noirq(ec);
> -		status =3D acpi_install_address_space_handler_no_reg(ec->handle,
> +		status =3D acpi_install_address_space_handler_no_reg(scope_handle,
>  								   ACPI_ADR_SPACE_EC,
>  								   &acpi_ec_space_handler,
>  								   NULL, ec);
> @@ -1529,11 +1530,10 @@ static int ec_install_handlers(struct acpi_ec *ec=
, struct acpi_device *device,
>  			return -ENODEV;
>  		}
>  		set_bit(EC_FLAGS_EC_HANDLER_INSTALLED, &ec->flags);
> -		ec->address_space_handler_holder =3D ec->handle;
>  	}
> =20
>  	if (call_reg && !test_bit(EC_FLAGS_EC_REG_CALLED, &ec->flags)) {
> -		acpi_execute_reg_methods(ec->handle, ACPI_ADR_SPACE_EC);
> +		acpi_execute_reg_methods(scope_handle, ACPI_ADR_SPACE_EC);
>  		set_bit(EC_FLAGS_EC_REG_CALLED, &ec->flags);
>  	}
> =20
> @@ -1585,10 +1585,13 @@ static int ec_install_handlers(struct acpi_ec *ec=
, struct acpi_device *device,
> =20
>  static void ec_remove_handlers(struct acpi_ec *ec)
>  {
> +	acpi_handle scope_handle =3D ec =3D=3D first_ec ? ACPI_ROOT_OBJECT : ec=
->handle;
> +
>  	if (test_bit(EC_FLAGS_EC_HANDLER_INSTALLED, &ec->flags)) {
>  		if (ACPI_FAILURE(acpi_remove_address_space_handler(
> -					ec->address_space_handler_holder,
> -					ACPI_ADR_SPACE_EC, &acpi_ec_space_handler)))
> +						scope_handle,
> +						ACPI_ADR_SPACE_EC,
> +						&acpi_ec_space_handler)))
>  			pr_err("failed to remove space handler\n");
>  		clear_bit(EC_FLAGS_EC_HANDLER_INSTALLED, &ec->flags);
>  	}
> @@ -1627,14 +1630,18 @@ static int acpi_ec_setup(struct acpi_ec *ec, stru=
ct acpi_device *device, bool ca
>  {
>  	int ret;
> =20
> -	ret =3D ec_install_handlers(ec, device, call_reg);
> -	if (ret)
> -		return ret;
> -
>  	/* First EC capable of handling transactions */
>  	if (!first_ec)
>  		first_ec =3D ec;
> =20
> +	ret =3D ec_install_handlers(ec, device, call_reg);
> +	if (ret) {
> +		if (ec =3D=3D first_ec)
> +			first_ec =3D NULL;
> +
> +		return ret;
> +	}
> +
>  	pr_info("EC_CMD/EC_SC=3D0x%lx, EC_DATA=3D0x%lx\n", ec->command_addr,
>  		ec->data_addr);
> =20
> diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
> index 4edf591f8a3a5..f6c929787c9e6 100644
> --- a/drivers/acpi/internal.h
> +++ b/drivers/acpi/internal.h
> @@ -169,7 +169,6 @@ static inline void acpi_early_processor_osc(void) {}
>     ---------------------------------------------------------------------=
----- */
>  struct acpi_ec {
>  	acpi_handle handle;
> -	acpi_handle address_space_handler_holder;
>  	int gpe;
>  	int irq;
>  	unsigned long command_addr;

--=20
Ben Hutchings
When in doubt, use brute force. - Ken Thompson

--=-j1G0dLA27Kob4bewxve2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmndT0QACgkQ57/I7JWG
EQlp8hAA0umBd4LrdRHQIDkE8dT27ae0qbREWuQ1Gh6Vkrax7PQzVcR2rQpSbwxv
drWaPy/m1PoZrLXDwz5RsqvzqGy9oU3MqybmV46iqEO34yAgc6AjllqnjyJSrLrq
+dlUlHf/CfpFIKb64w2ubXaAfoOwc0SZ0Nsi3sV1O+u4TKYYfDVji6MTDdUAXzhr
b68rXLxqTHxnDVDLePR1VneYhTTfbdxLvWaukNBAi+yBjlN6ez1daM+nBRSSK43p
Nv+DCIdJ9daNeL98BKMJL5iGYHhIvl8fI8vmaUd/UcBwawH+DORHyTnxHWs14p1D
U0XehJCRpEGDGI7oe3+EpXbayRAVBZt8jjFP7gd1x4Qi9D7O2TFTDdRZWP3J3rqV
4uKdNYtE17Phf9QWHowMsI783JMruuajlCPuTU4AkoZo77CCjLW+y1hoPQrCiH8G
yuLbsueX134xOgPg4ZdFX6VDM8aZ2JTH7X+hkPdUEHO9H3gTUaYN8F4cAawKBTXJ
ZBhpQRQvXYlwRdCchDgBB+jvDkTjEXtSDJVlUpkXclNI9bicrgpznfWCRxcWGXGf
V2Ryx6IGRDH0OOpnUbbGTs3mxX3PwhjAlITPcREld/dw4s2fW7RwPHKrOCUjvYnr
NMwUaiY3JUdvpN7vgC+3Of+W4UFet4rzHNIqC4972R4D4trlt4w=
=ojTu
-----END PGP SIGNATURE-----

--=-j1G0dLA27Kob4bewxve2--
