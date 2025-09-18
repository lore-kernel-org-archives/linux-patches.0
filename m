Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EF72D6E7C;
	Thu, 18 Sep 2025 05:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758175105; cv=none; b=N8ttiWlgH7EsUFwIQpe8c4Lef9trRYkLQTcL7viekAONtRuvYqg9x8paIrsZX/7sl/6MJu2UYGWqewurQ4jfll+pXri8PP0Ix/nXjLlWpuLUAqJ4OgxxTrbu921a3zEQOEc5sBxIYKekxbMNRbOrwrvL0PZRb+qfIxBXDTbKLBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758175105; c=relaxed/simple;
	bh=Z31P0pyB6/ssq5ftp8MiYvz56BhmJwldnEG7jzAhWaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hx39EB7ToZelwQai4tOI2Y8JyHGaxtc94s1H4BW6SRUtJHI2FZZCmo9DY2RLTrOeNqlPixYly/ve+JYkXRJEBZQeqimyTmRiG7xnQlOC2LdWYXXVecmtTT6BYcvxyjj4/b5+3oqdzo0bJOQezAgG2uYEJHexI3MP0V6ZHN0hwG0=
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
	achill@achill.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: 6.1.153-rc1 review
Date: Thu, 18 Sep 2025 05:18:15 +0000
Message-ID: <20250918051823.4121-1-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.1.153-rc1-00087-gb31770c84f52 #83 SMP PREEMPT_DYNAMIC Wed Sep 17 13:29:51 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
