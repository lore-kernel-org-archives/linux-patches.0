Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FAF26AFC;
	Wed,  4 Dec 2024 18:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733337867; cv=none; b=KXZW80diJbebTMHBoaLkttImjXZyrqS/6v8nnatyZv16dUdsmZtRmdXLASgbfWoMXw7Y/+2cxR0TZ9x2/+pLm3Ot1eeUxtz81VAyjZAjKHU6+X0m2gF4VBcJ8ixilgq+qHCW4BldFA2cpHVARCNsbE1My3+GpiSlXUrOLkB538s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733337867; c=relaxed/simple;
	bh=WTmBeUq16YBgfri+ot4OXLMdwYYtAuItjxDGV2q7/5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0QgwrI+yZmZ5lyER8WrQifSIzv6pvRwJn4Iy0DlD67bEqumkhVEPUH81RGKGmHG/lESg+hZP38o3DlJ8kkjzvd4xKxBVjR+D965FMop6zvDsC04qxDktO8Eb/sC/6d+4d83O7EpLzV5hJtEI8e0EiJ/BwwmeUhj+++YUAWcZ6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pYmmlUsr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pYmmlUsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F714C4CECD;
	Wed,  4 Dec 2024 18:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733337867;
	bh=WTmBeUq16YBgfri+ot4OXLMdwYYtAuItjxDGV2q7/5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pYmmlUsrgt4t2NJnJf48hAfgTwNLcFEqKSOz/MBX95hoU9qzOJiro0cTFvPVKxVaJ
	 W/C0gSnyQ7z38sx84INcDiRXhOnUXcy3sXlpEs81FV03Uro8mZqrb22RG4dPkP3Vb2
	 CM7zHDyO4i4lbfYN6ajCg+SMeqtf/Zhm7SXiCiGHy/C/RmfTCwhJdmKooOGmN5lI6O
	 i5z1z2Eh0vZn1zOyEO8n6GHgLpmcT0dDKgGFzeFps4T8Tcd1tHHkjfpmy7q9BAZeNT
	 WTadHnfj00gccAtxF1E3lqISMptsIX/BtyBLU6RHU/QGE2v01WyPNzXhC2YFI2o7OR
	 nO190G62b1VVg==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
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
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.12 000/826] 6.12.2-rc1 review
Date: Wed,  4 Dec 2024 19:44:06 +0100
Message-ID: <20241204184406.1609112-1-ojeda@kernel.org>
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 03 Dec 2024 15:35:27 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.2 release.
> There are 826 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 05 Dec 2024 14:45:11 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
