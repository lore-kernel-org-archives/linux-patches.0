Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E792D34EEF6;
	Tue,  6 Jan 2026 19:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767728952; cv=none; b=N88hHXGjgeYV5i3EVm401tYLZa8dQc3skpql0ads6I+Wjojj4miUEK9yAHvw7ZINNe3z2AoN8BPwzn5oxG6seDx7IggJAs1bgDMv1bplNLu8ZNTl3Q2bHpfrc3jaYLRWk54rqjelEk6mEOtxY4oDhhcpm+cEeqzc5/TQr6TAux0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767728952; c=relaxed/simple;
	bh=mvAg5Mi4BCbstMebIgjU+0yBi4msOu/lML+gguZarqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uC1Bm4M2fxinS9Fe9s3CiVP5wYnvnsCfiEGUKchDF2NAI2m+ioUZenst2J5xN9SyxeVUAJVYvcTvZ4XLjRFE8KGlSJpJMJsIcYlFV302JDM3R19sTuWbEIbSPo6t8zMirm4Tu6cnlOnzcP4075ux27fNJaYYXayCHS6YMfkYCjs=
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
	sr@sladewatkins.com,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.18 000/312] 6.18.4-rc1 review
Date: Tue,  6 Jan 2026 19:22:10 +0000
Message-ID: <20260106192213.27770-1-bacs@librecast.net>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.4-rc1-gdc7c4cd6ae5e #1 SMP PREEMPT_DYNAMIC Tue Jan  6 19:19:41 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
