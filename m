Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6501429ACC3;
	Mon, 13 Oct 2025 17:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760375190; cv=none; b=rOvQbNi/BWFZhjAvwQRoAcvtllEvXqA8LCC26cs1qvakbMnu0L7KUHr7Z/jFZ2GP3gQQfWZz+l90ECvcypeLpO0lAdWd5qzolmFJRhcvXSqeSnhjZIfzd0BhVcrFOEbUbtMYQB2qy2QTltU39JTC/4UmVyrskcwVqKC2bu+a/yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760375190; c=relaxed/simple;
	bh=lF/huWfDJue8hxuY1R1Z0IIgZ8Vy277xuxGBsAdIIng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZzGaVkWz4lxroesmLWSkARhW6TfJh4PMmlWMliX5UhdJ189lTkkGdD31mobva4ghTfSKjMHhINxiklIuUHLdQARUfWbN4tlGUUhZ5q+YfKjS7y0Vn1061ZVXDKt1PDrZDP5KnZftwRjVfiSewL2P01XC94/SqXNN5cywPwzX3w=
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
Subject: Re: [PATCH 6.12 000/262] 6.12.53-rc1 review
Date: Mon, 13 Oct 2025 17:06:06 +0000
Message-ID: <20251013170611.27110-1-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.53-rc1-g7e50c0945b4a #107 SMP PREEMPT_DYNAMIC Mon Oct 13 16:48:02 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
