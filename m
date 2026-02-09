Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC67134CF;
	Mon,  9 Feb 2026 18:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770660995; cv=none; b=qmlWM7kEgJt6nY8bcF/pOkV7g6ZngDPWvopJ0irq0XzIMIjwOk11KOMIrq9dc31tBK+2QT3EriqpUANJzjzKBfe7QiKTJ+93XkYemdukPTpppz8beA0GSYLuT3x1MycePGhkA9j7SW2SDP3VdhYj/QSkRrPJPVooG8tUYKWFwJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770660995; c=relaxed/simple;
	bh=7hXU0Wl0LRRGYwFEz3b+r5Em9rpln4DFvpv0TtxADUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnWgSl/yqMW1H1qz5nbaBk4IeAviS0dNiRWss9YvtShFlJZqIU3bKZ84wqzYG3TC9aRNVVBDPns5dVKMsgkdsfjKf2he6aOptDHkFCG4OAaENBDz1cec/sdmLegEigiWZO8ZhevEEYjEs/4q5l2yg3EIHT1Rbc5lRWpZkDunVeQ=
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
Subject: Re: [PATCH 6.18 000/175] 6.18.10-rc1 review
Date: Mon,  9 Feb 2026 18:16:25 +0000
Message-ID: <20260209181629.5752-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.10-rc1-g0aa40b8da17f #1 SMP PREEMPT_DYNAMIC Mon Feb  9 17:57:43 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
