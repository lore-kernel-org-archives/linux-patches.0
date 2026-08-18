Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE323E075F;
	Tue, 18 Aug 2026 14:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787062000; cv=none; b=r3no8NYv3R6dZGk2AjXcZKO43Gd7mH3WPq+H2GzyZCwVgu9Depq8Lgni9gaoBK7PTdIfw+kXG2Yq3SutQ4PrgEiimZ+Cf3/t2odXp9NBqmFrNwV5EwhE01OjDzIxmd4mQ1DqLUWry8cOPr0VSgfCDAqEmwlE1VAjiuC2QICTvD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787062000; c=relaxed/simple;
	bh=tbSpLyyxjzChPmJNZdpPQBABvZo1/3fir4xjafjiGQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzN+3RX4lRQ3JHET1vxWtqqdhhm9aD5q5JwXXqR1KT4hos6I+BF/1O1IdzFHNNPJYFioi76bekpza3DogDH21Ppy0fr5ZinPJDvWu+1oPZwURC/gMM/+P98wqVY5aEWbSoOhaF7mh6c8eR7ZyF4bWc3L64sq9CIXnrg3+sJF8CI=
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
Subject: Re: [PATCH 6.18 000/250] 6.18.45-rc1 review
Date: Tue, 18 Aug 2026 14:06:26 +0000
Message-ID: <20260818140630.30890-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.45-rc1-gbd7005a98dd1 #1 SMP PREEMPT_DYNAMIC Tue Aug 18 13:40:55 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
