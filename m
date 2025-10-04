Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBEADF72;
	Sat,  4 Oct 2025 11:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759577764; cv=none; b=J6lxn7+CWF2QKs13WeKafyD2uW+T+sf4h5JVpNotgx0uey8xH8ZalHQ+9OuRX2IGePyPcoWh8NR5aMQxQ2t+NAfIS714Bcc73LstkmaznY3qc4qeTNDCF1/MFOHQgNql1BooCtPffiw9kgpRQlY9/JabbPS2J5uzU80/7g7aCsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759577764; c=relaxed/simple;
	bh=qW6jif095O8UhMpgjpiAgs0vhW1MhdSpVi0wxP9srlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOUi2I65tLxitqa8ThF9pNUVgrK8p9Id+vLxoUmaCPqV8P+BxHsAfY3HQvT7g37P7cXobjpGBfadKiUASbtezeQNnuP8kMbmVmIVH3fmO3/nvd3sOt42KGo2Pr8FGf7+yd4XP8ZK5ajQLnhQEgN3F+9UAKHE9DDFheARNSZnQV4=
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
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: 6.17.1-rc1 review
Date: Sat,  4 Oct 2025 11:35:23 +0000
Message-ID: <20251004113534.20396-1-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20251003160359.831046052@linuxfoundation.org>
References: <20251003160359.831046052@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.17.1-rc1-ge7da5b86b53d #98 SMP PREEMPT_DYNAMIC Sat Oct  4 11:21:06 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
