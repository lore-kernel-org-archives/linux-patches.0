Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2728831D366;
	Sun,  1 Mar 2026 08:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772355264; cv=none; b=ixDOkWdJOP54Ih7qffkYHPOMDAaT7zvMtW2hgzAV3vCqMGeE8h1y19JUKEmWiOcmqSlSyOXWp6K7ES5IAri53ATzyFIgBDJMnrzDNonzzMZmBewdPZx5knRT4WeUqX7lJXN8tarykw+4vXR6QrnBVSXaQp5CymByVUIEih5uuMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772355264; c=relaxed/simple;
	bh=pRp90uiB1Mb1Y10ztValZoZCPz8xRn/NiqytwnvEbkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLfbSulsB5WTBIA/GtQJAkDZJIZnAkSJv9fc9R9TYZiE4EgFhMNjCfukIMvPCcQQb/vIc0YDDZrHIjFkO84nhje+pcEKIlpTw1pk0petVMITsEnvOWEkeswG4dxJN1XT4tm+eSlOPM+5C9HhDDtFn+L8MwVHLgn+bLd1KfTdJPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.210.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
From: Brett A C Sheffield <bacs@librecast.net>
To: sashal@kernel.org
Cc: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	gregkh@linuxfoundation.org,
	patches@lists.linux.dev,
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
Subject: Re: [PATCH 6.1 000/232] 6.1.165-rc1 review
Date: Sun,  1 Mar 2026 08:54:08 +0000
Message-ID: <20260301085412.21672-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260228181119.1592516-1-sashal@kernel.org>
References: <20260228181119.1592516-1-sashal@kernel.org>
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

CPU/kernel: Linux auntie 6.1.165-rc1-00232-g9616e339ac72 #1 SMP PREEMPT_DYNAMIC Sun Mar  1 07:47:24 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
