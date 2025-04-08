Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D1C1EA65
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 12:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116670; cv=none; b=BM33XxnSOsHoJoyEqlQcENduUN2hQYfxxj9Da9Fw1YzPkr/Y+61W07h4WTqB+aLc2shoDCcVRiQ1/mdh2dwyfI+e7E8tI6b4xMmKIEKdkxAjXrHQc4glSTjGSppkA1qoUWZUJXLaevrPKCmSr4BVRi6frusLodWV29jTsKWtYKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116670; c=relaxed/simple;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j+b9Z91awiPH4yrNjXBbU0tefXmaMpYqWMwkzrrs+JS8QM73bW36gQrgxML1Xo9nCxWxxPTQ5n58c3iiQTLVzjP9yi1PCjKN6mdvRE4IUHtA6/Y0yuzcc5eKo6cgiACFzEGclUBdZI14fuWEL4uSK0yIAgqBMW5TzfkTu/OTt4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=U2UatSbe; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="U2UatSbe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1744116631; x=1744721431; i=rwarsow@gmx.de;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=U2UatSbe1Hy6DFfCAh/CY0A9PceCPB35ErwrORwogeHGildVg0kpphy3dlwRr+GH
	 YQfRG/C4z7kPEcLTrnHu15CjZKPKH4ClbiF/6v+KOael3A62VielibVWmjUI3JP9C
	 4AmUuInCKiGM8ihdgB+hGjXBV5zxgQFeJwTZJmhqMEJ5SpLMTtn7tozVYogox2kEX
	 ksSSaR70UiFR3iYmTw8sP0493Xwpdn5i33GhkESZeRn1WrheXYLL5USm+TM8mkO63
	 OKpS+49X2TIo6gDUU5MBS0J7qNHTxipYarPqF+bXfD3GYbIBnyqqW1DotdaVkHThP
	 kgoLroZH6QyT3i8M6Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.33.88]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MeCpb-1tSFYe09gt-00dVy9; Tue, 08
 Apr 2025 14:50:31 +0200
Message-ID: <9dc80361-6dd8-4311-bdfe-0ad278bbd48a@gmx.de>
Date: Tue, 8 Apr 2025 14:50:29 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/731] 6.14.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250408104914.247897328@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:hC4gs/azVC3N3QfqVLeGulXhBPdDYSk8bn94rzY3dzpqSyJZ3lM
 +cJRIrnYjj/S9jQuR/FwLsWNO/qLibvCzVlIIfCnHsituG/YWU9CXkftrXXE2GNn4T9hOSJ
 B3jLtISzTQJ4igqySodeeXZcm+MBVlMgJziICNa/9hEc23lzTaG8OEyf12VlcO2pl5tBKEG
 GXujxNiSonfDbzblcPLTQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Lm7ps4cw5Mw=;1yASkq9uypofrRo4Ub41wmjLkxr
 a81/N31rjED7UaZ8IEfAFRLVkVO16nFRUigZ3CYkhipRvmSLHgJsT5HlAlqwQgloQdJ9cOxGp
 iMyyd6F1RVdkY9YcVXRta1E5y+HplLUDXYZIpIL/b2oGwpS07vr2GDM3uZIUfLPDObRzoaG7V
 bgES12SFbVky5pR9KzgZkEIXxHp7gwBS1RbNwlEINR9+KHAKQNVVEp2lZteEVOE79LkSsXr0Y
 kmoVp07ReQzD+LJBmRSu1529zsPREuYEVU92Wfv45pIjtODzHAb+vMFCkPi6i83I+8iN1HEM4
 44jvvdxdl6tYk/BN3Vvo5GlAxY6it380FFUfn5nq1GuMVVpB2kCt88jJo5fZ7u5K7tbEI/5fs
 +7CSJNjLVb8HV3yiTS02BK6iygKa7kFPYz8fGWi1ItKUOgA/zAJ3S7hLaeNPORlTx5ESY0l6z
 BgDXaC9Q1QVKgGqwyXzE1qrMza5xaPE0tTc26sly8txEFr4gI9etraLyp5ncaG1GmiEhPQY0z
 32MFGxPRcJiueFTFQtE5y0xfOiGmXeIAtBZAg9Hm+0s/+szZHt+AhnefxHnMh+Ni3N0dhR0wZ
 yp4B0R/waOioIrkdkqQLpT/odIWBYgevGwsyeNqS7ABvjiCXs/3RYiBqV8HzdljiPOa8Tv/7+
 BBlUvaPGqdsPtQ/gBkMx6fR+rGTJGbIkaymfyLh9LA64Mb5DTHpLLATztxwEUkvxbKvwel5Ez
 b4QhBLpFD1sqnUQAFk2XCyI2nhUhlbWOKdcawlpZH1dgqF775TeyK1J4iHrPwngzj23+fKaSV
 PLGKGxFdVyPEW/apfpFzDOFn/BSiyP13CYU0R5CEvJu9x54nDdYAvBciRYmHQWf74gOxXqKoZ
 wtD5vsydQqxSwGb3rLt6F3X/vT7k0gO0V5EGAHEEih8h2YjbRobXzWK71vkk9V4Mk0XZ2fOYo
 M1+e/O6yVIgHYddh8vh3v3VBVuzwXpGufUen/3Ps3pJdxL4EsGtZXf5HcpsR3iGP0h/uJg1s+
 GaieNf6HmDYNtNGbZ28WaQMSPzqmcHt519jCI8673vVQohcEZRZMJ2OaUZgFqTVxQzTBz3X4U
 XZyeyogIiBOrWj3DrsxRLTaqgd/jUCDIgIuhmXGPfc96wH0ql2e3wY3/oXhsEjJq4/qpSHKOA
 Fww3FnEWzK1YygefDwyFq1VME2ONo0hvcMrc2lXFsXeOrntm/IGVha6V/m6yXTkUrggWcsar3
 b1/YztZ+d93f1tIavBN8owVBnYfj/o1pgnvE0VD0M4S7ipMapEdKEyHZzPlcMITAmjsmVmuj4
 RC+20xZTHmNxQxZyopVosd201Es8R7CqVFsgAs6sRnUgW3pQvGZqke9mRypS3LkpwFnS+Jdy1
 FY03XDKgRLFSuFwvcmUG4dmSowMx+9j64+u1RkF0zC4mRC4j5CKmnPlm3LETh0s2rBQ3Kwhss
 uo1LsHwoSTHwtd0O2fvRFyKBTSZI=

Hi Greg

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

