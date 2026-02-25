Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADF32E0B58;
	Wed, 25 Feb 2026 18:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772043551; cv=none; b=hgIhepM9YhQWn/lc0a8hx5OAI/66Kaa3WeIG6ybJGBvI6lCM1rcp3S1iwKYzoVh3OTuxVwfJDn2PY4eUa1I/Drum3gi34BBke8ZrMpGpGNHsdN+sanblEq5Z0FLEpFTWNNmK6qc2W3ivla8tKuSkQwHNT9X1clIx47HBsI4t/jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772043551; c=relaxed/simple;
	bh=4k276wPOyFXdsyPYp05HxRqQNqhJzPEFaTKLwo4Liuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ejbnwyn9AVRjuZmtQNMp4ljUbBpnK2t+P2RzVWBkWnXopzn+ftTePu2I/MgebinnRpmvt2w61cvYu/Xe7jZkQcivgLB2PZLRbSaJQNOyxAZRCDpGyjrsIpQVzq+pwoLKhhiC4xMHmRa6rQAkULT081iSW8KbQLQK07QwXmcSMJU=
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
Subject: Re: [PATCH 6.18 000/641] 6.18.14-rc2 review
Date: Wed, 25 Feb 2026 17:34:57 +0000
Message-ID: <20260225173505.28609-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260225151847.709818960@linuxfoundation.org>
References: <20260225151847.709818960@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.14-rc2-gc807dd8cc630 #1 SMP PREEMPT_DYNAMIC Wed Feb 25 17:27:11 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
