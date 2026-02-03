Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA48935FF68;
	Tue,  3 Feb 2026 17:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770140596; cv=none; b=aopsTiFEON+NTeNNRHNxwSZf634p0u87b6Mr5JrUX3ilwXWpy3O/91F/uZy0kmHw90XqTwoCfNqRUjYjMqkxW99pB/g0t7qPf90niGtE0xvvRXMrSdLrihCOOtQm/+HFyjC0QFMqCeMIpZeQHl4CcEwQWHLGkMpx1F+rxSihBC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770140596; c=relaxed/simple;
	bh=4ci1QYZFo0Y4+MNcRYyPRdRgKlR4yO1Lv8njcrmLXmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qIuk+eBvQAr+FRi95J9egRGN0b4X8Z3gZ5D8jA5cXl33Q/OhyMMroFw8boOzu+DPtffDf47zw00Hl3mMb7wZ+O6/TkNzyM5z1wAH6VIRV333hOVUMF9kbOKYVjLWwynaNKxLr1NFkCOR8VkVr6hZkBf3YFtZEpWdTua/m6j+bYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mzvvojES; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mzvvojES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B25C19421;
	Tue,  3 Feb 2026 17:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770140596;
	bh=4ci1QYZFo0Y4+MNcRYyPRdRgKlR4yO1Lv8njcrmLXmk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mzvvojESf76feYQ8AAOM56/uWtAbwm+r6INNiRCSwrqXjLzacT0pIi2Ka3J3DFLKz
	 /zail5S4aUQNNQw5JDeqPnJM/rmURiikvBwZWeguS16jWrxYupGTc3kid2aYK7/w2p
	 x1t+TMDheqkHciviD/Qnn6AA4z/6Q0XDYY80MYTpor1phLtwo4cTTtdJ6jGqvmv0hP
	 YIlAYr9zwToZ+xDnLEfitegXmizopWSOqRBI1bbLdab2knEwMBchaqZ8YUpinn+5oY
	 pap0WBBtgIkwprqrgoCr5G0g1l3nFVO0FV1g9zdfnW3Odr1glJDiFRnjUWh8qDx6wP
	 apZsRCpTWcvAA==
Date: Tue, 3 Feb 2026 17:43:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>,
	linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Brian Masney <bmasney@redhat.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>
Subject: Re: [PATCH] Revert "clk: Respect CLK_OPS_PARENT_ENABLE during recalc"
Message-ID: <2f070fbf-9cd4-4fc3-9f49-2dce51eddd47@sirena.org.uk>
References: <20260203002439.1223213-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="KjDCRiblU7vvnc4E"
Content-Disposition: inline
In-Reply-To: <20260203002439.1223213-1-sboyd@kernel.org>
X-Cookie: Do you know Montana?


--KjDCRiblU7vvnc4E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 02, 2026 at 04:24:38PM -0800, Stephen Boyd wrote:
> This reverts commit 669917676e93fca5ea3c66fc9539830312bec58e.
> It's been shown to cause problems on i.MX and STM32 platforms
> where the board doesn't boot. In one case, a clk with
> CLK_IS_CRITICAL and CLK_OPS_PARENT_ENABLE is being registered
> causing the parent to be enabled, the rate recalculated, and then
> the parent is disabled causing the critical clk being registered
> to stop clocking.

Tested-by: Mark Brown <broonie@kernel.org>

--KjDCRiblU7vvnc4E
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmCM64ACgkQJNaLcl1U
h9DfjQf/cEtsiOs2FJf+RmPJOfdObLnRFsb9iZ+xIesV33Lj+mzda29ind0UbjGY
VbdeU9qlGx/sFxqb3Cgc2Ah8K/bBkhhdXsKTUeyTrBcnZtyFiboHES5ha9ZrN4cG
mqC4ysuPLsO4YJ5mGNETVE1tEtOQF6AHAm5GE5sNGfzo8XTQIlSAIeGt9UH1+p40
vZsSy7YqtHkVJl/eU7syht+zhVn8GJx5q8y+BvvioeXbxvokG7gylu9IcI/rgPeC
xMfXgd3dmO1kxtA5Z2ryy0RjXkF1ZM6teD9TiEOpYeY8S7vZ8Li1Ep37irnaqmMP
vMBTcH350hkSDIiGcXj2nUk7pTXVGw==
=geFX
-----END PGP SIGNATURE-----

--KjDCRiblU7vvnc4E--
