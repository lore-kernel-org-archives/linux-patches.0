Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717534;
	b=17khpxx0H6XvAsG36LWroCSoQ5Eo5sdSGckc+xrbQUa9IVZ9qsiuaJGyDD5PpodfEBSr
	 fYREmgr4S2BIK0/RDEn6hPVbXPa5Ftm67ob/cNGn4fQBxF2C2TCbT8inB9cvltst8dPsK
	 TNdZ678a2FOh7UivKVMdWGeWHPUIveT2flxeQ1QRCwnMcYfP3i3+I5L+fA+z5CwUUUZkH
	 t/tmxNK1WNHeoi30qDq+epFRESPNhBKt2LY2FYQ2xs/6Hz1A0FWRcY9jM8m70dta0cUlv
	 VjX/dbyQKgniVoTzSN5TJvGOUWIHqNaied8WiIyxSvQxFOj01Z2hvqod93o9pIPhxQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717534;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=DK5lkO7DDq83X1j5wa+EMjbvR9lQfhGLS95cc5EpcXo=;
	b=xZipuBJ/1RvPH8SyenfGhCPWuJFWPEb1GhbF5P3tU7nmNZt8KYoECsVxlH/yBqMxMRT+
	 JDuSu6t2DW3OO4bQ17ou91RseTz///hGcsawF2hBzbwvy7jnlg+JAqUJRdLTf9OhCU6ge
	 UWfgj1Qa7F5NxLz+QKwRDr7/8f36wi0nn4n70y4RnVcIzsD4mCcEq+RHZIaBRwgyICg5/
	 LomVfBhQgNOdlVMgRmWDPQxHpp1j0DyjfcBKQjOpNRPxEQ9E6l5iXGnReKW4JbNJkEFdS
	 rn9Uc8t3KaOji0zz73OEUGBm+JboAXX4XfLw/z5ijtnOMPAKCIUFXIRGwK+Z/iOcfVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mx8LgBXp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F22B606B25F;
	Tue,  3 Nov 2026 14:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mx8LgBXp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42BF1F00A1F;
	Tue,  3 Nov 2026 14:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717533;
	bh=DK5lkO7DDq83X1j5wa+EMjbvR9lQfhGLS95cc5EpcXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mx8LgBXpc6FJX/oG6DckYBobLi9rJu0z8jzj1w8T0AeUET3ldU06h5xrbad0bn1jO
	 oFebgqYxhl8mDr+mMTomaVwyBXt4mBIDLZggSio/QDka/2cXcFMM/ol/Fvb3wOu4I1
	 QMZgA1UAhyxhiocAdH4+2luPb3fwUiG+OcOTtHFUML6zfBz3XDlL3CLMOQqzcENLcr
	 qw0wBCAXVDXNXOHL8/4Kqh07lr5EeO/+D25IoYpbqQaXEWs9NZ1Q+eg02oREvemDHx
	 TzJFQAB8bJvwEihfHslEGgbm5K/4TkXic7EUFRCFOecs5BT8YLHtu12HEaKOsrnq89
	 s9lIgFcbjG/6Q==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	linux-tegra@vger.kernel.org,
	stable@vger.kernel.org,
	Jon Hunter <jonathanh@nvidia.com>
Subject: Re: [PATCH 6.1 0000/1879] 6.1.191-rc2 review
Date: Tue,  3 Nov 2026 09:51:51 -0500
Message-ID: <2026-11-03-1-daily-reply-0003-re-6-1-191-rc2-tegra-interconnect@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <6051255d-96cd-41eb-878b-a4e2e6ccdd7d@nvidia.com>
References: <6051255d-96cd-41eb-878b-a4e2e6ccdd7d@nvidia.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

> To fix the suspend issue I also needed to revert ...
>
>  commit 3d64d18bdd1b2a6bd4af1176a596736b233606be
>      interconnect: Fix locking for runpm vs reclaim
>
> The above commit is dependent upon the following and so I had to revert
> the following too ...

Queued the reverts of both interconnect commits for 6.1, thanks.

-- 
Thanks,
Sasha
