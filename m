Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE096E56A;
	Wed, 12 Nov 2025 12:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762950525; cv=none; b=u1BqrhUKIliWPZvTa+QFKu7MILFd4t4VjWK5XI4jj8u97F9rILZKZqja3b2Bx1j+/ppdsBmBlohqnb0Rx8dGbP4YRKVmj79HCow0WhZ32FkTtO5enQtKdFhBQmuaJzR9Yw6OOq+hn6N8eEOhXuw0BTeWeGfo9GExjo3Zx0rl0W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762950525; c=relaxed/simple;
	bh=DAPkTMGO973BQ1eOHlE5GaAoPfIc8P5AnHy1dBRVOWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgUQPpJZP+H5iaQCet2Zd3eSeWS1juck7XEqrdfGD8+k11TEAt5IHne837jxpdC9KLZCEJW4/kIEUK9+APv/Yr3vQNs5VF0AfuBcgPq18NobZ/TJj6Wpxpkwx8h9ih3iDTT08ulA8AccOClTlryUVUclRjLpCp/F3vAVDiq2enU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sqdi3Xnd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sqdi3Xnd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8971C4CEF7;
	Wed, 12 Nov 2025 12:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762950525;
	bh=DAPkTMGO973BQ1eOHlE5GaAoPfIc8P5AnHy1dBRVOWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sqdi3XndPU9tcj+chk98WB2JOeJz8QbqUu8w5ftEwqTEjfliBFXzC/56XeJa5uKV1
	 NDXnDGnz+IbgnQioGOhjdjftraSZeY+q7sol3+0DK2b+Le5mP5K8rtwQ1yqJUSmc66
	 WLP+8L+m5xLWXsefivMKaVb/DF9brKZIrS512ByRMGwYcXHlrRvU4tM3ZOb/ef1btb
	 LlaH+WNQthMEyU+cJUYu6t+rF0wgrUw37nESzClzBx7EfzrHcMfk52UfsN/qv0gG2Z
	 kQzmyFWjLq4SEXbt79X5oNIvN+p/0cN56/DeMXmAVV4GvHYONea6lRd4bI8tbc6Ti4
	 BJzz1anQnnkuw==
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
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.12 000/562] 6.12.58-rc2 review
Date: Wed, 12 Nov 2025 13:28:27 +0100
Message-ID: <20251112122827.133319-1-ojeda@kernel.org>
In-Reply-To: <20251111012348.571643096@linuxfoundation.org>
References: <20251111012348.571643096@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 11 Nov 2025 10:24:49 +0900 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.58 release.
> There are 562 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 13 Nov 2025 01:22:51 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
