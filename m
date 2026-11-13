Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794597785;
	b=C6zcyHKhdG1KbguQ46LTmwFiKMxt6mUdMjK4ezEODfgY0YMJfg0barrRbS/Ilf5dh/vT
	 fv4xycHJ3e9kN3I5WRNSHE2fdR673GYN/3YRrznEc3Kqct6VB+6C81u2ema3uP0wMTqIn
	 sipyz8p9OXXpxhVEBebNC3Og0nPXFN2SxdZnPXylbf8/eoMNc1lLwwiNTAfysqxAlrRM3
	 5nWst9yR0oxfxIYPU1Y2cxuA+G7wYpSfwVPtxDtQujlWJNJ0NdNmMCEKKygkguc/2lTag
	 GJ5/gqUNqfS2ydD1QrkkEH9RI2pbA04uhdTx0bhkxBKLKbbhlc8Vl7SucznUAjgTqSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794597785;
	h=DMARC-Filter:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GzvkGeGQkXF6ilyoJ/yjBv1xDvCOTZBtyTgt71sGOwU=;
	b=u4eIgJrNeMgdmuBYZFy+mH1471M3akEPItxJc0MKUArRL9jb9X+lSKdiioIrWDDfwpCy
	 22QCE/BcICws/owwkGqekBb+dqlGD/tJlrx5gVrL9bzUdJYnk3+dnu3sH7+re4Vhy0x+x
	 GLEQiGstdo33z+uk96OI+tMxqO3fPJUHywgzxn8anDcMpWHcx/ZqddTF4tQouvw18jXPN
	 F2c5wHs8JzCDMXGd1kJ8IRpIMkuNs30gRg5BC7lYHQQvwvWNUWq1eVShXimV7LKH+Ye6p
	 FyZQSqdOZjQnBekyrNEPYGVNlKMRIcuMBBElladUedu7OUSU75U56wCVhOST8R10UXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=OVmaxAhy;
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B86F606A8AF;
	Fri, 13 Nov 2026 19:22:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B86F606A8AF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=OVmaxAhy
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=GzvkGeGQkXF6ilyoJ/yjBv1xDvCOTZBtyTgt71sGOwU=; t=1794597779; x=1795461779; 
	b=OVmaxAhydUcfrO2p4BymB9TpS1B63G76XsYT65pFRmhYxLVAsp2N9QOgodr8VhYIMdiCBfWRjDc
	LdXRnht7M2ToGt9amQAgY6yje3pA/gRZMiuxSHZp7ONy6XR5viFcMN1/sLXUISI0VFNIR2FjRGXx8
	roVdi+zB1yurUxTEFg88gk0cYzGZKchskKdM+PBdoKv7u4Fp0K3TOOAeOsxiknNREWkTB1Nmn7LIl
	q6BIrf9ywUosh8vrBzlGL0bzECusnkKxngBMHfK4CHoK3Uvd5ck5PtNz3prHs/vZz9GjPsfuqKxEF
	88ydhdngSqyigOM8N2UUGbVrEXrrftDoISlQ==;
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
Subject: Re: [PATCH 7.3 000/507] 7.3.5-rc1 review
Date: Fri, 13 Nov 2026 19:13:55 +0000
Message-ID: <20261113191401.45534-1-bacs@librecast.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

CPU/kernel: Linux auntie 7.3.5-rc1-g2a640ccd9d0b #1 SMP PREEMPT_DYNAMIC Fri Nov 13 18:32:45 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
