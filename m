Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189FE1F4E4F;
	Wed, 30 Jul 2025 17:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753896088; cv=none; b=k9cLHd/+H9CTiqOKBL9HJBY3T6nHJWYJAb0PkrXJh2roekdPRaDyHccQhe9d3sWK3P91lvKRdtt7wqRWGt8Iv8feK1mN7zwrb7La+1nFRtLx0vH7oETb/OIrFd+iyXo65nbMQp6Mymg0W2kJN/jqdYk95hnMOWhHWlM3hJxPhxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753896088; c=relaxed/simple;
	bh=a+xZWNEpNsZUFYSMDWjcj24pSwQHz1ipLebACrXO6ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l6GVOk0YvfhLIBwFk8pschhkRm4zX1t3NG6KXOdha0u9a+nnBUhptYJNvPsgLsH1NQ/w2Rx1BAbBMmw94yBE1v2n74EbeS4kdmtOPEcc9CJccFBDCxe5PQjNz01jc+OYygGX32/T+U4tVHR56E9JcOjrj9Herc8M5OPPrhicETw=
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
	pavel@denx.de,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.15 00/92] 6.15.9-rc1 review
Date: Wed, 30 Jul 2025 17:21:04 +0000
Message-ID: <20250730172103.29915-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.15.9-rc1-gd9420fe2ce8c #33 SMP PREEMPT_DYNAMIC Wed Jul 30 10:34:27 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
