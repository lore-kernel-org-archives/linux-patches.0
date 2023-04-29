Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2E028EE
	for <patches@lists.linux.dev>; Sat, 29 Apr 2023 09:55:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EFAC433EF;
	Sat, 29 Apr 2023 09:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1682762122;
	bh=IFjWI4e/LGyg+cIKqlJF9QFaroYhfR116QVhSACAVS0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L0kP3jOVAGvtMyN+BIgjCI/QXDhtbqgQ6oVHq7qJRzPbkNSpPt8d5IofQ1It3mj/p
	 W9oCFjoitBudXlNDXeJaVWbeIkDz6GqVKAnmeMssM2hrJBsjxjuP8nDw1ynU7/50Gj
	 B99E9ikg/UAv43xN5Vox0GZaK2ErbM8vw1Fzm0ql+zRuD0PlYzl+bvDaFqsYgD1+CP
	 SHd9W/c3CDeHbcgU2KUqJmJTUBjzwVzc9YU7lGFyUrkvs3XPHlwx3Yx70wIG9zhCVT
	 XPjuMTTdF1BPqgEXqRuenmBGyEPRuwb4cs23HcF1OWnGG08QRABmdry3uW2A6ukmt5
	 rWjd0MUxm44mw==
Date: Sat, 29 Apr 2023 10:55:16 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 00/15] 6.2.14-rc1 review
Message-ID: <20230429-uneven-issue-c22086e02487@spud>
References: <20230428112040.137898986@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="NvEdwSXYuuUrp8ip"
Content-Disposition: inline
In-Reply-To: <20230428112040.137898986@linuxfoundation.org>


--NvEdwSXYuuUrp8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 28, 2023 at 01:27:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.14 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Ditto here,
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--NvEdwSXYuuUrp8ip
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZEzphAAKCRB4tDGHoIJi
0oJFAQCC7sYeXBhGZZQJbn3T40D2W8z+sQwYC9DLTnXCYqI8/AD/fxPohtWrPJCE
iMOQ3UJIyOa2VKt9PZ5eBFpVZheV5QQ=
=mNaH
-----END PGP SIGNATURE-----

--NvEdwSXYuuUrp8ip--
