Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A662817BEBF;
	Wed, 30 Apr 2025 15:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746028626; cv=none; b=cTgWHT4yVTwj5dyrISb1AIEnZ13eQe1eRiBZK9aIxusNqa4Z9EVJPKr8Tk+gmkA2/HlS8P55oMj1306I80JOaiowYirJXyfhgENM29W2ijGSkRjJR3H/VwiK11gk6wriA/0B8K/fT9vHso3/fcF4vqWiAd3cTUwjwKBCu6EoXQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746028626; c=relaxed/simple;
	bh=nwuRRm/BlBergWbJnJrnKzpyx5V3mqBF50iyYDWuI+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CW2Qi30tZYgwpCwQLZG/L8VmMMJUcvYN63lREWazerePV9btr801Jllq1Vu6QKSDugIBJaVxLr1zIEONA5cmdypZWDOMlqkFyx1yxopkcsNDAm9gS3UwXNXEnuDzXdlLXRm2AB6yEdoQX0QTvOsQJ1XRyP8jL6s62srL9j2gtyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LvkjyS3Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LvkjyS3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C84C4CEE7;
	Wed, 30 Apr 2025 15:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746028626;
	bh=nwuRRm/BlBergWbJnJrnKzpyx5V3mqBF50iyYDWuI+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LvkjyS3Z0lMmw63zosqxUpVNE1Bhy3ykHr8ArW+m5C5vQIO9/Zl8CUz10/y6X1IPK
	 mN3BmXRTI6SFysjGsOEe8uyxCrBECQBOowdvmrjlcXnsGcnEiEkWPIIniCSYvPdZNk
	 kdUVjIexvsCEUmdwD/U/CaQ/6swvIsNF+cYXuvpw/bEZ7HiKPN7UcRi4pZY3Lke/A8
	 DZsmgKVfNiquAZ3vld2ylLjqClnM75v1F24UuoZlNlJc3ywelKYG/Q8ZI9Vd8wK2Qa
	 7x/dbtApQHt0VRlV/fBVlZpTuRoBXuLwSRNsVjCap/xBWA1b0UUQQZgSEouJf5qcgf
	 Ly/f1YF89qvtQ==
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
Subject: Re: [PATCH 6.12 000/280] 6.12.26-rc1 review
Date: Wed, 30 Apr 2025 17:56:40 +0200
Message-ID: <20250430155640.797214-1-ojeda@kernel.org>
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 29 Apr 2025 18:39:01 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.26 release.
> There are 280 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
