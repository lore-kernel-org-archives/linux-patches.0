Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AC827F01B;
	Tue, 30 Sep 2025 18:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759258747; cv=none; b=ReQx5X9ci6Ll1yeXxNr/b2b2lWUsQnt4hciRSD12FK/hnzJ8atjUhiHKI3CUeXILS+QylJnlzBsOYc6/5rtJ5WzkCZM80N+O6FFgxZP3cbw+XaBFQkwkB8kTdHjYp3QOCKMiacV9LJGv3qVzFwZ4pkimu2/eVE4Plsk+JL00slU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759258747; c=relaxed/simple;
	bh=GHmdcF+wxzGRAJct3Au+sbXeG5yNXScTveot3V0z7QY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFUXF7mYbjIZNFr/m8VW1YlRcJAnSP/Dw61B7eZSc/1Sar06GIhFtPtEd9UG0az1Qlv4MOxl60XfE8yh/NLRFvYtXnBYeGs45upY1ss/X2AWibUX1t3AhH2OMkToDHUTUfFNWCNiMDswMbDuzM96JHQki2Wqa6Vi9NMb9y6l67E=
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
Subject: Re: 6.6.109-rc1 review
Date: Tue, 30 Sep 2025 18:49:47 +0000
Message-ID: <20250930184950.3816-1-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.109-rc1-g583cf4b0ea80 #93 SMP PREEMPT_DYNAMIC Tue Sep 30 15:34:50 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
