Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBC342069
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 04:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719290837; cv=none; b=e+O2T+ynWpyEkuqUZvFMNPrtkIf45ALjXusLDe8qsN79hJj+0kdEsmOOqoU6n+kX6zIGxoDiirRWc2CLZIopuCRmjGLEso1pGt6d4WjdJB4eO1AtC7zS6lx5e3tQre89iHKE4fGZA6BZO5/EMK8pA6nZvnUXEvn0pmKWNhAMXz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719290837; c=relaxed/simple;
	bh=Qq60K9uBm/y/DS9p0kw9MthIKTXDk3frdtVp/7N7oSI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ownVohDwX64EKc34qdbzB7n71XgR0ymjKLGyGjoDncrHMcryaa4J7IlnZHx9e/9zfGyOQr8qR+/H1tjCBZgqh5FsaJStiChZuOpsKyhH/CEOVUamwvi2N2oDHKOG5x1NnXgKoM+hF0W02dGlFFMh7VhiN6KW7zv2mXhnJYkPhow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FIPV+iK4; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FIPV+iK4"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2c7ecfc9e22so3610990a91.0
        for <patches@lists.linux.dev>; Mon, 24 Jun 2024 21:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719290835; x=1719895635; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ET8p4ZwbaktWKrn1b5eMaR4bScMUPPuup2Ir2dcizeY=;
        b=FIPV+iK4P6ZjXs0Go/Zapl6Z93cFAdTjWT04viVUOvOzXLJ/8ldpe3CQZNJcELk/K+
         1KMauHiZEV+Xxy9HhYOERjeLFv7Rjwr7PDchukymn9L+IZOS+aZCtr0499Nj+iSpqmis
         gm4WeVPlxdDM24APsd9/haxHf/oiBDVvjGKutmeW2IBIIlWSWDslLU5hBuPHSkz4RS/q
         C3K/E5se4G4QML35QBnljfwY/hARkW2K4Lvkz3lZqPKOUrlYXwfmfT4sftuVRkktNADc
         y1ObDgwsphHkP0LIsXiUjSnPmP+8G5BOgTrmp+6Kez0Cnfjrw57dVasSDA0Fy41o4o95
         ROqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719290835; x=1719895635;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ET8p4ZwbaktWKrn1b5eMaR4bScMUPPuup2Ir2dcizeY=;
        b=ojujWbe4t+F44B2QbM1ihUGbJhJsixcysVuGzuyOOsn7ehZzhH+DBrv2SfgyfGCIZC
         6YKNpt/iM7lbl9EcnWitQoHsnff0+G+4oWo5K+eomg0n1rp5qLq2ERRblGxPOfPG+XAs
         7MNp6/lmRhj07XFymQ1evFQbmtFjHWu7mUf/98YY6AiBG3EjrVfB3wogPjgYhNa5xrM3
         1TTzTsywEUhTn2Hm+m+c4T30W2Yn7JzmVusKoLuDvvgU8hetSdi6nBOw5uAcbY+XIz4e
         EHmOjreIPPNIdngsFJm9kllLrP01AKJMON+ffQIUxicDg+6vHOga7r7M7xdW8mr88NF6
         C8og==
X-Forwarded-Encrypted: i=1; AJvYcCUG6chA+oul3WAWQT98VqoGR57M0lPTFklnNkoyTg/NcR6fE6/+34sIWGUrXSq7cONdqvU9OvZv3VTB7dEAnY31DxwYAYAYyQ==
X-Gm-Message-State: AOJu0Yxdq1diyn4bbRbAiCtWpJv5lx33M9YbWtmVhZ2rwVKpHT7REq9E
	Y/2pl3a81JKeewW5BflGI8WiuvqGJA+mk9NravbqEpkh/jZlr2o3
