Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C2C22A4E3;
	Thu,  8 May 2025 13:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746710058; cv=none; b=iATio/0PUb57mXGKXr0nReWRxVmQ4STxQn1ktTe0lNM24wdg1nG0/VHUPmd2mPsiFWOTOlcF7z1naJS6RJMiQVXb46Z5eHrCwjct4EgzAebI3R/Y/liSVU6G9et4ZYgOSsNahRqO/iQLL6aQMzzeHo/MZCAdXsI42x37Zv7FiTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746710058; c=relaxed/simple;
	bh=C50vYTMMMLJegSnhiKqc3VZzFMbE07J+cq/qRHMRREs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2aPf62mvoupDMcTli+lKCiz1jzUmbxndyH3d3rLSe02ZWL7MnfMcPk+nW1OXQe020As8PTWAY7v9zjO04qg2qzM7IY2bEWuwnHPoSnMQsG9QPraYQ1NkDo9qBbYDD71yXjTj92/izxyhK1vITt9Auqp2TFGOWXS7JCJoQe7xSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dwji80nG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dwji80nG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD8CC4CEED;
	Thu,  8 May 2025 13:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746710058;
	bh=C50vYTMMMLJegSnhiKqc3VZzFMbE07J+cq/qRHMRREs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dwji80nGV9fIyRuxKaYf+HghXFXqx1+2kVS8apGQ/dOFuqoYL1sQZL/SOpn7wVeud
	 PyORB8EDEusdC1FTd3M9s6Sy1GEcTgfff09JLyLEYYusqDREgxQ4rz4CdiTSLbm1g/
	 iM1oObH3HydpD/iPKdPZtFAaMT/HHHhIj08ISV1MGKPayMMP93xolbOoVs/8y5NH8Y
	 z+lYv+ZfCJHvmD1V2veU/99k5Hk2qp5g8TPZnEHr8UgOjxf1xPLFBlR0ZCXTq/jH0l
	 BzXSg2p7pUyL0sPfG9+wDWUBow1Oc47lWXKFsGRwI5TbhFyZxSfkOFub8Lth1sycon
	 Itj1nJDZuQKEQ==
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
Subject: Re: [PATCH 6.6 000/129] 6.6.90-rc1 review
Date: Thu,  8 May 2025 15:14:08 +0200
Message-ID: <20250508131408.623011-1-ojeda@kernel.org>
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 07 May 2025 20:38:56 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.90 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
