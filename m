Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962341D5CF4;
	Mon,  6 Jan 2025 20:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736193910; cv=none; b=hecLCFfS7jJEr6ml8+OO4dGcAK6GoM89hwtWPkmuRSwL1fiwrk8JFGXx/XKYwQx6atAoZN1bSmLcWFcOnAu9IzwDVe5d+aPlllPvjW4jzeZn7xHNc1lFcPdscs2jHEvyadloovcAPLiBT151nIedE7Nljp+O6af1j4D9M2gtAV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736193910; c=relaxed/simple;
	bh=8HK07wHCIbF/eQHYUA1A5peATTHCqVByA9t6WEclQ/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXwyJ7v7Ggr3ewbLo60UQvYIPJDb0HxKcUbQGWZIffOO5QSAXvxZ2xacBFUQhPShUx4GNaGSilHKN9UxNNIk6ULO8K59MYPHJAc4P2c3qNNpC74SiVcj/U0oGmww1ixGTmkSUfjePgjlxiKiuOww+19ckJB5Cwu+YrIHIo0SDcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BaXhUaZ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BaXhUaZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DB4C4CED2;
	Mon,  6 Jan 2025 20:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736193910;
	bh=8HK07wHCIbF/eQHYUA1A5peATTHCqVByA9t6WEclQ/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BaXhUaZ61RW1EYv2RNBeLM4EpNTvkoE9rkKL8pqIFuXD8tezHPwv76pYgL7HJrvtH
	 IAq4p+kkO38KcieirZ9UlT43RBi5GRD+I5TG4QpDYxw+AubsheadtIygPUrMAOvig9
	 hKMYkxR6QJZOOvU5xlv+cKxbO67nSYYYftRJ4KrZ4+RII4G2dRkCk7fdf+dhjtdEzO
	 a8d7wWDSzv/7Fh/7+4Qiujd2lOh6b7abLmhUPTrpIQX9WfDjwbplmfIqs9bXnGplcn
	 gyF1fB9E3K2c82YCHwx5MCso7oN5VrSNW0WVkjqkHeKfaRGTWZu+wNlKfhnYcoH4jx
	 Pnb7KlpzG7dag==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
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
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.6 000/222] 6.6.70-rc1 review
Date: Mon,  6 Jan 2025 21:04:53 +0100
Message-ID: <20250106200453.1546073-1-ojeda@kernel.org>
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 06 Jan 2025 16:13:24 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.70 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.

I got (in both the two runs I did):

    [    0.022989] ------------[ cut here ]------------
    [    0.023006] Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead
    [    0.023362] WARNING: CPU: 0 PID: 0 at mm/memblock.c:1325 memblock_set_node+0xcf/0xe0
    [    0.023841] Modules linked in:
    [    0.023988] CPU: 0 PID: 0 Comm: swapper Not tainted 6.6.70-rc1-g5652330123c6 #1
    [    0.024062] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
    [    0.024156] RIP: 0010:memblock_set_node+0xcf/0xe0
    [    0.024215] Code: 2c 07 48 83 c0 18 48 ff c9 75 f0 48 89 df e8 78 01 00 00 31 c0 eb a8 c6 05 a7 24 a6 ff 01 48 c7 c7 1e 37 7b a7 e8 71 aa 07 fe <0f> 0b e9 67 ff ff ff e8 75 f3 e3 fe 0f 1f 44 00 00 55 41 57 41 56
    [    0.024361] RSP: 0000:ffffffffa7a03eb0 EFLAGS: 00000046 ORIG_RAX: 0000000000000000
    [    0.024386] RAX: 0000000000000000 RBX: ffffffffa82a2240 RCX: ffffffffa7a52068
    [    0.024397] RDX: ffffffffa7a03daf RSI: 0000000000000082 RDI: ffffffffa7a52060
    [    0.024407] RBP: 0000000000000000 R08: ffffffffa7a52240 R09: 4f4e5f414d554e20
    [    0.024417] R10: 2045444f4e5f4f4e R11: 0a64616574736e69 R12: 0000000000000040
    [    0.024428] R13: 0000000000000000 R14: ffffffffffffffff R15: 0000000000000000
    [    0.024465] FS:  0000000000000000(0000) GS:ffffffffa81a4000(0000) knlGS:0000000000000000
    [    0.024490] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [    0.024502] CR2: ffff8c88c6001000 CR3: 0000000005628000 CR4: 00000000000000b0
    [    0.024585] Call Trace:
    [    0.024778]  <TASK>
    [    0.024953]  ? __warn+0xc3/0x1c0
    [    0.025012]  ? memblock_set_node+0xcf/0xe0
    [    0.025024]  ? report_bug+0x144/0x1e0
    [    0.025042]  ? early_fixup_exception+0x46/0x90
    [    0.025051]  ? early_idt_handler_common+0x2f/0x40
    [    0.025065]  ? memblock_set_node+0xcf/0xe0
    [    0.025074]  ? acpi_numa_processor_affinity_init+0x80/0x80
    [    0.025084]  ? numa_init+0x5e/0x190
    [    0.025091]  ? x86_numa_init+0x15/0x40
    [    0.025099]  ? setup_arch+0x4a3/0x5a0
    [    0.025105]  ? start_kernel+0x5a/0x3a0
    [    0.025115]  ? x86_64_start_reservations+0x20/0x20
    [    0.025122]  ? x86_64_start_kernel+0xa7/0xb0
    [    0.025128]  ? secondary_startup_64_no_verify+0x179/0x17b
    [    0.025156]  </TASK>
    [    0.025196] ---[ end trace 0000000000000000 ]---

I hope the helps!

Cheers,
Miguel
