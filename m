Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED793803DE;
	Mon, 31 Aug 2026 19:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788203558; cv=none; b=HJNPPJpVJNxwqG0MT9D0tqqpGKhxV43Qw7suK/ihkNTXO20u4K4LzuLPR4Fqj11s4vh/VFp1YIlNbJMrF+zGrmHv3g6Roo1qjxJCQVFSu16XPTVHK45LFqkpYEcKy39VzSQ98Oy65Hka/3+qCzBdEiIue8RDN7c69MzW6j7mCJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788203558; c=relaxed/simple;
	bh=J3D5kcyAA/LgC3Mob7/LQaO+U+3mSTPRgNwitc7otMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WC8G4Y05tbg7GN/Qr+cdrHxV0nxSSWvqU4W4l7EvcRA1mPlyK5tMp5orrA9xu0MoGrq3thtuew5FHeTWi8S/Ux4pGVMVbU1C3Y1fUDQZWVyQyJFLpC77lp1BZqzsdbP4qcFOhfRrCWtJrHtV4kDJgueXh4RxGfR7oQuPV6elAtU=
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
Subject: Re: [PATCH 7.1 00/76] 7.1.13-rc1 review
Date: Mon, 31 Aug 2026 19:12:28 +0000
Message-ID: <20260831191231.28197-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

CPU/kernel: Linux auntie 7.1.13-rc1-g05917bbd09b8 #1 SMP PREEMPT_DYNAMIC Mon Aug 31 18:42:42 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
