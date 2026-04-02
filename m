Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE9E2F5485;
	Thu,  2 Apr 2026 13:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775136353; cv=none; b=n/U9lQrgUFswKPWfo6QRu3M9d8Me6+CoBa1J9N2qd/Ge0H8/ocOnTG5DiF+wc2ZPBPfXUiLw+j9kGczpvZdxm5Jdj5clatoHStlI24kNe2qtu4waO9NPsDEylWTrkDZs+/WoGz5Pa81OoxylTKqhx0b1AWAK8EZKe2NCU7o1tKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775136353; c=relaxed/simple;
	bh=rwM+DVtFCXHabJzc+EEXSnx4R9jMnMmtwdZ8fpOz/S8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgz/y62dl+7lYhf8Ua9irKDJxdfNfqKHjrjjlayrMNMnFjhXfQt81yOTQdFwfR1SZ4et+Tnm35uJawWCNQwjp4GwPeGu+sxCTh3EYPmFF76H6d79YL3fEz8ZyPoTxKn1sYEEebIwUuA+m4mj/Dg3MG502r1oUlS1WFem6EfwkqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hd43MtZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hd43MtZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B139EC116C6;
	Thu,  2 Apr 2026 13:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775136353;
	bh=rwM+DVtFCXHabJzc+EEXSnx4R9jMnMmtwdZ8fpOz/S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hd43MtZTbsCugyWMeslT6nRvlCZ3wG9bnTeK56DI1kdgbmiiNSBl5hQPwHxBmmvC0
	 dTBzJOt470aeENTwH1h673QP/u1yAJEKlbHu2yCTOyY8ITjpWXLP0GYgKlfEFqY4wB
	 vIvsqaWBGkCpbr1Yi9beiBsbfT7wgu2wEO8+T5Lv+YCSsYYt939vrq6EsP39W3Z4iL
	 1FCNRpf6X3ck+mHXVY2bJhfgx3RNCF1xdcJUBz0b5NNcGj4jxY6cXt8XaSg28RQp2m
	 3k84OB4oZTK17NYEUPeaH0W5nWL5UX+Y/hf72Ao0kTk6vOQAXMZGzPUsE55rs/BPpH
	 P89tZf+smm8oQ==
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
	Benno Lossin <lossin@kernel.org>,
	Gary Guo <gary@garyguo.net>
Subject: Re: [PATCH 6.12 000/244] 6.12.80-rc1 review
Date: Thu,  2 Apr 2026 15:25:40 +0200
Message-ID: <20260402132540.124376-1-ojeda@kernel.org>
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 31 Mar 2026 18:19:10 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.80 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

There are a bunch of `CLIPPY=1` warnings (errors with `CONFIG_WERROR`)
like this one on the pin-init change:

    warning: unsafe block missing a safety comment
        --> rust/kernel/init/macros.rs:1015:25
         |
    1015 |                         unsafe { ::core::pin::Pin::new_unchecked(slot) }
         |                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
         |
        ::: rust/kernel/block/mq/tag_set.rs:27:1
         |
    27   | #[pin_data(PinnedDrop)]
         | ----------------------- in this procedural macro expansion
         |
         = help: consider adding a safety comment on the preceding line
         = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#undocumented_unsafe_blocks
         = note: requested on the command line with `-W clippy::undocumented-unsafe-blocks`
         = note: this warning originates in the macro `$crate::__pin_data` which comes from the expansion of the attribute macro `pin_data` (in Nightly builds, run with -Z macro-backtrace for more info)

It is not a huge deal, since they are just `CLIPPY=1` warnings, but we
nevertheless try to keep them clean.

Apart from that, the rest looks OK.

Cc: Benno Lossin <lossin@kernel.org>
Cc: Gary Guo <gary@garyguo.net>

Thanks!

Cheers,
Miguel
