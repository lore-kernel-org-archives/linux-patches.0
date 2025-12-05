Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086FD2D876A;
	Fri,  5 Dec 2025 11:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764935354; cv=none; b=JO/pzXaoVJ5BJbgYBJ4Fh/zedmqoteXyG4Dn/efxTZmPbQxHWF/igU5g0BMOZCdBZBGOa7/6vUdU3K/Xu9aBlD8AfXnv8ZtlqczQrvfTUzuePn4ySA/pUJ8gH1GEJ1RvlsAJMvdDevvuB71ASQ1ps/BiK/LopfSoAUdaH+ttSqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764935354; c=relaxed/simple;
	bh=nRaM3As28e2SVV9jUF2fHcsJ/GXLp3XnHxBVBciHcn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WL5qPuHNKYB2Np2a5rqCl0Jkp+gcvd99hT+QvX8lVz1sL3/aVyqpcM/YCbFeFtXoKLRjmEfBvInBOACA8PXQ0jKLgmf92xQuEvPIAs1JqBf5LRRcZpanHxwjiWXE1tMho/Akdej6/kjgdbutAidH2xYAc1evaCV6HPSybW2ApK4=
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
	sr@sladewatkins.com,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.1 000/567] 6.1.159-rc2 review
Date: Fri,  5 Dec 2025 11:19:04 +0000
Message-ID: <20251205111908.2575-1-bacs@librecast.net>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251204163841.693429967@linuxfoundation.org>
References: <20251204163841.693429967@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.1.159-rc2-00568-g2ee6aa0943a7 #1 SMP PREEMPT_DYNAMIC Fri Dec  5 11:17:12 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
