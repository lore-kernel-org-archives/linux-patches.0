Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795766630;
	b=12DzTMyEzNYFuAydf+umRnSJ2y4agI6TKu/iwxfeU6AGP13NfbG9pKtf5iBsc/cdu9Al
	 dKXuSWaY+x1jUnvAdIT+cMAakFNihb43SRP5PS8vaEfTYbTofYRUXl/7DT2EKdaqDYo+D
	 o/PiKpa87kVFwJaXxWjn/RgEaavMF3roAOWLwDBtyHM0Vm6L6uq5btWkCsr5j/LPrOboA
	 QPzLaiEPjkvprP+lW1SxSVzzxy3zrifG0Ts14+Trw6bhKk29T987zHhvQNhwQfleX6Oyg
	 h/Hmn1fOMDMGdc+pL+OlSJb3bdV0vWrVxpcaIOOyuUXzPz/DYoah80U8Iq+t3Df/ZeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795766630;
	h=DMARC-Filter:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xl3r7vUR0LDYJdrGHxReKQycp3HZ5fBbEM1vjaedqak=;
	b=0SID85Lx/pizKReS7vPHj+hfRJAfQomdL5zMc6PzzetiVIJVyD2VLBmSfSfpzSO9Lt/j
	 gt+iYIwQDswodMf8Jigb2exOe1C27lUv+jFl6umvOi4QJSsaRYcY3x8a+eeTMOBkuKLp/
	 9dGCz4yg++5BZaqq6LtW1L7pQNwOzYQVFNOB5H+b7OSiD769sE5NKFqd6k1J2hLmicjG6
	 C1cgrjentsvsVWR2qZ20b+Cz8Oh9gJb5uNgi8nr5Ap+9AMf2SSvpPpiKVIzRo6RXArTwN
	 gyHBdXB/RJJPYIV+lMQLHPxG26oYk29R/tDCE8AslvDSA/1e6yM9DAJeQFGApcjewsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b="AUs8HXM/";
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E511606A31C;
	Fri, 27 Nov 2026 08:03:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E511606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=AUs8HXM/
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=xl3r7vUR0LDYJdrGHxReKQycp3HZ5fBbEM1vjaedqak=; t=1795766630; x=1796630630; 
	b=AUs8HXM/vdlz9vW/30rUGsEBBZJ5P2TIEfVt1F0bzNsl4eY5GXmD64GpZZ07gfcQMDZdmuWUDrS
	F5gESlIheKrxK+AyBWTCz167c/QcZF0uhw6TyKo9PJnJIPfz50Gd2L2E+d3keZmLRtlvD/x2HIBKG
	VkJws8nDKXpur+7r6qtFOg3D+P7A5NkMzz+UV9DN3dwZYiM/X44ITcVjurTM7NW+mqy33NNLEcnr6
	JPyLSaz+KvAH9u7MbMrjILth9T7b2VjcqAeT25caKGxwGc9XEFnw2i+PT6hwsfwWTvhDQKC9Rm+gI
	t9Ia0CPWtuGFoCbXSARvTjd9WRe0Ia4x0qWw==;
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
Subject: Re: [PATCH 5.15 000/318] 5.15.227-rc2 review
Date: Fri, 27 Nov 2026 07:54:47 +0000
Message-ID: <20261127075450.53887-1-bacs@librecast.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261127052515.841545444@linuxfoundation.org>
References: <20261127052515.841545444@linuxfoundation.org>
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

CPU/kernel: Linux auntie 5.15.227-rc2-02492-gd2b2008f6339 #1 SMP Fri Nov 27 07:52:07 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
