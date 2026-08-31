Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E7B37F745;
	Mon, 31 Aug 2026 19:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788203556; cv=none; b=Q3hW3ubxke31Qdl8b5AXfj4wOiUpphXcGGdI+f8wOF5sb7a31t1r+CpNo3EZUouMT4LWJ/EqkTy1LddoS6NVU+acW2Uk0GerGnzXJ4rg5ZyQgghGgBxFbTft3ARun8HdlE7+yVokFw7bgMfwmkym/NhUDTSPWPcsyf3JHXTAiDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788203556; c=relaxed/simple;
	bh=DeEn8KeYM72tfpbT/adUuQYlWBWbUzUc6ZVyZz6n+Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lsl7LTzXtcNbuQcZqqzSrJ/bAkD7VQHE9QZ4TuOc/EUOYAifrXu4k5/KqWRIMMcfSp4s63uh3RsUMJ4mqhDJzk8BX4wsJXefo411mM275VbpIOtW6iOZ513zsevEMNepqNBjUxF08B3CPy5/26dcx3D8/ZKyhjg1y0vaVrnonhI=
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
Subject: Re: [PATCH 6.18 00/83] 6.18.49-rc1 review
Date: Mon, 31 Aug 2026 19:12:20 +0000
Message-ID: <20260831191223.28121-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.49-rc1-g52d189f2c6b3 #1 SMP PREEMPT_DYNAMIC Mon Aug 31 18:39:24 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
