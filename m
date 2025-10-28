Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2ACB221F24;
	Tue, 28 Oct 2025 13:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761659630; cv=none; b=Nh1L4E25UeHGmr7/e7+dXBGANhrIGnNJw874CKVvBZnaJkX3tiZWFeHMxSvhxZlBn369xiQ93SOKSeF3DcbiLZQxwzN5gOxyVJLNyKFonkP2mjEqL79Aa3kz4XuIoHTBTy7+SeMQeLxsE1WfNOCAau2WyhsUto9JB+I4zea6oIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761659630; c=relaxed/simple;
	bh=B7NETypyi9TGaKpyw0HAWiIiPHQ8hwTEHufUGPGXiwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BU+WYMO0rnYbX0ahaRgZz8jEz/3KJ7PeZVMXK7q/r4fuox4l6E8fpQKDWWah69xuTAz2rt95uBN4XaVr5l+kUyK9Z4nMMnVLOu7dneSQu1Xx7HwiN931NSLLl+NHWxd5hbcQx2KIV7oNACjFPHnhlq9Ta5mD4Yt7tf0egvOHLOs=
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
Subject: Re: [PATCH 6.12 000/117] 6.12.56-rc1 review
Date: Tue, 28 Oct 2025 13:53:29 +0000
Message-ID: <20251028135331.3795-1-bacs@librecast.net>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.56-rc1-g426f7f601ca0 #119 SMP PREEMPT_DYNAMIC Tue Oct 28 13:28:43 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
