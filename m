Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CC54503B;
	Thu, 17 Jul 2025 09:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752743529; cv=none; b=FR3bf9oOYK9jm2HE/L7k/2yXNf9LjWOEnYR2+2gB5p44Z6WtEekBu3nGaD7k6TlNtmAzfjNmrFBkFXUthPFtzH7UhhaopuU1tKQuHqoXRVGGww8UfVCiFQEPSxjiPrApKmiDeslzH6SjmPC89LH0dcuGYI6l0JE8vCg5kkyt12o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752743529; c=relaxed/simple;
	bh=F4YP9KpZYWnrCuo/lFtUpt8MzBWtKkUzv/nZ72/r3W4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKJ6Z8kehw9aaQkgzheFqca36qW+ucoNPCxV9kpSQxXBlTk6Zi26V5WQ/m4GDBI3iRGCHCOqacAEK0r6ukXt0/Z4Zw+kTZt/pl/w/2u/RYx56CrgIi3oJn3eXAGENt9YRyyGaxn8EanneLh5zg/y/245F2647FhEELHKNHYlIfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.210.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Received: from [2a0c:e303:0:7000:443b:adff:fe61:e05d] (port=39092 helo=auntie.gladserv.com)
	by bregans-0.gladserv.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(envelope-from <bacs@librecast.net>)
	id 1ucKel-0098Nl-0u;
	Thu, 17 Jul 2025 09:11:59 +0000
From: Brett A C Sheffield <bacs@librecast.net>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.1 00/89] 6.1.146-rc2 review
Date: Thu, 17 Jul 2025 09:11:42 +0000
Message-ID: <20250717091141.28263-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250715163541.635746149@linuxfoundation.org>
References: <20250715163541.635746149@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.1.146-rc2-00092-g33f8361400e7 #18 SMP PREEMPT_DYNAMIC Thu Jul 17 09:07:25 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
