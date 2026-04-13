Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3A1371D0A;
	Mon, 13 Apr 2026 17:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776102191; cv=none; b=MFFuueiWoTBg+XpoE2Ya0jNCIy0M7h7FsbRy1ZkUx/nIsYsmvjnvSHqHLfrM5GdhB770L2CvmBfTvgxdvFa2XjjFAytlMhg1OXuhW2URw+o3EvDEqLplZ+A0IjbM/ODZtcogpE6qXPeG46zd1YrM99MJJYswN1EZS4v7Jr2xQTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776102191; c=relaxed/simple;
	bh=7T05xEwaZKLh2RSWMupy0ZenEKScsvGe4G1EKI+f3/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LB9zil6Uigf6Tz9iQl/v03xJJmVUwM4hz9Tyx+BsP9ZapC/S2Mj+r6JCsbCTHo2D+lWJA8BuOSYcWS8ZQ8ulZWV8m6+LxtItDp0AxnenCQnfgNr/JHdyc69+dGStkMoH8vmUakc9HOG0BrFPjBv3E/SsUOFq7o2JplQZuKXCn8g=
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
Subject: Re: [PATCH 6.18 00/83] 6.18.23-rc1 review
Date: Mon, 13 Apr 2026 17:43:01 +0000
Message-ID: <20260413174303.20446-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.23-rc1-gc600baa82c20 #1 SMP PREEMPT_DYNAMIC Mon Apr 13 17:22:43 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
