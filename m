Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71297397342;
	Wed, 13 May 2026 17:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778691686; cv=none; b=eRdRaRVqv/WOK9XzI39Ov1r6AuomNZF11bW5eOqDbi9A+eF8Iro0B6ywZHdXOJTXR0GZJcrRrroMkXyZtfMBaahWvWmUgsPgSU/QTN8/epy3EC1G2U70rzIzbamvwFX6AN5aoqdSb6Kb6QleMBA9kSCZa5jclCJB7dCLFbqUglc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778691686; c=relaxed/simple;
	bh=jxAUWklUMJJQhP+MOL7O8qNLwEG0tO2ERIku1lk/xVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHsIINTNrwwu+JivUJoARWXfXxLS5FCrDh3+5D7dTlpemIv/K9elvambMA70MKQZw7c3jvw5R3Ls56tXC19nob14wGLezHP8JNeovU5k+G7TVmuRY2iSMf4dcXDR2ym8sQ5IVPhA5bXexq2/vUrWdAdn/SnE4NwpcAntXWtoNZo=
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
Subject: Re: [PATCH 6.12 000/202] 6.12.88-rc2 review
Date: Wed, 13 May 2026 17:01:04 +0000
Message-ID: <20260513170108.19331-1-bacs@librecast.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260513153743.326058350@linuxfoundation.org>
References: <20260513153743.326058350@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.88-rc2-g3cdde8c80e99 #1 SMP PREEMPT_DYNAMIC Wed May 13 16:51:41 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
