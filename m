Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795299524;
	b=q120wdv1zIOu+Xa2MBOiuaiJpYl+L/0YgpC0IjqrsfCO0DLxNzXwM6AI31Zeuw0tFRNf
	 iZ1umOosBYAZRdn3PQ8hTdYd4TUm9tIJtMU7/Y3OrB7AhExpP9a+bpEwXIUlKK6k5ppk7
	 dbk3IxWSXZ4DSTbdTUnvh6mdUcVsAZyxgVeYnokGbnyKSpen1T06Vb7p0Ud4IuOmy+h0O
	 1tJ422t4HBQW+RGjJ+wDjfp3LMC/tl+w5TkMag/slhLNMdc54EGCrFTtKnth4I24zHbEY
	 dV3CYBY2IUePZqjq/ZfTo1qiWWEkmK+usx9Kkf28nBJ4oDRKA2WRwrDoRx78d34brKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795299524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=bKmfnZpMlxZs3VosRLaMSMo2NrwoC5TkZGrhQMAxPpc=;
	b=LQpL7Y5fqGsRp2VlOpIrOn8XmqkpkPkqu008q6DaiOJMdV6BCFhpl3lfdPNmW7+t9+rr
	 rbvTceszHGGbNm+4vsYDaO3sx/hK1p1qRGjQmxSiBd2kMqzzLXv3uhXMncq+/ew4ilhRU
	 xtD5/54hE4C8wRYavLs8nC9GUxh6QjhF9HFofTwD78nrwikmgqPGov4B+JSV34ItZ1lXB
	 CtCXgDyrzYk5c+t7cFNyKiLAzarBY5jJIMLdt3SfJ4WzfS57zT0F05P7AxSMWaqlw07Sm
	 rFH/sGPr2ubtCEl21VK2jaucmYi1bYEg7jsGyfU0Q4PV7umHWBGDnz5+8SVuwUVYudw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jwXlw7TJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0874606A320;
	Sat, 21 Nov 2026 22:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jwXlw7TJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0D41F000C4;
	Sat, 21 Nov 2026 22:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795299524;
	bh=bKmfnZpMlxZs3VosRLaMSMo2NrwoC5TkZGrhQMAxPpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jwXlw7TJijAaP6GGkSbDQz72ejxs+kitTrHVMUI64Ok9kX1sIBwXIr0f9zowoQlnN
	 m2Zke8Ii/NRGe+kq3yCxDaPD+UyjfQszYHFV3vc+KHSMc06IDqkwh3aECzBFoUHVzq
	 BWP+kqe6ITwZTpTfXGUaf0YlfgY55xRyCVEkzGwF+6zQgSyHTAsiAZeJUBMo113hY5
	 lUjRE/d9YcoK2cByzp3YZFFOdPXfV+YiAPshOrXgTZkGdcZQw5nql3Sv5D/Qr43ztR
	 zbKhrxkAR3AsfovCK4mLOeaok9AWEs/9c+3AwPMP6MgZp8Lpguz2TlLAweBNeE+lXb
	 VqF5JvEID3hmw==
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
Subject: Re: [PATCH 7.3 0000/2642] 7.3.6-rc2 review
Date: Sat, 21 Nov 2026 14:18:36 -0800
Message-ID: <20261121221836.135557-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261120055248.913352689@linuxfoundation.org>
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

On Fri, 20 Nov 2026 06:58:20 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 7.3.6 release.
> There are 2642 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
