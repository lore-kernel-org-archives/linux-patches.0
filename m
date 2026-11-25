Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795635880;
	b=KSQoSv1x0XLE55gh2O4PJDEgXZxyUOJaZcMvg4vDCe3RujI5PgA8XLkGe4ECubCC7YA5
	 VVhzcXGNZwAIYmDwL6ClHuCds3q8zHcCOAyK1A7rvIOvniBHt0ItxnUUPLV4f3ZeyMNY9
	 0sv6lEk/v0UrE5WrZ19pa/6+/Bu9S55IOa7AJINmRP51SKwc/QUEqNytxCGirUYAgrK3B
	 lOSpBeaxr4K6DzaRX/8DUI1xCHinqJcSEb3prfJSXZbBOaMTnRDsV9Kv5u8yhN6XbnkVx
	 s9VVRfrFreRRXhQnbuMsH6MkfXyNm70u7Ju/6bG4SIFSJPBLk3zDUhZKlyc+yiiR2/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795635880;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=+ypIl6O4RFwCdH9fMD25g4AZ0LJ/xXTxEjxVlFOHiqM=;
	b=UxMVMOPUOu9ePA9oZfB+HS/xzXsV1UKAdTqzNekU5bnJGFotTuHACwkX0jWiNU1ump4d
	 Gt2gFEnkaJLqK9L2Yatm+ODv86bWsEM4dCL56aX2wzxg6l2H292ORYobcvitgJ9RUkvwS
	 Qwrmie1929KXS3wlO8tF+UC9A6wgVyARTDD0lffFESGk4duZMIsb2auOQM7LTWbuJ+5Uj
	 d/zpDwgQzgPLbiUiS04K2ysV3gm9Pf+lRUpBDb8lAo+Kunxp3A6AnQqsApxToWh02tRxf
	 YG1IQtyDuLSmRWxCV98tLCsDLMYPQQ9JuvJsbGN5wmC2S1x0iOQhoIWfC5Oc9cLZp8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pm.me;
	spf=pass smtp.mailfrom=pm.me;
	dkim=pass header.d=pm.me header.i=@pm.me header.a=rsa-sha256 header.s=protonmail3 header.b=oOVmEWsn;
	arc=none smtp.remote-ip=109.224.244.18
Received: from mail-24418.protonmail.ch (mail-24418.protonmail.ch [109.224.244.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A344606A321
	for <patches@lists.linux.dev>; Wed, 25 Nov 2026 19:44:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A344606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.a=rsa-sha256 header.s=protonmail3 header.b=oOVmEWsn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1795635876; x=1795895076;
	bh=+ypIl6O4RFwCdH9fMD25g4AZ0LJ/xXTxEjxVlFOHiqM=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=oOVmEWsnmrPId/aQtxQQJWEnQC/YoVHCJIECkVFYljefMn1djcYp5bsG3P6kXeCSV
	 7oAe+ZYa4vrdKpeFAmeKTOrsO6yh8mqJThs4dUOj38F5VxcC75AmwvXSOJxnfL6njR
	 jAwjjb3KuwyFp2hg9TjT/o+KFC+3FKDkS7akGPgVkERpgNi/oKnJOOG6JZL6iOZw1y
	 LgjfCTwQWuApTCvw4Nbra6u2zYTcD4dlqoYqmx3cmBtNLF1giVGx0Wshd9VDwtG2K+
	 NcJFWJ3QPZLUvkzRlUBoxD/Opm4JTCduzN4FlW1wP7azLOiMraPjWA2NQtcvEkIbig
	 JZbp7ImL3EGOw==
Date: Wed, 25 Nov 2026 19:44:29 +0000
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Sergey Lebedev <lsa.uz@pm.me>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.3 0000/1005] 7.3.7-rc1 review
Message-ID: <20261125194417.55783-1-lsa.uz@pm.me>
Feedback-ID: 113843758:user:proton
X-Pm-Message-ID: 72914e73506db7fc547786334e45b19e065eeee6
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Built with Ubuntu's config (Rust off) and booted on a Surface Pro 11
(Lunar Lake).

With 0005/1005, the SoundWire ghost RT1320 quirk, the sof-soundwire card
registers with one RT1320 and the speaker plays; on 7.3.6-rc2 there was
no card. Ten s2idle cycles: no suspend failures, Bluetooth (btintel_pcie)
up and scanning after each resume, and the speaker still plays after
them. No WARNING at boot.

Tested-by: Sergey Lebedev <lsa.uz@pm.me> # Surface Pro 11

