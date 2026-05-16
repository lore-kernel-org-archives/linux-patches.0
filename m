Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D3326ED37;
	Sat, 16 May 2026 02:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778897438; cv=none; b=q316X+m09AV78PkYDlG9AsnIDaqo4gN2J66IrYHb2lFCy6hrHJl8+JtHBgzLS6IkiX4TfHnscBleRX9tSPVA7VqPmUZkOhV9ZjXfXh/gqTOvAK5uQ/7kl6hkGLVlRxHGSwDmy/FuMtbvdgtKYQICepvgzKTgi7gpvHs4dRAHiI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778897438; c=relaxed/simple;
	bh=YLamnrDnYV/Jc4BMUupZ+eV6CPaNuQjn3FkuM3slOUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQqMGocjSMWoAXK7rRu6hxjEXojx0wUYTFVOkuW+NrfMPigCc3dbC8idymWhGhw+/JcEr2wGt4UrPPIG6M3jIEZlcxHCLnzdxXbHuY5IybJnl1xzeHalm8lwxU2AvQEhf2alLe0TncMSYZ/QVYTCn1V8taqLVpmpf9fp65zv84w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q12tdwwQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q12tdwwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5376BC2BCB0;
	Sat, 16 May 2026 02:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778897438;
	bh=YLamnrDnYV/Jc4BMUupZ+eV6CPaNuQjn3FkuM3slOUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q12tdwwQSbDXiE2Tw9XutOZZUVc/LPPJ9aMXDn16lzRpoeWQCq5q0iNOzc8OLKs8v
	 K51Vl48qJZDGG+4PRxoYRp+/5/PyLPHueg6XgIZIN03O0Ot6pwvN4jVMe3jJ4JmkPl
	 zbv//ECvXGcb2kVv7cZ1vuuPTCZr8e0fA0YBvtu2FxWvmVcIrvOD4FRtlP/ESQjMNR
	 let/fIuXUgTgLA8erYU84mPo25gvePobF5VUNN6uxeJ++f++pEqJvtL76YKySTAMYo
	 nzg2hHFRdnINiQNoEaHKCoYA4DZWbkx/UZ+YeG/Ov/mveoKfWtVhtaJiyJeLAToLIz
	 9SvuH/uWkAxSg==
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
Subject: Re: [PATCH 7.0 000/201] 7.0.9-rc1 review
Date: Sat, 16 May 2026 04:10:28 +0200
Message-ID: <20260516021028.111065-1-ojeda@kernel.org>
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 15 May 2026 17:46:58 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.0.9 release.
> There are 201 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 17 May 2026 15:46:37 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

I also see the HID warning here:

  https://lore.kernel.org/stable/20260516020430.110135-1-ojeda@kernel.org/

Thanks!

Cheers,
Miguel
