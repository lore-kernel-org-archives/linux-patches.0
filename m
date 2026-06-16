Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420FB4502F;
	Tue, 16 Jun 2026 16:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628959; cv=none; b=XGOsnzfPJ1mLN25OGirS3NX/8WFzt9mjfbotOPXewiXVNphnDYxBvq0OpJpdNIV26L+Qqcdlmibm4CfeZOj/H147RxdlkIcJi/RWva7ss79sR0y6hTrAjIbwXo/zRZkGxoBlDGy/BhLkfjERu/FDLfCSEezm91kmIP2Jv2FoM1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628959; c=relaxed/simple;
	bh=QKM1zheAVKbCNAXTe+GsGaotgBMey1uLgBGkLNlHvc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6MJM8y4IaHCRCBADprVW88arQ72zTaYx/hpW2/Jp0ewx5i6HuJQk+2ps1orw+vQ3znXYVGJdtddCWxI9GGRD0PjbH29FI/HlkyvVeo/60Gef//GYOpz/2uzHy6FX/O7PSrqOaYJDfwSfTytGEuKFPnUkPzMiMqg1H8ygTWt9Q4=
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
Subject: Re: [PATCH 6.18 000/325] 6.18.36-rc1 review
Date: Tue, 16 Jun 2026 16:55:48 +0000
Message-ID: <20260616165552.26705-1-bacs@librecast.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.36-rc1-g1b6356bc9016 #1 SMP PREEMPT_DYNAMIC Tue Jun 16 16:02:41 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
