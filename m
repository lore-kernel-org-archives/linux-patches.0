Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9002A272816;
	Sun,  1 Mar 2026 08:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772355270; cv=none; b=dlmZKQCYjrV195qWeS02Wk0T4N8HJGbHz6dhO4olNd8xteqAXPcLbIzGRpPzPMeSA+I56rY8PLLLdcfePt41zLCLl81zYWYedCMwNhA/6frM7jLrIPF3Z/mZd8ko1Jlw9niIF+5xx3oxzVmhJRKKsq38z6euMlcFK2U/RwqpN+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772355270; c=relaxed/simple;
	bh=S2UrMywiVW4BXpCKNetBjCXXZyYmTqhGYRftUJT3A14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DV8Fgn83S5YbbdqmnyuCGQREAAB3zqR32e1xb6gLjjA6KiuprB7jBdVlj7CdqLdsAdX7CuEeIamkF8auRo0NueRna/GQuhWkwI633JxVCXSFtU0F7Oln/eU2ZWcECm4kweLIl4gokjfypTdZLLuv2Klnkdo/g1qRJ1E5boG/l7I=
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
Subject: Re: [PATCH 6.19 000/844] 6.19.6-rc1 review
Date: Sun,  1 Mar 2026 08:54:20 +0000
Message-ID: <20260301085423.21780-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260228173244.1509663-1-sashal@kernel.org>
References: <20260228173244.1509663-1-sashal@kernel.org>
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

CPU/kernel: Linux auntie 6.19.6-rc1-gbf28ec292fb6 #2 SMP PREEMPT_DYNAMIC Sun Mar  1 07:56:57 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
