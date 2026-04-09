Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E4527FD6D;
	Thu,  9 Apr 2026 15:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775750313; cv=none; b=m8uewLXT5FyssPsj8UBzuYBc2S8Mo+cBp1ltfYeqKABRXCD7IAdiT5Bn4p89yi4xHA5IQLKadYUBSqlkUHWpEfihtWbLvRzRPSoxBy+lTmmHc/pHHBl0ul9m0PPWI/4Hnrg/gyfEeIj+q61luw4bJvX/EOLlmewbM7dRD0j/NOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775750313; c=relaxed/simple;
	bh=GuLXsci7CSFRAaC8LLOVPMV3JubvJCiFROVlKUwIi9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZNbaHC6evlidBWd+JKYG5RemfPbyIeDHtcfViHQZKpkYGSyhITcNwoWUh2jSs3+WVNQOmwUhemkaU+7m9aGp4k8cDuYAVClpK9W2wzQZ9+TEmSFQF+8boH4buJ1aZRBbBrlZVYfnrZq75zaH5EChxhjlSUz5k62NBorrK0XkRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S4g+7S6M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S4g+7S6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1DB5C4CEF7;
	Thu,  9 Apr 2026 15:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775750313;
	bh=GuLXsci7CSFRAaC8LLOVPMV3JubvJCiFROVlKUwIi9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4g+7S6M3RN/UsQQp34wS1N1PxlT3PR1NN84YNP/CRcBPUI1nvi3ud1y2NcnoQQVk
	 VmdX+rBGdkk8EmGkhzfyWIUCO8cc2IEfjlpWomzNFm+8+jX7Mrf1EJ/rqUFyZVx+U0
	 KNbKvJ5B2buP0oZf/7dle+CQL0IH7thsmdHGlXXsE1BwE7Ob4w7nJW4sNXbP17NXnO
	 5WDdYeR5AoCZqjLFPrivhLZ62jdYCVg2E4dWnPBgZj96T4uywo2j98MQsUjceuGMGk
	 yY2hbc/s62pmTgvDx9FEL4+/wxja1JTzOrT7FChkVLtbnCH1TqdIEXJhpZR3UcEQPf
	 b27L1MU4y8X7w==
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
Subject: Re: [PATCH 6.19 000/311] 6.19.12-rc2 review
Date: Thu,  9 Apr 2026 17:58:21 +0200
Message-ID: <20260409155821.35076-1-ojeda@kernel.org>
In-Reply-To: <20260409091742.514769762@linuxfoundation.org>
References: <20260409091742.514769762@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 09 Apr 2026 11:25:28 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.12 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 11 Apr 2026 09:16:46 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

(arm 32-bit seems to build-test fine as well. Same for UML x86_64 on
a non-debug configuration.)

Thanks!

Cheers,
Miguel
