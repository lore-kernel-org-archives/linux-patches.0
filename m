Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45A923F36C;
	Wed, 12 Mar 2025 12:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741782750; cv=none; b=DophE2H1Wuyie/PISUZgRkxf+aaFz+sTVjZYznZKs898PkMrqITef21GOEScf9HhpMwEpyfGIrunRy+bgI3FUtVJUXGAsoc9XNFqtQjQWUK3FndpJpFjHJFEjP8PC/IesWLc0HSpCWYhTI7nF/JCeSkMdk3STWYz7Y9zyERHxJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741782750; c=relaxed/simple;
	bh=+rjJYTP8HwbYWg6ENzkVJt3UuUPibkhpGHD4QQ+eO6k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hW+dfqptl14AdL88eV+pzEax5dZPTukccT7fCIXUjGTtorRhFCmiCJnaQnHXDVLbkjJFYuaWeHDcuJHptW8fnMXscJVQFdGs0EDjQCYhRDwzp87d74zhFnfJSWuQ4WPiisM0h+jg75zEku2PJUzpuQXW6Rk66Rvohb0lB1NePLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hDknyuxs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hDknyuxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FF5C4CEE3;
	Wed, 12 Mar 2025 12:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741782750;
	bh=+rjJYTP8HwbYWg6ENzkVJt3UuUPibkhpGHD4QQ+eO6k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hDknyuxsGflVNUyadhV4XtLaZJD/j1GZxLocdLQW68M6mR3VCdbg7uXMtmXFnLV34
	 vKpXMR0QPz7FsdynNAmrTX1YBXxV5Zv7HYx68Qm00E1vtr72ikdl2G+Mj3CffzItuA
	 0j/MlzPfNjl2/MRqVZmoZ3RSLv0lulfLrwVUdXLC4xRWb1Z50losijF9B7rgiYZt0O
	 5s2GBnJ4/ECxZXFjf1WtbHC/Zt0Rn2SOa4h0Ccknpg3+aX2oLTH2rLByEYY8H+tLzz
	 SFgst1EtgwHRzS29UmAqJ6EDQfvslEZm1t7VEBm8DBZPxu+TNaFTCaSZKNJsORYQNa
	 wqD5OJszqhJnQ==
Date: Wed, 12 Mar 2025 12:32:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.15 000/616] 5.15.179-rc2 review
Message-ID: <6b5e407a-f2a6-4cdd-a90f-82270af1b70a@sirena.org.uk>
References: <20250311135758.248271750@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="t7229o1Gb+ikn4+0"
Content-Disposition: inline
In-Reply-To: <20250311135758.248271750@linuxfoundation.org>
X-Cookie: You will outgrow your usefulness.


--t7229o1Gb+ikn4+0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 11, 2025 at 03:02:03PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.179 release.
> There are 616 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--t7229o1Gb+ikn4+0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfRftcACgkQJNaLcl1U
h9B+EAf/ZZLUP0qq+WHUUuZwmiYa341ftsJqn3klcNngjmVu1zojPwg1GsSijVPn
EJrzN1rQ/bTVHJo4hTH4njcVpW+R3l2nWVs6JQ/88SywedbHPb5GQyhq3/6J8ugf
es9vgzZbGyMTaZl6pCU1zvs7UoAU2GAUsiT7wv1kBGQ88n8/0tzc7yXIHds/FlHl
5YOL8swwTTumQ0Jsxq3xhV3jXH/3CvfYI0jJ+vZ516xiRaY8izezQPmbFsggZr+C
oYtvy/GzPteBEyB326DDCbVrpEzOhOoAqEzp8oqAkBINIPdrKBKVMHhQhyMDlbiW
FWFgFaxIApS8TdUI+tUTTpdv9532XQ==
=i+pA
-----END PGP SIGNATURE-----

--t7229o1Gb+ikn4+0--
