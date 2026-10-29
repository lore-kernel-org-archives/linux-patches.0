Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793279552;
	b=zq1XCgRwql/leKtgQUO/4AH1UxmdIJQFiIffh0hTIjoKHCoT9NYlK5Bvustdcj7abOcQ
	 P+fPZOgfAwLNqlbuxg1DXJI/VWD+S/JiaCmSaKA2F4P9wJ3U8mDyAHWd1xdXEa4BTmZZ8
	 4yMBIRVTmNrXP2akfqjapL63rtoQ91OAoQQHjB7Lz9xFkUBpI/JxKEmoIDLD2HI+5fg9K
	 CUTFKvcwB8QyBJglFsNDnCidL1Bhx6nLGDWcBF7zjbgBPF9YhdM3+W8fXpTAxKgjYfFuV
	 CfHeFh7b7sh5Ye+ySq3oOWx9dJOHuG42T85DrpWK3wlRK7XbLb/AKsMDjHrqdQb+xYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793279552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ay7VjN3G3LpX07Fwg3zrb64XCcq8+MP2MyYddEYvaqI=;
	b=KceoOCz/3i7UhJbdikUelIXNtsykTkIXeEfIo2crxFBQ2XhMwUq3ts+TkZXmAHDkquD2
	 D1gHgIc45575kwOQ5+FjLzjleWJEAp1elBfgEGMtGTZNlqvo2HTTBt4f4K7b50bcMZ7GO
	 mkbjvjfv512g4Re7/X08hPcM9xPoquuQozQk61EIIz3gY9QuJL1RFclAxH7jweLa3XMcK
	 X6dUrFYixj3doa8QhlzcGKkoYLPw0CKrUJECWeYxv5LeICTpj3M7gNkwJ87nEw41cFeDp
	 bZ2YUTZmieS3Dkym+VSVjysVUnSH/k0Icsud6FzemYF1gElPjzk+Lge9VTx7+mpHS5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MhadseVw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901D5606A31A;
	Thu, 29 Oct 2026 13:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MhadseVw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D711F031E5;
	Thu, 29 Oct 2026 13:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793279552;
	bh=ay7VjN3G3LpX07Fwg3zrb64XCcq8+MP2MyYddEYvaqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MhadseVwcm+c7YkY/4rfvugeE7IeCEE3gpOEmOtIzXezT6WwZU64e2jH/LVpm/r3t
	 1z7GNMEYPo0g2oeCmYdiX8QIpnB9CJsRNPyVlJk3DsEretpG8vq3Jj0c0TNRTTBkJS
	 hjkIQDXWfB16nLgmLeBrsqL5Ha/VOiTPFUwJs1SBSxGQeVmZDJR8lCtGSU7x6S56Kb
	 vWmxN6h0fzCpRLh6jUfSxcZ4Xm4FJrhPgYAWThcJITRizpT+Eo641apdqUsxyvaZ65
	 KdslpDAlJ3QLt1Y46UGiW0uwCZnIt+9+0pr1l4chP9Rvm85V0x6UBi/p+K4uuwLJ7A
	 mN/vhKDf1jxlg==
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
Subject: Re: [PATCH 6.6 000/168] 6.6.161-rc1 review
Date: Thu, 29 Oct 2026 14:12:22 +0100
Message-ID: <20261029131222.23664-1-ojeda@kernel.org>
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 28 Oct 2026 17:58:56 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.161 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
