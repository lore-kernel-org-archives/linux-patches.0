Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3234C7B
	for <patches@lists.linux.dev>; Tue, 23 May 2023 14:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50030C433EF;
	Tue, 23 May 2023 14:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684853699;
	bh=zdl3AS29MyWrLEmOP0SSKeqNHJlZoqqwYHXogpqPUXU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jKc2zzzlsLy56Yi49H7pkqwLeJClCqkpF6fm0ZtPJRzjnQvemi58FolIFHeG19WMc
	 nhgv38Dqfayym2AojOBN3nBqO+KD77DuyatEZZK0ckyszE/FMbo4wya7bvTpFI1Bmd
	 NA0U7U7EeXvX9ut8dJo88w+6mKrvOGmA7xIbvWiwpUPfLBUHUUcJ+qQZR0aVCSNJaN
	 eAtdRcdyGr2nEcJtRFIYmI5HNKexH3kpOTZ5GBJGTR3PWoJUF7pASaKDLXcqwnZ5Ws
	 CTtv4LKyhnqPXXe32vv6OECAqrDt3ad+pJZ+6wENQGeePi3Nq4QBIIYUG0kX/ZW5IJ
	 MRmRY1gM4PJXw==
Date: Tue, 23 May 2023 15:54:53 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/292] 6.1.30-rc1 review
Message-ID: <20230523-swapping-tracing-90ed17441023@spud>
References: <20230522190405.880733338@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="QU4KWqIybnCs5+Gi"
Content-Disposition: inline
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>


--QU4KWqIybnCs5+Gi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 22, 2023 at 08:05:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.30 release.
> There are 292 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--QU4KWqIybnCs5+Gi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZGzTvQAKCRB4tDGHoIJi
0uPjAQCUCWcOuk/Ir+if2RbUuyJhXoBsiMaPdx1ZnANDOqQ48QD/V6WATUmaHG1h
DwZW4S47uBtiAZ3h537ew1tsbd62Ggc=
=bTzy
-----END PGP SIGNATURE-----

--QU4KWqIybnCs5+Gi--
