Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B54522128B;
	Sat, 22 Nov 2025 06:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763792338; cv=none; b=fhnuKlbe9xScdnz86jqIyuIr0+yDbBpZfq1xfn3weBr/fsJnZHkVWJS3Ev8gEBJtKCwt5JmHhx6qJYHx5iGLsg9iL67Q1Iy4FB4OjPTrsUmGNEMbaOKg2wqEW8SclWo1z1kYh2vJ9rWdwb3EvoxgTJA5/AfLn1tPMJuWfrozF64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763792338; c=relaxed/simple;
	bh=DpZqZYNX6liv59eb1R+zjb+I1o/FiaQW52oHh7Yyvmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BU4XfhjAyWTx5NPOlJSLcMLargLOFhWsqw9eilUM3QnLntrpkff9dF6xwsJlHKy0n1h0d/4HqcEj9KYfP6GvvrvV8vdPH+LGeimue+0yEEam3Ls9WqxjAEzqQI9yCcK7dOhBIkko7MrSUUI01OLyeORJzEbPpsMWtubXXThr5TI=
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
Subject: Re: [PATCH 6.17 000/244] 6.17.9-rc2 review
Date: Sat, 22 Nov 2025 05:52:35 +0000
Message-ID: <20251122055242.28681-1-bacs@librecast.net>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251121160640.254872094@linuxfoundation.org>
References: <20251121160640.254872094@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.17.9-rc2-gddfe918dc24b #130 SMP PREEMPT_DYNAMIC Sat Nov 22 05:42:59 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
