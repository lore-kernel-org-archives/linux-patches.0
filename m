Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1DC29C321;
	Mon,  9 Feb 2026 18:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770660991; cv=none; b=RDlCqh3YFfUl4daN7NR7enjYKANcbPoym7yQr202TT0bdOIhdZJRXSUS1AUdNpwRrhNiLeH4aZI/9AUHF+Y+bA2GFoQm0ZDe8qTfYRT99EizXhbzxGzHWLosdmMXSNnIr09ie7Mvgfh/3ts/9R6gHZfvfXatH2zkHOh2d67MOFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770660991; c=relaxed/simple;
	bh=FvnaKeYrLJC6/KuIXh3ydF11hWT38YzGF7m3wPEMIpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gk5rJ2UH9ILbbai7SK22wOMqupdqXkIqgGwOi5GaRg92QqKjFSXZw8Opl6cTb/KJLu61NCyrEn2x8uhj4EFCWv2oFKiH3MHQ4XL8NwfFqlea22zdBRpGaP7mTJ5LWKq+ISDRDY+oIfTzfhVTHVXh3GtXYJOB5vavOw/6R+qzcYo=
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
Subject: Re: [PATCH 6.12 000/113] 6.12.70-rc1 review
Date: Mon,  9 Feb 2026 18:16:16 +0000
Message-ID: <20260209181624.5706-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.70-rc1-g59b78c63efbf #1 SMP PREEMPT_DYNAMIC Mon Feb  9 17:54:35 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
