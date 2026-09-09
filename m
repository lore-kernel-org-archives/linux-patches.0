Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72350353A71;
	Wed,  9 Sep 2026 22:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788994386; cv=none; b=DgXNCNE/u9H8dn8dK08Rnsqng0DdKacw/1mvt42iIFCeZUoqLeWpXQTZ6qgWrzEOoA9+1Jg2j5OnGhv3W0f5dbQfknNXQbp4dYMWLm+xpzyem7VfsSrXFgYj4mVx9peQ9oVLmPScQo8CYPcbHGWAal8KaaLP/GgjTRJYMsPecsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788994386; c=relaxed/simple;
	bh=sHrj7KMmeQk6/TCtwLgYJCZTPLXr9OLnScK/nuHrqG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDm94OWvowDUo+5vYOgiIr8sZFigVASX+lF4qed1H05RSs4TRa/uPc/oFJiLgVAabdrNv0FI9yH6u2R9lLAYPnNCkIf0F+jXBQGLoUEJZxHGiWOmpweE8Yozs6ETCZAS8GsCvNcKPV/t97b66xmqWDKBnVtJmoIZ5YMN/dsvg8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YzGtmeHw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YzGtmeHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1231F000FF;
	Wed,  9 Sep 2026 22:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788994368;
	bh=BH0n3lwWvOubBgqnVb5fx5iTpUpgql+t+lZW+OuPUpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YzGtmeHwDaf6nEz6Qel0TnOiKhLzwFchuTiVpWiU8SZveKHNT6f5qT213lVWK9Ehm
	 mU4/16UOQr83o/t23BYhX96m33Iy3jEOmfbmOxTfoVIuEC9fL4BtfaV3rTqbTvnIA1
	 4X7RiLT+rcopsXbUlujw73+j2IDj5CS8foK0bjGjjzbsw8zP41JZOP4yon5JBAPoXy
	 sHv0GK4C2LabiLvcBuNouT1KLq1LbXv5qc7v+32XpSu+2PUNtBcuqoH6W6OcGGf7+F
	 nSjw/0WfSkZGgxs37QXHPyPC4xDiLIdF9NvQt8bC99V7gRf4/OCBM3jjkvxKjtoC/Z
	 S9k56LlcDLpsg==
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
Subject: Re: [PATCH 7.2 000/556] 7.2.5-rc1 review
Date: Thu, 10 Sep 2026 00:52:39 +0200
Message-ID: <20260909225239.421160-1-ojeda@kernel.org>
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 09 Sep 2026 15:34:40 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.5 release.
> There are 556 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Sep 2026 13:40:31 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
