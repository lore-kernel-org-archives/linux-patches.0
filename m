Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851EA1F03CF;
	Wed,  4 Dec 2024 18:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733338312; cv=none; b=qSPtcDjNWFEs1xjjJslnohcl1RQk5kHDth5kC4rEMhhxDjaUzl+vkKChxF6ljZHWqpMQ5a5jtKrcGxKfeT7JkudI9Y60l+/gEIA/xODmtO1+e/lxlaGgTBlfWQ+xV5ObuXbg0LDGMvEy3Ms/VEyMXJ00SLhTOE+xnqDJVd9DdaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733338312; c=relaxed/simple;
	bh=si4F9IImxaNJXpTOVCiXoQ2/EXX9kI29cmbk2KF/aVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BV+Dg6FGh3qAnSYpgiwubaarSfxzbBUPro+/hPS8HfXH8dPQFjb1dhPOWibjEe08OITPI055tnJsn3xxHgI6kb3NfCNo+rplc1gfAVO1B8K+w2iGwS1ikv8dUY4Ud1TXsFLOOpF3e7naUlfImVsT+hya6ND3/g5DlNdmc199GHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HNNjWnaF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HNNjWnaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3963C4CECD;
	Wed,  4 Dec 2024 18:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733338311;
	bh=si4F9IImxaNJXpTOVCiXoQ2/EXX9kI29cmbk2KF/aVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HNNjWnaFsh5Tku0puSo+cL/tWENHnPOzlvqtdMyVgFmTMmj1MyIP+g3Q6iMNtH4m0
	 Eyoc3cdULXicUvxKS7UD2PcxPiFWVLXVMp99mDgYnRI9YfZz0Rr73milJXdzHM2bYN
	 njgsq9NKR2/Hx+65YQrdmGcGDkCka4njuNXs2OWs5mh3jfRMTQennUg2B5OuJiaNk5
	 5m/VwptS0l2x7EbzrL31GsJFZaN3q8rZSF4NfTuVi0xvnXUf5SZ5t8+R0fk8HlKcL0
	 ta7XZ6Ki5wjfYFkcFIjj1VrARD7iAZZkVY0oq6mR83eRUXe+b9sLqNF12ObxQrbnhZ
	 98EcgBl9a81hw==
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
Subject: Re: [PATCH 6.11 000/817] 6.11.11-rc1 review
Date: Wed,  4 Dec 2024 19:51:36 +0100
Message-ID: <20241204185136.1609963-1-ojeda@kernel.org>
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 03 Dec 2024 15:32:52 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> -----------
> Note, this is will probably be the last 6.11.y kernel to be released.
> Please move to the 6.12.y branch at this time.
> -----------
>
> This is the start of the stable review cycle for the 6.11.11 release.
> There are 817 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 05 Dec 2024 14:36:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.11-rc1.gz
> or in the git tree and branch at:
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
