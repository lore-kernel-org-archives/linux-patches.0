Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0462176034;
	Sat,  7 Dec 2024 22:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733610741; cv=none; b=cSztFmpD9UX+74xmRMpDZ7cGeGSFsUPCIPq2yhjcJM0Eyycm+LoL4ascDgAb/1KtczmSOuNlTADchM35GflVAVbZ/coWYPbGglSyHYCPYgMUagviGu22qvjVws7pTTZxcBR64HwZz0QWqWBjQAp7GoHs3W9XRN5wf0FdHwRJDFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733610741; c=relaxed/simple;
	bh=67UfToV1KQAAfZ8FCPvuuZrBIYwOGSghN5o4jEZ0pd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WBkCBJ43GI15dxxupISkmIVAwcxbAalEt6vzgRRcxoi3f72PMrgu+DHCjCe7wIyF4u3M5ppesln8CtXqdWGQDu/KH1djTP4Y1FZVi1pODEwjihdW3UiZAMDImdAb8SFvMm+GaCu1cqWuJah0O7dfhAi7fYqV50SOCID3RVftJ18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tVZSvV7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tVZSvV7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45C3C4CECD;
	Sat,  7 Dec 2024 22:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733610739;
	bh=67UfToV1KQAAfZ8FCPvuuZrBIYwOGSghN5o4jEZ0pd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tVZSvV7ywJ9OVFJ/JA+eM8klV/ociRftedkUU0jExtW8TpyNmLB0WECjjct5Nb0em
	 ZMxwnuoG4sz6RvuzkpGn9fqZ7jHlQmdbKRNQK9sDQjUF0dy7V9xt6XusCk/i8W0wvK
	 LccbwVgCPx2oCgeiv19aZXW/dvg/8vGFa8YVIquqCL+neH9GsJ/Z1Y62jpToVlEqhm
	 4Hdl+OpY27/5kfZVl+LDLGmwGcGO3rcHOUZb7lEihS/mGixH/0MfotvhrDVwEayrAI
	 Ygek2ulr5TvYt2pPsYINsl70uvy90nMBwq7Y744wYMpKXyMy2y6qqlwugXCRAwK5L2
	 NNv7GrpxUN+kQ==
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
Subject: Re: [PATCH 6.6 000/676] 6.6.64-rc1 review
Date: Sat,  7 Dec 2024 23:32:03 +0100
Message-ID: <20241207223203.1835415-1-ojeda@kernel.org>
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 06 Dec 2024 15:26:59 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.64 release.
> There are 676 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 08 Dec 2024 14:34:52 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
