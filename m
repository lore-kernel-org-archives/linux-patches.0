Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6273161A0;
	Fri,  5 Dec 2025 09:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764926414; cv=none; b=tYdf4iJERMl2wXNFS8CaTvoZ/i0KwspxgHM29DGHI7l/w3WU8K54qbQPWjoezQqxed228YDgZeu6c8GG7tMSu/72JOsXlx3jQjHPaStUdFWTo4M3y9JodyotYBEa9In6ibY3nHZ7hpsoQr2c5PFgqTLHaDe1x7BUjGzi3AeDBlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764926414; c=relaxed/simple;
	bh=qOb+qeMXApSrJAwWeF6VXNnaV9nud6+WD9xI4yOIWyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzlrbPbH5K+R9ypupHs0cTm6q1jLo4kca7L0FQG2t3u5ph0aDOhho+ldMuFC7bkdLA9uyUWb5iF3KqH0T+rllCjdz56DLqCoL9IOcY+XvYOzrmQoT+LL6xaH2UAwzFs0/a3zzxhGnHVhEty17zdVRtF/TyOzXZg3JjLjmThrcbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OHo9cB9A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OHo9cB9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D14FC4CEF1;
	Fri,  5 Dec 2025 09:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764926410;
	bh=qOb+qeMXApSrJAwWeF6VXNnaV9nud6+WD9xI4yOIWyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OHo9cB9ATem3hkYHC1vv/g2/KfAD4Z3iIXDyXohvM/53BL52WCaMKBJg8wv0OL8TV
	 joXwSRVBycsSRI1WmARWlALkSQfRVf9x3qJUFCfimpyvdUIMATc/bCWt+iLCNVfFTh
	 GgVKbTaMUHdK3te4fvbck3RCGwCxc4D0z+VgwEF3jyMGENueH8ec8l9A6ZJTy/BhSf
	 o3pSsTGN7F+PlQ/73AB+UEF5li6bJLkB74E/cjDWg9P7V842M4Tby3Ddcv8AJxOTev
	 xp6XIDXPtrP9wyTz0mpzE7v55Yp2TexShLDYezFRvK6DeRwopd1dm6mLOGlCu06atT
	 TGS/QiEhROleQ==
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
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.12 000/132] 6.12.61-rc1 review
Date: Fri,  5 Dec 2025 10:20:00 +0100
Message-ID: <20251205092000.2162479-1-ojeda@kernel.org>
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 03 Dec 2025 16:27:59 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.61 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
