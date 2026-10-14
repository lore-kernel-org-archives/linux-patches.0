Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E96E5172DB;
	Wed, 14 Oct 2026 13:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791984061; cv=none; b=E5Pyi4bkUfuLDFcmjXgHO+sQj6Uaj+B35Gcn639PoXmFoXgNVSyDW2DXAT4a7sI0Hsy6CkTFc+UsGI11yLl5SuLsEaYwHWDm0w3OBN4s1PHuWWC55/7G1TpEsImuzwoBioel+Q1Cno5UvgYCoFt/bq6W+rinSWUSGSE73QjUPoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791984061; c=relaxed/simple;
	bh=w8X2W2B692JD6UwjfQfBnREY1pOVvfAsEdEHcGaTSeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJr7VuK4cUWezH7nsSLexK5eBNaJ0V/+MPO9NH7/yL1yEM0b+dVKIAWAxf/dtJO4Znpeb79vTWoC10tM7HoyTYw27pWfwwa1w9dlOwkmsIA/3DhPTm0meJdr2UF/yHCZ2ezWmCANBw7dLnFohu1XzG2HzmK4h/ib0y6x0RqL1Ik=
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
Subject: Re: [PATCH 6.12 000/505] 6.12.113-rc2 review
Date: Wed, 14 Oct 2026 13:20:43 +0000
Message-ID: <20261014132047.25800-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261014123803.944920639@linuxfoundation.org>
References: <20261014123803.944920639@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

044/044 [ OK ] liblcrq
010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.12.113-rc2-g4a8beb0f1e36 #1 SMP PREEMPT_DYNAMIC Wed Oct 14 13:11:01 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
