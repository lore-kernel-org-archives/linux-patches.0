Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA791ADCC
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 15:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1403C433C8;
	Tue,  1 Aug 2023 15:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690905406;
	bh=iGV+6Aj7YdAAbxDxMz9XXvaxnnB4NKb9aoSMOJfeyy8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HkPEuJiP5IlZdyMlP/tOap6keT7iD2mj63Q6cUfrjmwbHGNc+2S8LXSIJ676j+/fS
	 cipsVmvY2ThVEP+KHhNbL1JMuagiz7w/y9cciX0gewqPDnq1D4Y/CvyjLdqYbzRRKr
	 NoC1Ch6skSHEpy7oWck+17qTSj4+bTslWdDtBEj2P+0v1+aggWrVmY6ufRnUXOi6L5
	 ZBvASCGlcFP0TXqJDxZbtVqBXGVvH0RCXCFMSGq+byioLdMMvF+5lrTLhq0/pDdext
	 ko7txeGI928zRnBn/FTz8yVUJO+rtX9q6NNfR/Jj/9dx5PLiY9oqdiXjezW9FRGjkJ
	 2OLnmfHQ64d4Q==
Date: Tue, 1 Aug 2023 16:56:41 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.4 000/239] 6.4.8-rc1 review
Message-ID: <20230801-hardened-paralyze-da39ecdd12b3@spud>
References: <20230801091925.659598007@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="xnYYIjW9LqcL8ceM"
Content-Disposition: inline
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>


--xnYYIjW9LqcL8ceM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 01, 2023 at 11:17:44AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.8 release.
> There are 239 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--xnYYIjW9LqcL8ceM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZMkrOQAKCRB4tDGHoIJi
0s+9AQDNHZ7ZWADkUfXIy2NHz1RmNvbqcKVeyuTVsVk/0SYNgwD+IaYZ7PpgnyP6
wPF16i8dSMyhx03vgcxaUqcWNB1JTQ4=
=oevv
-----END PGP SIGNATURE-----

--xnYYIjW9LqcL8ceM--
