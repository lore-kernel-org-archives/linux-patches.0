Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2B27B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 10:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D050CC433EF;
	Sat, 11 Mar 2023 10:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678531503;
	bh=gof2yisp2HtIDZbA1b8gnwkujtd93p2xrNzrWdFyZOM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mlM4pNEFTwMj2dn1dA+/ugfFAURJZEmy8ECzi/Kz+seqLUChYsWhwutj6U/AOUpPD
	 3Jb8pNGpMZy1vflOLHZ49pHOetaz5HFTJVHzIR3XOc8jEsY3obFxjtX2xAjDhun68J
	 IzrEfEgEPp4pSy9y+TIpG1GIOg07t8zRTGefhuwHDgF3/AuGKWGPhXDm60bCxZnUQO
	 +2P/OSLkQcOZ8eurIwucG4UdzcUQTf7P7koyyCT8LaWdNl43wJRYOvZmaBCevdCFY6
	 7getoEeE1IXzgQbkYzuksArx+n1L8NLyBGmWB6dLPp4IExZQXqDPdjDPaSIUIU8ur9
	 uq+ZiDh5pY8hQ==
Date: Sat, 11 Mar 2023 10:44:58 +0000
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/211] 6.2.4-rc1 review
Message-ID: <7ea166cd-6ee7-4e37-9c1b-651af74b3485@spud>
References: <20230310133718.689332661@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ZPlgujJ53LLPEV6A"
Content-Disposition: inline
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>


--ZPlgujJ53LLPEV6A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 10, 2023 at 02:36:20PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.4 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No complaints from my CI :)
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--ZPlgujJ53LLPEV6A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZAxbqgAKCRB4tDGHoIJi
0hiBAP9QwqvVjlZXm79qpbUfDTsT84TD6XWWDhiiRuTh/d3eQgD/ebZnfcCZm5cP
PK6W0EseZ/LzoK58QbYn1ygqlBTwKwM=
=s0fh
-----END PGP SIGNATURE-----

--ZPlgujJ53LLPEV6A--
