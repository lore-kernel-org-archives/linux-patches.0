Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BAF309DDC;
	Wed, 22 Oct 2025 08:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761123373; cv=none; b=kGX/YghONAU+EuDCNCYOKB0m7CNLFSSuFQAsBeK4atw3FZaAhv2bp2CdI5q9Cy+4ZjfKqXeACnTDRKWk6y6FS8VC+bbdswdnN43uM3+Chk+LCj8Catsw9hEYqGsj2j0k8AV8Y77nKFZFD9O1CxGtEz8706x4pvtVYvVZpTLpmbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761123373; c=relaxed/simple;
	bh=Yf6Reo/wz+7zlVdeyvce3JyP9NiEWdt/ZI9RvdrMYes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qk/DJc3+5bX9EAPffyKRW07TJ3zwRz9NUiHE2yrVLGE+1+IWbkacLCESnk4MPw58zMShUcI7Nc9D14e7MILoIBl7gfQ/oJ2Kqj9rkVZiJaxgZumJuWkzlUp7y3/UWgG4TBzVOiKM7qhBaR0pfFPFi4dtUN27NAD2ru4+2Zbqk34=
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
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.17 000/160] 6.17.5-rc2 review
Date: Wed, 22 Oct 2025 08:55:36 +0000
Message-ID: <20251022085542.3691-1-bacs@librecast.net>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251022053328.623411246@linuxfoundation.org>
References: <20251022053328.623411246@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.17.5-rc2-g3cc198d00990 #115 SMP PREEMPT_DYNAMIC Wed Oct 22 08:36:08 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
