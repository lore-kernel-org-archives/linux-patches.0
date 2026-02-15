Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5902C749C;
	Sun, 15 Feb 2026 00:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771114016; cv=none; b=qD8lBXV+PLI7KPdUYaOvpXZ2VPRctRDScksI2hUjAaLK/rSwmnsVcHAWmdQVQZ9AMHxaQrxAPihQB70ea4E05SCoTg+fKi1dUVeriqF093PH2nbZJhNrmpw5MoLCmjBVW3uTVtOkVIiqaMqgbHWf2pvf6V2A3Kn82dYyYVK0Lbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771114016; c=relaxed/simple;
	bh=qVMj8dZj1vUKBNxrA4XVnOsAMvpQM7Ee1Pijxkh8kkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uU8L6ny7jUEhdfHYxVIJQTkvSnTvXznBZGTx/EyLtMWSckZjtXHwsqUn+QQwGo5GqCqCeIdqS61ONYuUjhxDk2ZjWFlqVGjBiyDnpKrgwWSuykIJUJQrfDJouRn4aafSYOrllj9E6DKZsRO35/3DAwM0bsPLzPI5ojRC4HAzibs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FkKAOhh6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FkKAOhh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254E4C19423;
	Sun, 15 Feb 2026 00:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771114015;
	bh=qVMj8dZj1vUKBNxrA4XVnOsAMvpQM7Ee1Pijxkh8kkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FkKAOhh6JRKtKMLu/ZvGM1ZLKAReQpyAskbx0HzmZ2RJ91mjo8jD0gH4arOG6OQ7Y
	 o8Msa34jmQx4r9fmTxZNryQrQ1LfD/0Yjd+vQvJq6HI1lO4qbddan/W3kihISjRWKT
	 mcAR7VQIWEqYYXjZ7Zm4m3+1eJ6N+EA0sqvXz+gOnK9Oj+f9hz+spl2hC8QA9n5CRh
	 XAZ0upkKkaU13qS3DbRBWMknIgzhOqTsMV1VqdFCkOQQvDTvhZBG0ipht3KURPTZTy
	 k149V65C3S644aI6zzx+5KMuGxZfT95ZGFjlyIkrN9wJilOyPbJxzTqsma1RYQk5eF
	 oZPJPHlJEhqbg==
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
Subject: Re: [PATCH 6.12 00/24] 6.12.72-rc1 review
Date: Sun, 15 Feb 2026 01:06:45 +0100
Message-ID: <20260215000645.42746-1-ojeda@kernel.org>
In-Reply-To: <20260213134704.728003077@linuxfoundation.org>
References: <20260213134704.728003077@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 13 Feb 2026 14:48:19 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.72 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
