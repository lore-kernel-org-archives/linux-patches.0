Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030052AF1D;
	Tue, 21 Apr 2026 08:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776761352; cv=none; b=bVqakYxh8G+uzDwWP7iNyjROhkISEL1oEupLIzHKXLZdy0qlLVaD7FzlKu/AOPMHU5FkMczd0ANEjAUYAeeqWeVt/DEkka/I/QRLuZJ5C68AHZ8f90o+rJV1KLUNXrIRMguakJq2lWQxT5zEPZmHBKTICeNXI6drRpWDcC84xTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776761352; c=relaxed/simple;
	bh=Bf1L6NQo1q20N4mIr0a9PksVJ6wKgoNNvjC9IQ06ysM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdH4QmHNEGTWWbXXcGNCnLbCgUoLGmUskd4xJBeEa3fYKDYUp7dqQA2IHvMz/ruKqz+E0oUEHhcKt4AnnRMalom69rj5zVpfRKYdgorVZAAGhFPAFf2l4FcAOfPQZKa8o17SvnpObIvjk1gRFykSfg4MTy8Lok1u+MOwdMAJd6E=
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
Subject: Re: [PATCH 6.12 000/162] 6.12.83-rc1 review
Date: Tue, 21 Apr 2026 08:08:50 +0000
Message-ID: <20260421080856.24489-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.83-rc1-g74878a6aec56 #1 SMP PREEMPT_DYNAMIC Tue Apr 21 07:45:34 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
