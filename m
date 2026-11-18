Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021154;
	b=LRwowK/brIpmBNPDAPhMg4gvcnQzkEyLdfP1KplHMuCB5s6fci+WduulakUuf/99hd5+
	 1boWgEPhmxhDkW9aWyMcXZiKlvJLlBDxLOmES8DelxfgKNkHz1G+JBZ7N5BR7wvK2QzTd
	 kG8ADINvM/+M1t/wd/z4CoKZrDmq6CdfQtsrr3b3+S38ZBTFWTbYkVXXhceHhUvtQH8g4
	 lyy2S7D/rXs3Yf7E9w3IINEd7E4z3XjA1nJroRM0nsQYL+SIbBs82VRiLvta+IkPSdBpE
	 Fc/r5NEuEglNN+hqty67RHHCVdo8m23NJensMspX7Ol3QfKhOBB9M3bdClSXIkk8xNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021154;
	h=DMARC-Filter:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=gu8Ysk+r3yeqGSyp6qcxeoAHjDKOPekHhKnNw3fP6XY=;
	b=N1X/BdVW5eGuwCdkXqgBC1pDj15hv02RwGvPckYQWfxvWdShZP0drqrQzvP6n+oZsOqH
	 xJrKYHIpw7Xb7zxiDW8H8bOdjttbyHQzadPN9fcEOA08eMW0qfmUEPecfJ+2noVfj/FRO
	 fMle9LhtWmjNGF0RCZwD7lwNk1i9aMNJ6VEx/nQy9qgk21kD0ncnzg4DZ531sWlHlWM6C
	 mimXNzWM//uOQnwDgLxns+gBdJfnV2bGaRrt2lTKnVGQY15ZJc17bJZQO/Jqw6d5c4tW8
	 ztQpsj1XB+mcYZA5oK5VeaykhMP45J6iAyxkMttiDqRKdfSHJr9b4HS3MHePOvI569g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=hXOfHk7I;
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E78606A33A;
	Wed, 18 Nov 2026 16:59:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4E78606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=hXOfHk7I
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gu8Ysk+r3yeqGSyp6qcxeoAHjDKOPekHhKnNw3fP6XY=; t=1795021153; x=1795885153; 
	b=hXOfHk7I2x6n3vWtXdThK7iVBD4r54jOzPcWuv+srkMlg2b3hKHwK8BJWRK7dKt8aFEjl9uPKHP
	BdqlWKQ+kWXEkc2k9eVtu77nSijRYwbwgA2jZ9mtwie2umMtYodHO2C/NU3oKOxRbCN+f2YNItRmd
	TZLYwoE18H9OpHpI3pIQBT5rhqbnpM8BrB6WC6EaR+yFiQNQxus5eGm7g5vloNKbbu8aOhEZQKo31
	65oYHShEz4EOwwjnKtLwGGtHFm1dOt2SYECY3nb0KfgUHAa9PwSzfWJohe/QiUV0tNo9IlE74iSAK
	FdMusxc/IJAsQHDYywlzVW/MlWJV0RtlyOeg==;
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
Subject: Re: [PATCH 6.6 0000/3318] 6.6.163-rc1 review
Date: Wed, 18 Nov 2026 16:59:05 +0000
Message-ID: <20261118165907.35677-1-bacs@librecast.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.163-rc1-gc4e45e560351 #1 SMP PREEMPT_DYNAMIC Wed Nov 18 16:53:07 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
