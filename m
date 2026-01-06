Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6647534F46C;
	Tue,  6 Jan 2026 19:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767728958; cv=none; b=IpBCX8Gm2fCh1HKr7/DBK+oFcbLpXSUyJVnJYk85kqfvR20FKOPig2i1j7/yUjpuIsOsSKzSl6bHznXigR/26Bs0VIjHHkl7xsHNf1d2Afx/oUul3G0jAciooFoM8YALUzfgoFj07ip8x2Y4kMlnSba28rnN8YjiCiYAiqSoL9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767728958; c=relaxed/simple;
	bh=GvGwm+rHNaX+Tacj1bdC+2Ju6gamvhWLle3s9/BNx0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbcRNINeYGIRiunIRT7ephdj+cyrcqqdKc032kxNrNFC8uAG7xu1I1+PxUtNaDPuu/ZFPJ366AubO3rKb3lxZztCh1mUl3ua1Td2qBocaheh/NjQe7ooiUNZ4J+FQhXlKMdVmuBQTx+wfr2tsjTbUfv9AIP1h2xQlR+8SMJOwmM=
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
Subject: Re: [PATCH 6.12 000/567] 6.12.64-rc1 review
Date: Tue,  6 Jan 2026 19:22:02 +0000
Message-ID: <20260106192208.27730-1-bacs@librecast.net>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.64-rc1-g98ddcf2ac4d1 #1 SMP PREEMPT_DYNAMIC Tue Jan  6 19:09:11 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
