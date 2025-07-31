Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22EE420CCE3;
	Thu, 31 Jul 2025 18:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753988181; cv=none; b=JZzeV9bjtYtQImNSNiWLv4QgYg83tIzdWD+/6HFEECVuSmzxQ6LbwM/ptjFX1bvSMs6D1MGPlKT8ePeO5Xs4sFF0ZZrGBGjBtRksbheeNiSxSOoBtORJdhUWIwaQgv70kjIZfxt7hcQ0uwGl7eXPbKN+pYxIekk8ZkPk/rIqcmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753988181; c=relaxed/simple;
	bh=4xqdiIgRx4vR9n7j12UKR8I5KXKD/8v5boKDMOGbmks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UP3v7oXw/7HZ7Jn1UgvpHGl4HEt4NVQ2V9/fjyulskpb0RKzwPsi30aTSQLP7FSQbEifveMBE2kPwk0jVZ/L3JEHIp73uzxGlR9Xkh6EkQ18vtDTOtzaZiEwLzdxAZE4fOnBRZZdRZ95GZ/o7twVkwwYGVCFmMwx6t1OlLZay5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VYG1V19T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VYG1V19T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33F5C4CEEF;
	Thu, 31 Jul 2025 18:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753988181;
	bh=4xqdiIgRx4vR9n7j12UKR8I5KXKD/8v5boKDMOGbmks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYG1V19TYBkKfAHeN57xxb6heKvE+OQ+uCYnTnL0VkeLL3XJb1gcvTgEZy2NRWVks
	 ZpywtGNQMIBHMlz5KkMnWZgN/ZPqqwBZ/kSPKshB3llAXLu8omUt9KA6OKgEYP7WFT
	 u57Fe4FQi8jQV+ihqupPpaGHTY7GRnwiVYqo8lkM+XFEzepDhre3H5K6cEQRpeUNTp
	 iRE1nd5batsBEef3mrB45YLDQomC+vBaIf7zOJubuu4rwf2AyT4pvoTPK4wB/XJ/9G
	 QUjfjlkL3d+D6n2R1XRK4WfS9Dq9vhJB40IJBHOtsFg+zwoUXe+Q/JaharfAmyeSpS
	 t4xfBEgKQKSRg==
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
Subject: Re: [PATCH 6.12 000/117] 6.12.41-rc1 review
Date: Thu, 31 Jul 2025 20:55:41 +0200
Message-ID: <20250731185541.243806-1-ojeda@kernel.org>
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 30 Jul 2025 11:34:29 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.41 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 01 Aug 2025 09:32:07 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
