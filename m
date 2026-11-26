Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795693027;
	b=p9IDh0cXlClosBwrvqe012+lTv9yN0sljK5a7a5ZUc1ZduHvf8wQmyXBg6xkDRXfYcyF
	 ZxqUhJQDBCQg6EqJqliaisf34EHagLkw2I90mpZo6SV3XWoHHyez6hTXw5MddUeEnxKvd
	 JKkWzjAsfMdtfyrsR9B/OCch+vsR8Kosy30aOGgi+wTFzCPVd1UhTYk3HdiubgN3hrljo
	 6zPeuWFDq5OAIlpkIB+wjVE0J5gyoBJfmW9ii22EuxWZOY2lNlRp7YAviTnZiVyU+1QLP
	 tFlXxbBaQ/pqmsgEU8HAQK6X5V3foVWDkB5ECwWMsKXIVQN0sZlEeLEv49FM5MJwXaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795693027;
	h=DMARC-Filter:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=P/lcTmneoJa4D7IMzyTg9fRPPCBNr16TDsg9Dcqvi7M=;
	b=4MVnmGXkWVRqOObO5j+R42ezT/dKSOYf4UgtAPQ+J2NvfjShnBA/ofKg8oiNCiixOUn7
	 iexSBlc9IZeoe2YI8T2JYy33EBOQ4EPcZFh9F1yumxg5KHMHREFnIG53n/GaChwBJWzRQ
	 oOKHFt+dU+jx1HUoDJVkH4bkZNFWOgrnOXuzsYjJgZpfeklVcMf7QS/28sDPxzKQWreld
	 8u9Wb0Sd/rPPPpO3vCAbX/H73OJAZeekpvgvphTavq6y3ISlfAnyxvBkAVpqi7E1AigpN
	 0JsryMT37PTFOoaHfEEukCwE54mk4DLbc7utTghjj7/QWbbnINzLhy9HvKTgKMKkmhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=Jz2CqO21;
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2216D606A31E;
	Thu, 26 Nov 2026 11:37:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2216D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=Jz2CqO21
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=P/lcTmneoJa4D7IMzyTg9fRPPCBNr16TDsg9Dcqvi7M=; t=1795693026; x=1796557026; 
	b=Jz2CqO213sIdwr2ek9TlSnMAzKxYpDuotAu+KrdGetdHyi7P+Rfbbg+SqLXaeqcZOG6O+ZzbWy4
	Pe7rsvPXtKGMJieDUuILX/5AQu4p7LLSw2P264mCxKG8yRU6Elut2KcEDWbudewd7FwnIjMVSxbca
	vHqbzYRojiYH7Mmx5kdH7GTXh0smEkrenp3mYHorOxgT5pIv3YogO8sXZ6zgJFWskbP8mdZ35Y0xS
	qBGrEmBmbfZ7en/L2wjvcnB1+8yeGyzs5F99zsapRhCfdAt1XzVhII8LByvOQpkuWlaA+lRm4m0Iz
	73L8bo7VSzD6Ko7wO8uShlxX8GovanmVlH3A==;
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
Subject: Re: [PATCH 6.18 000/990] 6.18.66-rc2 review
Date: Thu, 26 Nov 2026 11:28:15 +0000
Message-ID: <20261126112818.27886-1-bacs@librecast.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126105725.767748294@linuxfoundation.org>
References: <20261126105725.767748294@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.66-rc2-gcdbd1b15b2ec #1 SMP PREEMPT_DYNAMIC Thu Nov 26 11:11:19 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