X-Google-Smtp-Source: AGHT+IG0sebUeJQpuk9+1T7kODbDmbzQzYQvAA+fXGNUTHhxYQMrZTAru7EJUh2kkRifOwgpdBBbcA==
X-Received: by 2002:a17:90a:1286:b0:2a4:b831:5017 with SMTP id 98e67ed59e1d1-2c861435644mr5105992a91.48.1719290835238;
        Mon, 24 Jun 2024 21:47:15 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c7e64a2bc8sm9674004a91.54.2024.06.24.21.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jun 2024 21:47:14 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 47CFA195E2806; Tue, 25 Jun 2024 11:47:12 +0700 (WIB)
Date: Tue, 25 Jun 2024 11:47:11 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Itay Avraham <itayavr@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
	Leon Romanovsky <leon@kernel.org>, linux-doc@vger.kernel.org,
	linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>
Cc: Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Aron Silverton <aron.silverton@oracle.com>,
	Dan Williams <dan.j.williams@intel.com>,
	David Ahern <dsahern@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, Jiri Pirko <jiri@nvidia.com>,
	Leonid Bloch <lbloch@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>, linux-cxl@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 1/8] fwctl: Add basic structure for a class subsystem
 with a cdev
Message-ID: <ZnpLz_w0sKmYNVFt@archie.me>
References: <0-v2-940e479ceba9+3821-fwctl_jgg@nvidia.com>
 <1-v2-940e479ceba9+3821-fwctl_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6pUg5LYy9ZFeyzko"
Content-Disposition: inline
In-Reply-To: <1-v2-940e479ceba9+3821-fwctl_jgg@nvidia.com>


--6pUg5LYy9ZFeyzko
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 24, 2024 at 07:47:25PM -0300, Jason Gunthorpe wrote:
> +/**
> + * fwctl_alloc_device - Allocate a fwctl
> + * @parent: Physical device that provides the FW interface
> + * @ops: Driver ops to register
> + * @drv_struct: 'struct driver_fwctl' that holds the struct fwctl_device
> + * @member: Name of the struct fwctl_device in @drv_struct
> + *
> + * This allocates and initializes the fwctl_device embedded in the drv_s=
truct.
> + * Upon success the pointer must be freed via fwctl_put(). Returns NULL =
on
> + * failure. Returns a 'drv_struct *' on success, NULL on error.
> + */

Sphinx reports htmldocs warning:

Documentation/userspace-api/fwctl:195: ./include/linux/fwctl.h:72: WARNING:=
 Inline emphasis start-string without end-string.

I have to escape the pointer (while also cleaning up redundant wordings on
error case):

---- >8 ----
diff --git a/include/linux/fwctl.h b/include/linux/fwctl.h
index 294cfbf63306a2..ddadbe15189b45 100644
--- a/include/linux/fwctl.h
+++ b/include/linux/fwctl.h
@@ -70,8 +70,8 @@ struct fwctl_device *_fwctl_alloc_device(struct device *p=
arent,
  * @member: Name of the struct fwctl_device in @drv_struct
  *
  * This allocates and initializes the fwctl_device embedded in the drv_str=
uct.
- * Upon success the pointer must be freed via fwctl_put(). Returns NULL on
- * failure. Returns a 'drv_struct *' on success, NULL on error.
+ * Upon success the pointer must be freed via fwctl_put(). Returns a
+ * 'drv_struct \*' on success, NULL on error.
  */
 #define fwctl_alloc_device(parent, ops, drv_struct, member)               =
   \
 	container_of(_fwctl_alloc_device(                                    \

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--6pUg5LYy9ZFeyzko
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZnpLzAAKCRD2uYlJVVFO
o1kVAQCH1QHvokEmFRkQR2mgHs8K7Dlhtwzt3YYY/nU5W7068gD8CRCDUZcTmGzG
DoBud1vig/RrySo6o0mtkufVgkx1qA8=
=WNas
-----END PGP SIGNATURE-----

--6pUg5LYy9ZFeyzko--
