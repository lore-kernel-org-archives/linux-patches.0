Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211922264CD;
	Tue, 30 Sep 2025 18:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759258341; cv=none; b=Ic0aQ6vGw2bHEwBbEs3J+9cBp2bEdGb0skjZY7b+U+jBiNwcYFlkNp9vPy11JXNHmrU5QRrHNYp4uMAeOReL/BDJpLF9+CMd4qE0eH5PYTTJlesv/3FsHnNOOZDrf3p733PbvjEGAocmZXoNO5PaUTUSC7zVrDw0rQKkbjbt8tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759258341; c=relaxed/simple;
	bh=0qOeA3dPrm7aSqahvF2nTWIMG2nA/ffG/n6HODb4pW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tr+PQNsyPpLmoC/p9SOH7Fx2SaqYKB8cI/kX34XJ3ljfxXGzZZBB+tnTLpLBnd6Zc33IWGQT0qnXcmFz9TnQ2jvVrWEV7V3av6MCESsyawzbi03VC9fltpXK5nNGOpgVm9PXLCZ5USUCXbdvm/G4z5lJjWnp3PC1vCXzgA0vfxk=
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
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: 5.4.300-rc1 review
Date: Tue, 30 Sep 2025 18:52:05 +0000
Message-ID: <20250930185210.4041-1-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Build and boots without error. No network tests run.

CPU/kernel: Linux auntie 5.4.300-rc1-00082-ge1a2ff52265e #97 SMP Tue Sep 30 16:08:47 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
