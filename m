Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2034813A3F3
	for <patches@lists.linux.dev>; Wed, 23 Oct 2024 06:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729665154; cv=none; b=RWsLeaSKUXMEuxZQ9zCw4pFV6hx1X+temSpDSE4iFcXJ+B2+k8kUI3/AATmKxPupi/T4ySvmEmQ0ow863e40cJ6QJ3Sc9W8GdXtidgH024ZEjxEBt20hdKoTIsIcNQcN7w0+8PHUGwItit5pJ35IlFYseThPPjNN1cb41Dd8V30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729665154; c=relaxed/simple;
	bh=ngQUyspk0u5tmnuw4tF5HJKltqCiL9AJbZfUWTdGVNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XeIxahrLDNjviTpk4j3Rv/SYCkBA1nPYFI1zJHUsvtmUhlK6LeTyuKjrRUaFLnwBEdWLA6T89HBT1qXzHMsNlQVU/xCqRo+r8e0E9mL0K0vMFGCDWZwydKT6ndDDVXkARAmLCTARLd8Eys15yk5UKX/IP0225p6oCctog9+qCqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=iGpQUzuf; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="iGpQUzuf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1729665067;
	bh=ngQUyspk0u5tmnuw4tF5HJKltqCiL9AJbZfUWTdGVNU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=iGpQUzufGKagQD2p8OJ9+o1rv05GO3s0irkkzl+B/jVQzK62CKg8qVz67X69ysnlY
	 guTCSgPYkdN689aKc9jSkAv2q1YkVkLU9aW1hyxIu8y95ubUmp7oLbbBrYPzSuQtxk
	 b6AP1aH471/Gf/Mf0lCx04AOx9Z8n7u1eTbhDMCE=
X-QQ-mid: bizesmtp85t1729665063t7rgkpzf
X-QQ-Originating-IP: /Pu5B/BFVMh1l61DmVeOAJ9BOb/PIqdl2onMEJbSJ3s=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 23 Oct 2024 14:30:59 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 5490330265754036757
From: WangYuli <wangyuli@uniontech.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev,
	nikita@trvn.ru,
	ink@jurassic.park.msu.ru,
	shc_work@mail.ru,
	richard.henderson@linaro.org,
	mattst88@gmail.com,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	fancer.lancer@gmail.com,
	linux-hwmon@vger.kernel.org,
	dmaengine@vger.kernel.org,
	xeb@mail.ru,
	netdev@vger.kernel.org,
	s.shtylyov@omp.ru,
	linux-ide@vger.kernel.org,
	serjk@netup.ru,
	aospan@netup.ru,
	linux-media@vger.kernel.org,
	ddrokosov@sberdevices.ru,
	linux-iio@vger.kernel.org,
	v.georgiev@metrotek.ru,
	linux-mips@vger.kernel.org,
	ntb@lists.linux.dev,
	linux-renesas-soc@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-spi@vger.kernel.org,
	dushistov@mail.ru,
	manivannan.sadhasivam@linaro.org,
	conor.dooley@microchip.com,
	linux-fpga@vger.kernel.org,
	tsbogend@alpha.franken.de,
	hoan@os.amperecomputing.com,
	geert@linux-m68k.org,
	wsa+renesas@sang-engineering.com
Subject: Re: [PATCH] MAINTAINERS: Remove some entries due to various compliance requirements.
Date: Wed, 23 Oct 2024 14:30:58 +0800
Message-ID: <A74519B4332040FA+20241023063058.223139-1-wangyuli@uniontech.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <2024101835-tiptop-blip-09ed@gregkh>
References: <2024101835-tiptop-blip-09ed@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: N6+UlSQllctNd9z1plWZnnP8kKpd9MPfEVy1geCnF8BkGlfZL4FIZ+Vc
	C2RgjlHoyHGYxctHsmGSNdu50xYWG3s2eRIFDqxucpg7CFpjAQgR2H3Azf5VcHPl9oANQ1Y
	XUE6UsBUK1oYctWCGDI7XM1PjaNlTFTmc/SYgjRaKvOvGCAZL/nb5DJjX23uUZv1BytU2+k
	fhcUAR57NZ2AJ9kWGV2fQrwj8h9Fq9eb0o5qwFREuD0sJd25KczX0TtlNXlLSOc4jD2N+rZ
	ZyygYFHtZhWVItO4bwZzyI/iLGF7d5J7WxORAu5gQY1tU49b4BF4mGRdcWEHsSpJjyOo/4+
	ZR3/JNbr6i8U2EY7kuzuj7U+3esrw7gFVqWdBXOqfh+OdBkeWOq9hKD/msrWYhD5sGn+x8P
	eqJlBurObi7PpeXimGcbW4N++6vPFXaQW5NzVtUHRxDaVZjbx9DSJo6KseBuW9rmtfGyVj8
	ISc0aWM0bXIHbN5uUXDYmYnOqbKDgVrdeTNmj7SJcAl0TadGOxyYDwmuRbuECHzvidi3ciW
	nFg2BAmPLyJOHIZAwblLi9ZF7gFawH87Ok/zAhqJy7qwCpXy5V0joaWGMyvg0hBMr6KPRVO
	hughSUUNKaaV2XdqzqCdv84D+GAKIqPCNzRqn4VOcP80fRAuxsRFSi1kpZNJPI0wdRZflK5
	zazUaHV3wbfigNVv+YFGflsa5rsQkTUeuF/3jOCwB5mMyP3vutVdxHDX+z3+T4CrE3aKBFT
	3I+3sfBmMuZehUunKJcIVUftU5Zwvp+ENEL/L8DIpmwuS03Hn1anJy14/W1fTBLYXjAkbun
	zdNXv8+JIHkBJd9EgELO2Sud16rCRYLn7q+3Iwy5S+JzsC/xRMN0+U+VpnuD2IhwKJ5EL6Z
	0eo79wHgbyjfFVwzC3sSusu2q+SRWOtNsZStDSkSuee+wxaDjykDI+80NHwvvRusvZFEAcj
	oxnSCdG9toT1qktgl84NDmCuy
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
X-QQ-RECHKSPAM: 0

Although this commit has been merged, it's still important to know the specific reason (or even an example) that triggered this change for everyone here, right?

And those maintainers who have been removed should be notified.

It should be CC'd everyone who might need to be aware of this change, including the removed maintainers, other maintainers on the subsystem, and the subsystem's mailing list.

To ensure transparency.
