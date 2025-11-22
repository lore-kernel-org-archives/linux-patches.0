Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DC82E413;
	Sat, 22 Nov 2025 06:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763792350; cv=none; b=SLCaN0novMWJdFfEpFCebX+myKsbDnKxMmcosoroDbzH6n/9qNUE0KalelG+heGHA1J7lcqDXJFVtJ2vhJ4e/D4UCjiLWPu2KkKUC+kLVMwkzLSVBP/DN7lKoXgPDGFvFXDb04h0Yx4f6Rre+JZG4COjXnk7CerTKG2bOCr6GOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763792350; c=relaxed/simple;
	bh=aaeaolahhiW/1JCLAbCM0dhlIL2QUgVOkzpVbKlR3II=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XaLuBGjh2BvoG4HB8Tbyayf8wWCqxo94fW42wShRS/Bf8N2SLQniq8DWrGEjyeIjCtizqqOdt/BSMIV97sLOjlPg8Jhgjh6DTLf/o5a2s6FGDlHYiAJC6jrp2Cnu48vzfwroun2qUdtbiOtDCdigE+2TRMzJCKK1mIls46K2MfM=
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
Subject: Re: [PATCH 6.6 000/529] 6.6.117-rc1 review
Date: Sat, 22 Nov 2025 05:53:40 +0000
Message-ID: <20251122055346.28771-1-bacs@librecast.net>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.117-rc1-g69eeb522a1e2 #132 SMP PREEMPT_DYNAMIC Sat Nov 22 05:50:19 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
