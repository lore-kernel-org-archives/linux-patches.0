Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E56D3A1E63;
	Tue, 16 Dec 2025 17:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765906197; cv=none; b=scDW5dGE/WnG+UspjeaeGZdf3w4PoLeVZyE5QmCoyZAWb8TU46DOwzIQXCKvfLidgClLzzxFc2dzEKNNBT49YkLCLzb/0ttIhQc3j+Vp59hMiuy8tNjC4wn2QmAsJcQ1/BgxTNMsivI3msmh9Qo8qy3SZr/MpdCMzqKqdZQ2zkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765906197; c=relaxed/simple;
	bh=7nrN3ulwW6YO7rnicOr/L4VYLb7cLQ+5Rz4NEcVfts4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMQl6PP0mqqi98J6s7Xfwajk8jfuA9wvCNQgoSJsCjoVlqzawGMc21uA2rxHa50PxLYgMuskGlzgZGnYuTEJ4LC6C3bJutbM5l2pT3tL66arwRO6l3Gu/KXZS+Os7hDttl9wOY2Sg8uzZVaSBuFIruRTydaTKqd/pA+yyh4gcNY=
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
Subject: Re: [PATCH 6.18 000/614] 6.18.2-rc1 review
Date: Tue, 16 Dec 2025 17:29:28 +0000
Message-ID: <20251216172936.28206-1-bacs@librecast.net>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.2-rc1-g103c79e44ce7 #1 SMP PREEMPT_DYNAMIC Tue Dec 16 17:27:35 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
