Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6731E338F22;
	Tue,  2 Sep 2025 16:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756830781; cv=none; b=SDoIOqdkI+QblW6wPz6BJv6+HoWg/KQ9X/OeyI9F35bkec5CJDlR/TL2Vh65H46lnhJkYsVf/pO54rbrb8RMc80MpIzkuaZUJrablAeAxNwMYQr+MGQiebGdOifz7rW9Btn6AD17aUkwqFHTSaBUenXNGuOuWlGJnXpNsKVY9hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756830781; c=relaxed/simple;
	bh=MWtVA3+ro8FIx8lq/dgDED8FCRxqd/bK6Fn/21Kv8Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euauXgPxFOBMOzTSYiecnQ0YB3MUVu8Kk9V3HsoBI1+clx42FcI6UGzydEbz4KtjZDWMlvRx7KXRRslVYAZacjdouqSUXQ+K6gKEkoWLLn8OOdEblllxVC/VNFoxZyq7H8+fKrxEXhM6hhYjYmu95X4NNOq2kVBni+ExV2SZj+U=
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
	achill@achill.org
Subject: Re: 5.4.298-rc1 review
Date: Tue,  2 Sep 2025 16:32:38 +0000
Message-ID: <20250902163237.4643-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250902131924.720400762@linuxfoundation.org>
References: <20250902131924.720400762@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Builds and boots with no errors.

Linux auntie 5.4.298-rc1-00024-g79c1b3cebd7a #61 SMP Tue Sep 2 16:16:49 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux
