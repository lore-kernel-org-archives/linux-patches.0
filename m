Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B94F2F9C3D;
	Fri,  5 Dec 2025 10:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764932198; cv=none; b=NW3HBw+VgPSJ0Tq9QIC2R0loyHpTsTR9xRzd1sasdS9Wzcpbd6AsnqQaWfBUVSYOLE1kUjM+tDD3seGIp5q3WgwUg1lTFRWZxj3pD0CKY+/f458YdE1++cFznL30VdvBk3SurSftKIEK40qD3bmGXqgM4R/FjRh7wv2CNI1YA/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764932198; c=relaxed/simple;
	bh=qENByy1nqqn5u0cRRvg6KinyVoRgabT+Mp7h9kTVXs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cphBry7JEiub4Yw+m/A+t4DIxTnHaSgUGy499JiJ7t7PHneY8+AUC4OvadQD5XpucxHogoUo/0Ff7V2HU4ofSOjLkZ0T4fUY0bQ/hzT9+j2/tGAQOH3ZUG2TB9YysJqULbP/Ntv+5nWdKVA4hhfn0LMZ/XRZn1FARBXYsukDc8M=
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
	pavel@denx.de,
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
Subject: Re: [PATCH 6.12 000/132] 6.12.61-rc1 review
Date: Fri,  5 Dec 2025 10:56:12 +0000
Message-ID: <20251205105620.26698-1-bacs@librecast.net>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.61-rc1-g8402b87f21e8 #4 SMP PREEMPT_DYNAMIC Fri Dec  5 10:54:20 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
