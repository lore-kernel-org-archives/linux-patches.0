Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2433164B7;
	Thu, 30 Jul 2026 18:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785435466; cv=none; b=XdFY1uxpXeUcttAOckAItSjWekoOFy0stSKdRq//6p42w8Fq0sCp7fC3DqeLCAll5AU8FabELgflP93nSLjgVrquKOxzk1neWvv3NwBr6Jy2ZcXUspyWW6zLfBEnj6pZcaog+77wgj86fbr5R/IWegPPE1PYkyIQS/Lmr6H1/Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785435466; c=relaxed/simple;
	bh=Snwv4ZX9n7rsHVFGJZZarZQi0g4FUtW3ValMoH96bV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YEHdXpaZRRZckcmpXjhX/281iIyz9ATzMiNaxFt3Go5/o3Bi6jhCXCAwx6LA9nxBBDQAR4PDembkkLB8vWv+CPlJycVomvEs1CpS0cSELJXRP2QMFUpRvdEHZKXvnQGKxoqdhjfd9C0iOtefpLsqXFrPvbg+G2dmC0dXMK7cH3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fuXCm1mL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fuXCm1mL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F6F1F000E9;
	Thu, 30 Jul 2026 18:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785435464;
	bh=6R6dAzebd0lU5AFh1vm8XcRfXETiBlUdRxOXlhLQ9dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fuXCm1mLoqc5U3HXHSVUiHIjwDassHB8iSnSwNq4WhbmdXls3Z/2rBcJQQryry0MQ
	 d0/5PoQ4wY1kXlywpxQCvpsKPiMhJPYwXdKaTtnn4ZkrDnUy/qUhdtciMN4bkCWUB2
	 UxyJhIaQl4tedm4dCpOaRXe2lNKkO7HwUeOlA7P4jjJE59v1utLBeKnNEzjeVX6J9J
	 rddw/X8gRdnv87M//z/5Vi15Mrs9YHzBlWvHxQG70tqI5fSchBSokpp/u0pHWO2vM2
	 VzXYjm0e9qd9kJ3V7eR3+yo5W1sbmCjfCPjDRm1umjoiaj1J5PuVngngXMpH3w1+dj
	 Pg9O90dBhysgg==
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
	Miguel Ojeda <ojeda@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 6.18 000/675] 6.18.42-rc1 review
Date: Thu, 30 Jul 2026 20:17:17 +0200
Message-ID: <20260730181717.95457-1-ojeda@kernel.org>
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 30 Jul 2026 16:05:30 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.42 release.
> There are 675 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 01 Aug 2026 14:13:45 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

I detected in the middle of the build lines like:

    find: 'lib': No such file or directory

It looks like we need:

    ee8bfb15d02d ("drm: drop lib from header search path.")

to go together with the one that was backported:

    5e7b3c10420e ("gpu: Move DRM buddy allocator one level up (part two)")

Having said that, there is something going on a bit confusing: commits
"part one" (4a9671a03f2b) and "part two" (ba110db8e1bc) in mainline seem
to have been merged into just the "part two" above in this -rc. Is that
intentional? I am asking because the original removal of the `lib`
folder happened in "part one" in mainline, so I was expecting to have to
point to that one above, but it doesn't exist on its own.

Cc: Joel Fernandes <joelagnelf@nvidia.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org

I hope that helps & thanks!

Cheers,
Miguel
