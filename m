Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5BE274B4D;
	Thu, 18 Sep 2025 05:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758172667; cv=none; b=mxGgb5Xjot2yvWCeux1zX59h+RIIzdPU9eS903yuLz7/dpXJr55RLkHAz5JqU5Cx7UereGJNG8xE4Ik9f6df/wMQwZZS/34F7oJX2FUbDSFPPUiSWAGm8Gc/IO9hC/R1fsrSeefKGXdmO9/ggWUrP5Q307N1NhepOKBblFvr5Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758172667; c=relaxed/simple;
	bh=79atgPybSWcDkvhx3WQgXPeRwM48KOd+oqV65PaVErw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miSHT/mra+lAZk5LBjYQ9ZzI6vbqed3NsGyW+BuxXJIYJLBcSJq/yUKeuhiiVyLrkhlY0pmEjo/vSTmlPPiN+KWKVlDj1zwQfWW5+s3pQQbm0fQTfphrXDaq+9N3qXRbT66Dj5MfRyG3qY7/V2EwdmhwKtoj7D7uHv5qHTRnZ4A=
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
Subject: Re: 6.12.48-rc1 review
Date: Thu, 18 Sep 2025 05:17:22 +0000
Message-ID: <20250918051730.4049-1-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.48-rc1-g6281f90c1450 #81 SMP PREEMPT_DYNAMIC Wed Sep 17 13:21:43 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
