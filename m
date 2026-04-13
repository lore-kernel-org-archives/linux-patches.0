Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C415371D1E;
	Mon, 13 Apr 2026 17:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776102189; cv=none; b=TNZ3xP3EaIUeo3VsaAKtm2K5/zYABqEhjyEZ94PyYcQli4PIZx5Njr9RuPcrr8phb2K+IAV/3HiOJ0KEpHT6sW1qcXA3KF5x2yQCbMRjpw/uAPso96IwkjDUJREtJujopRrFRD7hw2VyWXpUd7sNnYc/EWckiH5qisvQ3Psx+wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776102189; c=relaxed/simple;
	bh=ZdVJikIX8fMB6UFq4ux+C+IDDl4yDFtKV2Qd1UQZ3ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFJFmMsqQW05zV3N9LZWQRHSHcMCTnxjsepWIqwlY7EfQZ1gkf40cjlKhjEJRXArU5gBt/oda3J0Vk1vyYkQYrjzbkFIIYgoWBjtLOCH9KBTGnAHZAYhZhmXwLi58XRPcxHums45zzgUJlolDzmvd4tQETMOBA4KJStt/I+FpMc=
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
Subject: Re: [PATCH 6.12 00/70] 6.12.82-rc1 review
Date: Mon, 13 Apr 2026 17:42:58 +0000
Message-ID: <20260413174300.20404-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.82-rc1-gf4ef43b0a8c4 #1 SMP PREEMPT_DYNAMIC Mon Apr 13 17:19:28 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
