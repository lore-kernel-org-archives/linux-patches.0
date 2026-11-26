Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795693031;
	b=OZjkUTuE0guzgWh7qWEO0j6B5MH4U7xTNbGB6/ngnxdu5haNtxlpEiqZQWsitmc7A/ua
	 hpgH11Ep4oZyNDK2fRSBU2jKcz2wQ5CQuzsdr0pUrQuPyMLn9gkrxxWsoNw+bfuZTneIT
	 ZedGpR4wuah3v3F70jay4PnUGtWPhS7ATfcC7Iz7O/2N73Llzgv3Eqd3OHOJTokJ1rhNe
	 dF47VAODqECq6Z7d86FQNb1sZ6syBuDTaeu3DxYYXTSRHfbho2sOPDYB/hrO9xv1Wt0AL
	 BPCz8NmqaytZN0K+NeRvbDCIvlNOu573odrDilbMo04HabCIcuuEfSwlY+Ccr/qxo9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795693031;
	h=DMARC-Filter:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nEMeqFNhstAN2lC6P9gwJgRz0fsd/BJYA1AVyXdoQDw=;
	b=SeaFdA6v5erhBNPNhCvbAEWOUudAScccMQuc2fohMKufJCbyQegek4ODovWA1xDhJCDh
	 5KCcgp076zpq0ft78tgdU4bIyfh2Lwclsrg6JiKU7LsE9B7scGD05+NX/WoP1KEY7PWyM
	 1v4z8MLG+hD9RyJO4uiA9dH96M7yOG9Rh7hUvIuR8WlPQv1k5WQJyye0lcwPtOFCQOATR
	 Pg7wDMNIuc0zPCM2LiFcLpWttQ6IyTP7GVFwqePYMUQue1curO36vFYHt9uN+DSPGwaow
	 azZz0jO9WU9NsUt3N2auTJls/TGb803EMmy+mTHNo7Pr3dzAQA2nrF76ouKzRywyxHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b="VLrXz2/p";
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0766A606A33A;
	Thu, 26 Nov 2026 11:37:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0766A606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=VLrXz2/p
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=nEMeqFNhstAN2lC6P9gwJgRz0fsd/BJYA1AVyXdoQDw=; t=1795693030; x=1796557030; 
	b=VLrXz2/phTNgdj/VHptaKED6vvsmyMG86tK6sXH29Aeelkw7y/Ta0ruj1JOPbc6Gh6haLla+G1g
	M2FcSWVuznoP2nEDWvjhDjbZfLcLVtfde5xP/Y9xLj11fIcZIftkBYvuzEXkmI42CUnXWxMLCNnE9
	NEPiVKgbbTa8JkfKylwg+jESq6VcFdIEmj7BfPcJcKu6rrYvKEkJudaYmbmTTdBy5C8UUlPQciP7W
	ArUsaP3I3ZRZRn1U+VMfLDD5rZsX+bfJFV4xvmMGGYPCPC6QilFZrU/7sZ+pP57llc2ElaobP8/e4
	rxh4Ie0u/dUeKZp0SFwXvUUFag+CUIOJGCmA==;
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
Subject: Re: [PATCH 7.3 0000/1002] 7.3.7-rc2 review
Date: Thu, 26 Nov 2026 11:28:18 +0000
Message-ID: <20261126112821.27924-1-bacs@librecast.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126105729.110697432@linuxfoundation.org>
References: <20261126105729.110697432@linuxfoundation.org>
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

CPU/kernel: Linux auntie 7.3.7-rc2-gce73b94700e6 #1 SMP PREEMPT_DYNAMIC Thu Nov 26 11:25:50 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
