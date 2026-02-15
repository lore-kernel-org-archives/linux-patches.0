Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B776B17736;
	Sun, 15 Feb 2026 02:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771123000; cv=none; b=uV2C7twVPPkSf1B7JopiozdfXsycqaM7uJ9X34pKxU0JVY99cMirGdR+89dRMyyczAGKJZObJ9Iv8C0CBH6QvdGJt69+Pn6iNDqfI3+3/3CNPkOE5dyRB6Rno0dyS9zalNBYlUH9Ti11kx6LRMMGhTay8xixa5nXpgMlS8KSGvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771123000; c=relaxed/simple;
	bh=MYvTWNNgh3VGT9AePyvrnE2IsLdxkl9w5j0kU6lnsgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SV5ivxg5L/T5rKtOQlSqVcNuEaJ3aF3xh/uGJHXkNBB7n/f511vXi7RpOq5COVzY1xwNL473TWS1Ds5pEp1BcL+8K3yRkJAxlPZ330onWLKX/sw2lycTz9+JLmgDCq9hFHHVsJy+AUphmbrgis3u749stPQLYZWFzT94yDGV7Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=abdTW+Nz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="abdTW+Nz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173C9C16AAE;
	Sun, 15 Feb 2026 02:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771123000;
	bh=MYvTWNNgh3VGT9AePyvrnE2IsLdxkl9w5j0kU6lnsgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=abdTW+NzMsKI+PWtvidzee5M/8jVLLgO1Po/PjQBgMztD9tl+K0FcxmwCVOQTL/Im
	 W00uIxjg0zqGdApoKnR02WKfzdu5kS0yDZEvOCjrWhWbaLEqaeclKLeac3g1haeDxi
	 nFdnf+1BVkLgoJg5aNcZgTepjSeISTsggChIirbFL1jqcNqgLBG7RCL/U0QcshtZRg
	 11kPgaV20Lz6P7df46/aXP9ieW3ZSy7nbSw+zg8qQgpowMXVU4tehYpW8MU8EvCauR
	 TC1QXpjU09lqRHyne/o3ig/lboID5GWf8GCXaI/ZLd6ZoBXb4cuyEFQawf2Elrt2Wy
	 6soFlfOfvTSOA==
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
Subject: Re: [PATCH 6.19 00/49] 6.19.1-rc1 review
Date: Sun, 15 Feb 2026 03:36:27 +0100
Message-ID: <20260215023627.56245-1-ojeda@kernel.org>
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
References: <20260213134708.713126210@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 13 Feb 2026 14:47:19 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.1 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Notes:

  - arm, loongarch64 and UML are waiting for a build fix: commit
    174e2a339bf7 ("rust_binder: Fix build failure if !CONFIG_COMPAT")
    and maybe we could add commmit 68aabb29a546 ("rust: redefine
    `bindings::compat_ptr_ioctl` in Rust"). Both are currently in -next.

  - arm64 is waiting for a build fix: commit 5ec66bbc7488 ("drm/tyr:
    suppress unread field warnings"). Currently in -next.

There was no Cc: stable on those nor Fixes tag on these, but we will
need them backported after they hit mainline.

In addition, we are also waiting for a warning fix:

  https://lore.kernel.org/rust-for-linux/20260121183719.71659-1-ojeda@kernel.org/

Thanks!

Cheers,
Miguel
