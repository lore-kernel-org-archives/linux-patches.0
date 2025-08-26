Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737922F0C46;
	Tue, 26 Aug 2025 17:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756230889; cv=none; b=qtgqk+o/GZlh01IZAvyHEKj2xUpH7BycQlPWzplSmxKQKZ+xORetBaDzKu6hGnhEwHyJQtQAT5+ZKi5dW/ozBWasRMcfY745eORbI4Bv/LyzXJldUWftWtuWtHZb/RpeqMlArfUH1O3ODRikhCBFA7CUjUSj6B4bbVYyU0DKotA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756230889; c=relaxed/simple;
	bh=Gz5rAgOB5ugLA+rxTxWr2akFpN3bg43hniv8kuYs1sU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfKoixUpi2Xjqu9lNaapwE453VjMR2NpmsFSgTMhCQq+Oyvc6KyHjMOYMtGDKMikR0OZiSMKqnjgZV07d2qgfs/t1MbmYmJX5VZnl750Pn86l0BFUP0oNbfWpdO2/LvlZBYTvWtOcgKrTyky48aNrnSO0UdUvZmpKgTujLMhGTE=
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
	srw@sladewatkins.net,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: 6.1.149-rc1 review
Date: Tue, 26 Aug 2025 17:54:17 +0000
Message-ID: <20250826175416.30202-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Upstream commit:
9e30ecf23b1b ("net: ipv4: fix incorrect MTU in broadcast routes")

introduces a regression which breaks IPv4 broadcast, which stops WOL working
(breaking my CI system), among other things:

https://lore.kernel.org/regressions/20250822165231.4353-4-bacs@librecast.net

Mainline fix pending.

# Librecast Test Results

010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.1.149-rc1-00483-g3c70876950c1 #51 SMP PREEMPT_DYNAMIC Tue Aug 26 17:19:50 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
