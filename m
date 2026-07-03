Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88193B3BEB;
	Fri,  3 Jul 2026 09:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783072380; cv=none; b=o2nirD7qu90TQtMQzFt4I+Xas18RFmojAFXBhO/KtWRn/KFyeqz0OBQ//ndSno69/4l1DpPeAn7ooUdDy+wXaPW2RW32TgWSKuI+eVPQWKYvmM4q1x13lGtvX0Gwy9tUuzkOqAgzQhcSYsPL5laRDEsgvNgCNpc9syQCE75/sdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783072380; c=relaxed/simple;
	bh=GuesheZqdsL0zWW9NRv+KpQdGthPF6v7d7FqiBc1Eak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4teZ8U9tNkSzah7bUij+Acajuio1eMLl3XlBrKvK4/HXQseTPFW7cd5J0ZxGjRGGPe4fZHfQYznMmeBHpVY+yMio7dnw1RxVrKV0fcbNCdTsVoFBsqZrpOjbAIiplP0JSqyAvcvhr0sYGLVqpTkEQmEEuG2j7w+V7BcI1tZnYk=
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
Subject: Re: [PATCH 6.18 000/109] 6.18.38-rc2 review
Date: Fri,  3 Jul 2026 09:52:45 +0000
Message-ID: <20260703095248.50985-1-bacs@librecast.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260703072816.644513463@linuxfoundation.org>
References: <20260703072816.644513463@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

020/020 [ OK ] liblcrq
010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.18.38-rc2-g455fe3223158 #1 SMP PREEMPT_DYNAMIC Fri Jul  3 09:13:14 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
