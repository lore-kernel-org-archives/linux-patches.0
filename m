Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18AF23ABBD;
	Tue, 28 Oct 2025 13:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761659678; cv=none; b=o4lvXe1bDLOMa06VSNvogpREO6/m9LweJ6OT4afLXlReE/3G6+faasg4VgDqSV34iv2bjAD9KoOx+kmMlNTlwWPfsoxu9OqftdrZxZKa4R1EuNGsXkahoT51afVjAUZba3jUq8dFy4De/uzZf0dGBFtlPmUZmTFZ4WF6pO+mNqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761659678; c=relaxed/simple;
	bh=vxnkxHS4UhybIza7ZGYc4jPQp+7CMWNT2fpizBhG3ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCEHSPjkLbYu1MsUQHZ1AHdVlZe2fwIdWaSKxcQqQeuWKwESX6BPHjxxprSHz/SouRD23mHI2tqQSSQsWeDbkelgeEMBl47YIR2fKcYZwIT8TuxUIwpxc8v0svLuiwMPHBD6ITt58NOx4SFDYn+WZC68iK9UNj0WuNtXRuU+nSU=
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
Subject: Re: [PATCH 5.15 000/117] 5.15.196-rc2 review
Date: Tue, 28 Oct 2025 13:54:27 +0000
Message-ID: <20251028135430.3967-1-bacs@librecast.net>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251028092823.507383588@linuxfoundation.org>
References: <20251028092823.507383588@linuxfoundation.org>
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

CPU/kernel: Linux auntie 5.15.196-rc2-00118-g59a59821e6b5 #122 SMP Tue Oct 28 13:37:26 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
