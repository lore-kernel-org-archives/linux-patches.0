Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774872D7806;
	Wed, 20 Aug 2025 09:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755682111; cv=none; b=PoO4BSBDBBs9+W/u97UHXYpL4euHdAWwIX2cbpPn1oCvfGoFPdnxn+LqEsj6CeuGuP/Ku4i4uh7Ul6MGDWR8S0j51CcaCwfxrmYE90UTAfBwDOR2lPtFrCrNtEegGC39ZJHfBy35qdRlYsU9KaduAzF8HfjUObbvIWrJZTEH8M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755682111; c=relaxed/simple;
	bh=5oiKYKyMGmuO45v0KZ7wc2aHbTc1dkxx8uJAwGxgck4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=loFzAOt1lH2ax2qPkD/Wz3nErnFdobzC4JSsSgIZcgEpd5nQ8w6hmDklyYb/MUFWduDYp07ewP6AtNdtqr0rmjucdw1KZ40Mr/Wj9EmmA18GN4H/ypzgSXXYP/tZMVjiazprxPBJEpwjDTwFm50BlLjBFvEXZbW7DPqu9ssyUdY=
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
	pavel@denx.de,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: 6.16.2-rc2 review
Date: Wed, 20 Aug 2025 09:28:02 +0000
Message-ID: <20250820092801.29917-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250819122844.483737955@linuxfoundation.org>
References: <20250819122844.483737955@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.16.2-rc2-gb81166f7d590 #46 SMP PREEMPT_DYNAMIC Wed Aug 20 09:23:02 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
