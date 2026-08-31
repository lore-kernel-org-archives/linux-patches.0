Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19EB37EFEE;
	Mon, 31 Aug 2026 19:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788203555; cv=none; b=O6/mx/bqzjM6F3kREvBboJIRIkJUEuWGwytjntKWTPCw8V+2em7k2sCEhGVKRMrSRSR4hk+YRr00GKRS7UZnHYFk/dUDYzPG8gjmotpXvBz6sj4gylA2koelo6lSImB7jruG+pph0A2WGgJxf1OO4J5Heq4/sWrBKaCd0yl9wWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788203555; c=relaxed/simple;
	bh=Jd4IzDWzfhZfk3WOB52jIgyF2tb3l8cRsijBYM6z/Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFV6n3gcexcNwISSCTe3dTfUc3RlyB3/hSpdz12Fp9Se17cIrJicXvJdIm6KciPqKb/hjjhV7dteaS5HyoWHDURxsfGQbHn03VOo4hPusSVfKa3zY0UivPvg3zRgsRslp5KGKXLzt/NBPKqsGVkLU8xFB8HERuZvmR+NV2oIjlg=
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
Subject: Re: [PATCH 6.6 00/91] 6.6.156-rc1 review
Date: Mon, 31 Aug 2026 19:12:24 +0000
Message-ID: <20260831191227.28159-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.156-rc1-g658884b4c6d2 #1 SMP PREEMPT_DYNAMIC Mon Aug 31 19:09:36 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
