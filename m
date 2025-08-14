Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6361A1C8604;
	Thu, 14 Aug 2025 14:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755182287; cv=none; b=AnnpLU36VbXZBv4XXo50RHEt8UDureVftodMM7ddgfxz1YPUkE4UQle4SYsaKq62AmIcj85JduWZS/4zaz7ROsMiQkRtnKtS7Ob3FVg5JbuJJq1bI+QF8FlWZsLYOEdBFdur9rJxYm9QvHny9WuflTcoXfSQbwKj2P6/5rY1h9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755182287; c=relaxed/simple;
	bh=i1ya4O+2sgXRQ0m2vn05huEoTs/xcbYP6DzOFb5bANw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7R21cvriqs7ZRuebtlfZXwe8yPdZPXRuv2HTX0eD+Zpw4LOywfxqEkPm8b7uwDWAsu3efmGOamr659ipZUUS8LnEC6goLA71KEfwf4eddGObOpgE3y0ZP4Aax7teCezzoiURGwghW2pJ3neev61OktbNay390iHH44k8r0Gic8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b24WctMM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b24WctMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B47AC4CEED;
	Thu, 14 Aug 2025 14:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755182286;
	bh=i1ya4O+2sgXRQ0m2vn05huEoTs/xcbYP6DzOFb5bANw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b24WctMMtww4etyiwdlBi6HiUrE7kblwcncUDrp+e1cdswaaw8rJQoA7NvMM6lf19
	 KKSQlb+JmPUnSAXffGLbBXu70yoyt5OPKzIAxNAStZWYsTchR6R8OJfqxLUoPZ5Vk+
	 zMOYVry1hUCrLveh+Z+XRU3YdQtFa5kmFAb5vb6m0yDBAZMnpVlBydRORl+eAet4l8
	 y3Zvjj02eQizg9ZNJTQIDvhccm31lDsBNefG2SqPCS/9BNZr3ogMjMl5wORglSxHye
	 zWVGjMIzmS1uHmYCyWVsv0l5rVAEk0F9BybpRBkb4dsYkfj6WiL9Q0AYn0T+HsdQpg
	 R4oEC3JQobgKw==
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
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.1 000/253] 6.1.148-rc1 review
Date: Thu, 14 Aug 2025 16:37:44 +0200
Message-ID: <20250814143744.2340961-1-ojeda@kernel.org>
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 12 Aug 2025 19:26:28 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.148 release.
> There are 253 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Aug 2025 17:27:05 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
