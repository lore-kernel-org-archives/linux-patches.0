Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E77B38657D;
	Thu, 14 May 2026 12:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778761221; cv=none; b=hOQz9ojL0LWBL4O0m2hZVm14zk28ENuWtBKWqC+uCPYC+i+BcGQqA5KklqafpC41305fbcH0iyDoDoBYae0JHba2LzvimG4V4GfatMxxbWK1UpC2ypS6oa2xgAUwHgVlagEEd0kpjGaL01an91Zi0GlvMvrXltnT/jz+dwf3KJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778761221; c=relaxed/simple;
	bh=fJ24ZMLVSwSP2GQDtYe0Yo61tlRu4kIqy0rHRENVA2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOix5g7aGcaMVmWEkOEaLa7h1H9IdhesXTFjFzMLRQO6dy5djl9Df+QOnBaH9JG2YpOWBJnr0yPVM9SywwpwyymbDg2c1P44yZ7buLsCCe5P6fj662K+Y7nzV6VU9oSn+o48BufYQNzXcFF5+2hiJaqfZnhwUQFRsBzuJNrCip8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TMMM+V5W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TMMM+V5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9B1C2BCB3;
	Thu, 14 May 2026 12:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778761220;
	bh=fJ24ZMLVSwSP2GQDtYe0Yo61tlRu4kIqy0rHRENVA2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TMMM+V5WSg0GEomqflwsi3O4cnUfJJPdHk+AEAHERrIgYF9IrUfmiFyiMns2vQcsn
	 wIBDX2oI1Fir8e1b29KdPP7LNMkoWQsFHJT3xUGgXSxixeoAxnB0tLPHAhDqB7iljM
	 z2RNoiuEGkOxv+cSfSF+VlI/sK0uSwYpblwDYN984ibVMlV20DOHIH98VdSBwfcNDe
	 lUrxxkKAGG/XRSUIfpndGrsFIUYO4tNsh7mN3h8XehD2Wu9/mQ3aROpN9mqbVeeUFO
	 oALUkbyEJ++YcqN+82XExB5Rip+QaHwrXZz1QClqABIOcVJDLf2T6jqx3tAnDLhNBZ
	 vk7//lrn3pQYg==
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
Subject: Re: [PATCH 7.0 000/305] 7.0.7-rc2 review
Date: Thu, 14 May 2026 14:20:08 +0200
Message-ID: <20260514122008.415577-1-ojeda@kernel.org>
In-Reply-To: <20260513153754.934923793@linuxfoundation.org>
References: <20260513153754.934923793@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 13 May 2026 18:17:34 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.0.7 release.
> There are 305 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 15 May 2026 15:37:27 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
