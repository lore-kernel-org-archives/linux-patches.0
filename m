Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FEE2C15A5;
	Fri, 29 May 2026 06:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780034977; cv=none; b=vCxdcGwL5kaSo4K7R5uYq0QTsF2E0rFMr/4ipHuncZ2W0SCgq6Lt4qQ4DYmVfUTx/Mojhbf9/PRI1SVCY+lWiHm6S0+hqukyM6lvdDLjtd/LQS2H5nMB6EZXhQf6QEgfHDQnk1/OiCWLnA6kZp47DUwuoYqEdMzcjc7N1Zgpr5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780034977; c=relaxed/simple;
	bh=fIclOetvM1I0QIG02RKZl70AzDznTBk+NdsBhwsjIU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BglWB+QGXTFZ2I+Y6AZri01psKSkHuGpYYN0ehi+cXxp0RQjkG9T7CY63N7B5sA0ne9L15XnlXUGXV6/AlOehVEPmqtVpe3wGhDar7HLspwciLS2txBZMGcSPBs8YFU0Nniypdj5DS4w3zxEd8SGNExbVQKbnNpoykQdiPeElpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EM3A7L7m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EM3A7L7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C42D1F00893;
	Fri, 29 May 2026 06:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780034976;
	bh=pTHyR6AqtgUjVBTYL19Bfd0hR3boodWmhm7OEYTZO9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EM3A7L7maU36AQcQxDmHswhEWSHuphXFIGifJgvim1ghA5909A0uS61DkB473+/TZ
	 BWpLZDweN8SsyQoCmXfs3JbslfPvvMGrv98963NViBZB74enXXoMYZWYrO+LxRl5Ex
	 XY3b4E7R0mlolAyKkUE2XuIWUgswJfg1mu7CCaXoxGxGK9LbCZTJgeyQNzlV5Ez4v4
	 jPJrohFmF7/bBm0QoN5Zr5Zyu0yUfZFJl9aKRbrSirChY67w9t2NLI3281AXGSb+N4
	 iilNWkPy9Pw3k2Fhekznz1YytL43mGN58pTsXfJsiFMgNzCDNw2YMxNlDzCAtONW2D
	 4GE4W72eqBTlQ==
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
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org
Subject: Re: [PATCH 6.12 000/272] 6.12.92-rc1 review
Date: Fri, 29 May 2026 08:09:18 +0200
Message-ID: <20260529060918.123155-1-ojeda@kernel.org>
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 28 May 2026 21:46:14 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.92 release.
> There are 272 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 30 May 2026 19:45:52 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

I am seeing:

    In file included from kernel/trace/blktrace.c:23:
    In file included from kernel/trace/../../block/blk.h:5:
    ./include/linux/bio-integrity.h:101:12: error: unused function 'bio_integrity_map_user' [-Werror,-Wunused-function]
      101 | static int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter)
          |            ^~~~~~~~~~~~~~~~~~~~~~

This looks like it needs:

  546d191427cf ("block: make bio_integrity_map_user() static inline")

(and indeed in my run `CONFIG_BLK_DEV_INTEGRITY` is not set like the
commit message says).

Cc: Anuj Gupta <anuj20.g@samsung.com>
Cc: Kanchan Joshi <joshi.k@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>

Cc: Jens Axboe <axboe@kernel.dk>
CC: linux-block@vger.kernel.org

Thanks!

Cheers,
Miguel
