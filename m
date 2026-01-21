Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B0C3D6488
	for <patches@lists.linux.dev>; Wed, 21 Jan 2026 22:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769033585; cv=none; b=q/9VeiSN5YmAlFuGO8R/GvumxK9nfuY4PzCW81hVSJ4+vgzANZaaJFPFnInjCAmSrgCFom/KA0invuDt9pohq1b3Kt5ch/0bjQlcAhpEjZPzvkCx7wZRLOo08RsHpi7kX9fGossRqI06UpiMPAiOSeEqFOnLGWrpW7R1A3OCs8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769033585; c=relaxed/simple;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hU8sFbZ8oT9lbnf6TxdqmnwZ/WkUTbY+wa7/XKMV8m+OQvadf/ESKtsRHh99R0RBePryxF4YXzsdm/K0dnZ3aJwt8kIqAv9QuvuaZ7Atm0gnr4ObY6NOscFOan7F1Uzhuc/jIO2QhvgkAZbL8vAsKKVPV42a11yKKIM9FVkczHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=hIKIT/KN; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="hIKIT/KN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1769033541; x=1769638341; i=rwarsow@gmx.de;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=hIKIT/KNfLfVcnoqvGbIe1pN5u2tbLAPN0McHKAoNGmJbLsU9WRlM+GnBmgFY587
	 qG0KqNSKYlYz0oHolUMcn7PWon4EvhrxGOG5fXq2KpoUN4ARYyGQSoibrBo7x5Z1x
	 4JM96Lej97I2R2ezJVTglr1BOJu3xRSv4umgTqK7PE5C4PW+hvSBx6ZJT+f/uo5E2
	 zNaedMEjdnUJNVe9jGPBGr187CsbRwX/RePAzy13o8qk+mUJmtU8u8QqBv1G4DLl4
	 EsmW3ozwaEvcpaBidxV1WJ3rwtIhf6R0o4RxCygoAyOJPnjEAFqlA8eFcbYadeJYN
	 v2QPEUhVopbQNlKTwg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.33.39]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MSbx3-1vKALU1PCb-00XKfD; Wed, 21
 Jan 2026 23:12:21 +0100
Message-ID: <c985041b-7a22-4d49-8e69-d132d10300b7@gmx.de>
Date: Wed, 21 Jan 2026 23:12:19 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/198] 6.18.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260121181418.537774329@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:9CJB1oJ/bw/Y0Ze1ndHh7NBBh2ruyTmLcinx31S8cBcAxeUdQLL
 w3YwacxP1GuIUJZGmfkguB7OCWC9aUN3Bifr6gmX3Au2Be22vQKmx6REPDvazkQRfTfh3s1
 XE3CQXcLhIWd1ySSb2Pjok7eiMpmkMf1JUYMwNHVWBOYfLoADNp+OpPr0gg9I19/wWk5Gly
 OyZr6x/qTHEnLLgRx6/BQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:0uBW7bxMsGY=;4NifpYP8vTgrJcNEndl3zk+J/ga
 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
 hkPmGFVKS1mP/2UBQ=

Hi

no regressions here on x86_64 (Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
