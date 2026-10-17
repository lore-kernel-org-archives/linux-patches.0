Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF51394470;
	Sat, 17 Oct 2026 17:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257583; cv=none; b=iKc/o1Ate75lCjE/ttdcLEQeHePT06OSnt3ErPFxpCkG+P1oOC3U4uuxta0hrb0Ic4k2KYFWeqln/yRlX9fVAtLYhGlp0MXfezmz1dUPVP0xrSSWjUcHiswJBOWM8UwAR/ZL9GqHWqeqlExgbv0zDFSDzONWeUgWCXSDjCQWi6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257583; c=relaxed/simple;
	bh=PMeYN8ha80zGhZ2lT2MNIraopUrdnHAOPz3RDTn7zH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/wh8sof8J+2pcGZyavGKU20XXAyCIhizv1Sw+LNOaGbKArQThj8rc8mmJnQKIwoDhM8jdnyjFRQsUENgq4n5fJr1zfmwL1H6CdZr/CJLggdRgOo+aTOVqnQF+qyJ+Zi0MF0sbb7MfzEC4gxQ4gP/qoeXG4FrROC1udSL5a8MWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.211.58
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
Subject: Re: [PATCH 6.12 000/869] 6.12.114-rc1 review
Date: Sat, 17 Oct 2026 17:19:18 +0000
Message-ID: <20261017171924.501415-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.114-rc1-g1cda2e472e80 #1 SMP PREEMPT_DYNAMIC Sat Oct 17 16:40:18 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
