Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AFF305976;
	Wed, 22 Oct 2025 08:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761123374; cv=none; b=MMMObK2Ko2phs5EraKHNaWBAAKOwTY7rdvSbcHGjvMJk9X9aRF5cjdUtoyUQTMonDdRatcPLZEo/Sa1r/jANiGE/lhbGnvj7044CWX5oUiGjR10g+sFeZOZp45vM4aTkzzOby5No2IdKafBFpwhtrcmTPNX5ed176WI4qy/gPo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761123374; c=relaxed/simple;
	bh=I+RV+oXWwgz8g1le0FNyN9EiICykwR/9IqLMNprmK2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKfT0vqCdwwD+xzIXQ7S3mWM5zJu2tPcjjtdZlbzV0H3BAFObBbiytxeI1ZOA6QSfNP0uUmka5jqmHI8pIKpwzCSTNUBLWqujgkEzNmiM0CpKh3wA4gdbTLS7kTZg5hq8J8FPeY34aN8EIys0RLCc+AXEgtZWts9+z0d/wMLIus=
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
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.12 000/135] 6.12.55-rc2 review
Date: Wed, 22 Oct 2025 08:56:00 +0000
Message-ID: <20251022085605.3748-1-bacs@librecast.net>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251022060141.370358070@linuxfoundation.org>
References: <20251022060141.370358070@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.55-rc2-gbd9af5ba3026 #116 SMP PREEMPT_DYNAMIC Wed Oct 22 08:46:53 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
