Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884213D649A;
	Wed, 26 Aug 2026 10:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787740367; cv=none; b=m3SYmYJEk4Z4w22eL/yGfMdYUpFGwkwU3tPg1jGbWJOao5fT8XM30wlwFVWqiRq7IEwt+r6DmMZTDz+16vSg+h6DNSctKIR59aqG+gTrDLNflBViBliP/ONtW0MfmDUM8ReT0Rh6iQLTpCe0w9qp0lr/8LPK4bC10VlYIOuBsho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787740367; c=relaxed/simple;
	bh=4qD5vvLslogyxnRLnimGQLsgJKjov1eu8Uw9QfECY20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UydntrWneM4ph6cw/jEa2zx3Fz7RFxWb7S347eq0mxDgHfQ0tWUL5+P6E1Z6yDXK1q2BHtAL5FjGryzUKsCW+EPk3dtc8JLdOqTOvya6hPV3olQ1ccykHDeX4jgPXXrnlGYGb/YJslW15KS4AFP1r/73Z05IpDFd0lOd3J5ydzo=
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
Subject: Re: [PATCH 7.1 000/101] 7.1.11-rc1 review
Date: Wed, 26 Aug 2026 10:32:36 +0000
Message-ID: <20260826103239.61472-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

CPU/kernel: Linux auntie 7.1.11-rc1-g822f846a60fc #1 SMP PREEMPT_DYNAMIC Wed Aug 26 10:16:51 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
