Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EAD34C991
	for <patches@lists.linux.dev>; Tue,  6 Jan 2026 19:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767727449; cv=none; b=MtZi4YUn0OsBY7KPzR0Jf56Ye29V82gAi1Z5n6LXS/IvFLbhfPaxpc+BoxY+r5Tex7xYWCHxo3auYaizfM7NcfgcgTA5kC7RdLvbjBwB2lbb9ZL4MyOhK6keXH5dq0vkdgsI9ZHCAwB348PUYH6b+6TECznavkOKeqGS4DGK69w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767727449; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ilRuaEYJnIcGhM4mwM8HlP9kll9FQp5emJGvVAg/H1KT99XNbkUT0cs9e8RcKAvNCqh/a8TlbPqtFCjfCL9T2N1s+X+Ag55LmZuAza698gsEPlNRY4scJjagKsLh0D3RnI9PxcWJ/DCuTx50Qab7t35d58Eo9pIdLu0Pqf3s+NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=HlvG106v; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="HlvG106v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1767727445; x=1768332245; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=HlvG106vxbrtaOXjlyARPCkKKeBhRFzXyZTHuDDBOUMTFAlgKPgrCHfqoHYAfjDH
	 6MREgqKH/tRq5ovwdZSF47hEfJn5DvZfOMdJ4g/ebt2xnclQb56qjTUd3jaCZy41u
	 KxZC0mr6/0NFT8CbIshXfgmu6JMQMKt9fkkmxryrVcnLVAEYOfmG/A7CjtB1Ck0On
	 VyNwmyVMqkD27YYrYZLNGBoRcseH78b/lJTQD95KwVPnHgkqxzK5qockEPYgwrWVX
	 pyVKIh9c0isqfhZtiFKK8QOe8G9H5V3pGkgq/V9FN+iskc9wTxC8D32Rw+cnRYxTS
	 AhgDNtPraasNlgkKwQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.32.44]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MbAcs-1wALca3Tg0-00hmVF; Tue, 06
 Jan 2026 20:24:04 +0100
Message-ID: <5a21cec9-ba96-44a9-8c3b-6fbcbdb3cac7@gmx.de>
Date: Tue, 6 Jan 2026 20:24:02 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/312] 6.18.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260106170547.832845344@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:UQU1wfmzWcPx2lNx6Ysk7TfZpAQS4N0xy3YZNJkzlQHQmS0n2Qn
 sym0EgJVgwsk9W+rtDbEubqlN0FZbXiG1ikB/LEgXoDzRhphL77SvUj1JvNc07m/9OwAEt9
 PWxAAXoR9G1UTIQn4oPNJfMXAZdcwYPjKaR2Wx2y+F8t5oKaiLd7RAYDEod/XqeGE5e5uiQ
 lKKCAl3r5tVpvfszNsS4Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:e9mqlgHfYoo=;zMUpMow7nmyGwZY856NjpFn02sq
 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
 ie40KsWnC+NENzc5bRTW/xtxkU=

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
