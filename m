Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A201A9B58;
	Sat, 14 Feb 2026 16:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771084945; cv=none; b=F517Rpaml96gsbFArw5bqoYN702/NNb0xJFG+Ndz5sRI3lHLFJQ1TiHKA6R2gBiB8i8HZxjCWRHJxbzHX3IdoWPV0isucZq986FGT/A3nAM3hy0gN01MKxwU/m/oqgVgCbqmvFrqeE3qPwyz2Sqiv3dJDpkE9C38MwL0jLA5dYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771084945; c=relaxed/simple;
	bh=szOSM7pLLVaMb8SAb89V/OUI3Wkne7RuUiEbJGlLJrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9MWtM2GzrnWNu8BO6Bid6pOKTuzeVxx6vkJ6jCH5QUTfG5R2roGm4Y5XDMaUmuj6XZDXVBsOVMLQccBxWuv43/wesQ+7PhpRlNVkA/ns8wFS5DvSAEtxLjyAdIvAnYHd5XA/1EY1kDp92rgffg7iP1GkYLyx/pDo6YR+NQvEfQ=
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
Subject: Re: [PATCH 6.12 00/24] 6.12.72-rc1 review
Date: Sat, 14 Feb 2026 16:01:58 +0000
Message-ID: <20260214160205.4401-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260213134704.728003077@linuxfoundation.org>
References: <20260213134704.728003077@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.72-rc1-g4b487d46d595 #1 SMP PREEMPT_DYNAMIC Sat Feb 14 15:07:47 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
