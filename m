Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE86621B9DA;
	Sat, 18 Oct 2025 08:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760775012; cv=none; b=n1wqKeD5YkIKUiHACsxwxTxFYTAuDKS8GX0VMjnldqwyOYehb3hmMEtpmw54KjJrHYWq4n6wXKwTAUnZIqMv8bpACbGsK6habdj6Lx1nQ8NjRvltFa4wGLICUTtCkv8TMp77BZwRSIFbK/gYMvlM3NjrZEAbXmLjgPtcXZKrF0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760775012; c=relaxed/simple;
	bh=64fpil/3xJ852lh8uAvA4y2maUrZIi5EFJUTecxCRnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RyrGxJBKnzuob4VA5RsJZMa3LodAOBRE/4ojsJ8fgmrgw/kwKKw7zhxVV1LLwUiVC9bBT0wcHwrbDLJPmmvvb6PBw0UzhER4hvOiizdjbkro2ZG/aMQ5VJ6AG1jCAZBSsfN7sWxqdDj54eNFCTNGvWyOR7Uaw8oX1hUY8Yebq38=
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
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.12 000/277] 6.12.54-rc1 review
Date: Sat, 18 Oct 2025 08:09:41 +0000
Message-ID: <20251018080950.4322-1-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.54-rc1-g6122296b30b6 #111 SMP PREEMPT_DYNAMIC Sat Oct 18 07:55:01 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
