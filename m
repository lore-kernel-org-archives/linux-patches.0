Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F5F30AD05;
	Wed, 10 Dec 2025 10:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765361780; cv=none; b=cCaAD0QPlJpCB4H47Zulgb+A0DCfwiCCBRNooSKzwYlvdNrhslModSgJrBovltLIqjhTj+gCU55WLIlpFgjxFTC6aA7NQQUqf3URfrk4JUdhHG/vbAVKDZx8C+8QwfXiaMVEbrJU4G7RHTLsKSmQx3H1YjE1Ur2koz5Eufgb8/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765361780; c=relaxed/simple;
	bh=OaGywPHewF5LTj/ytHizvQMJgQhf+JknAIIN81Dds/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InPjp/9nyUHtwOZZ8LIQU+07wXYa8aJCvp16MTifRkI/QNSy3+e+mFIAwJcDq3aydBI4BfNxmOzpGuIw3srS05TYRlMakBEInY3JRVKfNDjoAdYE1z4AuC8fGDs/ykr3keOvlV4/Ct4tjOJFzFXq2oaLZFzqlCR/d11IfS0GNvs=
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
Subject: Re: [PATCH 6.18 00/29] 6.18.1-rc1 review
Date: Wed, 10 Dec 2025 10:15:54 +0000
Message-ID: <20251210101556.2426-1-bacs@librecast.net>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251210072944.363788552@linuxfoundation.org>
References: <20251210072944.363788552@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.1-rc1-g7d4c06f4000f #1 SMP PREEMPT_DYNAMIC Wed Dec 10 10:11:19 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
