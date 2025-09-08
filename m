Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A7F2F3C28;
	Mon,  8 Sep 2025 09:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757323683; cv=none; b=iNSUyfPe6hGIkyqRm6m9TE1Mz5bFibyODO1DnL5VeTvf3C3r+dlghc0NMZFtdYhgGi4iM3YaykbqX1E9HjCAGJdntGO2f+wRBeZXh0mox72B3Ko9uu+ZcivIJch6wK5S38aQmgo9b5M03pGxpj4emqBSNH3SAJt3APc3J7w7qh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757323683; c=relaxed/simple;
	bh=I/G23htBdL+aAw2glF8u1J1f4kdwA8kOYWqAS9WT9Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+F4RmPln11Vxd27jmQmOh/jnPSKh3xOxK4li9h/ssD/VO6/YWjhdH+d29ACbWmcI2I+bv2Of6NrNvnVp6WRIb+AL/hs/JE0QY+OK0VD2RMbvl6WkKqqcpb7JsWZZlqVKNw1m6gDkeoaQprFVkU8svWoLYLw1C4FIMlaD1/bwAA=
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
Subject: Re: [PATCH 5.4 00/45] 5.4.299-rc1 review
Date: Mon,  8 Sep 2025 09:27:46 +0000
Message-ID: <20250908092745.22874-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250907195600.953058118@linuxfoundation.org>
References: <20250907195600.953058118@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Builds and boots. No network testing performed.

CPU/kernel: Linux auntie 5.4.299-rc1-00070-gf858bf548429 #68 SMP Mon Sep 8 07:03:03 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
