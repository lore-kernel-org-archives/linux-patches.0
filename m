Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAE730CDB7;
	Wed, 22 Oct 2025 08:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761123406; cv=none; b=crkTQf58tKA6GddFvRsSJM3ND0GE6AZHMcexla0jXeDIgJ4DHFd3vytV1seoGE2Mp55BjPPNJTuzIUjbJ4jBI1srMtOa+EZEd0++2M9577sWYjrKSJdIrkoVMLxSMqdHjpxRojuDZyFKencaD3xmnG4R86B8WDIAnHcZE9th5Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761123406; c=relaxed/simple;
	bh=2UaMPM+XEE4PKWwxOkREkoG+56CZYhIWp/g5dEP4MOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sw7FoDqL8WKyyOcCbA0zdrGjcNkhZs6SlpdBG3aRGu73HFcynkeGoFA7bajwDWiBaI7B8H8Krcna4H9LQqOzWU2zM/vJsPMbShoxiazFBs6UiNRaxEpVtQBovLIl/mo6l4hLkHsZxZEjB52jGak6Hum5SUQOTfS0AbO1dYl0S/c=
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
Subject: Re: [PATCH 6.6 000/105] 6.6.114-rc1 review
Date: Wed, 22 Oct 2025 08:56:20 +0000
Message-ID: <20251022085625.3785-1-bacs@librecast.net>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.114-rc1-g8ed83e981d68 #117 SMP PREEMPT_DYNAMIC Wed Oct 22 08:52:13 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
