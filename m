Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EDF242925;
	Sun,  6 Sep 2026 01:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788657368; cv=none; b=X8OAHhneX+Xa9SWZ+pvPgo5WHXbXQ6J/vvUzV5vICdCv2LxMY4mS9vL22wQvsuuIL7Z0yWEL/US2aeeDyb3JgYe+p+Qxl7/JEJ495IrFLQ9ZVn9cgL2mIFSTw8udP1221Lgj+2w+7k3/CnSZ8BdHoC9+j/KB8AOoGdPaJWL66I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788657368; c=relaxed/simple;
	bh=XKvP6TY8z8CQTEARcJxhWey2ph0uubo6yoK2m89qC2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdMDv5Q1BBQbz18XwIEQ203zvpXwEYSyZOrXhDyx+qK7C8exNMx4zLfnvpqoX+v4eCeIFI0XPRJIc+pgswe6RbruRVOl7LY8n+/rOF0y4VNRJWITrTtmq4mRZsYNvsPh/5WoNbhdXht8PAJf77IFZIeik8aZynXtIP8AmmisFM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hhrpm+jD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hhrpm+jD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD0A1F00A3A;
	Sun,  6 Sep 2026 01:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788657366;
	bh=Rj3tuLQjF16ttkagBHnxPK1cdVCIwQoexhsa6SA5Z8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hhrpm+jDRvlpm0Rln88ME/lAZOoeXAtt+lq65gSwec/jXLoOlIYMqInoBzoachdZM
	 eiQlLshUp3QrpgM/ZuQcl5XrX5r3Ig9Rv9YjebFtXIiEf3hOn4dA6dFINfjk6FAayO
	 kswBJx3ndlx0L86H4xboc2rA7Cvjp1dQpbP7nPHdNWeClf5u4aQn5vLW46A6cPokl1
	 wLQf8r4CTIcdmlJRE6V+64hQAIz75fipUk76aSv13IVljWVs1ltCD/ZVoJsiCXcazx
	 04IdpEIHcKtlfwINCj9cMy7G6/YZjcbFh/OdQ2he4Y/KTVwqbvkURa+U7JZyGYYh5k
	 EAsxfrW2uvTJA==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.18 000/551] 6.18.50-rc2 review
Date: Sun,  6 Sep 2026 03:15:53 +0200
Message-ID: <20260906011553.174169-1-ojeda@kernel.org>
In-Reply-To: <20260905115635.269562615@linuxfoundation.org>
References: <20260905115635.269562615@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 05 Sep 2026 13:58:59 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.50 release.
> There are 551 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 07 Sep 2026 11:55:07 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Now that the `huge_ptep_get` issue is fixed, in UML I noticed that we
still fail to build due to:

    error[E0433]: failed to resolve: could not find `CStrExt` in `str`
       --> drivers/android/binder/freeze.rs:109:13
        |
    109 |             kernel::warn_on!(freeze.num_cleared_duplicates != 0);
        |             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ could not find `CStrExt` in `str`
        |
        = note: this error originates in the macro `$crate::warn_flags` which comes from the expansion of the macro `kernel::warn_on` (in Nightly builds, run with -Z macro-backtrace for more info)

To fix it, this patch can be dropped:

  https://lore.kernel.org/stable/CANiq72=EounScE9CxhQVRYTMe6XxgZzfid_cJZ5dxmkz7MQ2kw@mail.gmail.com/

Thanks!

Cheers,
Miguel
