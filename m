Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061882;
	b=4oHXZ7YwHjGygtnQDwzgyVs6ruZNhA0Sc5xl0I2hO/aREBLFpmYKKZUJAmNBAt51kfc8
	 xr/0le7L9cyFgGWIKHohuEOqbuoOrCxIsDQ3JpidubMZTxawElRAUifDyfV0K0Vdci52i
	 ez0AXcCb4GW0zdH64wyFCr9h9XnAOc7W2YlNJ3iqEQyiFzDiQ82Tjo1Ln7uKDqBzkZGVT
	 NrcNL334yRpCHUhPthnspNJptzUQgKh/Qs9MtnkKB8eD8H1VO9PNfaWvpRTlDK0lORuo9
	 lxqJt6+K2NW66jq0wPIIm4yzyTpDiVS/OMzvDlqBx2G8hUhAtjsgptTO/uSVcwcjz8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061882;
	h=DMARC-Filter:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=H6ONeWXJtGH9qB5f7i4mCOx6oVERrf/iKyksBX6Ows0=;
	b=soO5VL56G4HpyjN5AaHbthR/tbzlY8v/wjDUO7O68lFhmqMuklSbgLKfg2OGqHHwqCWN
	 kGXaQR1ThTFXRs+i7SHQOWHeHREn7PKf8IllzNJ+DlKY6TqkivUHPX7STC4rLZ28l2QSK
	 4kXd5MMp1Y1aji5CUTRk/LVcsGhWiqNEyke83CPKWJ/u3SFwkeWY6OF8Z1FsG/oPZXAOs
	 lB7EUUOziF8WgWgLihvKq2tduhyG9SWyo2PGlfNE7KQrPQts/lX7xW7lzXq5i2fZN9lZt
	 nJ749WBPR3nL8z9zHZAusSUGZVAPtb9jS3yxPJxE3Zn2sOns9gLqaYfpWrqw00RCgYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD82606A32C;
	Sat,  7 Nov 2026 14:31:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BAD82606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
From: Brett A C Sheffield <bacs@librecast.net>
To: gregkh@linuxfoundation.org
Cc: stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.18 000/869] 6.18.63-rc1 review
Date: Sat,  7 Nov 2026 14:30:56 +0000
Message-ID: <20261107143103.29725-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

# Librecast Test Results

044/044 [ OK ] liblcrq
010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.18.63-rc1-gb7660db717ae #1 SMP PREEMPT_DYNAMIC Sat Nov  7 14:24:28 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
