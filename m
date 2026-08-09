Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F00A3A9615;
	Sun,  9 Aug 2026 08:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786264096; cv=none; b=bo6gjVCOP10jUj2mNRXGJnK5S/pFD3rP+CLTp5gv+72KK3vLPc+dobvtuKtY0X3sy54iaVtXkSiPVq4MyHmLOAmFwee500uecBoSCZyKzDB0MJbSyHEW1oRUP5m5lA1mT+DREIlnqVbibFuAwTEp2pHRnKqa1/MfrVbBFEDIpjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786264096; c=relaxed/simple;
	bh=n0FUUzR694qXALZ+QNvW5O/2mpuEvBXs4QzXrk3U9FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHDnzr9kkDl7DkrtgrB5WfM+TCiVKBd4d+uahjJT3SDq4auJN8R763IJtpnvDWEWEvTBgExnu8RNy0PBxSeujxkvMOmAgXUtzUjHqdMuLUlpPrjkTXdi72hsNqhlM0pyAYPP9/43EM7Tqf1/fa0WZj8C7N3uHgNBXuAw2WZm4hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LK/5iA6p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LK/5iA6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FB01F000E9;
	Sun,  9 Aug 2026 08:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786264095;
	bh=scN0dVtHJLocRH4gfEpiZ+K9AepgESz2N8BuExFDaKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LK/5iA6pbYYYgfKE+2cgYUmPjlfQxRvdxMGah9atOF0/A2MUQ5cw8NmDKpY0jEx50
	 WQlWo/htOFjA54RuXmRJVrveRp857knhxg+fEydnHTwp71c+A4WynNX6vjbF07Nxo7
	 i/8Idz96BpGckZ8hbc/uKYDY7hEwLeWCGpCBSbJjMFVitNVEVDLb1VGG8olaL0/mAy
	 uYHCJNwdfdqbTKgM4pxI4QWAlF76BiWfjg956wScAFIzHMoYHpunV2D1Wpr0mXyVhX
	 VvHJ2yeJjm9ffo7dgRlXBtj85eN7UWbu0Ix2dKUzOxt35BgIxOyLv68qJWgbjkHu4+
	 7UlQsnav+iraw==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	i.maximets@ovn.org,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	pablo@netfilter.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	sashal@kernel.org,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.12 000/337] 6.12.103-rc1 review
Date: Sun,  9 Aug 2026 10:28:04 +0200
Message-ID: <20260809082804.252555-1-ojeda@kernel.org>
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 07 Aug 2026 16:33:24 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.103 release.
> There are 337 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 09 Aug 2026 14:33:46 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

I also had the slub `inline` issue, which I see Sasha fixed already:

    In file included from mm/slub.c:21:
    mm/slab.h:572:24: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
      572 | static __always_inline inline bool need_kmalloc_no_objext(void)
          |                        ^
    ././include/linux/compiler_types.h:249:16: note: expanded from macro 'inline'
      249 | #define inline inline __gnu_inline __inline_maybe_unused notrace
          |                ^

Thanks!

Cheers,
Miguel
