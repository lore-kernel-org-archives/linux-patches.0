Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795161870;
	b=gzAWJsS8vws6rJgWNvUtRb7SLHcs+YRaTMWdmIxTxWEkZwcNHz0v6j5zGAPpyxPqGqub
	 nAD694dKQr7sdagtUpAgFvc7WdRAjqGbJg3Ecz7AN4LmrER81hhHGyecTVwJfSALI/ybK
	 4caQep4gF6Xjy93vfiHhUQnnq4/wjC6r9ELHs1x6wihwjW/czyXks2ImNbKzdodW0RS5x
	 d9DDHj1GlUKyPgOEarbAPMTANWiULaNn+VrOcJ5tMSelEJfztaxmn7mXjjcGBqpJHiqx2
	 8DriJ93rBIxs0pQfHu8i6ejCkBKjQteAhJWihx4HGTsLpB6xg7uTtqRZDiCwgaNZiDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795161870;
	h=DMARC-Filter:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ZRvvdRNhre7GKsUTkxieAVVogsg1uVcavblDFbOq/Zg=;
	b=DX7vd8A5Kmp4VUtB2B+cRhfFWgWxhkCytrwkNQv6i7tT5xs29smygiE5Kf2dl7vafDYX
	 MSd/TyGMfGkuQj2u7hu4Ffgg9MJ3c/CdP1MBTu21SZEnpX46u2q0qDVfvovdl4Bi9VfiM
	 +q1Ct/fyVZEr7PYHG5gpoXi7uUdyGiQVFTYs3XKtan5kQU4dfePXv1hd5l2iuvm3V+f13
	 oUrMtBfzh08fnvMfop2iOQCBzuuHGobqrm4ev5+o1MX73m89TZQVuPBDgv+IgOGDWifVN
	 qw3kTQEoKEeF3MCR9O1NB9xsRWDOmekZWpl38QdykrZaabjJFcQK3B0h69UxFw9ukRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=CshW6tEp;
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE7B606A325;
	Fri, 20 Nov 2026 08:04:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2FE7B606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=CshW6tEp
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ZRvvdRNhre7GKsUTkxieAVVogsg1uVcavblDFbOq/Zg=; t=1795161868; x=1796025868; 
	b=CshW6tEp+5wMXerkjvrdMDddmx0vdS8P0ZqIUe5hrv9OjLtDpKMufYKfdted0iq516ytYX/eT36
	pjDaq2x16X3qJuyR27MW8EdylDwSjAXEx55k26U6ybfEIS7V4DgxZfoxKcVypZfkMFs7c+29ZB8PV
	K/vQdw/Nt6+61N8p3F1yfMbhyJqYbmvzBaKlX1TU2LLoFhzmQWI1bA+MeZ/FdvV0/GQIPItCxCs/z
	jMHvyU1wUJGMnY6mkfPOj/mLGPJceLb1SwVCkk8Pmf66j85BEb5OV+DiT9TunacJ3GmD/40E99UFb
	7o9e6yQxMi2eMYYqh7JnriNwnNAI5rAgIx6A==;
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
Subject: Re: [PATCH 5.10 0000/1811] 5.10.275-rc2 review
Date: Fri, 20 Nov 2026 07:55:27 +0000
Message-ID: <20261120075531.27198-1-bacs@librecast.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261120054906.397973290@linuxfoundation.org>
References: <20261120054906.397973290@linuxfoundation.org>
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

CPU/kernel: Linux auntie 5.10.275-rc2-01816-g878cb656641d #1 SMP Fri Nov 20 07:28:53 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
