Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDA748F833;
	Sat,  5 Sep 2026 12:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788611293; cv=none; b=pCFgy+cuVtHkfEHZ/Vnxj4/FOEv1i0mEaw0LGa81MOZ0Jv0VIU8bf672hPzuGMrz069TtvnpdAVda4GYl/oyRBqyFnFdv1xZL2SSsV4wWsjZ/jWjKA2aHTmnuaPqnVY6E/uIDVYzHvZVMVRcJlGgrkzo3MSgnJmOb6FgT7QMXEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788611293; c=relaxed/simple;
	bh=njOsJ/KsiihArh/rFlQQwvcSYxiU0Q+wxXMvDhnsLRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTl2nsKVA/bDiTXOmhdzAwe9KWGEP/o0AlBY6zoP5WGTmIdf1+TdDU2BFaombQKkuqOQUHOJXGtBsB3K6GKr3XBNaMOScZyYGDwXjxhwdiYnUSrxaLuPVvZmBUlxU//Sz76AEBWQ5r893xBpIUG7zL2Q9WByMF6cspisKKn/bLk=
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
Subject: Re: [PATCH 6.12 000/400] 6.12.109-rc2 review
Date: Sat,  5 Sep 2026 12:27:31 +0000
Message-ID: <20260905122749.105040-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260905115627.670276262@linuxfoundation.org>
References: <20260905115627.670276262@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.109-rc2-gffa41b797906 #1 SMP PREEMPT_DYNAMIC Sat Sep  5 12:09:19 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
