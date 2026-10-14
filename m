Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5ED519DF1;
	Wed, 14 Oct 2026 13:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791984072; cv=none; b=kziCjft3r4oHzh+t/vOdXz2xTHPWg9zqLKqfZ2ET7tyqXYrWAf2auPG8vjhRUI2HdLnVqaCj1hAqHt6TraZ3f/2wFhN//wQ92kyNen1V49KjVIdUDuCYPd2e6T8H76jVR8Uw3D5jTXiUPf5ctSZbUVMNrLv0hGp6QFFPNVRnomI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791984072; c=relaxed/simple;
	bh=Aq/MeeAhQs6rnXr1ug1zDM0JuWteAExa6Y6qIqGE2C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXmS2y5av1Me/MX/STdTVZyHNNVS94vN22pN7UhuRNLSDHcIPl5YRHsxBFSRFcZnVueEaoeDdi1OyuxgK/DvIG7hgeGaykhT04nKeEhi7gouFv/dpSnny0rHa3Dp6O5ZpgpDBM/9LBkHuDFzljBx85LNG0S4uSxjEcIronI7Pvg=
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
Subject: Re: [PATCH 7.2 000/284] 7.2.11-rc2 review
Date: Wed, 14 Oct 2026 13:20:51 +0000
Message-ID: <20261014132055.25880-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261014123758.782265692@linuxfoundation.org>
References: <20261014123758.782265692@linuxfoundation.org>
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

CPU/kernel: Linux auntie 7.2.11-rc2-g62eb344d00f7 #2 SMP PREEMPT_DYNAMIC Wed Oct 14 13:17:29 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
