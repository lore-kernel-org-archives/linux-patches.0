Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795161875;
	b=JrWFCx2zuPMI80p/ySBKNn6AewFnEdf8rJa7zvMVZAs2JlrIiywrsaZz/3sbXTFO4GmD
	 hpLqwp0bh7ldqcqHmqVQQLUUjNBC1J6GffXSd0W1khn+XJJG1vbnwjUNHia+trexD1fB1
	 1vRP7mmt2QVhiYHMHqQnRh8AqqSxLZ3AU7o27jJZnFlOf0q9xvmS1oyT46wP5wJ6Iw5Ze
	 OVUavWvmAgTGOy3HVUVfo0qK9SZ7SZ7AFVaJz22xQvqqzekvBUD5Y3WbXjseUd9ftpHDy
	 F8woCYg8OHqi/IzSOe3N6aHoiNz3L2mHL1p+rTfR8zzw0hiNXuW+ENKaeIO+mJLftpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795161875;
	h=DMARC-Filter:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nP0xTJ/LQBakwr5j7aQvO9TnamkmC7AKtSnfi9q79P8=;
	b=TIl+xxE+4L7VExTcMAxt76lSNAXP4fCyJkF5ZqTALNxnQgGx82rHJtuuRL9p41Z3v+pB
	 BOWdDbNUMsSP8sM05OTShjmnjLljhFMA0t7NvCjqEqmI6xRsZtFpBl0k37ZkpzacpgVv8
	 pFGLh8qPxzt2cogXo96YX7eQh1Lgndv4Z2/TIOeIKOZmAfZ7Ngy2MFGIFyKmfGBdCQizt
	 KcdnPA1LMLtl+imEoRRfrG1VhOXadx+/xfHDT5mJNRQqfUS5DrdUJNHA1Fj8iSiuhr6tC
	 GlYMqMI7cL3G1SDQO0+4niotn/0q52ot/5uIPud7xSOgC1HyHuib/67ylTJsJiBwe5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=K4RhyFuV;
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F8860A2614;
	Fri, 20 Nov 2026 08:04:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60F8860A2614
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=K4RhyFuV
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=nP0xTJ/LQBakwr5j7aQvO9TnamkmC7AKtSnfi9q79P8=; t=1795161875; x=1796025875; 
	b=K4RhyFuV+FitOKOge66JXk9/dcAOcnQm8UQAvyy6gsDUuI5MlTi74fOwhLAkAvRedMGz/lySJhK
	2t7a4/VbLyGWI5TF4lkTBqUnQtAO1JaaM4RAdb3t3PIvqiltY2QPv1KruPKS3JyDb4iBQ+INUAVKp
	7pI/g8qUo7Y0zB0487wSRonbRC7mfA6NQ3kwknsWIv/wOTrpHZI4rCZCAgBGYovg2S/gZyoNDE9mj
	1HUPEpih6VEouP7P/FZdcvuzubHFa3t1mfgIrhGia/7Yniz6NCXwhgCk4QEVCE/RlLd6+N0sb2kSn
	EfHcXWZZB/80mrBODsfy4gLCnc1pqi2In2OQ==;
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
Subject: Re: [PATCH 6.18 0000/2144] 6.18.65-rc2 review
Date: Fri, 20 Nov 2026 07:55:42 +0000
Message-ID: <20261120075547.27357-1-bacs@librecast.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261120055114.182757740@linuxfoundation.org>
References: <20261120055114.182757740@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.65-rc2-g7e0638af5322 #1 SMP PREEMPT_DYNAMIC Fri Nov 20 07:47:02 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
