Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DE3DF76;
	Sat, 11 Oct 2025 16:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760201788; cv=none; b=V0d6Jk00b9+cj4tafXOWYpohzmxBYG7fAK6Vost3rfd02YZCW63e5XK/7XD7ebNqNJgJvASPhwRINLf7kv+Whv9et/gmavXWvhEYTDoiEWzjIsm/DNR+2FelZMkvH/OAOCwUuH+wey0neP6x883e8yskOG7Tq3In6nE3VJ3gP7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760201788; c=relaxed/simple;
	bh=g9IfGBbGiEP8z07oh8zuug2pWLdR8im79mLNTEub3wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jhuop7o1IaOgNygDLUVEdegSC+pCvVCiBt+xdvYm6eWyCrwwYe8++Z7FFGIHbyjf8ZqwT774BcKHmtBRhGYji7zMJS+4sNCk9S2hbRCC7IwAPSn+YFyPXEEYEuXcoMcZAOpbnq45hE+00k8iJLZ4FGrEIQaH+jaZtZrYq70lg7I=
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
Subject: Re: [PATCH 6.16 00/41] 6.16.12-rc1 review
Date: Sat, 11 Oct 2025 16:56:13 +0000
Message-ID: <20251011165615.31073-1-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.16.12-rc1-ge006d63d59f2 #103 SMP PREEMPT_DYNAMIC Sat Oct 11 16:53:44 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
