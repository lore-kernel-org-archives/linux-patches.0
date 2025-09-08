Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2642EB5BF;
	Mon,  8 Sep 2025 09:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757323608; cv=none; b=sJTBNwO0/oUEY+yGIgx/8isLGEO3dhNBbx628Uw6EtSSVusmEbYSS//yoNosSCo/IZ/2e8gu8VsV1akpXhQjC7HnS7x9/bSBphARVRK9fRA8pHCNALztuRPYtvx6whTTYTIL13hDm6sZIb6CfQOrynDJxZ8M6Os++pkdvd7t5Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757323608; c=relaxed/simple;
	bh=G1ZfDLdk5LAhXzh30a/dDNfsgbaDHZWKYdvr0/Utews=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BH8f/ot063zojaoC+CbcpwrLCnpLJvZDVuMBQVfw7EK4Hc+KzTq486DMbmlgbmNoyYWgBJMfhtl6OeK1X3ARsn7fSLotMuoWCfUSLCGRwDnOAVi5wLkqG4FKxO+JZrIT8PFM7pOPvxY26ndvGomxfPXgY8TkofSKHoDCrAFj6iY=
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
Subject: Re: [PATCH 6.6 000/121] 6.6.105-rc1 review
Date: Mon,  8 Sep 2025 09:26:20 +0000
Message-ID: <20250908092619.22684-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.105-rc1-g235604b18bff #64 SMP PREEMPT_DYNAMIC Mon Sep  8 06:46:40 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
