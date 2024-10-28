Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C6F63C;
	Mon, 28 Oct 2024 14:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730124868; cv=none; b=ErAgC6T+t4GFIBYeE1dgPcvjjIYPrZqrAkpl9uXWsTqawN/nV7IbKqNr8N7nRWpBV+g/UyAVlEehSGwV2stvaAjJOdlRWpplwBKyO9qqfzJXmzKu4BPKVL5f6/ypLtx+JdzbSjDENXk5FdAxrM79AKtF8b39e/J0YkGRVswSSrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730124868; c=relaxed/simple;
	bh=uUkjiW3ieirbS6YNuwJO2MWW+78ISJdxJh/yYlhJbyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qUpZQmn3PHMj8Xy3mUc8c9NSM6L+xIFA0Ag/iE6/VnrmDvZQPZGULxZzJZ8p3sEs55j9DlpuO8V0009OjIf8LwB/yU4YFNuZoWxYEisyT/TdgZMrkPkNQ/CqWrGmGCxjX9ZPCm33tnVML9N/QhuR5zflcJD943Hvghvy9JNLtkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ljbiRyat; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ljbiRyat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB5EC4CECD;
	Mon, 28 Oct 2024 14:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730124867;
	bh=uUkjiW3ieirbS6YNuwJO2MWW+78ISJdxJh/yYlhJbyM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ljbiRyatUhdjoe4e8gVfxWIBSnHOfJWx7eF1TmMGjSgSiuzx+1vOSp1/P8BTHIOuc
	 fMW/M3EAnxqWbmAO54/WODlFmmutNXtUroiWeJtAisgOtTIUOWsyBPPTYsmFowuX2w
	 wdwNgz8meXp9tYYNziGtQ/P3GW4OmpOALc+hcEDfWyQKbIdRsuHlfmsj4WnEU8JRJe
	 9FyOea+TljjlpquVZEVBn5xgh73wiNW9OTClVDxJurlgaNEUp7E4Q6ahSKkvHuxhDL
	 24DhZbcT3MLp1yBEreMl9WxfMih56XAsVBT1wSGbL8WdM3qJW0Lxt2ay3JxZ+HmwYH
	 NO6pKOyh6XuZA==
Date: Mon, 28 Oct 2024 14:14:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com,
	Marc Zyngier <maz@kernel.org>, Eric Auger <eauger@redhat.com>
Subject: Re: [PATCH 6.11 000/261] 6.11.6-rc1 review
Message-ID: <b7b10796-5bbb-4cd3-b66b-64eb80208c49@sirena.org.uk>
References: <20241028062312.001273460@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tvPZucr4J+gWp7S6"
Content-Disposition: inline
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
X-Cookie: Remember the... the... uhh.....


--tvPZucr4J+gWp7S6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 28, 2024 at 07:22:22AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.6 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

The KVM vgic_init selftest has started failing on all the stables that
"KVM: arm64: Don't eagerly teardown the vgic on init error" has been
backported to.  This also happens upstream, as discussed in the thread
there:

   https://lore.kernel.org/linux-arm-kernel/20241009183603.3221824-1-maz@kernel.org/

this is a testsuite issue rather than an issue with the change itself.
Other than that things look good:

Tested-by: Mark Brown <broonie@kernel.org>

--tvPZucr4J+gWp7S6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcfnDwACgkQJNaLcl1U
h9BaJQf/QTTf6k6tCWxSgHmMRBn8k89lHPr84RJyxWkK6Nt6x81yk97XHOn11g+n
SPbZNqYiVjjTxHF5JXY0GWQebxyOoBbejis+pwvWUxgUkC8opEp+FyOHjrsCfaJK
+ZEk3pdo+DUiAWBj+bZB0cjTAZ2JGe1O1wicWAm44IBR5d89kuEuX7gbaKLOm77X
Wxc2FJxh8MlXHKl8DELaQUEbFVpLsI0PNHj0m6EvVTuDdx9Z45Zkmedg6N1V1i8v
D3N5O+LJ2vIcQ5FPnZYlYxnbb8mwLLhUvi/fQZFEf1bWRLt/o7Fq8BgTJNm6xH5D
tdYsCkvZ4aa/w+mgIzt9Vqn2rQja8w==
=xRCX
-----END PGP SIGNATURE-----

--tvPZucr4J+gWp7S6--
