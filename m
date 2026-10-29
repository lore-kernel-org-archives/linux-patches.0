Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793262610;
	b=riupDN51oF68S8F3se1U3zJim1+hKdd3aXaGMeJ76757jr0yrY1rZEaUGqUvgM/Z/W53
	 evUnL5keUsF1A3hPnMNo2PRn1TQYi54HBYvNeCOWj0wAiXptLE3ZsQ8apimCfgVPzPL9h
	 tBbcBXen6UauQVcfXNumHaOW2zbL+JEhOYvbT0vnle3HP+Y1EaVoEnr+XAzlgSMGK9b8M
	 EbwNOELxUC9Gq45HQuiP/hdzmS/C01n6F2e2sESx0HZwxmPCZ7eTcSUAeynWATgl84YXh
	 i+OOETGKKbJxIXtcYynNVTCrT2JTV2jIpED/7IvgQBzca72UB4T3eeA5yoJ6cxC0Q0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793262610;
	h=DMARC-Filter:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=CBgX/CixbISvRDKOe58dp1nuc8CZNNXDIYuCs+WW1RY=;
	b=shk1ICaMsMntegVXkWW9DkgCruY538mtoWnXnVqR/NSv5APsRhdMqPzyHriDAH9XLrrY
	 zc/z5NRODuKgK6X1aFagjs0LFOImjFLtReHRf3sX35t5K5ojoB0BtZjURcEIhzpA2Ih8N
	 eFVeu1zkyTtyxzLn0aozZEmFY0JrHhc4lx68Orj7vfDweMU+ZRI76qv+NwXSogFw65qWM
	 YUziv37vQO4J0xJgkRmZrq5XEGfrSCZHUkKEXtI44BCwXtfO27SzBkXyN9+jNAUxm4SMY
	 MdSd6OdKLac0sppIrC3POaapOeFNcTkzPhtnOJgGaPrPcstaTKBjflBc4eJ83omMT8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7674606A31D;
	Thu, 29 Oct 2026 08:30:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7674606A31D
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
Subject: Re: [PATCH 6.1 0000/1879] 6.1.191-rc2 review
Date: Thu, 29 Oct 2026 08:29:55 +0000
Message-ID: <20261029083002.38110-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261029073135.159947193@linuxfoundation.org>
References: <20261029073135.159947193@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

044/044 [ OK ] liblcrq
010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.1.191-rc2-01880-g3b00df762ebc #1 SMP PREEMPT_DYNAMIC Thu Oct 29 08:21:39 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
