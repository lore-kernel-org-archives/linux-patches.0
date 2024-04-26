Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221D2171661;
	Fri, 26 Apr 2024 17:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.217.213.242
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714152317; cv=none; b=Hgx8Lz7Wqn6GaT6sbRVOATrlg2Sm7NE484Ea7uTHplPD0A4DKJvb4+isuoaRao/cjKbxGwd+l2wepNdzBagLULLt+lAY86QHfFASn6iWNesLnhHPEOyigVLZ/Zt8ZufpwjxuB5J1gta6LeVloC2uWkp9vUFiZ8GdLmGyg3VyjCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714152317; c=relaxed/simple;
	bh=avX99l12aaTneezI5L11wOWJLcGRfk67mgBNxxwnBsw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SGOIHlsAl6zhsn8dWengQBNG9aHASUnB8bdghgqp3itXuaEG2QWqGBqGeu0P8zXcn2Qt/DmMFBOIlIf/pZMGPYx7Ef4Gpn/bUq8uUi5LEZA+PQZrnBZ7g/QJFzBsFtIQPavv/v8mOwvZlYs6cM28mWkXBNuaS4k+0PoEkgnuaUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=95.217.213.242
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from 213.219.156.63.adsl.dyn.edpnet.net ([213.219.156.63] helo=deadeye)
	by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ben@decadent.org.uk>)
	id 1s0OsP-0001oK-Kt; Fri, 26 Apr 2024 18:56:45 +0200
Received: from ben by deadeye with local (Exim 4.97)
	(envelope-from <ben@decadent.org.uk>)
	id 1s0OsP-00000000RcT-08rD;
	Fri, 26 Apr 2024 18:56:45 +0200
Message-ID: <c8ac24aef38a0f9fab3f029b464fd396ee51bfcd.camel@decadent.org.uk>
Subject: Re: [PATCH 4.19 091/175] loop: Remove sector_t truncation checks
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Martijn Coenen <maco@android.com>, Christoph
 Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Genjian Zhang
 <zhanggenjian@kylinos.cn>
Date: Fri, 26 Apr 2024 18:56:40 +0200
In-Reply-To: <20240411095422.304818113@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
	 <20240411095422.304818113@linuxfoundation.org>
Autocrypt: addr=ben@decadent.org.uk; prefer-encrypt=mutual;
 keydata=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
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-YqBx7HU+ec+RXTA8wGbW"
User-Agent: Evolution 3.50.3-1+b1 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 213.219.156.63
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-YqBx7HU+ec+RXTA8wGbW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2024-04-11 at 11:55 +0200, Greg Kroah-Hartman wrote:
> 4.19-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Martijn Coenen <maco@android.com>
>=20
> [ Upstream commit 083a6a50783ef54256eec3499e6575237e0e3d53 ]
>=20
> sector_t is now always u64, so we don't need to check for truncation.

This needs to be reverted for 4.19, because sector_t wasn't always u64
until 5.2.

Ben.

