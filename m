Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3FE2DE6F6;
	Wed, 20 Aug 2025 09:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755681293; cv=none; b=mpxXH4zdoY7ti8WJVs95qbobiYgLjOeLN5MJbwSbTVXOIbRFBh9qicl8L5o/GBbHJ39n9futmt2Fqvb+8XNtrNqtWuYDhTOq2pcTYnPuY/woBGDj+aMIxMUtH5boxMQxwaK8yIUTSM8UakHjMPmtYD0gjCmc1USijyi6nqMMlao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755681293; c=relaxed/simple;
	bh=etCgKISUUn8vYRoz0op4FaQiCAIQjYWxZgOMZi6QWfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MLw7meYzItu14FUqC1BhrX2w7FG1OXmLVatt8pUbYp2kNn21AY51GF/36EkaW3fT5+8NYExkRtzeK7X6V1X4n1QV24PmA9a+lCWsFJkTxJR6cJUal1GkCPIQesT1HO2IwtBPgLQS5MlNEZ30K138nmh+q6eM8pQGmzHqcjmVmW0=
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
Subject: Re: 6.12.43-rc2 review
Date: Wed, 20 Aug 2025 09:14:12 +0000
Message-ID: <20250820091411.19994-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250819122820.553053307@linuxfoundation.org>
References: <20250819122820.553053307@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.43-rc2-ge80021fb2304 #44 SMP PREEMPT_DYNAMIC Tue Aug 19 14:02:42 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
