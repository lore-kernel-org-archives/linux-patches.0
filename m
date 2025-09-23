Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7811542065;
	Tue, 23 Sep 2025 20:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758660153; cv=none; b=QFfDdHGcnv40WIw1Rc4HYwjhWfKctvkJmUfkZjYfizT6dNE2BGV2ikZ3Ptyar6jq0XRDPEUMNWBb7GSY4nfhQaSTn5zbC0/nOeL3gnT0mCMfAAUO80xHFLPMJAevGGWag40stVQ9YQHhEZgFaHWDdDx3iwyXW2YXMhi2BhZlI2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758660153; c=relaxed/simple;
	bh=0Aj6KVAUa+ad+81yOmGEowkofhC2dzK/A2I6CcrMSRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rH4gK1f3e6vKJ8qJnlU16OdyuNor3ZsEaZnTvdaVRoaWDTDN7vWTRwlsuofmPiOz46AGEIKqrN9lAW4q94WzGe+tHNCM6WQg2lQfoslTCLYeCsHkJg2gmn4wcTIHxHAgENIMvQ8xAgvTiBMz4yy4iBcVlHXNmLUxaNSdv79qgKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NjgyxTMn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NjgyxTMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4504BC4CEF5;
	Tue, 23 Sep 2025 20:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758660153;
	bh=0Aj6KVAUa+ad+81yOmGEowkofhC2dzK/A2I6CcrMSRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NjgyxTMn93xRf8YyTZu+nyBoAQCifeJ4GyKT7n2p3/5vjRx6Uv4tYfoTBfdMK31E4
	 dOIaZV6106WmKAUTUy0bJKnZ10oTK2uoEOJ1qnfWtQqiSigRk1tqg8SV55TgkTtAFr
	 xmInNGHYJ3JQMHmDAg3HyI2frNTguMrfz/0kLS41cFlcNVrW7IPBQ0jOpCVY0c2et6
	 EgByGY5pdo73xjIf4u6Fvye9nd0QDd4YBwSQ4074gAYhsliQ7V5910d4yZYTfXHWMh
	 DtvwCuDAouH971gcLJ35HPBLfSTiFUDbRgVXlPpyCCaM8boM15YEguAlKSGNtJm1Ni
	 z6WLKeqTB0l9g==
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
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.12 000/105] 6.12.49-rc1 review
Date: Tue, 23 Sep 2025 22:42:24 +0200
Message-ID: <20250923204224.691941-1-ojeda@kernel.org>
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 22 Sep 2025 21:28:43 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.49 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
