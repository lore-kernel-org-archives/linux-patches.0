Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5C51EB9F2;
	Thu, 21 May 2026 15:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375618; cv=none; b=Yzs/ER9SZNnUKoNgCUMChgFdr95x9AAvW5yqGy+ec7ajD+IJ0BkuNrwlvknsRvLgO1/NUi0PuWv7e2etkiJlXTmZOtm/+nbPUYPuibnMIk/Qhy10G0v3DqfX8ybkXPTQcYCLgPCMbJcd6ZXEAhEFqTehk4+oTk8njykn/fmHxG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375618; c=relaxed/simple;
	bh=W6QQtVl/SnzUrsxygkTJ+G1JUXyPmlughJ+RVW2GT3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGBzm2TKIkTpXnuijlDwbDp0BS07rb7aZrWZrBrjpoqRZaoTRmEV6K9CFtKSmh8gl9vUv+Ue22lAwJDIoxp7Ml7UTjRw9xaqj+KzByCZyNQgxwlOQL1w90Q19nwNzYd4CvtwEEMKgUMJVG/f0hFf1QuzMNKxVWvxpvv5P+Ctne4=
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
Subject: Re: [PATCH 6.18 000/957] 6.18.32-rc1 review (actually 6.18.33-rc1)
Date: Thu, 21 May 2026 14:58:46 +0000
Message-ID: <20260521145952.23147-1-bacs@librecast.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.32-rc1-gb7adc4ce3f26 #1 SMP PREEMPT_DYNAMIC Thu May 21 14:55:30 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
