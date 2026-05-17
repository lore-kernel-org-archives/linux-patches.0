Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6D422D7A1;
	Sun, 17 May 2026 05:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778996075; cv=none; b=RqyJtS0Qh5QfENVyijMjE1gwtWAPyQQFwwcMSQC3bkCea+QSxQ7/zDHRpaOWFd80ORHzA30CenhfMI6EMeTYGXFT8Y9OXSyljjbFNJqegxZv4Qo54eB1zckyUURd2kxXmKEOav9z+Pk2poQvrzweJSmDaBH26EM7LKehMinsozY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778996075; c=relaxed/simple;
	bh=kP75qeCWCdrLTTiKM1iI28cUOcHaJh622ImpQpAlG/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxYM1tdA41paV5xUEWs06ybwOIO4015Lm2DU33QAiiI1ScaWvbyZeb28uy9kzPGsBAlcyIhbVBnDgj4GbNbe8+1kBVB/VDwHL6mckxyyZc6er3wf41ztLH7YZfKnZerzecaldDy0jnK16pbD4aUUq5AOGeXflmq5y2AgilYQv2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CoXriuJ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CoXriuJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBE2C2BCB0;
	Sun, 17 May 2026 05:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778996074;
	bh=kP75qeCWCdrLTTiKM1iI28cUOcHaJh622ImpQpAlG/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CoXriuJ4zYn3c2mJ77yjWPHix0FXunhHWRtdgPP+LgfrPHSWbsFnEKUTrvglXbQ20
	 OYFNP0jzOuTJDVA6myHg4oOGe8tUiLV+aDljEwMUIIpoGPcErHxl3gR6VadNTBMU9W
	 JF4xf5A0LO+zgHQTD17rNSuy40eLleW28BMJz19uANsYAOgHUWxwJAjoKTyyhXqGn7
	 98xbPN9+nOJ0SeCkoRD1LhIRGnfDllFXhfojY7x8RJsIr7DWKr5Bt8Wgog1pbNt6iP
	 n6vskUF4ThZJhNDKyH7/fR25BqS6bZtf9RPYn1ENbMuekahqqLUZERM6FuWKUGeGVs
	 StLPbrsLgr1SQ==
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
Subject: Re: [PATCH 6.18 000/187] 6.18.32-rc2 review
Date: Sun, 17 May 2026 07:34:23 +0200
Message-ID: <20260517053423.191056-1-ojeda@kernel.org>
In-Reply-To: <20260516102236.209957148@linuxfoundation.org>
References: <20260516102236.209957148@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 16 May 2026 12:30:49 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.32 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 18 May 2026 10:22:18 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
