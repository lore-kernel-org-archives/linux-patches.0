Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BDD47D941;
	Mon,  2 Mar 2026 19:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772480138; cv=none; b=tvHKQ3sbNJnr9sHld9MNQ9JRGmblzsAiqhFiKJLbhoEwe1Ax1x50LHX1zn/ayTEwM3yMMR4hrpUAhG8/mW7/pO0y0NX8aeNIFPF+F574eHU+ywMw2kKV3Nfx/7S5IXoVMVbXKZRSJHHHx4HpuhjtUH/ORuq4CPvzAR//G7pE5mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772480138; c=relaxed/simple;
	bh=OsfvX7YeKDVUUUBSxXdXNsL5Hs7dKE0HGACmDIiW6kA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNhjpNWWbcpUVgESiYYeGgBcIqkxZCi+jhH8kuC4ZI+NkrZQLk6VnxqC1D9MlB2PtvRL6ojJDMOppfqJWKq1xIcvssfrgTTSfrlB8s/4Eoxd+FdUXhhzgPMmHzvqbHbA0pm0f2n/ZciVPU8IkKqHxd31xH+LFzf/Kfan5grZaqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.210.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
From: Brett A C Sheffield <bacs@librecast.net>
To: sashal@kernel.org
Cc: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	gregkh@linuxfoundation.org,
	patches@lists.linux.dev,
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
Subject: Re: [PATCH 5.15 000/410] 5.15.202-rc2 review
Date: Mon,  2 Mar 2026 19:35:21 +0000
Message-ID: <20260302193524.3237-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260302160955.2522727-1-sashal@kernel.org>
References: <20260302160955.2522727-1-sashal@kernel.org>
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

CPU/kernel: Linux auntie 5.15.202-rc2-00410-g2ecf8c20edad #1 SMP Mon Mar 2 16:53:52 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
