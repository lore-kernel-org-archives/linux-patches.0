Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6901E5B72;
	Tue, 14 Oct 2025 18:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760465766; cv=none; b=Yx5om4nkEsh+UK6y3YOa0OnMy2sYqxr5YEzZsZHGvX7Hdrk+gjhBrO1bP81o/1xQJHqpLgaOKoXwSlTGAlplRrRN5Mxf6yIbxIiYvj5h05Nth9b/68cpRruHlyGyT0H6Gvsxskawevha+MVb0T6zWzvCa+8OyV+k9OeBzwD5RIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760465766; c=relaxed/simple;
	bh=6CuAO15ll4/iKOsiJv5BwYxU+ATVaMe44Oz9Cnwyr9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeFokEMQUWf5O4Z0gacrOwW/ZHDQyh8WxfvzSZuyRx2i+qQK6qPQmrv/fw8mMsB3wBoQJVIs5V0/rZkam4jn/KXAB9rZeOnwa3nSPnZjiXhQ3M+9DhIm1xM1fH6xtHME3jP9I1jDboTsgUf2oOSL4BWc8c4VGwTOD7GIg+nQqdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nnOmxGFQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nnOmxGFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A5BC4CEE7;
	Tue, 14 Oct 2025 18:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760465764;
	bh=6CuAO15ll4/iKOsiJv5BwYxU+ATVaMe44Oz9Cnwyr9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nnOmxGFQqwIE0a8RR1S02LRic0fNGqyxDA51ha0tibS7vU7FKPVcRk6DJFf/yznYx
	 quMdovOSxtUIuQDT+wytq5BmyHN1Kx0nmoebae5LkpOssJmGI8nYSM2188ORCkukbA
	 xXfQ9B4BIuWuN04VSVHgVzeLFlqgEsZNKeikEevCm5andoo1kIKztDZmd2t+yQPoOB
	 f270CvVMMYywLHTxAGp8eL/WFstWdVt6zjfTVCBiYM3L/4/kUcrIIEDi0kea7JQkhZ
	 Fj/cNFj7Xk+s+4va9o3Amo3UHXT7LPubKpjoAeorTQTUKYlY0XcTyoQY0mQixGy1uT
	 jrEHlER/mvCZA==
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
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.17 000/563] 6.17.3-rc1 review
Date: Tue, 14 Oct 2025 20:15:52 +0200
Message-ID: <20251014181552.1257795-1-ojeda@kernel.org>
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 13 Oct 2025 16:37:41 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.3 release.
> There are 563 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for arm and loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
