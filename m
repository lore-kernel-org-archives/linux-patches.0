Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313243815D5;
	Fri,  9 Oct 2026 14:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557627; cv=none; b=f6gDsiNYJr+jwlhsi4qLi2XjeAepuL/3FkGbrNY+Zzw1bOXI/GWXt1IVveOEOoQpocjTYi6jsWIhe/7dvdlLjB6bzKfIpFbAe7+3zY1YQKszQC6S7aRdwe2X11UvxsjOSf2pzcYQhlGWZ7eJo9O5PpGCLopwZPDCGS97x/k8vrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557627; c=relaxed/simple;
	bh=PmY7mF8M3Tn/ayi3mxon6syQCCI7Iovopbg/dIqwBqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHUtJAzCv6vN6imZE+sQQoqCSNEo3buWy2+IfZoW9RRnsuDFOXmwmOhPiipVKW/aTaxWMfGUqhYhUTJE+vSaxUZ3igMEpMCRfy2JTTfCkrF+bo31T9FwOM0ZunNIa0zAAuuV3Gkq4plGkT13MwTU6+q880FapBd1HjQwgcf2Dik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.210.58
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
Subject: Re: [PATCH 6.18 000/403] 6.18.56-rc1 review
Date: Fri,  9 Oct 2026 14:53:23 +0000
Message-ID: <20261009145326.77659-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

044/044 [ OK ] liblcrq
010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.18.56-rc1-gda42e30e9b04 #1 SMP PREEMPT_DYNAMIC Fri Oct  9 14:46:59 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
