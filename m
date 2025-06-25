Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59318204592;
	Wed, 25 Jun 2025 23:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750892408; cv=none; b=tqvna/b3mqce1vo2D0KPdyD3rA42y528LsdIlyQdE0bTkJ6IAz51L6tYBu4xmtRX+JTj4I9E49KA4HKLjju9jnoroOq7xC1hyvBCdvx84xqkKn96irkYGJcRDURaUl1W6U3Fft9JMclKgQAlOOrOw7lNhtgmzBdw5md7H35PxyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750892408; c=relaxed/simple;
	bh=/XOPd2uKT4IzRd79BirEY/LY1ykAe4Qy6Paud/SxUsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tft4sw1EO2JLR6YvLnEs+fALNwmynjVNXyO+INvHugGz7m+1Ogvw4qG5OhTn8HsoahrhUaCm40YPMGDftXqfWiJWhFqdrPMckPUNdDBkW7MK4USvOl1iVmsBJ4LOZO29vvekcmbhlJ31KGqodAWpkzmlbV5JPnpoicb4E5eWDr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oFOPyL/k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oFOPyL/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E3AC4CEEA;
	Wed, 25 Jun 2025 23:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750892408;
	bh=/XOPd2uKT4IzRd79BirEY/LY1ykAe4Qy6Paud/SxUsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oFOPyL/k4XdkBUelG1/C0fljocVOiOdwL06kcBt/veS+r25kFA3UY5h9s/1ELqfM+
	 OyocRjzc74ZbFmiUq8kH9UI/tdEjPElb/Qg4XZ9RvOVwewTOtXtLje864g3Phy/FxG
	 g6XHRqXDldHKN+no33mqg8L7/tf2ftaj3YthzkC8EM6bfrwSwYG99kuhQvEwe7M4ws
	 4vPh5vGwXmMk/5TKCfn1BN581w8enV9ukDylYUznaUOYKaYOsH3sudaHdeSjJsM1EE
	 /a0MIP03svVeyrAxGfmwZK8PWMXOsB/DZ/9z90ptfP2yhgkraQWvB3H1gzfKP7lH1C
	 W+5oudrEHQ7kg==
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
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.1 000/507] 6.1.142-rc2 review
Date: Thu, 26 Jun 2025 00:59:47 +0200
Message-ID: <20250625225947.951129-1-ojeda@kernel.org>
In-Reply-To: <20250624123036.124991422@linuxfoundation.org>
References: <20250624123036.124991422@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 24 Jun 2025 13:31:39 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.142 release.
> There are 507 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 26 Jun 2025 12:29:38 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

(-rc1 was also fine)

Thanks!

Cheers,
Miguel
