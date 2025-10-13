Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE39E1474CC;
	Mon, 13 Oct 2025 17:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760375224; cv=none; b=cKHCbVwkidD1cyy+aPcVd4QSsIqDL0CCmB158PQiay5vbG3tO5n/GPJjNzP582ZE3wWRK+QTNltsBMcAdS7y+VK92YVcCDQUh8IeoQg03L8PkxR1+bDLUSD2et793B1OJkt+IMuvNRzQkie3auohHrRldmvZM6k8UWpSCV2JWo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760375224; c=relaxed/simple;
	bh=0PbXxjWkxuWZB9D4sjCe8V5GT09JJiTFBfYL0eBcneQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvyggdMxtlJSEn6FF6SD6cfeH+Hw254pXLQ7RfnHgukJsy7al+pCfCmKzfffL+Wvv04xGRrghwx90hICPY9F6qTmCEPFBXL/RFqFGlchnEfrVHfrK38hGSx6Q0kxxz10zTVP5WK+FmzIHS7enXAfAXcBofGZPDzFNLNfDGFgRuc=
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
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.1 000/196] 6.1.156-rc1 review
Date: Mon, 13 Oct 2025 17:06:48 +0000
Message-ID: <20251013170654.27184-1-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.1.156-rc1-00197-gb9f52894e35f #109 SMP PREEMPT_DYNAMIC Mon Oct 13 17:03:04 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
