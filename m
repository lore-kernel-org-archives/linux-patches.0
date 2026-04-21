Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DC039D6EC;
	Tue, 21 Apr 2026 14:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776780669; cv=none; b=bAgcx4nKZk2DCC6+Fqwkmdlj1kQt0ZclrEmE6NSsOmDX9pH/9ikOUvf149ru4b2q/DFTZNNAiW2JiP/zwB5+sQQmH6pSa7xj7eOnnO+u8GfGgM3qPyuzfujfTCpvksgXqSMDG4V9JYM8OBSXRJ8QpEF6cOQSyQt3SZaLFHmrOws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776780669; c=relaxed/simple;
	bh=1J9FfnxTSLeqhX3K3Zj33PkIZ0qMUPETy+sOXGJxrug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iG3guyZAeNg2AiZEXPMTEFl/q2W/wB+aS0Dto71ZxJUXtZYHkKNjh73fvjAgrRXvFCW4nLXzcQFEWZG+MeKPaLhqU2pJab/fRyFWYypNVnTynolgTV5Qa2rEVECPCcZBWlZNvdcTt3wVUuppI3b76J/svV1g2nkoql8sKan2CUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jmlYX+cv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jmlYX+cv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E554C2BCB3;
	Tue, 21 Apr 2026 14:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776780668;
	bh=1J9FfnxTSLeqhX3K3Zj33PkIZ0qMUPETy+sOXGJxrug=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jmlYX+cvQSJOmsklMJ0qJCXwwVytDjf/A/W8WJxOLQB56GL1iYu4pdwHniOhhxqp4
	 KrZuKdBkIJHSJUMSj/i0oaSfQQmsPDsbPvCfJh38kAn/0hZBAZCv6oRFQqyYq7JgFW
	 aKd7XX60vXNp8Wd/8zP1npdIwWkPr3rfy4Ec9TciAt5+9cZdcZapCBlZ8YAeB3jEFR
	 QFVir9OLmWL+ewmWaGbgOhM4gQbmTCaFSnD/xpRNrK8pFjRmnZt6kX1nLlsFbmvkKD
	 y04S83N2/c7P6GK+/1P6hRycdDYait+jQW1w83cntGH6iY5Nvj9wsBho1nZing6UlA
	 u+tF+gCum4pkQ==
Date: Tue, 21 Apr 2026 15:11:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/162] 6.12.83-rc1 review
Message-ID: <a1072a41-290d-4c84-be67-bd56baba33ee@sirena.org.uk>
References: <20260420153927.006696811@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="RFvs+5FMNX7pjKk+"
Content-Disposition: inline
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
X-Cookie: Jenkinson's Law:


--RFvs+5FMNX7pjKk+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 20, 2026 at 05:40:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.83 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This doesn't build an arm at91_dt_defconfig or bcm2835_defconfig:

In file included from /build/stage/linux/include/linux/srcu.h:47,
                 from /build/stage/linux/include/linux/notifier.h:16,
                 from /build/stage/linux/include/linux/memory_hotplug.h:7,
                 from /build/stage/linux/include/linux/mmzone.h:1451,
                 from /build/stage/linux/include/linux/gfp.h:7,
                 from /build/stage/linux/include/linux/mm.h:7,
                 from /build/stage/linux/arch/arm/kernel/asm-offsets.c:14:
/build/stage/linux/include/linux/srcutiny.h:14:10: fatal error: linux/irq_work_t
ypes.h: No such file or directory
   14 | #include <linux/irq_work_types.h>
      |          ^~~~~~~~~~~~~~~~~~~~~~~~
compilation terminated.


--RFvs+5FMNX7pjKk+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnnhXUACgkQJNaLcl1U
h9DmCgf/UH1zaDlfWL6RjHPg5fEmZy3jI42K/KOELEhkq1sz8QsqXHtmqjPy4hAY
Y6VMC0ctG8Nm9WEnkPzqwGbFVpOacs8tWeefFdh2qg6RBCmxPjIF06+4yrdP1q8e
d6OtEecfmI1m/+4WtlV+FxxT2UW84SGnlHMsdP5+aInnl7aCECOdYSsSRKMbX0Y1
FR2p2bqlxsXJwv5RPfQVJLpSLP+I7NU+ca8Z1QfQ6edb6txYcCT+TTaIQsno+piv
nn+mwTQUGKx7AakC6ja158sUm3fW3gkyGDu/5mlspz/tAqVC/HhR/4jf3yQZVCWT
4s76thOQ5/39Pc/S7Ll0kMaRa6H9qA==
=mDPw
-----END PGP SIGNATURE-----

--RFvs+5FMNX7pjKk+--
