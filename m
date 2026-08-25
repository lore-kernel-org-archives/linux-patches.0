Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD55C30E85D
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 15:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787672880; cv=none; b=JsH6QjDKfbVL5q4+0PCggXsTdI5TazSCz3kohpEfMq8i286D0lg4EhueJGK6avN8lLPMB3/bNxhbZ9SuIM5EFTE+DRAuDYXJnDjAiLUNOLRrcw8j/7w9WfI5wuaSpYwOgSBHOWe1tJDFVv+SZOyFyHRhdsY1rCYgJaSrzsSDxjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787672880; c=relaxed/simple;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qcuP4h9A2PWSkfCpML2NEY3K/2j+4GSE+f+EbBtD+R8NU3isMFi5tkoEjUXH4tMidib1f8EAKJh6uwwKq63SOpFm6gaNfISs0ALIOZHiqV12kuuxcANjG2SuaOrYbZJcI93Hb8+p415iGCR1Krh54nJsW9900SRHi3fuxhNSBSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=rVGu1yE1; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="rVGu1yE1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1787672846; x=1788277646; i=rwarsow@gmx.de;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=rVGu1yE1lVvAMyULfR2S1jYd3U+utSIkZqw+XWGwMwbxALkYmSRddm7OnJr7jStm
	 8NAqjwKeyg3cH3/v7tD6rrwUaW7ZAZJZKV2DATNlmOyiGRqf5FtweS5l7W8l1/hAP
	 MNocOIWDwEp4XDVBHvrAfqJiLSWJPFSyLrSfIcw56LiDP6lahAMYg+lNrsEWHCbPo
	 SAW5ad1OycwiSQ8Vm8k40H6WmQGRNDRbP0tcmX7kVhJMwRQIRusG/6kZZL6nTya+R
	 tHNN9HesgWf/JM5hY07ZnHiNVDlN3eEua3PMT2XniDCXKAIJoxRUR0mEnm0VDge58
	 yfoZ/XnQuTVED752gQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MfHEP-1wS0Wr0qz5-00ZUJa; Tue, 25
 Aug 2026 17:47:26 +0200
Message-ID: <3dbf9ad6-a572-431f-9cbd-5cd891e66563@gmx.de>
Date: Tue, 25 Aug 2026 17:47:24 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 00/82] 7.2.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260825132541.560541185@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:jx99b35Z8ogDOJn4XCNBPzyDuEqbOs2G6G7H7Qj7HjeBU4/zMyM
 KZftcyEkqX1fbTSp1oaf0Eeu2zXv1PJ0EUOZUOIbjM2fko6WOblptMHWXs2BtqLx1nfGns9
 OY6EFjlb1yHyQv5vT53caSkE2+BVa70BN4JY5DRo13e9XxGhJWMeLMB8NEw0XeSGd4vUBlp
 beKeI6jDcqHRSdRMTIpzA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:KreDy7fI0AI=;7RQosIFPJeXvEv06ChyaLsao9mJ
 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
 SNBhr4xF4ZnDgPn7GF9gk7aVpq7w1ScHlj4y3s=

Hi

kernel build / boot test on x86_64 (Intel).

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
