Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0AF484229;
	Thu, 23 Jul 2026 15:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784821400; cv=none; b=Ob3UOoU76nE/G8W2V1o9l7fO/qTEWaBuqhTCsz88M/xtI2mCL8NxvqZ4Y1+wohfD4ExY4o7wRUYRhIqUr48No+B5qEqwr6UXFXvUF3zg/Z5bqEqI1EbgT8HXIWuY+UUU7N9a+nci2tVYHDd/qop5fd6XsOP+tRBsRg+G6QTuaus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784821400; c=relaxed/simple;
	bh=7CtQsGOkF4aE9AptO2qQPJHnLasb1hwzeZ6GKl3hLQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k5XLypHaCQt4GL7Dy7SRl2FKMH9KAgDFlJJNiYPnAN68U+UzhAWnclcvaFbYkrtBekpIZIkLjNwjRIW9LjjSZG3bd+1Zn8UsQugTjPyqTUEhAjxpvkO0DCuNOQfErrEH5TI3sGAUlkb1CaYS9eOatOv0o3PAHVLjtLKSaGx39XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K5le84i7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K5le84i7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6511F000E9;
	Thu, 23 Jul 2026 15:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784821398;
	bh=n+cHDD9zAl4Um9SwhjM7LLm9yRbwoVznrjntYEx5NNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K5le84i7bPrvUhmaEcZNEO/laXZ16q1Gz7wJT3o5UUCf/oA1kaakRD3EwZHxfdvY6
	 9+oNhR+Q2tUVl6ClLaojRsqJk93orjrBKaf6afkwsxJumqOosa4opVS5qtY3mh+Sw3
	 nCQ/3U70aEfd/84tUn0rbwqaOdPV4NudO/Cg/q4KoCYYFNKbxCRKFaymPTI093G9Q1
	 gGhTOzn1SvVhISuE8EjphwBJ8diSr2vV2vJ8Gv/jCCdFK/ltWhzo1M2f2PaQyxGfXq
	 Lbv0WrUhwO0doc85Cvo64z6TciQ3zXKrCz4tYPN8dovTuq68fkLzSx3EZEDi8jt8lz
	 n/F0zp8v3XkzQ==
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
	Eliot Courtney <ecourtney@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Alice Ryhl <aliceryhl@google.com>,
	nova-gpu@lists.linux.dev
Subject: Re: [PATCH 6.18 0000/1624] 6.18.40-rc2 review
Date: Thu, 23 Jul 2026 17:43:03 +0200
Message-ID: <20260723154303.11008-1-ojeda@kernel.org>
In-Reply-To: <20260722142910.893804136@linuxfoundation.org>
References: <20260722142910.893804136@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 22 Jul 2026 16:31:54 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.40 release.
> There are 1624 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 24 Jul 2026 14:26:57 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

I found a build error for all builds with Nova:

    error[E0405]: cannot find trait `FromBytes` in this scope
       --> drivers/gpu/nova-core/vbios.rs:398:13
        |
    398 | unsafe impl FromBytes for BitToken {}
        |             ^^^^^^^^^ not found in this scope
        |
    help: consider importing this trait
        |
    5   + use kernel::transmute::FromBytes;
        |

The reason is that the trait is not imported (and then the function does
not exist in 6.18.y, i.e. `from_bytes_copy_prefix()`).

I suggest dropping commit

  d8fa174e21c8 ("gpu: nova-core: vbios: read BitToken using FromBytes")

for now -- it was not marked for stable, and as far as I know, there are
no production users of Nova, especially in stable kernels.

With that reverted, 6.18.y is fine for me for all builds.

If we want to fix the bug, then we may want a custom minimal patch.

Same applies for -rc1.

Cc: Eliot Courtney <ecourtney@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Eliot Courtney <ecourtney@nvidia.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: nova-gpu@lists.linux.dev

I hope that helps!

Cheers,
Miguel
