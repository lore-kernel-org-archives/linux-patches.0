Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C583D413F;
	Wed, 13 May 2026 07:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778658116; cv=none; b=e77fCYvTSQLmt+tk5TS/DMu8DSvAdueVQxUR4cH193jkJNAt9p+3ctwMMxnRcdDeyTTxASidTv+PIsvT0CJkoJ8em5XbwFy/6kh/Zhu1ipiYP03f/Vtlggc6rXLn2FFMAx0PxgU0csKvks8MPJrOHgpFDNaBlbTHZQ3IcDHb+GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778658116; c=relaxed/simple;
	bh=dcBNdQ0aK5o8YT3K1Vvhv9+kz0aKZWxGE3cAD173jdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2wITtM7AcgBc2vRynQiR0n5G5M0KAJ8juSAHojgknclg+KBTCAeBg7e/McvO6U8iwfr2xup+FyLmmBi6k7Gl17VRIIY/fo0hIchNyhFgkQP/f+ZVHLGXQ4fVx8o4afjYkMHND6cf/eWs3D+Qr+sjTu4QsbqXSf9HmsokJdnhR8=
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
Subject: Re: [PATCH 7.0 000/307] 7.0.7-rc1 review
Date: Wed, 13 May 2026 07:16:07 +0000
Message-ID: <20260513071612.38320-1-bacs@librecast.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

CPU/kernel: Linux auntie 7.0.7-rc1-g9fd19ccdb6f2 #1 SMP PREEMPT_DYNAMIC Wed May 13 07:11:13 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
