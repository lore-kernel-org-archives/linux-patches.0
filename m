Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D6933B6C7;
	Thu, 19 Feb 2026 13:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771506197; cv=none; b=UNffjSD21uqNauSV15OKeLq2dBY9r1F0yg92lE2dtgoJpeYMP1pI4V2NbROqZT/BAwh+v5iWVkdfIn9+3AJKeanYduphh9SEcHmkpRFPMrkDVRZRDJqgaNQKoxpkPfvFyAVKNhi3HCiy0Po4rrBvtzSasW8rWAUPkPkGzCFwk7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771506197; c=relaxed/simple;
	bh=yK19pzf3xS6eSgWh4BDlWw4MEi9y63s4HTiuIj6YxRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpuRTIXQeOY+tTt2C9LjtXXfKY7l0x1ncH1yRvHBht/sHvekCF+e2JdtXVsVSdsy9xVXWbMkx4bOP9AQrqa1XhI3EAlLe5pCLpP2bA2qDEvlwqoUAm86G/sJ7GGG/VxMIgAeB8gfC5k/GVR0sC7A9Skci7ViZM8oDsDpkTd+HzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t2ZoCQY7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t2ZoCQY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A83C4CEF7;
	Thu, 19 Feb 2026 13:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771506197;
	bh=yK19pzf3xS6eSgWh4BDlWw4MEi9y63s4HTiuIj6YxRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t2ZoCQY7ubMdJFO+Dogk0wJElzLEhXKFZ9AkBXAx4+w9tG9dUG0pnEtgX8h0cx+fm
	 n9RakTCI8kMCHii/QQlCHqpbzeBnQeGxOzuAvJRSyQ9vx1nTYgb666rG8rkBO0Oo6v
	 QvBbQS7LB4TCat9b6w1Kalq7MYIP6LBenv9Ukhh+WC6mpLKKTRY3ScpuDPB+JoJA3a
	 7Lk55C/u9d9tzCOAjUTit6uEMYu4E4F7keqAxUURTzY0HbPAJxO3/C1mrSt1cqugWa
	 kr1GHwpPT3tgaQMsL2F0lJCRLROfCqKX2txbhENwjHaWlpuLm1z07hTaXVts9iwBsc
	 AwndwIqXFKQIw==
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
Subject: Re: [PATCH 6.19 00/18] 6.19.3-rc1 review
Date: Thu, 19 Feb 2026 14:02:56 +0100
Message-ID: <20260219130256.31407-1-ojeda@kernel.org>
In-Reply-To: <20260217200002.683975158@linuxfoundation.org>
References: <20260217200002.683975158@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 17 Feb 2026 21:31:56 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.3 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

The same couple build errors and the warning still apply, from 6.19.1
(and 6.19.2):

  https://lore.kernel.org/stable/20260215023627.56245-1-ojeda@kernel.org/

Thanks!

Cheers,
Miguel
