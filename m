Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793365952;
	b=lfWadRwCY8IPLg9Fw/nXaCfZ/+c98LiaKta8SF9q1jAVbN8uN393ssWmXmVXhzNCRpFT
	 CGuXajzaFiH+lJiEXkRczw0Jk96PZbUtCIS9T1YWiTFOOtoo4T+1mNR2rDTck3lyxZmR9
	 XYr27sd3YGMzKTo+VGDC9MXd144261nD64iz9anNU/LVbSPIxXEfWkpIEolzdhJMwToF5
	 B2iR7PPeGKlxDYr6A+9tc2aptwpW9wkwTJF801lvjXjT9tCPH1eHaqe3gZxcMZxxr68Qn
	 d3gaGyWfkVdocAOErkmrzPVTDNkOoM49lpv+/rMgx8ZAAvsND35WuQfzhq2cytLq+fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793365952;
	h=DMARC-Filter:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=euxBjzjwq8Z83ulFel1f6iFFPekhDEiJ+HQgYwW5dcs=;
	b=gZILxmnoL1E/JUqQEUGsDQWUd/8vYHWgaPpwkEvL5cGYHgPRfoufqDN48zPyJ3jqHkQ2
	 aHMMfnOQ/1r1O7qK8zkO78qbTdWaZGNafaVpZKiK8p89U9O3NACQXaa+T4Da5mXzXJyg+
	 N4SdH2lChOzZ5Gq1RnAbb4w/fji0/ojL/OJrHYgWx1nRxoeQ3z1px3S/p2DpPsdzS/3II
	 VWXEAXX+xwroy8dQXLMG4ycD10sZSUrVuL/pqwtMVyXEPICGovP78+DXSIq+XiyepzXIf
	 oNBbmduYkzniAGltlKOeSabwHFrDL2+Ew9vriDgQm0gHJW3JK2gui2kvj08ykEZsqkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027FF606A31D;
	Fri, 30 Oct 2026 13:12:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 027FF606A31D
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
Subject: Re: [PATCH 7.2 00/10] 7.2.15-rc1 review
Date: Fri, 30 Oct 2026 13:12:11 +0000
Message-ID: <20261030131214.50038-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261030121255.257615100@linuxfoundation.org>
References: <20261030121255.257615100@linuxfoundation.org>
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

CPU/kernel: Linux auntie 7.2.15-rc1-g82a6a11b11e6 #1 SMP PREEMPT_DYNAMIC Fri Oct 30 12:31:49 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
