Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D3CEB34
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 19:47:39 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 4C6111C09F4; Thu,  5 Jan 2023 20:47:37 +0100 (CET)
Date: Thu, 5 Jan 2023 20:47:36 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nathan@kernel.org,
	marcus.folkesson@gmail.com, cuigaosheng1@huawei.com,
	andriy.shevchenko@linux.intel.com, m.szyprowski@samsung.com,
	jack@suse.cz
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.9 000/251] 4.9.337-rc1 review
Message-ID: <Y7cpWKbQlNW5qEeO@duo.ucw.cz>
References: <20230105125334.727282894@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W88MDnI1irEhoaY2"
Content-Disposition: inline
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>


--W88MDnI1irEhoaY2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.9.337 release.
> There are 251 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

These are kCFI fixes, we don't really need them in 4.9:

> Nathan Chancellor <nathan@kernel.org>
>     net: ethernet: ti: Fix return type of netcp_ndo_start_xmit()
> Nathan Chancellor <nathan@kernel.org>
>     hamradio: baycom_epp: Fix return type of baycom_send_packet()
> Nathan Chancellor <nathan@kernel.org>
>     drm/fsl-dcu: Fix return type of fsl_dcu_drm_connector_mode_valid()
> Nathan Chancellor <nathan@kernel.org>
>     drm/sti: Fix return type of sti_{dvo,hda,hdmi}_connector_mode_valid()

This is marked as not-for-stable, and does not fix anything really
bad, just smatch warning:

> Marcus Folkesson <marcus.folkesson@gmail.com>
>     HID: hid-sensor-custom: set fixed size for custom attributes

This is quite wrong. Real bug is registering the interrupt before the
device is set up -- it should be fixed by reordering the init code,
not by checking for NULL.

> Gaosheng Cui <cuigaosheng1@huawei.com>
>     ALSA: mts64: fix possible null-ptr-defer in snd_mts64_interrupt

This may turn working config into non-working for someone, as people
now need to enable PWM manually to get fully working driver. I don't
think we want it in stable.

> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     fbdev: ssd1307fb: Drop optional dependency

This claims to fix a deadlock, but in turn it calls
cancel_delayed_work_sync from interrupt handler. I don't think that is
good idea.

> Marek Szyprowski <m.szyprowski@samsung.com>
>     ASoC: wm8994: Fix potential deadlock

This one is okay in mainline, but contains wrong error handling in the
4.9 backport. 4.19 seems okay. It needs to "goto out_unlock", not
return directly.

> Jan Kara <jack@suse.cz>
>     ext4: initialize quota before expanding inode in setproject ioctl

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--W88MDnI1irEhoaY2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY7cpWAAKCRAw5/Bqldv6
8ojEAKCY75U3fxHtetJmbMdT2+rhB2HWhACgs7WB0SnN3QEXI1p9VceTklePlfU=
=giGP
-----END PGP SIGNATURE-----

--W88MDnI1irEhoaY2--
