Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792839539;
	b=eH+B8Opq+/brlzwezw6iBJVUuAWwlQK2Dun/f66TvKetA+j1pxLx55p+lP4jI6pF8W/z
	 gF/DA02gZlewH9BaEUL8whnFjdYnpKxU+c+1UOPXjxulv4YPJP85fpr3QAxK2mN//vLgI
	 QBuSq9XFg6/IzF23dF6wTtvsvIA8g7YWmMSsIn4ongnTCU3aCz6ppgOWa48JV3H3b7b3h
	 0V31QMHedUavg5N5JDADilxboZ5NufsFHleJ+VvWi1PAS36GDc64r6ox0zcq2mSXEy60E
	 KVU7wEEljdqLb65eq3BKbGcccF7Qv/yGwRPmX7DPeHPv6kgK3AxNe3w0KIyq3krwxSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792839539;
	h=DMARC-Filter:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=/lutylWlnckFEMU4DjHCntHI3zB9FH09pgUUECUCPaY=;
	b=VRqNt7QgM7rSidnDTzx3wImWoBxjf3YP1Km818p7xckbfxOZH4MVZCSvGQkWrPD1L17S
	 EkUGmaUD3hugfUX0/b/TX9qy2gHiwYwZOYtWzg+A4t2QP58Ubgxhg3kLeAmiGlcVtuly2
	 QJVy+vIeAHD1XzIR6PO3GhjR7tiIlpKqpxl6ihgMt+pgCiekm8BJ8iaNtjccaLhs+xtwV
	 qHHT3BwrFPvC4EaoO8s1jTap9wYQgkCr2W/6OLayHvcPfVxlxnPFJs+cZ3IPY8s3T+SCZ
	 8zh+Y68lkNRbOPXvweIXnZLfRhouEnn5aWis0y4QebSVmKyjyGf9j6T7rFAJhyM2biQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03728606A31A;
	Sat, 24 Oct 2026 10:58:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03728606A31A
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
Subject: Re: [PATCH 7.2 000/243] 7.2.13-rc2 review
Date: Sat, 24 Oct 2026 10:58:42 +0000
Message-ID: <20261024105844.56900-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261024064731.125251200@linuxfoundation.org>
References: <20261024064731.125251200@linuxfoundation.org>
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

CPU/kernel: Linux auntie 7.2.13-rc2-g7694d244b4f8 #1 SMP PREEMPT_DYNAMIC Sat Oct 24 09:21:34 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
