Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857E62AF1D;
	Tue, 21 Apr 2026 08:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776761355; cv=none; b=p4JEBgmjcGgNMoj3cvqnmFM/y5Nm0ceqHUX+5AGOtmZ6Ps5CYcRGPmubqELxnZJFk5Kbd0QTfLAkKseLwjZWQl7brCZJhyK6wSaQloIdsSlG0YQko5WaUzronxIvKA4AIRbpCpJXsRvkrxiqvhWWjz/BZPGeAGMu+zwZfxtKkA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776761355; c=relaxed/simple;
	bh=GiL2ZOAKQCYPUiHFKfG1Bctq7XKiuEsX0SuMUGlGV/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayfvMuAZAFBUUvSFYA0nPwM/nB4bJpu5PFsmPBq4qLoqVuTtRKPghsRi7AZRXdvvmlzLTm4HRCfCx/IoFi+5aSefD3J65aQYjbvemMAp8JgcxLntiusd+Md+BrQbKLOaCKXW00Nk8M2oo7F9OedyRPTK/AXQhMnbvungY92rdC4=
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
Subject: Re: [PATCH 6.18 000/198] 6.18.24-rc1 review
Date: Tue, 21 Apr 2026 08:08:58 +0000
Message-ID: <20260421080902.24548-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.24-rc1-g79c8a3af6b8b #1 SMP PREEMPT_DYNAMIC Tue Apr 21 07:48:45 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
