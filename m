Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1EF256C70;
	Fri, 23 Jan 2026 21:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769204489; cv=none; b=uGCYE+pzx2/IX2kvBfErEw784r0/s4DFDzZrVY7dczA9ndNxU0IMq1+AHLNBvoLOC2va3jWOueh/8tnik+OFpJrsAmLMsO38lyWRMl0xPMrNkbgjHh1GPYj4Fhiz6dkROQjLPYJCOHFkpU+MMqLYp/FGIsLf5bAJ8KPk+8TxkgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769204489; c=relaxed/simple;
	bh=Je70bcBzcj4dsXrG8ZfJpnw5/HF+33l3GrF69bgsmMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ds4ovEJc9ZK9Gm+LHvVTOLDlPd4ldOqMKzbg1su8YbfTX7I9kx6OEAw0ngcOkMg/m2eqTiBPpTv1hUk5Rs4uHd35qajQ7o0dQ8VO15KF/Blgyt0qR2pPbVX6iBDeaCup58eo+2ACLBfqP8PDTOQFhl2Uf1/ez7E5thWJJuQXfgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hl5jc/aW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hl5jc/aW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95373C4CEF1;
	Fri, 23 Jan 2026 21:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769204488;
	bh=Je70bcBzcj4dsXrG8ZfJpnw5/HF+33l3GrF69bgsmMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hl5jc/aW4WdS1DGPsJI0VRUUXGXrFfXC7uzGYKirihtUI9PKdokUu7hc0iBC+CA/v
	 8b3QVIa+EBlbFIJNQQxwowV7wp4R9845CXPqqs09sTzu2fSI9yMSUC7w7LHVrBRALR
	 f+T/A+86thuGG3JNVJpPvchMh4A5ewmQqlklk+gE9pzdFbbzy90YeMRoB7tvuj6sMN
	 f9mLYM5lH2weJERveU4Q0Hzsk2dKQ16mIbZQsaEWxz9zKh2YHsGxS+qIQmtxrkBYI8
	 tuiFQCuQ8HRgfgURD4Q4JFwdksiFL1ybcOPeBZyCOyJKi08P6LeJqVOK1DPSKNb86j
	 EpolgfEigSZuA==
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
Subject: Re: [PATCH 6.12 000/139] 6.12.67-rc1 review
Date: Fri, 23 Jan 2026 22:41:16 +0100
Message-ID: <20260123214116.8553-1-ojeda@kernel.org>
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 21 Jan 2026 19:14:08 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.67 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Jan 2026 18:13:43 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
