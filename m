Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4423B3F0AAF;
	Fri, 17 Jul 2026 10:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784285756; cv=none; b=HHkPpoEj1KFZ45s9NjFkE4AwiOagC+Ur8VFWMZId/v9VQnySpEhoSKmCsYc1+kckveJGi70D2KZpFwvAUldYKCt9sM67AOXdCNuBsobC3F5K8K0C5XCLIs6Enb+QRhaWh0PxaLqjP4cenVJnTb1AlYC+0uAPOgnnd6PMG3tTOZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784285756; c=relaxed/simple;
	bh=hRMMWlXiN/BUIkxqLX3EBwh/s4n27RevA1UVVN+AhLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4sLc/epebxf2Kic9OszLUMzwMSDvPLDnlWzOH0RlWCB2X6TjS9eUDcLSI1k/s/bP9BrmBOVg/C6wsJ8iNt7qlJG41kFvcMPuQqO1YUnJ0fyVKUopF1clFANqGDkQidIaU+0jF/2uHe+1KDGiptKTwWI1OkxIeCB8ePLssv0i7I=
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
Subject: Re: [PATCH 7.1 000/533] 7.1.4-rc2 review
Date: Fri, 17 Jul 2026 10:55:36 +0000
Message-ID: <20260717105539.35998-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260717101912.682013354@linuxfoundation.org>
References: <20260717101912.682013354@linuxfoundation.org>
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

CPU/kernel: Linux auntie 7.1.4-rc2-g2ae9949ee672 #1 SMP PREEMPT_DYNAMIC Fri Jul 17 10:53:29 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
