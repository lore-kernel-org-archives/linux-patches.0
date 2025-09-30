Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E782367AE;
	Tue, 30 Sep 2025 18:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759258311; cv=none; b=AtJbe7a/L0KdR0N6aHBYoVoCufUH4VWhVDV3GXy8QvwUNqq8lyDIrGbRrrslrie8dLZc5MoZTxsQA1F8DxOLmibhKMdEpdKuTJ3MT5WdHkkmOX2tPONeDyAiQqqGNJ9AOnadNyXiKcOvtyQy5rnY7Ph2b/t/tNEiton6ObXhSe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759258311; c=relaxed/simple;
	bh=K6B/UrJDRNSe7VS0a+ExhgpCA1eb5mfz1QI79j9gtkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmeIQM/KWXDqqEsDnMctbscD+qwGXcnWfUa9xVR+FgH6+Szws+DfZpd9MtldBkkwV/S8VkOrKMRnsFpNyPtvnlKDYdLIqQeUXI/WMUBU0z+PszQ3o63DXwYy2yip0Rxgk41A68DshSlzHlizViBK4wxClOJwxwIJ32AQfC+SyNo=
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
Subject: Re: 5.10.245-rc1 review
Date: Tue, 30 Sep 2025 18:51:39 +0000
Message-ID: <20250930185143.4005-1-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

CPU/kernel: Linux auntie 5.10.245-rc1-00123-g9abf794d1d5c #96 SMP Tue Sep 30 16:03:28 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
