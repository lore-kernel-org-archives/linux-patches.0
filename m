Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50AC1367;
	Wed, 28 May 2025 00:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748391554; cv=none; b=SvAKLT07iZJ+XaEZRNZOX/pG8qIzqHb/BMHngfYvlwH2xxZ+bvq4m3BnTps7G8O2SA2bfxwD118jXZx+kI/0JaXeH0M1vBLd6C3T4jDq3YjymRw5d1mhCXcoN25T/fwvrKjYmtpaXSI/I0iC+qiErKoAySAR7UdiVjJKMm9NesQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748391554; c=relaxed/simple;
	bh=mdAyTNaeZsyEJGrZSS0PuREE6FkDzCJ2uUkF+MgqWDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPk/EXJbVuvT4cJznvWhpikOVxGBD/9tT85CZkXgHgd/yvOqRjoiQ27WjaeEKsoJdxphqovVkmwKJ3mJMQxrHvwe4C9FXT0YFSlpyMRs9RrOquLrl/wsOMsq62fbiSOeve6MZo7dqdVBmLifXmJEWJnZ/wuVALQROtGaqCsHfmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gXQKTmIi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gXQKTmIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96726C4CEE9;
	Wed, 28 May 2025 00:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748391553;
	bh=mdAyTNaeZsyEJGrZSS0PuREE6FkDzCJ2uUkF+MgqWDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gXQKTmIizE3+EZCrGs/+Q7ij9uKQz6sHpzXxbHQt+8sn1kbKQEu0HInW9k4c/7glh
	 0bnDjXGs6FkWjcprgTFMMHZG+wrRBo0yZ9cFIQbqlKqHI3a2QMY5lc7p4/RIfw70YX
	 ScmMqkJ08fDvfDt7i8vbtn52M59J+cE4U4Q1OSSYnrGSZXCUpqHlVsbVxVMvJJwa/T
	 erXT1ruli2BDddlutUZSACuYLKj2SukcoFOfqkg6qqePutxy5ARAgYRoohhLP3m8+Z
	 urBiKu9N3H4ZXsxPyt6eoYv0XZXZSL2aRFpWtECQ6jFOsEDB52/DFYyvT4W4L6tx+w
	 Ds6EaTG0OAX7A==
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
Subject: Re: [PATCH 6.12 000/626] 6.12.31-rc1 review
Date: Wed, 28 May 2025 02:18:58 +0200
Message-ID: <20250528001858.4009079-1-ojeda@kernel.org>
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 27 May 2025 18:18:13 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.31 release.
> There are 626 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 May 2025 16:22:51 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
