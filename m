Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B9A222561
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 15:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556340; cv=none; b=mamVuKY8xL0+og5mHvS6QMEeZJlgZI/KlFBoz++VXiOh05NPyNn4C4W9yp64GD/W8G6JFox9s7g4BNz0wMBKRWV0T9pXPByWlHWgXQZ1MOYu8SOevKUqPu8dD9yZ9vKOjuj4ZMqDiKDNxDQ7TxJ3LcqtjSEHBHlyzl8s9bFRK3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556340; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ox/AdW0uhhyQQCVIPLMr8y+/6RYCUuTk768QdzB2i0mFeHYVsmKZ0OO4IueovZIRYP+jLvw/2LClKU0sKLPgmpXvO3Tl/ZaQVn5Z6kU3PszXMf7XkwqE+HD6ISCZ+kfPQ+Xodp2FlA75Mocg8PdhVbllPMw/NWJ0mbkrHduLna4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=RYl8fDlM; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="RYl8fDlM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1751556331; x=1752161131; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=RYl8fDlMW9g6NbGMw0YV09iMaOBRLLN43IZymZACfMX9OjyUFtsKOGaMQp9oZgZ6
	 mCnVAgAOigQTbQAmMdBh1oR9p1PQC53yTeF82iASQjc40hLZxJ7jPSmsbplFoybot
	 Qe0ypCoxBP9r+rkStA7urNBs8HymDqrdZEIa1/K1XhtTNNiK7bjYt01nFPPnGlYi7
	 I/V/A+EbVic+MnOCAXEM0GQggqZS8ZMhtuFfr2GVLTgJ7XX12OMIOp4hcWmRDUy6M
	 7OzIgl+f5Lsmo3HO3LEBCZ0d8ZaA8OX9PcQFqsknb0I76kP8GNXamg1bK/kt+1USq
	 uk4uMYMAtslxOuF/Bg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.34.130]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MfHEP-1vClRQ1FUZ-00dqYz; Thu, 03
 Jul 2025 17:25:31 +0200
Message-ID: <9db875e0-b62b-4ccb-92e1-14d84d760652@gmx.de>
Date: Thu, 3 Jul 2025 17:25:29 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250703144004.276210867@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:uzozty5AOPS2DgvQWnWTKbyzKmk7OBI570El3Juaro9rK+WxbEd
 zZv8kqzkkW2wdmUwnTz214Jk5qZBSyhkGRO/uSY8XKQMKX0HrbQpShCiMk3izWNdkL+yosX
 uLTt99rAQL+DCCh3KdVw80xZ2t3tgNczUejJOz6chpu7NCdbgY/RbHZCDCMQI3x3WIDhMB/
 WKlX5CEgwv+ARB6cbqtLA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:JGRggaJNfgc=;xUIyECuu1Uu3hp/L8LKF7p907WJ
 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
 pz3UNjOvR93a5akluoeuMcZ/g5Bfw==

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

