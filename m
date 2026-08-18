Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C3E476689;
	Tue, 18 Aug 2026 14:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787062003; cv=none; b=LQtNtzJuoTfYzfGYAE5Iao8hSIhXTtCqe4EXutxobETQjkrzCjrCV0b/TNctK3J7YZ164qDTgqvU/4bLCE3u3g7Sca+5flFcYcrH5DVfKaM4BkcQjZCKhk4oVaul91k5EXFaMZ7auPnY2B+jMcWNTX+CO/dtYxKfJPr4CQoNjxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787062003; c=relaxed/simple;
	bh=ngszVkrpLIdNnN3del5LPPM/sDAgWmzINKQpb6T17m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+wNllNX0d0K8sn3d5aAMen5M2+UjNbj1L3O5GwqB59T1hLDb0XimNF50b6vSnIvO1vxT0lg17mBDGCD4P+ssutWeXZj44ytnVsW3t83Jwj0Qp+bpCqWyigoo63R4ZuEYSUMjJxbmsDQi4cHWlSUBxFm2TQ4qql4uAOH6XFnOds=
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
Subject: Re: [PATCH 6.6 000/156] 6.6.152-rc1 review
Date: Tue, 18 Aug 2026 14:06:32 +0000
Message-ID: <20260818140636.30929-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.152-rc1-g9a239823f9ad #1 SMP PREEMPT_DYNAMIC Tue Aug 18 13:55:00 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
