Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAC12E2640;
	Wed, 18 Jun 2025 12:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750251453; cv=none; b=fgCQ6ZTZyR7q13DdySQkUWBz9PLjKoFO/eyFZEDktqzjnKhYxNCIopNS9jN0vV3jpkEVOdQJZHeFYCtyk3KuUwvKz8O9BS8zrGfv6p6gYClUCqIyM7bUglptb6dsVhJWDfnE2CGX3B82bdKV0NvBZh0NI0A7qBJ53/Os7X5+E1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750251453; c=relaxed/simple;
	bh=7HYY0spsrPniJmKfIQbUJENhpdxcqwe5JFROoHUtcuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQVJQbtuyOT5XQY9OM2k01KeTlBZZZU7V2QNqtKV+U77I/Ctq4ysONgLv5wA1h1LGJjh/aIh1LiD7nBNC13r/GCJ2IBKj5V2JH4QGJmeUbPaTarVkqRe40j+B8y44w/TxLe2JxAyThvavCGa8vXa5SgmAjfkCP9MJIBorSXRg9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PkR5yBqF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PkR5yBqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E774C4CEE7;
	Wed, 18 Jun 2025 12:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750251452;
	bh=7HYY0spsrPniJmKfIQbUJENhpdxcqwe5JFROoHUtcuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PkR5yBqFxocYdjEuCYI5E7t47KgCxTzUJO2837W5Mp6UWUT3+PPK+u5eVqcESDt5E
	 mx2ExA4cK9HyPIS+WSK2NM5vLzXI+LgQ4TyA37mL/YszNycBhmJY0qZg9I/nP1Bh9S
	 kVdPwpgx2fucvn1E3fSb8gV1amXZislUi91yvWGxzmxyyOwouvZ/yAmxtTXCVgxoWn
	 z8KGUL+AxhIfveJQBoXnPJ3yy5A6ujIrGQrvMeFHZQk4UI5TznMjw2Beb1PyFZHJD1
	 z7Rf7RMfCTutFSaZAMeKqvc5+Bx61fukq+XqGlb5yJv5ljdo3Nb2jFJuMLgNHjatKN
	 D8HaNm4qYztbg==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
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
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.12 000/512] 6.12.34-rc1 review
Date: Wed, 18 Jun 2025 14:57:10 +0200
Message-ID: <20250618125710.1920658-1-ojeda@kernel.org>
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 17 Jun 2025 17:19:26 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.34 release.
> There are 512 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jun 2025 15:22:45 +0000.
> Anything received after that time might be too late.

For arm64, with Clang 18, I got:

     drivers/thermal/mediatek/lvts_thermal.c:262:13: error: unused function 'lvts_debugfs_exit' [-Werror,-Wunused-function]
      262 | static void lvts_debugfs_exit(struct lvts_domain *lvts_td) { }
          |             ^~~~~~~~~~~~~~~~~
    1 error generated.

I assume the reason is that `CONFIG_MTK_LVTS_THERMAL_DEBUGFS=n`.

In mainline I don't see it. I think we need commit 3159c96ac2cb
("thermal/drivers/mediatek/lvts: Remove unused lvts_debugfs_exit").

It cherry-picks cleanly.

Otherwise, boot-tested under QEMU for Rust x86_64 and riscv64;
built-tested for loongarch64.

Thanks!

Cheers,
Miguel
