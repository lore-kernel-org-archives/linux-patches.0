Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC4A2D541E;
	Thu, 14 Aug 2025 12:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755172823; cv=none; b=tTf/Z+Qqwo0jsMjo4Z6XrntHhi2edbKPTcoRjzDO0N8DHmDCcmlPXGQSPtDvpo4ygrkjRmdGaQ/hWxG1ZfaYU1ZxFMGQMumD/2pUGVc29PkuR/IgGLKzBi7N0L4ngC1AOpVmW1twpdxOZ83a617BHJyk9V7Ozk4YQhUMDR6dYQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755172823; c=relaxed/simple;
	bh=0hkCufjTwewKABvIOWDB1aQ8HhROFwXo6mznl7TFI5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GqmDmHsZ9znsOylDooK85siNsPFn0CV005bzb0znSQxztvIWENeg9eK0r6L7vkqFHg/IqG3Hp053sn3w2u5qI1+yt+zG8sGRTJ0tr9xAq3rASjZHGQn3jI723Yc49aEi4gGJsGR33ILwfLru8RtBOHoL0jC3p1f6z32nQGWsAt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l1uDbMvp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l1uDbMvp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DEEFC4CEED;
	Thu, 14 Aug 2025 12:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755172822;
	bh=0hkCufjTwewKABvIOWDB1aQ8HhROFwXo6mznl7TFI5k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l1uDbMvpGT6Gv0OeDYNAg57p/xbkjoPXuGXF5RON80YCwXTZg6h7pXIHjIFaX/K5h
	 H6NPGMyBHg+oAqpbFRgGmJbko1fFv3ZrSBK6sL6izOF5+5z1AiFfhkKebtidvudgd/
	 OumiVLLAqOcNX0PO1SqGl43ST0JulkEf67RhMFnhe1224h4V9XNh9kvAaeZuVBsfj+
	 snxzVyzPBAK41FuuGeDZpHXZOwbTXzhy9mX7Xba12jrkm1wHebsvAvsD8zS8vbw75p
	 rjM+XQb2CHtykuIGWmJTNfKqf+2i5BpRiDmx5CAoRnaW64IJWXfVGs+X7t1DxyBSg7
	 A3kxiwTRDeh/w==
Date: Thu, 14 Aug 2025 13:00:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.1 000/253] 6.1.148-rc1 review
Message-ID: <c882fa53-817b-4598-a7d0-9ce288890142@sirena.org.uk>
References: <20250812172948.675299901@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="W92iiBVet9RsU9TV"
Content-Disposition: inline
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
X-Cookie: This sentence no verb.


--W92iiBVet9RsU9TV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 12, 2025 at 07:26:28PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.148 release.
> There are 253 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--W92iiBVet9RsU9TV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmidz84ACgkQJNaLcl1U
h9C1aAf/atn7oAKRa9Hi3delndL1b8hfxXhxyi0c+3imdEdkoMJ2DiOgF6MDci7a
hZskkgRzQ/6hl/lCxKpqUs6D40tfabzkCBrTLEu4IIQZDFPLIZVn5pVbJq6Vzskx
DHljAj/+zHTYb15QsbwE+8ne4VeuUpsZVvIg2PygSnrU+dsAjf2dFzb94Evy/c21
7uPmpJbjIVAOg4ErvpSe0I7p5ItYj9OfG+vv7ZUk6GVBDI0jJaVqV5wDBJXiFCuE
GHTBUTGfTS/z9zeZbse8AMFI5/mCD/OJY/EHryj0Wx7PuyHP8SpT1s9zHM2CgH1e
4tXMFHzr+IeQNgf4LfIU7yHFknWe5Q==
=h/RC
-----END PGP SIGNATURE-----

--W92iiBVet9RsU9TV--
