Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074323EBF07;
	Sun, 15 Feb 2026 00:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771113803; cv=none; b=jjF5RmzHPLH62vjxvliLFkfGfxMIJ/xOCWclMrGTxa6/QuHvv9370gTLQ2Y4vNBSfhGdIEGXlTJK7mD5j5un7isN5PhdEiSXiX2hkKitgvGkgR2ooVCNSKFjh7QxwyQKELaG2pf7X20xZULU3GvMnLEZPI1k9ONuCgoS0MeUGDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771113803; c=relaxed/simple;
	bh=fH1DLbUghFqyumipHbIo6uMGvK3ol2p99WiJCMVE2So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PR1lPiwleY6LiOtJRpzSy/537DC7TDkzniB/lMJ0+xC5zzuR4AxNNRUkQNVvsPBZFHSiXPIGbhb6rWKG08/yNUP3HVNreS2gtMD5CQsNh/VT9MvdrlGKpAEAx0GhClGkRL6Z75IIZEn9rxQK6ERhpR2utTyKfeJS5gE5Hf9CYi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YD5wYz24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YD5wYz24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC5BC16AAE;
	Sun, 15 Feb 2026 00:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771113802;
	bh=fH1DLbUghFqyumipHbIo6uMGvK3ol2p99WiJCMVE2So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YD5wYz24IbosIe+d9cwvB+fFHT0EQUzSJdUpr1wT1LrR3n5Lto7s4XXkeApp/AKPw
	 N5HgbA2Mcl4lhQfOLv1nGdxzAx6zBaTAnMWR4pZIh97ldF0JPjLlNtjTCHU9CjO6p6
	 murFDbJLNAmxOFGKssg36ODUXz6n6o1N0Pjoz69tAc+9H5R1W5cZSew9SdImpG3hQ+
	 ID2WVJzUgBc9MiKzSIWcNko7Dk6W/BHyV+b5m0c1wZ1VcS9Mbgo511az30wzjQOqt4
	 GlJfh9Dw+G470Z8D1PJBhjmb8BxJONCSQoPEjnH+ROXRH5P5Dgk51rLVG6e9p9O+Hj
	 7HQ1gQlvyEdoQ==
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
Subject: Re: [PATCH 6.6 00/25] 6.6.125-rc1 review
Date: Sun, 15 Feb 2026 01:03:00 +0100
Message-ID: <20260215000300.42263-1-ojeda@kernel.org>
In-Reply-To: <20260213134703.882698935@linuxfoundation.org>
References: <20260213134703.882698935@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 13 Feb 2026 14:48:26 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.125 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
