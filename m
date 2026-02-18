Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD9133291D;
	Wed, 18 Feb 2026 09:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771405771; cv=none; b=lUHN6qKf9N/AaDHLz+wZ7fLC3JWbm8du9qZdaJC+U4QswPZwnVpKHAclFuqrnsy30nDYxSbbJ8yL008EzjNjA+OZeByzDif5ttXXH5qRBKzPiEwatr0iTcsW9HWz6HSjyDW1dNSQeJThkN5A5APAwP+FnSL7ZLj/Of7sfbYaqWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771405771; c=relaxed/simple;
	bh=Z95rRS1ajDwZTmKokgzx66LosNXALkNAtasrpzP+qp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjjAwuwiNEyNzem1CnUq7tbbpixp3Ss81suzvkGRX8Y069amL46g2fBjyVIqphB0ExFzl1rsVP9xu0SigAlMgZL1e6+7lIL7DZUT1BCz2QHq1PKH0u3sMmjHfwG7LBEY0JtuxtIIqKL1qgvqkmJdiu+mHw2SoNTRVYFsF4/M8uQ=
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
Subject: Re: [PATCH 6.18 00/43] 6.18.13-rc1 review
Date: Wed, 18 Feb 2026 09:09:19 +0000
Message-ID: <20260218090922.9720-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
References: <20260217200006.470920131@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.13-rc1-gbfeb67747626 #1 SMP PREEMPT_DYNAMIC Wed Feb 18 08:30:25 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
