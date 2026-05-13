Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D129C3D6CD6;
	Wed, 13 May 2026 07:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778658076; cv=none; b=b3dXXGcivn+PfXdW91hCLt8myIS+TSkgoBbG6Xqr1MmvQQtYGr7/hTgsLhLj4kRMnW9DRifhyZsV++EMpO7eTZReVdXmmhgvauzWeabuPG7gTvDtNYiCSUwsA/woLRifSvSbIN6DTwj4HU0kFGQIrhMO88BchYnqNtNKZfYn6Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778658076; c=relaxed/simple;
	bh=0HSHZy9ZtdmVTMfx7HsMYG6t5CxPN6ZoLxi8T+kydeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MB3kg12FIi0eVgS+rwCIBc6ahg7jq5IS2jfyVGb/fEWa3nVS8EgmuiPS6kVSTk2Idwm5i4Po9VOT/2H5wEt7GJmNbkxabDouxLDoGjCGRroMQ/Bkv/StR2+g1xB8ATQySR8oPhHzJ19BqaNv9RvWjZhU/QvkpTlhbAWhQhJBjeM=
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
Subject: Re: [PATCH 6.12 000/206] 6.12.88-rc1 review
Date: Wed, 13 May 2026 07:15:40 +0000
Message-ID: <20260513071542.38235-2-bacs@librecast.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.88-rc1-g12d177f80a13 #1 SMP PREEMPT_DYNAMIC Wed May 13 07:04:40 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
