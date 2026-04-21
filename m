Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDA43A0B3E;
	Tue, 21 Apr 2026 08:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776761358; cv=none; b=gAkjnMaKkYpEOPG/fF8P1prhmIuuxvvDrIkMCffy+GZXRv6+QcTtNbiVPOOWsGs+kOFvdY/Wrx8QYkDzBJipkXSmFPBg9aZO/HtCNq046TMV9MUx25tpCPOyVGGzdEMXs2jJhWIg49fQVbVWqU4AxcoPTP+wx+IRQfTmZoTwziM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776761358; c=relaxed/simple;
	bh=nAGTnFrTd2DoklRUR8ylfHdcOgPTlxhS8rgGFnmx1GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=geKGJMZP3X7rcFQyanhm2Hte+qS3XeoP/z9cRdcVmN1iPiT55yWiRjNGOE5fIj1gL5b80OiNvvJFOTIuYSviuvKywbArbqdaoiMpLV/scGzEuwAuEFmbUMq0YehfJv47k3n60SWeK7fRlb9y9n9rX6IU+FndV11h7zD2fzPC/NM=
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
Subject: Re: [PATCH 6.19 000/220] 6.19.14-rc1 review
Date: Tue, 21 Apr 2026 08:09:03 +0000
Message-ID: <20260421080906.24587-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.19.14-rc1-gd5ff99d1ccf4 #1 SMP PREEMPT_DYNAMIC Tue Apr 21 07:51:57 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
