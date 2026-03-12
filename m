Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10AE1F03D7;
	Thu, 12 Mar 2026 20:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773348104; cv=none; b=lxyp/TUi7ZJoVkAUVfHS9NQGmh9ZQBydr6+W+MoAFQH9ai4gu19R7TNmudtAJ0KMMaaQlkirDIa/rVQrj3Bf4svpqENz3yXOVIhEklYpTzT5+nnQpkQVpHn12lekHZlSrWCQj5O5eKV1eiyLQEnWSx84ep58VI1SQUO0im/WWR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773348104; c=relaxed/simple;
	bh=cik9Mzs4jXYWPScQS/eA+kHakdxcMmj7/XzWZ69GXCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIV+75dMFjM9Ch4Y9UYBKZtD+zJVqXUMtBfhGM49mTwdu2oXdXSTkcqirk2k4ipFu3gGhBP5wxUiEtN4vCMr0GJ5uBwEkjSsXhiCXVfeHkirmIyd+TdZ6aChMVNQjIP1vJk/4z4WgS7CjQFnQf0a90BTbnQyBui/P/w1ZOECL6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.211.58
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
Subject: Re: [PATCH 6.12 000/265] 6.12.77-rc1 review
Date: Thu, 12 Mar 2026 20:41:20 +0000
Message-ID: <20260312204124.2193-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

020/020 [ OK ] liblcrq
010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.12.77-rc1-g92f326b98fe0 #1 SMP PREEMPT_DYNAMIC Thu Mar 12 20:36:04 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
