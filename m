Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1298E25C810;
	Mon, 13 Oct 2025 17:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760375204; cv=none; b=cpC08qDnV7BCXnoLwQtuF1rYUC1Sj2n6EosL3l/GmpyYdOUuq2+gK9Igb+94Uoe0BWVToziAYtXmfYnW5rYbBNvp+aC/k3312FDvcu2VJvfxkg9aLjLgdb+2Nmla6ZWTqTRYnDpEV+ockBRYeSpzlZiAYToS7PAst2MlkjTmHbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760375204; c=relaxed/simple;
	bh=qjej2SHygSZIPwcItx8SkEAimwR/n2kxieGe67m/szA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYBNZlnS5O4sxp4szVbcgN2c1/RKwDa+OjGn9Qbc+ookBelu7xKauVvVghJbepGcgxplfToa+kd7U0wUBZoCrypWMraEL4dJWYF1/iwATgYhzfJRYEpbV8m9x2Ji+stdGFkIg+gXeynkrtGGoC+ZTxFMHVuW2Ves72WhNPUr8xc=
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
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.6 000/196] 6.6.112-rc1 review
Date: Mon, 13 Oct 2025 17:06:27 +0000
Message-ID: <20251013170631.27147-1-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.112-rc1-g07c1c4215e92 #108 SMP PREEMPT_DYNAMIC Mon Oct 13 16:51:13 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
