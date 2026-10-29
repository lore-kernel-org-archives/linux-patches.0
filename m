Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793281229;
	b=UucxnQIQCukTNNdy8Rfnx+uN0KXzNKzBAtdEMdPsGauO9ysuJzIPTNauTNE7lu6Kd7r4
	 WTEwpE/TbQh/1WYtcOxzC5swfKyt6FuE6dgm54DhgURUx1G1ODu2t2CynV2oLuE5VXb+i
	 UrfSlc2TnvX7cBjOIPVQ44n5Ybc/btRjb6kHz+GPMTYh71EUxoUI14THynUua6sRwGFtf
	 4fx+gOb/LkJf3rfvU6mgy6tqhf4hFG5ij0GbPTCgoo9DM8Dt0EhErZkoh1vpFJ7maoslb
	 Yb0WM5SWMCQQG4Ly0ZrOxJG5GwQmdUz1rczGyTOWvRK6t3ceR7jyLkjjOR5EGjUhMyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793281229;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=sJFaFwMkyP9qVaoKCO1Lsm0XT6CfVfgfIkv6WZb7oCc=;
	b=xH/zHQdzxkmqs+ZxApF65JzoJ3dmIw+7ESRPEkbCznwAqfH8M7h0EqkNP5f+H6G4whA+
	 jhcScCCI389OFjSffrsDhD24gEbjiBEemTWmACGsm38Ey/1ht1xW2dHD1qkqD6ZWZctYy
	 zjvzECucJVdZdWpDYkRoIzNts5f8T4qugDyf/DTOnBOZWhuDuBTOazlNU+fNVTzrUMZte
	 IcZcGzIWYuyql92GVFHJaqOtvcG7Z58CKLRRWPSvjyRhCTjyiKF3U5iRf66u7RwfVwZhi
	 rv9xIJ9ob7VEuSAaeRWSYFQDGhQAjPOoRl4VSU9PMJXQ/sBKSGcc6VP7bYKfKWze+1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bf7rtjkb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9532606AAC1;
	Thu, 29 Oct 2026 13:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bf7rtjkb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3351F01243;
	Thu, 29 Oct 2026 13:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793281228;
	bh=sJFaFwMkyP9qVaoKCO1Lsm0XT6CfVfgfIkv6WZb7oCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bf7rtjkbkjalftz9wzNFlBn46EFDYpFQ1OB0WCAhCdwb9UwHuezPuFJVsnH4CERyL
	 LQqiU1fLD3m6Er7VJ+cDJB/i0I0f5x1vUGG7LO1ASKZab2Xktf+N8GGhayih+ad9zr
	 OGv63sLA26uCGmJch9cU2+y0GyOE3uMnbVOYus1n0Z9ToPWbBwOuk9L6BDSq/DKXjB
	 T+K/8BNRqSmJloJ15MzKJW6DoOYrAU+7ggf3VlmVZHyUi1a152J9KaElU5D1fTBSH/
	 2aumiC3Q4glB/3va11zr4BpNZ3MfelWcEse2Tc1B8Hn3HFXBBR6LJ033zXX9AA7AKy
	 UcBLcZdqrUJ+Q==
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
Subject: Re: [PATCH 6.12 000/247] 6.12.115-rc1 review
Date: Thu, 29 Oct 2026 14:40:17 +0100
Message-ID: <20261029134017.25906-1-ojeda@kernel.org>
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

On Wed, 28 Oct 2026 17:56:43 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.115 release.
> There are 247 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
