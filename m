Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FF8349AFF;
	Wed, 20 May 2026 17:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299207; cv=none; b=MTl5QPXiUZOLXUS6LvExId2Rufep/GZpRly6KaHabs+JQZ+Mcl+EP+2T7FR3myqnA5OMZVNbJbniWXgcEbz5HNlW3P0HojPysCj1lIGNaxVWLm2M+wi4qm0uLUcd4gmkNM4JuqbH0FjtCiL3/suOE7GehHOte4kn/13RlmNVZ84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299207; c=relaxed/simple;
	bh=0jDE+YlCM/r9UGoCf+vCz+RV2dhfTtMHfxTKng93vLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDbLfunhg3sJfJ91voYCpdNZn3HIHNFsfbPAmuhUaCgfbM+2KekD7hcHg2yhxqJ+ooq+KjWfiiva4yFMM38a2iVtGpU6Q2Fbh7Q2yQW5DILJbYAIblufNmz5+hG6A9n7NbsMruiaPfX9dmoBvseS+os/ojtUwODD2AfR4ysM1EY=
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
Subject: Re: [PATCH 7.0 0000/1146] 7.0.10-rc1 review
Date: Wed, 20 May 2026 17:46:22 +0000
Message-ID: <20260520174626.3230-1-bacs@librecast.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

CPU/kernel: Linux auntie 7.0.10-rc1-ge79d5c5d57c0 #1 SMP PREEMPT_DYNAMIC Wed May 20 17:33:37 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
