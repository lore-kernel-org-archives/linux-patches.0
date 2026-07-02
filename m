Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13BF35E952;
	Thu,  2 Jul 2026 19:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783021612; cv=none; b=csn3vR5a3+o/pPyicRWiexKKvNU2fs9mBE4eG18tVymqWReuPZ2qMlFU7sgN2gPJLs8eNaZzNh28py/Inw2lVTsJjPIdlIjgVIuqrae5MAnRlBkQWvmxLnXRs6jHxPneTtywB4AF4VVm6IrVfpW47Q/SH+i+klhSnBO+Q+2zUvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783021612; c=relaxed/simple;
	bh=DKHaEpHoSsFWPjof5OGtNQqotlcOK7V5FIQUgXoXzYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxNEQI5FqzN9sMd4RnSMDDfaPVZ29j3KGT/FbR40CvQTFeeLTaMRplP8jjJJb3N3P3DcLL1cVm2U5jiUrjnZlrYVXxP3T91C8yQT8/mf30eQcIqO4+XM9ByOsae9irEkJ0QP9/p7LIzKrzfnaYJc9KPr2KkbOziMUpM3b4kMC0Q=
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
Subject: Re: [PATCH 6.18 000/108] 6.18.38-rc1 review
Date: Thu,  2 Jul 2026 19:46:43 +0000
Message-ID: <20260702194646.34856-1-bacs@librecast.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.38-rc1-gd87316a03ed3 #1 SMP PREEMPT_DYNAMIC Thu Jul  2 19:32:45 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
