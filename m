Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662CA3EAC80;
	Wed, 22 Jul 2026 16:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784739299; cv=none; b=GDPdhekcnqVsClGKHRWAS3zgE2eRty+Zdf+G9V39FgHGXzXw+Q/9eV0rDjpxBlvUPcJI6QHg90MiVoM8LXHKw01+NBI60ytBDrUV+Wa6IgWNFQVbnTQocwgD7Q9Q6zsMDfEeKffRvGEBTAJtq43SfrnDqbZ441Ik+Ry3MdPL86g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784739299; c=relaxed/simple;
	bh=ZlouHRcwcsRX0J8foqFgaFSseMFmuIuIjccGf/92NBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGkdC9xUM0bnNdLTELF2I5FsE9xvqSMpKlsCwkQeNyIDKh0X2b8HH4D7d1DL74xTY9/IpQHOXDmPjNqM1jtZloOSTxp6uDlsW4pFJjujYRjA7fgdLMn1mhotIqqA2Zz+HFBMv39ujyiPMpFBow9xGevzut9XoB6ObnBWaYT3584=
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
Subject: Re: [PATCH 6.18 0000/1624] 6.18.40-rc2 review
Date: Wed, 22 Jul 2026 16:54:47 +0000
Message-ID: <20260722165452.42005-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260722142910.893804136@linuxfoundation.org>
References: <20260722142910.893804136@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.40-rc2-g472909de267e #1 SMP PREEMPT_DYNAMIC Wed Jul 22 16:48:08 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
