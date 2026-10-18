Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458A738E12B;
	Sun, 18 Oct 2026 09:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792317136; cv=none; b=IPzO/x83/mA1ta6/ZrPkPdccsXu73z5ed0lDtocsENoBxpQWFg9ntLQ+GfwB66m3Ch7Slj1m/qbVr/EDaNYWq48rUf3cwgiS/n7e73csPq1GAewqXHS7KZ04kUr6AKl5waPyQKQCmL1IQZ90p6q5XtQCzqIVFYIh/eQno2Yj6hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792317136; c=relaxed/simple;
	bh=d+sXICrjzf673PudZOy5bX7Eje0sY7xoCtjgXYy2vdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUB33EnLt34N4DCBbrwxF7rzOVURV7WiX37I2SCrlP+ETywOpJ3IYEGdNchNw8iLD68NjolVFAVnTdatFHPlOa8ZELVf2m4MldVt6RiHYtXZweVYm7BQcqKVTWA4VtBOLiNj0byzeLiJn+aYau3YZoiAMjSMHSmNGT6YiIAK7EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UTlnjFcL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UTlnjFcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8F31F000C4;
	Sun, 18 Oct 2026 09:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792317134;
	bh=fSd6z9Y4HxuJ2jMV/MAGvC3gpgqN8DdHTKmeJxXxM08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UTlnjFcLiAJ6iUzqlQ89lEv/MuPGrWecJcIVzQCRCbGYaCjDn2ZzS4lXYdMREcUf8
	 3CRzjBVoc5qy2Lc8rno9k1lr/RN7Bu4nAgEUrvii+jM1vQ+Slm/eiSX1gzmDqrEy/T
	 k3S3Ig3UstQuYIWCTB4NIbh9Xhfj3tNxBokaQWa7SbMb6s85YTmWC7Rpop9KIF9NIA
	 6JL2c9+pUj/JnucJXx3al7eOxGbEzAvwEptCT24GiMg7DWcCwvS26Dyi3xun1ldGZt
	 B2h3+yGJ1C4/DjEO6gZdCVM5dTNQbHGbq7tdzu4MPED9+EPOjVKdEz/pf6XVcEQ1wC
	 x/UBqoBLuSEqg==
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
Subject: Re: [PATCH 6.12 000/869] 6.12.114-rc1 review
Date: Sun, 18 Oct 2026 11:52:03 +0200
Message-ID: <20261018095203.48343-1-ojeda@kernel.org>
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 17 Oct 2026 17:47:21 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.114 release.
> There are 869 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 19 Oct 2026 15:59:15 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
