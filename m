Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021281;
	b=vtfpGgVRdxmmlt0WMaJip3WnyGhoPtBbJGGtlvqYhEZNqXt9ouMflKP3EE61OmQ6z15C
	 sYtIUN2weZ+XVJ8JVF55uyhxXF5RoPucz6Uml/B6hPIpoHfYlfmaZZn/t8pX+0zMy30Xd
	 7160GsZ9VQuDKvd6WsdLWXUGWjGra2wEqSgacroiR6CC1JVP8rJt853HJLClFD1tBr1qh
	 AJr7qY1WXzwjQpjPOWMu8+kwljo1wQZJnmtgLG/Zjt+VQr7bqMTF0R6tSNi3rZIy1myB6
	 pjXS3IK8hUECyOuaWwt4weH3M6KB84WLxmyr0brj/o5NdtJWq/dQYQ36NTwuFFtRhmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021281;
	h=DMARC-Filter:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8fc3rUrcD1IZLm8pPlhKV8zX4DnzQ+5myz6UfOSrlPY=;
	b=KAfy989Tph2pEUdBzdeF9NJ9rAyjTE2HcibHnCiRoy0qyB3H55wdO28VQXOe4tsvsOC2
	 JV5mL9A1OWRAWVjPY3BiU+QVykE2Y3EuEqBwSK0U/xLw1vGRkL8t49FMAPS092OoqYq/8
	 9pxSMEfi0AH9ZV12ZTKUkToylYtN5xYj/Ed0GcNy3fZFVeRw5XuYoH8SZGtqq7emxclN7
	 +F+re7e7SZ0RypD2H5W4fHYj4p0DdXRte24jtfwzlHArfCpWdCGIdJVWHDCjF8HkJlZU0
	 RgBLYrP28XaETk+TvgwKVh/rw5aSbPQsIRtVcLokbXx+XRZCu67DbYKlexdpSSiOysw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=WQEZyslY;
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F7D606A325;
	Wed, 18 Nov 2026 17:01:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98F7D606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=WQEZyslY
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=8fc3rUrcD1IZLm8pPlhKV8zX4DnzQ+5myz6UfOSrlPY=; t=1795021280; x=1795885280; 
	b=WQEZyslYqoujDFz1UxV4Hk95wk+paxD1oUK4UAe6Qop8WDS7Kd4R5Nl1M5v6vhfbVC1lUqsiIK2
	ERGT8HCHAKz8Q67c8QD0aMN4lXDwDSggnAi/qdSqmhS55+byTfQ0pLXsov4k49l5H809tu/NxZyN5
	84aHinVU4c985rBjZAypaS3qcm4dXCk8KehbuWlTZlPR4rGn3dpXKwiywoqUYn5jf5JcCMNAPD2mO
	FmOiyAwZcEbViHq/BGT8fZwIiDNvONDgT4r2h1/afG7eNd60sfNNS+vDCyHYWC4Xh7J2Q8IYQlo5v
	YanwSPbMPSoa5RxHMpDrtir/HXpdPdpOASCQ==;
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
Subject: Re: [PATCH 6.12 0000/1756] 6.12.119-rc1 review
Date: Wed, 18 Nov 2026 16:58:56 +0000
Message-ID: <20261118165901.35595-1-bacs@librecast.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.119-rc1-g52008ba8d06c #1 SMP PREEMPT_DYNAMIC Wed Nov 18 16:47:02 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
