Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B116F31B131;
	Wed, 13 May 2026 17:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778691687; cv=none; b=M607TJZp82PGwogceumOw52kqbM7zgPMaIX46AwOPzxNL1n42n02c4DHYDkc+eEEM2bDiac6DX0mYnAetIYL6sqLaZ3BUOmWG2SjX2b1f3DGHvgncPuwccRDxGREpkrvXl92n3ArR1Ntkon5C1b3f9y36lS1zCJBpFvK97bBtkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778691687; c=relaxed/simple;
	bh=qYPkx8TPRJqCOd1ZNT0JT2RXg4DY0VOd/EvikeFQYyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/XiVI1S8I+dvTQnQ5u76ZinZaJq7ssMK3GyF8+m6q+YyiOg2PI0e1YTbPJ8Xlxj38JaxpH1M8pCmNWO5oIUD+qccHQ87RTOOOwmm+gaVhhsWbxpIs7rcd0nawugFOYvCEg6sKrMCLFx5bJQLk0F77k2azer+EQ1IAR4AtNTyLU=
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
Subject: Re: [PATCH 7.0 000/305] 7.0.7-rc2 review
Date: Wed, 13 May 2026 17:01:13 +0000
Message-ID: <20260513170115.19415-1-bacs@librecast.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260513153754.934923793@linuxfoundation.org>
References: <20260513153754.934923793@linuxfoundation.org>
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

CPU/kernel: Linux auntie 7.0.7-rc2-g5cf0eea3bd76 #1 SMP PREEMPT_DYNAMIC Wed May 13 16:57:59 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
