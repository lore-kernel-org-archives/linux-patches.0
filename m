Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 412FD1F76CD
	for <patches@lists.linux.dev>; Thu, 14 Nov 2024 10:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731581400; cv=none; b=TpOz4VmtQYCQzTbh2bHJnK2RyjAWHAmQ71mW1yHSPQuuJs+8nLZDU2XUhguzG7eCdvm52/a2CCQNFddZSxyyiv/8t4QCc54tRMUAQf6LBfHwWPnwbxPJytj+UNjsIaLDhmHRScPP6XxeQA9UhEWRtec/tuWU9BQCH9dFPIWdCFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731581400; c=relaxed/simple;
	bh=H5yKHa85K/kN38MCbIEu0HaXLqb/id9+omWJt6O4sx0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=PFsHOygm7V3NOatgYcZl1vfEOfFjL1002Xbr2djqZEb4+pBO/3K06TzCBXPqEhpa8H1mIwOz9ec/gic3Ws4lBdRavQ4d73fZMv6WNL7Wo+AhreN+ShOidkGFhKc1EDbdjSetr+vUZ6Z3a3ezXLbbGqdBkWlZxug+cc3Fsc31rBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=kwEyfk90; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="kwEyfk90"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 901D320BEBF2; Thu, 14 Nov 2024 02:49:52 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 901D320BEBF2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1731581392;
	bh=H5yKHa85K/kN38MCbIEu0HaXLqb/id9+omWJt6O4sx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kwEyfk90B8OGiyH8bPqwDaHvHb60BrJDMqxkzG7uysEcuTjU8N12X/0/IV6IN3qCj
	 OQYfkEw8/rgnCZhVkC20yi5ZzXYdEVogvNrnnLWVIp5QBnnvOIsIKlFMzFmCDCm25k
	 PI0nTFJDUYrl/QaLkvP5gS+pC8Pn8hTSrSVHugdQ=
From: Hardik Garg <hargar@linux.microsoft.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 5.15] 5.15.172-rc1 review
Date: Thu, 14 Nov 2024 02:49:52 -0800
Message-Id: <1731581392-10064-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
