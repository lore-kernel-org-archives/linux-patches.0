Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B5922A7E9;
	Mon,  2 Mar 2026 19:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772480139; cv=none; b=g98++u5DTex4Np/C98snAjy8FInT9eRQF/ocu8rDyFvK1PkyRXT27Emw0s6H68B2niHnIq85/+K51nsEqm92pvBeF8tAvMhBPShw9I3zJM2agGiO8VvNR3gpNuBGXxzh3VJvfTTMZcaooy0NIBT+0yCF0NQR/BWteXuPpuImTlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772480139; c=relaxed/simple;
	bh=JmPatbRSJs8KfGL70UYgCJ7fty+9YCYHlvDV4uciwNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CF+qQxeNE24m2nic3PkYt5CN5bSLUvJyMrMohS9pFIZDiK8hRt5YZjiqpJHEj2GnDUryFhzT0yKkhwRuTsVA3GBp7OgouBN7nnxK8uYMT1y4ButlpZW8ELAWs2Y53W7ElGJUG8JXkiB8FzFkh0Wz5dfSx/DFN1D5oRL/PnyNbE4=
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
Subject: Re: [PATCH 6.1 000/533] 6.1.165-rc2 review
Date: Mon,  2 Mar 2026 19:35:25 +0000
Message-ID: <20260302193529.3276-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260302160943.2522184-1-sashal@kernel.org>
References: <20260302160943.2522184-1-sashal@kernel.org>
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

CPU/kernel: Linux auntie 6.1.165-rc2-00533-g3e17bb28624f #1 SMP PREEMPT_DYNAMIC Mon Mar  2 16:57:50 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
