Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793895442;
	b=Jj8Mmu9c5ECTbng7gCPqX8+vOi1Roa3WlMkeQpIs4aKwLGo3Hkyka+JfFt7U2fqZ/6je
	 egCcfYWVcIyPz3H/I5767UMgnAn3kG2LZ+lFQ+iCt6i4NCQY1XNs7/9ivRtD7blb9DVAp
	 v3RffAMZvbNMG0X+6LNxLEB2aycLKOzGGk3b3vqwMpgJqrFboaPAsDV0kTPmpvlATsFTU
	 D5zgTcadTMyMXnqmsUIob0uc+H/BhKvZEjOTOmQmBw7TKwhJKpJIVucAq6ufYr67A9NSm
	 ggSu7vaT6rBPylGpduppcZU6z/3uXCDKBtgbzBn0plKbplmYG3b2t3rk3NbR9YWwKzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793895442;
	h=DMARC-Filter:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=aqbpb47X9W88ZzJR4OfFVG2nvpjumhwDX9OcEgJezm0=;
	b=G6f3FipSnFIqpGuX79mmZHVRM81e97+k57kV99YDHJFNKIuuKIYfLkrMI0VPJr8FTF1O
	 ohOaY2gSd/evh0QFcAOFtGXrK7bCuvMA4pmK1s0quoWD87zmBqbbBpreU7HWzGhwFuKz0
	 Jn1OooIC++Y1+bbT5VNO9K89e8noLt8SIqPJ7L2gp9414bdwdebpK/vOMRrzNO9Hi9N4a
	 X6W71yGYnRvlky0Ff93oPOErAC/tJHVU9ByV1kDbFco9unZ1JNOtLkNBSbR0bnb1nEgjr
	 /5N8rk9BTgrG1KyZbXoCObfgwN8v5yeGdY8eVd8oG92RaFz8aHjjEBPcmpJ0QLMN8hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5248606A328;
	Thu,  5 Nov 2026 16:17:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5248606A328
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
Subject: Re: [PATCH 7.3 000/547] 7.3.2-rc1 review
Date: Thu,  5 Nov 2026 16:16:55 +0000
Message-ID: <20261105161706.35372-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

044/044 [ OK ] liblcrq
010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 7.3.2-rc1-g75eaee7a6465 #1 SMP PREEMPT_DYNAMIC Thu Nov  5 16:12:05 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
