Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698BB430B96;
	Sun,  1 Mar 2026 08:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772355261; cv=none; b=lMg3bxo0iuz+sWbq1KaUXuDZJAHCLiwywadkHJmcCt0NnzmXu9bd+jAzG0lmaBuXbzwj4xDKeIKEtgkm8cXv7b2ilAdTpu9smRw1Op41X88r5eN8LxdZ3q+/VlFMtPXbw8SFPm4SOuaKXqh70Q/GNcXAa4QnfmwaCuzs1Olj4Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772355261; c=relaxed/simple;
	bh=4UF/5AxcVmAD3zs4skkylgMmWfF+tYhkAcRE57IODXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrLg5ye2ORZ+bJShvRk2snjs+IOz8ahKluebWvNVmqulNwGLTGt+TgQyCvfeYCA34SynTHoHpFKoP55L+6Po9k6xx2gu/1UYRh1uSJAWg+YdU+QdMRIBSqh9IXiEm1emGgq7Qap0zOJ5v+9CS8KQJ3LR/HR2Bujv7qU1DWAhy9M=
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
Subject: Re: [PATCH 5.15 000/164] 5.15.202-rc1 review
Date: Sun,  1 Mar 2026 08:53:59 +0000
Message-ID: <20260301085406.21636-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260228181458.1600528-1-sashal@kernel.org>
References: <20260228181458.1600528-1-sashal@kernel.org>
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

CPU/kernel: Linux auntie 5.15.202-rc1-00164-g787042c7f0a1 #1 SMP Sun Mar 1 07:43:25 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
