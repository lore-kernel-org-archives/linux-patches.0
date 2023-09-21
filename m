Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78405B641
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 13:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FF9C4E67F;
	Thu, 21 Sep 2023 13:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695301564;
	bh=EP89eX6yOgeR2iekeqQE5Ry2w+5p5CtBuX7Qtt6d/CQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l25MNE5TKqRvrezR1WxWkXus4o+3QMHHByEzPOD8kGXHGZ+pHxqjzO0fUYSqCzbXx
	 p/byGA7XWmMESx0vismQs3Zo/uZReQy6C8NOR0G3B6Sbiws+MuA8tDxa1VLWExCs2I
	 KOHqDJExW3/Ms1d6461wv5Vo41MWG6ar2P3jjtwaJL9YWb8rL/SyyE4rWbkSeNl4HM
	 CMcl8QrtbEW9jKCeLyDm7SVcTbfmkkamyA/YNFFMim9a6jvm7JbdsnWsDL2vZ0+Yi2
	 3LapxG6qg62nk5b+ql9AHoTo3uypWbNth32QIn0cOiEyui0TYRcq2qGTKpFDeOeIRM
	 iFipAwLH3IpbQ==
Date: Thu, 21 Sep 2023 14:05:58 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.5 000/211] 6.5.5-rc1 review
Message-ID: <20230921-exposure-writing-f10542bd5826@spud>
References: <20230920112845.859868994@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="MdHrbX13gF8e3+ch"
Content-Disposition: inline
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>


--MdHrbX13gF8e3+ch
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 20, 2023 at 01:27:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.5 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--MdHrbX13gF8e3+ch
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZQw/tgAKCRB4tDGHoIJi
0pu/AQDDDTW275Cw6AhB/QoX1H5646dHJnrJSJClq1QdYOf+RQEA+ejVENELniKD
EnLwAKZLEQzSFITcxrNqqN2mSNFGZgg=
=V+jH
-----END PGP SIGNATURE-----

--MdHrbX13gF8e3+ch--
