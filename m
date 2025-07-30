Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158ED132122;
	Wed, 30 Jul 2025 17:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753895035; cv=none; b=lbewRvwn0EZLnWgP4if1NQBvkFkvtluXnG6Qvqkh+/pkK4jh7mNAVIRARK/83cryq8qTXTeR80WXaYAkz4HYEKmG2ge0Gi0AU8R2yk9mxaqd0XfwjO4f7VvCnCGXXGXYpTAixWJv5mXvfZPnQiydyQVYNxEcJzmFf0cz0mCp7c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753895035; c=relaxed/simple;
	bh=m/rDzWAlOo6y3gOCHwAlb/5G7CUl/K81mlWb1hMbAt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2CFYXW5tlXiSRTWgQenCGEYR0Fn6hPyqel25KXErTSbGR6jAVSw2IGmobzisu/yl+QbIl+sG3UhKS9Poj4T2EyNnfGal+3imb8q0Stb0qaZ38znZRtjOKatjCL3qjYLGkKc6YPxB0kqQ1S9uBs34eYaVNk8wnPR2v7RG3SBd9Y=
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
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: 6.6.101-rc1-g1a25720a319a review
Date: Wed, 30 Jul 2025 16:59:12 +0000
Message-ID: <20250730165911.29371-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.101-rc1-g1a25720a319a #34 SMP PREEMPT_DYNAMIC Wed Jul 30 10:56:44 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
