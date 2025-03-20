Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D8D33E1;
	Thu, 20 Mar 2025 11:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742469166; cv=none; b=QcjaEcre8aN7mZ+u8yInQvxXb+4raqFQOCLpNQlhnbgAIMZ/KNh8wqLg7fisUdfBKs8osuvDqZ4z7brjpTDBci8aTdqrHSsAAPT1cWSre7rvZQSOwUuUMCWDMQxjjXq6+0ihOp0xBKyNgIlLienFcUFNqEHmkiciVT9QvGT5HGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742469166; c=relaxed/simple;
	bh=vZtsh65CCyjK3jzsVifeNULZc4u5egeLkxrR0IWBZH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csBOTapaOqd7b9b2yj/T6BF02zE9fK6fIw0mwVbAR7OZdNtP6NdUVjQF94ej0VQ/42z+gpk2o8NvWfAYKghzxNT4QYhQEj2KnsTKeALS5ZzJynQXEgLbhRWeT//kACapDLOA/STROm6sXgHBrk5vDwkLpqCPnyI4acM8lIN0AYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/kJytQO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/kJytQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC951C4CEDD;
	Thu, 20 Mar 2025 11:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742469166;
	bh=vZtsh65CCyjK3jzsVifeNULZc4u5egeLkxrR0IWBZH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/kJytQOlh18NbUzxt2kkdUN6Y56lpYlAgr6/ubSMq11QDyHWF2a3n3srbC2L7DWT
	 3q8lTYEMpNwH8sJ94+5yAqFfP78ZqFxCpCEqudYRzwGT3Jn2TSxIo2w86zr/DVfaeG
	 lGXHTcJEay28lbfNNgkn1uorOEXhEoy5Grn9nb8CSDBya+XiL3MNamcG+ztoAEH/KN
	 PD5kje8sL3+lRCfYT2S2xNURHFm3SV/bMcy8oHbwd8FnS9+R+XfJGa29lj8nMHKDFQ
	 R7cH1oJz06y6nhyqq11nzjX3gdKrCRN49jDWFws5EIK1i094zbPLzsiduZ6diNvLi6
	 ON0jgN8gPCF9Q==
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
Subject: Re: [PATCH 6.12 000/231] 6.12.20-rc1 review
Date: Thu, 20 Mar 2025 12:12:34 +0100
Message-ID: <20250320111235.222854-1-ojeda@kernel.org>
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 19 Mar 2025 07:28:13 -0700 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.20 release.
> There are 231 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Mar 2025 14:29:55 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
