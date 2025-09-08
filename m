Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B172F069D;
	Mon,  8 Sep 2025 09:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757323662; cv=none; b=F7frYEI8p+EygFzwNILvfABJSLtNCfjrJS/odQQKV2UBqaq7lNLga9Ug3FKXeTG9ubP5bXJUOs0zNF36QD+jDeUjPuFtspWrgOZVrLkfOltqtDiTQ5OYE/7WgNyZ5EgGzKCQrl2VgWCuUWkU8NX54iilBtJ7U9VkoDhQ0u1MEp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757323662; c=relaxed/simple;
	bh=OchKJYV7CPOJ9CNBP+OKJyfG38TzmK/480K28HoVA4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrwTd+9YuNhaOx8GVovyP9jW+p0BtrTYwWP9p7N0ITmxrN/8zy5hL59R1FEwTPkjZ7+iWl1h3rUXP2PYM8syb/NPRAvP3QC0i25V1hKb4iFJc7X03f7SPMvSPuX4SqJ8dXJ4mpbIKKt5LSD7PjlcXNPr301vHXGQUIaojm5SAhQ=
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
	srw@sladewatkins.net,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 5.10 00/52] 5.10.243-rc1 review
Date: Mon,  8 Sep 2025 09:27:27 +0000
Message-ID: <20250908092726.22830-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250907195601.957051083@linuxfoundation.org>
References: <20250907195601.957051083@linuxfoundation.org>
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

CPU/kernel: Linux auntie 5.10.243-rc1-00089-g910e09235335 #67 SMP Mon Sep 8 06:59:48 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
