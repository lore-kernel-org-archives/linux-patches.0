Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE72284669
	for <patches@lists.linux.dev>; Fri, 22 Aug 2025 13:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755870191; cv=none; b=YPth6KFaTmLPmi5e98X1egE2tOX9oZzR2w2ClMNDIT94Hx81TTFKsMVmLb0OPserpjrtpB57RTKYL+unNbSnZCGKUnnmD//xN9OFHYgEE78Wt3/s2yzdj3hdgOZOuVH0l4clbAuI6kiIsEKCjlxc9qSaBGOX5+lVy8wOCGFvnvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755870191; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CwNubhut2SjKP4Ea1e2J/TOaerjFTGPTN07bU4IZ9XiNi3Q01aD3YuV8e/BshMSzziWD9CiLZGL9256zcWpI5EEDILlS8zus5DXEscvi5+1LikfsK1skgISsU5OJc6SUNOxuqMbhHV788SOfhSrGtZK0/cCqZXmsdBklt1CmKIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=YQ1f+wGP; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="YQ1f+wGP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1755870140; x=1756474940; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=YQ1f+wGPRb6vwpMAYrVxZMXcvXpaTDG5k6xU2rl+S4tVM1hGEjTQebHSccahGES8
	 cnNSzgvJ3SS/2/ySZnsvU0BSklRkPy+jwX+ODMBEGZbtxUC+b+D7cD4wylzDWASeG
	 x6r784H8MVZaygjlZ+UGUPCwvPxPGKBqSlq65v/zGCj0uRXTj6pldVh0/Y02BbUqO
	 QEhOonyeu3ozfnML64xce15PfmNx6mHpq0dPSvWRTUieabd8ipCG2ZKFVwpYiUoWo
	 9Cd252KPhnDRgskc/2BGMjQsUYLOeE0hjfHZvT02fz63SZNV1kQfj/y1yvC+qQkgG
	 ijtGNxhKwoBVofn8zg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.32.34]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MwfWa-1uaexy2BmU-00ylqL; Fri, 22
 Aug 2025 15:42:20 +0200
Message-ID: <40bfeb7a-43a3-4510-8453-1864eea911d4@gmx.de>
Date: Fri, 22 Aug 2025 15:42:19 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 0/9] 6.16.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250822123516.780248736@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250822123516.780248736@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:hTXWjaFMlqv689gWXuvayJsvr2WXq9xbZqWZ+ADHwmsP0HKGIh4
 Em1FG3G0V+ohW00Vviec7vTyTG7UhmgnT8kRYehRaB8oSaebt/f7TLaiSJRzg60YA2MKMsK
 5ozVlQ0JXZWJjvvaETE8MhWhLGNTmwyoOiZeMX8Gz1+uGS2MyWMb/sYyWeyv7xc7YShAzM2
 zvU576Cid1EDqUzdulSLg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:6N6rag8Q1f4=;s1js6ZCSNB0Zl/RvvjwD/qTo5Jd
 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
 qoz9MIZxMEqi6dUQsf3y7JL6+NQUzDIUevY/H

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

