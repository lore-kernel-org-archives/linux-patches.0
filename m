Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795301224;
	b=PwQqA8WJuiY5eHyE+88rOiYfTV4WDImohLNaEk6ZTVb66nxgoa43dao+YTldOQObY7bp
	 L3n4+nnn2KQJM5OcXzz6+y8E5h62hfoNyfkclcmOkFyHpHWwGGFdz1FGZDu84Rm0Be7LA
	 9tk2lqt40W9WF/+ciOr9WLGuAFZCuzxhO3QZegweA/ffkKrzg7xN06vYFU1gHrXjxhDno
	 aAuiYi7DoF5LOs1x6s+MdZhN7Gs6rh3GXpHDGwPywaV3vtz9mOt8Ej0tM6w0mLtmlVBgq
	 ATNPXDdV58Ob+FsGpR5WGTl3PLzmTvJFZZwxRTmlyFQJoW4/0YJ3lTBvoVHCa/b27lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795301224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=XT8m1CKSI+00WLR+pPujkQ1Ddqhzv/L1jEX7o9vDjA4=;
	b=xzgEQUkEdvfUdGeAcN50XZ94lzQfFzeuhaAGycMPjA+A2p2VR+I++47ytGdHelQhtyrw
	 mGKq/NNI+3ttee0IaKkE8TacnDtRPUX6Pq6G78z+0RlbfsSct0iy2g8aN7Ywb8o98yrp2
	 Fe0msBHObwP8AD8wg+kTGctM5JFzhSfWwulGW609718a1SqYxOv3yQ75b79TNbp9R8IQ+
	 FUv6wHPCQPkJAtgoRg7P1kv2EQiqxzD7eVL2aXxReBMa6CFmLGaYfIqqDFxd5f+IT5zSv
	 kdrLj26DQOMnYPr4TiIXRXwfqUXTpJtDbkDrDvxchWd/pKh9sASONrRMyXjLDSsM91g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nHX+hHkD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B24F606A320;
	Sat, 21 Nov 2026 22:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nHX+hHkD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006341F000C0;
	Sat, 21 Nov 2026 22:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795301223;
	bh=XT8m1CKSI+00WLR+pPujkQ1Ddqhzv/L1jEX7o9vDjA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nHX+hHkDqFXQZvbVcZe6n0xcFEiamNcC98WZLT+DjPTW+Z7ZdGb0e9F+EYH3pIDQQ
	 X6ae5Awxs3xaby9wJfEPNDb3vNTJ/UeS/Vsr1ZVLzCN77Hq90u0Bi4fJ7u8Ke2ksMT
	 P0AS8n+8G3Jb/wJL5U4jDAIqg2gi8+gQ5pA8Tf5ovIAwWXvoFzV9VtTBxYwCBSVeoG
	 WTkMZtB4x55/2N6AFWYwXJA5lJ5xPAMP5J4DyFtrOh6FZwShP0EfjOvVxggGz2Phee
	 Ip9xMEMw6TsbHx8t7BuMJkAwYIlKI3z3WrKF6GpkfLHwISjQWdGVDQYIXnDGALo+9E
	 I+zNgE92eaUSg==
From: SJ Park <sj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.15 0000/2178] 5.15.226-rc2 review
Date: Sat, 21 Nov 2026 14:46:55 -0800
Message-ID: <20261121224656.154536-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261120055015.328810133@linuxfoundation.org>
References: 
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 20 Nov 2026 06:57:07 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 5.15.226 release.
> There are 2178 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