> Signed-off-by: Martijn Coenen <maco@android.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/block/loop.c |   21 +++++++--------------
>  1 file changed, 7 insertions(+), 14 deletions(-)
>=20
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -225,24 +225,20 @@ static void __loop_update_dio(struct loo
>  	blk_mq_unfreeze_queue(lo->lo_queue);
>  }
> =20
> -static int
> +static void
>  figure_loop_size(struct loop_device *lo, loff_t offset, loff_t sizelimit=
)
>  {
>  	loff_t size =3D get_size(offset, sizelimit, lo->lo_backing_file);
> -	sector_t x =3D (sector_t)size;
>  	struct block_device *bdev =3D lo->lo_device;
> =20
> -	if (unlikely((loff_t)x !=3D size))
> -		return -EFBIG;
>  	if (lo->lo_offset !=3D offset)
>  		lo->lo_offset =3D offset;
>  	if (lo->lo_sizelimit !=3D sizelimit)
>  		lo->lo_sizelimit =3D sizelimit;
> -	set_capacity(lo->lo_disk, x);
> +	set_capacity(lo->lo_disk, size);
>  	bd_set_size(bdev, (loff_t)get_capacity(bdev->bd_disk) << 9);
>  	/* let user-space know about the new size */
>  	kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
> -	return 0;
>  }
> =20
>  static inline int
> @@ -972,10 +968,8 @@ static int loop_set_fd(struct loop_devic
>  	    !file->f_op->write_iter)
>  		lo_flags |=3D LO_FLAGS_READ_ONLY;
> =20
> -	error =3D -EFBIG;
>  	size =3D get_loop_size(lo, file);
> -	if ((loff_t)(sector_t)size !=3D size)
> -		goto out_unlock;
> +
>  	error =3D loop_prepare_queue(lo);
>  	if (error)
>  		goto out_unlock;
> @@ -1280,10 +1274,7 @@ loop_set_status(struct loop_device *lo,
>  				lo->lo_device->bd_inode->i_mapping->nrpages);
>  			goto out_unfreeze;
>  		}
> -		if (figure_loop_size(lo, info->lo_offset, info->lo_sizelimit)) {
> -			err =3D -EFBIG;
> -			goto out_unfreeze;
> -		}
> +		figure_loop_size(lo, info->lo_offset, info->lo_sizelimit);
>  	}
> =20
>  	memcpy(lo->lo_file_name, info->lo_file_name, LO_NAME_SIZE);
> @@ -1486,7 +1477,9 @@ static int loop_set_capacity(struct loop
>  	if (unlikely(lo->lo_state !=3D Lo_bound))
>  		return -ENXIO;
> =20
> -	return figure_loop_size(lo, lo->lo_offset, lo->lo_sizelimit);
> +	figure_loop_size(lo, lo->lo_offset, lo->lo_sizelimit);
> +
> +	return 0;
>  }
> =20
>  static int loop_set_dio(struct loop_device *lo, unsigned long arg)
>=20
>=20
>=20

--=20
Ben Hutchings
Everything should be made as simple as possible, but not simpler.
                                                      - Albert Einstein


--=-YqBx7HU+ec+RXTA8wGbW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmYr3MgACgkQ57/I7JWG
EQlwkQ//Q1+CQkD8tpI7V8khvE3CdtiDAbb+SX+1ctYwo1ykrrWKA5dopTt/Irn0
DAtdfMjzxirtbYZdGWMWg9PrmMyc3CYzNRykydFMp3gdHdwZOSK2qlyoqnIi8ayA
OSZhb5wqcLT+ay4mEoG8wUn971BzAKjnRaATsM6kZddMF2nqt5ExaPwrR0AVGSsv
Lqxqvz+OJd5z4LhAc2KTbX9OFWXIeWNoTWIH51+aRlc7OCETvrMSGvHAbMNx50mm
0dfO+ixJA3TLSR7Dz+MTlaKjWq4AoIkR/2P5XvyZgIkZKYwb/AMU69bR39CrX082
cBqUWQI5jYilp/pQh9Xkky1R/UWVUS/3AFt67xlCzZaQRX5ZyZPkzOwvKJHYMpEs
TzWC7HIHfqMyHBMGT7ISICwAotSYnyJgFllFQmWEsc9MHvefQS8deK8hbpQm6j+R
NVaG0G235o56Nvb8VaMlIoELAdN2oq/MjVMMemj8pK4pDcv3Mj/jb69C8UC1PvTO
InJTSaXV9v0QOgJKKcTQIonCzMTDLCk8z675ni4/j9sNabLPwMgTHS63NVxwIre/
B+jz6kV/gorbx2T2H2m305mbwtCwtgz0S+JL3aC5pasd5WE+FyipUm3rny0qmujz
0zZYE2/00eptoIfYNvUUhTWFST911rUYKVdFMNQiLnrAM33v1uk=
=mCsA
-----END PGP SIGNATURE-----

--=-YqBx7HU+ec+RXTA8wGbW--
