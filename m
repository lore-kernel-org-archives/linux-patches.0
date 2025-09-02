Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737E828489B;
	Tue,  2 Sep 2025 16:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756830698; cv=none; b=Y2hFSkK9RysWvhHF9ty/f/SfPaE1jpb3/dmJaDmthUYGgj/trw6gVRcADuo9TqM/JtgA+OqIxv6PrJ5ExsZ2yoqS9Xcq/Uze/21LTXP61Kcuy2lfULUx+V5XRNFgx6C5rSoLLNqn29ss9PN4o9hgYT03gtkUsSb/hTYaZFPl+VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756830698; c=relaxed/simple;
	bh=ngO0VOuVumRwbYMeA2DDsWosRgUgavqSX3twmjAQ15w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4E6RamkNMGhj184nq9q20pJF5pksIrHSY4cn3qGurZKYkaJGy8miTsrSBH3i15FtP2EvihaZktgMCtJTSM3eljLTOFOXPM7HlMrT0jgfH/amWSuigT3qy6dy47F6a1IP/u/o10GiHasIZV1r8aOnsouw+EMASHi2mnCtUnTvoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.210.58
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
Subject: Re: 5.15.191-rc1 review
Date: Tue,  2 Sep 2025 16:31:10 +0000
Message-ID: <20250902163109.4503-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250902131927.045875971@linuxfoundation.org>
References: <20250902131927.045875971@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Broadcast regression confirmed fixed:
  https://lore.kernel.org/regressions/20250822165231.4353-4-bacs@librecast.net

# Librecast Test Results

010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 5.15.191-rc1-00034-g29918c0c5b35 #59 SMP Tue Sep 2 16:08:44 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
