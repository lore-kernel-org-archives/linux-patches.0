Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1972283145;
	Sat, 11 Oct 2025 17:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760203705; cv=none; b=X8k3v+pyEA37aMenibI5vJVNdQow5QuI0uBUIosDzX9TRj9OcP4409jhqvxl3DVerpmRmGIoi1EM0pJhOvdOgHgso+pj04IhqBVvK4EvDtWQBUqwt4gEToBbkr4XMlBwlB2Yzx9r/Hgs7IDGBOj8aQuwGKMuZnS+760Gah71YLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760203705; c=relaxed/simple;
	bh=ert1ptUzYp9/xz1+Q9jngkczmSnswwxeTdl6spLDdDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JuOF7U2HtfcRE91ec0K3vcHVKWUHiRkwU9j2gf4LywrxkvIyve+wrAZzFle6AyRV1fRBpLecIzUsbKe415Pz7iqfrawwF2khHewkWMIsOeuTyLIadjSVKaMoNeu2al58KZMNaWwOuGTM6o6aRlCQ5R0McKQ2UNEqMPgIgwaDKEQ=
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
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.12 00/35] 6.12.52-rc1 review
Date: Sat, 11 Oct 2025 16:59:30 +0000
Message-ID: <20251011165934.24970-1-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
References: <20251010131331.785281312@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.52-rc1-gf7ad21173a19 #104 SMP PREEMPT_DYNAMIC Sat Oct 11 16:57:49 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
