Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F264322538F;
	Sat, 25 Apr 2026 11:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777118003; cv=none; b=SNby96Aqtb7pYVVbMowCSXMtbuDET4c3srhPIHw0+xhx7xH70efsXKBwr3ZgJOM2mnL2inxmi6aUNfdwI7CIlEa6RjTJGdjW1Nc+V38ubtwaq37XwDROXVEULp1R4aUggyG8dUiLjn5YEYTP419ZuF5gZMlTXovq3QcdvQUuBzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777118003; c=relaxed/simple;
	bh=EHaXLa+Vc/JZyKQHoW0ByJ48LblMeyMfVoaUz4hGIj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvQYi5dKitotCAioUZGrS0TAUzHFAP9lBr5reYJ0faqLa2EMaltQ3zyxr+11h9sIqsh9UgDAb5H1EUjE8KDH6tO5kcRj5fv+pDIFsW/DkmDeuXGkx+ZXXdFl6zReNaOTeE/5w2+P6L1Sh6gQGhRdHgBXusS89tQ4EtmOlBQwDhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bDfF7AVL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bDfF7AVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0558C2BCB0;
	Sat, 25 Apr 2026 11:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777118002;
	bh=EHaXLa+Vc/JZyKQHoW0ByJ48LblMeyMfVoaUz4hGIj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDfF7AVLZKKWoF+1l8v/U4ZFXMQrx6BVKWw4SSl0WIgfuUu0ARcbf4Kr+Hy55Zz2Z
	 lHyDHE5t94eM0TZW7/i8IbY9Ua0XvtlJj6Ic1DblhfuC6mYs4MEjrFIzYZMaUoYdBg
	 bU6JkLvIS2d29XmTwdADXWwJGK5DovZfN3thZQMye29F+WpT1qle4Zmi6CMqPls4zp
	 vzE7XlceCqnTHdSXae6j68pOVyd0R06KmIxahedXYrcvkd2K2TYnv/TjZYjMrzY+fu
	 IUyKhy854qmcUIgp+lZhtzftaDlFzz6zw3YnLucPNFyLbaPvv01afVH+yOFrRsoXG0
	 0zYRjcsAMJmnA==
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
Subject: Re: [PATCH 6.6 000/166] 6.6.136-rc1 review
Date: Sat, 25 Apr 2026 13:53:12 +0200
Message-ID: <20260425115313.158665-1-ojeda@kernel.org>
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 24 Apr 2026 15:28:34 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.136 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Apr 2026 13:23:21 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
