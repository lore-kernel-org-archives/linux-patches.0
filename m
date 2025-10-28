Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A1223ABBD;
	Tue, 28 Oct 2025 13:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761659757; cv=none; b=HFG+MKFXZE8Plvzuh2ZolWAw9F8FkU0IexegIGsLge5s/6nVXyUnS/6Bzk/6M5EA7CUv/nzJNkxPWEMgfyZZ6uAUjQaHpbdvaiJKvxxr+KXW1RhE9DaArm9W9pAnb7LnuNFjYeb9PS5OEZa1VaG7mSGcwqqqOy1TBt5RpobYxLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761659757; c=relaxed/simple;
	bh=AxyH8oYK/wEcSp8t+gK6JNzkX00Zlhn317GxpCK0VsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yu65ONHI8S3akMmqzI0CfaRocGoH7R6i3saKsT5sPrhT+/ysICVNQZV362DmwDSPgcqfgygexQs5/Widlhdh5pdT4QAk5jXsWJtpZxYlZb3C5Z5TqUBTZpAFoF7FwY5e7Q4pr0/aHyMcZuCvgatsGHH1nFX05vc+ivuETrBrmBI=
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
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 5.4 000/224] 5.4.301-rc1 review
Date: Tue, 28 Oct 2025 13:55:47 +0000
Message-ID: <20251028135549.4044-1-bacs@librecast.net>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

Build and boots without error. No network tests run.

020/020 [ OK ] liblcrq
010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 5.4.301-rc1-00225-g4e89a6191515 #124 SMP Tue Oct 28 13:44:03 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
