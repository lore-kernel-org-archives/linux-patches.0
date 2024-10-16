Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F712076B9;
	Wed, 16 Oct 2024 12:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729083120; cv=none; b=bytYAQOWED1fJOiwQsw5mef6asl+qSTleY4DdFD4oCamsKSMCx6KwKGOFyOwUfx772gg0gufum6YwaKe19g8y7gyQTuylmDTgFsGKXwvLMmGo/vpAsyrd1r5sqfWlcB76vevjfX+epzJVcm2W+x9UufZe+xVciywdMqsat//TsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729083120; c=relaxed/simple;
	bh=qnEpZkO9RPabM86/NHLaprvuqszunNfSE2uk2xNi9QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQTFc4TGY99PJOjitcJuB8slqXH0ofje/LBqc490HDImCj46OXQutOv9u2wF6ggYoe7P8AvCzmFSAtSoJ/JM+L04rb+Hbqy49IWgqBhcII7pxZ1nj0Qnft9lAl2XTakYdTcub4kxkQRT67ECtUTWsapoGJFCH4fxD6UCQHWKPP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yg8TLW+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yg8TLW+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E82CC4CEC5;
	Wed, 16 Oct 2024 12:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729083119;
	bh=qnEpZkO9RPabM86/NHLaprvuqszunNfSE2uk2xNi9QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yg8TLW+VDns4KWXOZhyAD+4rsBw9FtOFIJzPeq5bnvl3XJ+2zOylxKk926+o1eXch
	 DzkKx4wkm4irqZUcBbZqVaWFMRWECL3XDnr+W/VG+w6CoCXITVOD0wIWcvSDH4fMz7
	 +QRNscmVsiw8n6Qx2ejWhJqi1mUN7q2swXEer0s7CYAruo0UPVrz7yHPr5Ei66dC5y
	 y1/S/nd9LeBLzDnGpC02fjzka1Ar/wE4csH+jm0wPfWWbqlyx2pl4zinfyz2jkdPTu
	 5jjs37g3WdFeTSR5Lr2ygShkxmQHKQLEvsLmXBDul0aMg9JInU8bZjreo/fNzVesFl
	 aUAqSc3CZ1qbw==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	allen.lkml@gmail.com,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
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
Subject: Re: [PATCH 6.1 000/791] 6.1.113-rc2 review
Date: Wed, 16 Oct 2024 14:51:44 +0200
Message-ID: <20241016125144.139393-1-ojeda@kernel.org>
In-Reply-To: <20241015112501.498328041@linuxfoundation.org>
References: <20241015112501.498328041@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 15 Oct 2024 13:26:04 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.113 release.
> There are 791 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Oct 2024 11:22:41 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
