Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF587233949;
	Fri, 17 Jul 2026 00:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784248573; cv=none; b=Rsv6SJXNKLS6k44fa6IO6snIKaesiw3u0AXygyG8sCnzNpc43tcnlj+G9ww9LDNaPY2wEZW814OhId0in9m9CEXwwVMl+huhgmigndZ6UGToJZTzVCRaqTzpEDdeUrTrng/iDZEwATkwc9RLj+/iyljFlUrnEbrbi8mSXoE4y6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784248573; c=relaxed/simple;
	bh=c61hOkuDWPBGPWAgT2NivMHAoDabUOUUcZxFPw5ZdOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqDCoO22UzJ99Hdks0UdqT6bwO+t1OkOr6ejc/5K/gQmAZi2ql49V2+F9fttO8su/Uu9KrElGogPpqUUzf3mAEvGFzdKRghP7y+2RhxRCr4FWnYDXRpCLcIXhZEM4fLPvSzRqtBXVoOOk6Grrapsx/p9BaeH1DYLsI81JdIDkEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B2Nmepm/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B2Nmepm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C853B1F000E9;
	Fri, 17 Jul 2026 00:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784248572;
	bh=yck5fMQTI8Lgd/l6ZJL4otYv+LUV/fGsbBTHTeYDaOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B2Nmepm/UQuRYmEEm7d/cHjnPlws+fRZF/GB8188Yp22qZkPik60jslanx2voR18X
	 frNkRg23A6PI4Q7MKl5+AkqWrN6Pu1ojNHLuizg7ZnSLIm3DYxGZt13MBsbbWiLcvT
	 IvVNaOw/ODMlzRO+5hP4VY0RaXy1dGv40yT+CpHscge0pYVcO4Uh3G2iuEHtNVJrTR
	 Q80NrQEOcq3CKes06eMaEEbHAIhWV3jJI/z5ND24rAyK1MOvuwAQTP+PNKUBs6THHt
	 9OG5Scfg/GDzVHVGTZ8qy7YdD0H0rxXfBAA0zoMCX0nZQQiEFh4arbAHCim/+lC1YU
	 oZG8fVJ8/T+WQ==
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
Subject: Re: [PATCH 7.1 000/518] 7.1.4-rc1 review
Date: Fri, 17 Jul 2026 02:35:56 +0200
Message-ID: <20260717003556.133341-1-ojeda@kernel.org>
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 16 Jul 2026 15:24:28 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.4 release.
> There are 518 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Jul 2026 13:30:01 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
