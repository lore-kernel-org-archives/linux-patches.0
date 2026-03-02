Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6069647D947;
	Mon,  2 Mar 2026 19:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772480159; cv=none; b=FpXy/BPXOSu2sxgE8wgjRkYrL5NI3EjMRFi0WT8LlAYSZuwpT+WT15n5A07T2H4Lljb4frcGa3i7xU6zxrKUUo1/X9+Kq3wnv/T9g7A2IdTlRBehVJl+BSBTlLJYVrNV3kexjy7KJlAM5eX1dVAHpLnu9R/y+CRLgsFcf+A/RRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772480159; c=relaxed/simple;
	bh=I5QDcEjSvGawaG6txekGRTAwT1WxyMrFYMcq5xfdwPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrNFqbIwF4a5mEwleW3M5KJEL5UQXiy8pw3qyA5e+jn1Zfs2XY/aac3i+Is4vskAoIBgpWy+w+N3+l1nzS8dX6X1r/c+6PIO36f9L2UFjeEV7sIusXBq+rp3jRLkssFENJnmeYGtzFa/zizmEbrOlGSrx5CoMBkfvYVGSb/fEJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.211.58
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
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/956] 6.12.75-rc2 review
Date: Mon,  2 Mar 2026 19:35:31 +0000
Message-ID: <20260302193545.3315-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260302160918.2520730-1-sashal@kernel.org>
References: <20260302160918.2520730-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results (FAIL)

020/020 [ OK ] liblcrq
010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.12.75-rc2-gfac02d83d8b6 #1 SMP PREEMPT_DYNAMIC Mon Mar  2 17:10:35 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Builds, boots and passes network tests.  Fails to poweroff.

Appears to be caused by upstream commit 4589712e0111352973131bad975023b25569287c

See bisection log for 6.6.128-rc2.
