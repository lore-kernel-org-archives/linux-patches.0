Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645A128726A;
	Wed, 25 Jun 2025 23:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750895415; cv=none; b=Ywnyy6PLfvRm3TmeU08qkmLg0igbPtNCe/sSkeeJkngGwaZBRW4G5kj7CFEk945rdtkZbQma8jOw0koEKFw6Jm4wne3aXEtncpxe5B/C6e8LrN93Gegds9GSALrb9fAdYf4PvhfxrXzLx0831XbNVMGnNENKzNa47ahZluCUm/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750895415; c=relaxed/simple;
	bh=DKeuTM+CKiukBYg7vjMtDra3exZb15JwGw/0w9xmmJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XmrUirz9BXVNorwwzf4EpV0ssv8/g1nTsgpRmpLp+2Xd3K0cLWooCZSuBLfU8VRnR74dUOnznKpHjOD0+6s4ZEuw/E9Q0afXq2NeTh+vnKs92JgS9+d61yU1kwMGDv+nhAi44Qd57k1sxfzV+cI3gZ8WGOcqjrrhnTWY4dtWaq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lVUiEpKC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lVUiEpKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1231DC4CEEA;
	Wed, 25 Jun 2025 23:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750895414;
	bh=DKeuTM+CKiukBYg7vjMtDra3exZb15JwGw/0w9xmmJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lVUiEpKCSKnNM+TFHPWu8RXS/jAGQU2dh+J6BrbhB1DDMrznTxBsZeF9oDFtGe9Uh
	 3UTPDs4Es8Xuigjr2/PyT5kZyN9hR2y3mjmWgYIq3O5G+9bvj00R6LKxGSHwgQdDW8
	 D2WY5OxPZVci6vH0Sl9r4SMNfCiFcK3ofCWHFlFWomNvXhzL+x6cWo4lWiw7k4yYlk
	 IFRHx5qQnI+/Yo5a5p07lyihqEdwS+IJPUvguVqchCnjgUeOg9M+uXmG5tyEO/81mC
	 W9vHBfGcsitkjnhMlVs39DwQayNfXPoIPkW0nAYg7OS8LAFTaoouspgurIBUHCSkLR
	 lISLJMKqN6sCQ==
Date: Wed, 25 Jun 2025 16:50:08 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/352] 5.10.239-rc2 review
Message-ID: <20250625235008.GA4073092@ax162>
References: <20250624121412.352317604@linuxfoundation.org>
 <CA+G9fYse3W=-C0JbR6fhw=PLPy4aWUFqPwPTD0eK+x0sLidxYw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYse3W=-C0JbR6fhw=PLPy4aWUFqPwPTD0eK+x0sLidxYw@mail.gmail.com>

On Thu, Jun 26, 2025 at 01:32:27AM +0530, Naresh Kamboju wrote:
> Regressions noticed on arm64 allyesconfig build with gcc-12 on the
> stable-rc 5.10.239-rc2.
> (this allyesconfig build was skipped on rc1 due to other build regressions)
> 
> This was reported on stable-rc 5.15.186-rc1 with bisection results.
>   randstruct: gcc-plugin: Remove bogus void member
>   [ Upstream commit e136a4062174a9a8d1c1447ca040ea81accfa6a8 ]
> 
> Test environments:
>  - arm64
> 
> Regression Analysis:
>  - New regression? Yes
>  - Reproducibility? Yes
> 
> Build regression: stable-rc 5.10.239-rc2 qedf_main.c field name not in
> record or union initializer
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> ## Build log
> drivers/scsi/qedf/qedf_main.c:695:9: note: (near initialization for
> 'qedf_cb_ops.get_login_failures')
> drivers/scsi/qedf/qedf_main.c:696:17: error: field name not in record
> or union initializer
>   696 |                 .link_update = qedf_link_update,
>       |                 ^

This should be fixed by commit d8720235d5b5 ("scsi: qedf: Use designated
initializer for struct qed_fcoe_cb_ops") upstream.

Cheers,
Nathan
