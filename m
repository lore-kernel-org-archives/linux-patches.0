Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C87311C0C;
	Tue, 23 Sep 2025 07:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758612412; cv=none; b=cscF48WVCkh4ezNEvQsslSG0OsZpljjz/mW0MI4MW7c7L7+xfXOncQ09wpNPpbxMI9RMXPj3l95d4sURTkpW+NdCEZA2nGe+1fxxqUDivzyOySOOB85IvZRcS9jKDemjZ4XRo+pEs/0UIZ9qDxy32r/pyAeVJZ+DZnUp1kyA+6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758612412; c=relaxed/simple;
	bh=L538pLF+FuJYFSpUKWu64nETmbWscOrhfwReT7pEWv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AM7D8Z0GbYnNB3bVghOWXF12GyJlGVx652yJx9pQc/STfcn+g5My2eWqGx1wxbQ0+vVCu0LqSIWt1g/j0DBawwhC8Q90KYO8o/ptOFBNVZqyQ1W4tUZqI0wEknNSEuTm5v42BLfUaDCbqPZ3HbW640UVJxLtHAuIxPmV+jN7gxk=
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
	srw@sladewatkins.net,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: 6.12.49-rc1 review
Date: Tue, 23 Sep 2025 07:26:32 +0000
Message-ID: <20250923072638.25333-1-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.12.49-rc1-g1fcc11b6cbfd #88 SMP PREEMPT_DYNAMIC Tue Sep 23 07:12:39 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
