Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107B42EA172;
	Thu, 27 Nov 2025 17:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764264582; cv=none; b=XVP6bRZgMMdb6TERR7MMRBnwAjorcpIk9KdNWOxRKivpsRz8PfJ9rg1a1e3aKVM5nUd6YKYSTRhe1wLpUQo/SsglFXm1fwEO+Z4WO+/vxxxu+fu49JTWfyvIIP/YBPoaL/5+vXNszlvIiloRjcy3gSvwjy1o+1rwyWetlqgC1hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764264582; c=relaxed/simple;
	bh=S73fBykKCzftcyC0Ar1+V4PY3RSAIUFL8DtEHNXuO5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/jv2hX1vnIL/k5y4HjD1vDDG6Y4clMcKl2llyLPP90rNwVn4dOzW6J0a/XSnbd8l3SNttfe7aLt4cfjitEaDEO4rbpvZqwbKuIms0rxASpIRQ4j6mM2UeBAma+Z8GtiyZqaUDqRMaGRCL9+TC22eZ5cqt0UdNdgPVABu06JAVY=
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
	sebastianene@google.com,
	will@kernel.org,
	maz@kernel.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.12 000/113] 6.12.60-rc2 review
Date: Thu, 27 Nov 2025 17:29:25 +0000
Message-ID: <20251127172932.9824-1-bacs@librecast.net>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251127150346.125775439@linuxfoundation.org>
References: <20251127150346.125775439@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.60-rc2-g375669e5645f #134 SMP PREEMPT_DYNAMIC Thu Nov 27 17:19:24 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
