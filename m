Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11B13921E6
	for <patches@lists.linux.dev>; Tue, 13 Oct 2026 16:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791909032; cv=none; b=D9zXo6fUw50k5yLzhKry/MXnE8MXIGMMLU2ixDiZ4Si5NTeaHIGQWg2gwnUBtfGXqGj3sdqN6SPjhfMU+q8nYWxgguWygy9zPAYqDekzYW6Buf6Xxzy1VMRIuQhnPmKEWW0tpE5P/7ftsgkK4zGALtqSTYMNfKw4QL1MDAurDPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791909032; c=relaxed/simple;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GwFU6BezTcSF+H4DBbPGckifR/En2qZ5nlRtbcfejByAxIAST+HvGNsF5EScXP9jDefnVKBq3cOHepLCwXlD0inGbGNNMu/pBNI+BZVDVVWL2hnwqp3rCNmI+yzf3IODxh+GhnZngAJWNUNDGUwW4KYpZWxG84+CCPNkS3FDfZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=Mw/gSHvd; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="Mw/gSHvd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1791909004; x=1792513804; i=rwarsow@gmx.de;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Mw/gSHvdgOANKkQ4Fuu9jAlPMv3oSn8rL18HQLcf1EPTBlhE1CrcP5jmrllXQ9EI
	 Lln5iKRkD7HOAfldX19aQ7z+OHH5ez16zVq7+bW97keWQF3onJJmSht3bSPueU0iu
	 0UuBd8ouQMUFcV8Pm2Mb5dxSy6uvRiez6kWdkSkj4sQCsrXdD0NC2hocNwcbPnXio
	 o5PCrAehGH3TlRa/qYQdLaMeWXpMt7M0QQOiGsdKBW5J3/Us4knXbcV8o+UYtnvZA
	 OXvb4U1L0yke9eKyHTKByfNz+uZQALtu/7+8l2soFYVzswhudzSXEWW9R2eZWP9LM
	 fv+onUGE6O3NmC5Hpg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MYvcG-1xCDRE0aK8-00RQVY; Tue, 13
 Oct 2026 18:30:04 +0200
Message-ID: <730578bf-1017-464c-b4f9-d8e7872fa2fe@gmx.de>
Date: Tue, 13 Oct 2026 18:30:01 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/281] 7.2.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261013112855.045212108@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:eliAH5UsBprtvA+IC/cyyrVcW8pNcOIil6/J1GIWEm7SVh6pfEN
 QnQfrpe8oIsxYnARhxkeNmO5p4stRaPnZCVcJPBlGquruDwmqAhkCNmAvjDZ7G73iQR043v
 G/W7Rzexo9lK8QMWT+BLSwiBS6i7Nxof9fiCtDTUsmuhljMYq7c7lxZP0kkyoTaqBaRpiAj
 w8qgNLuvwPaMVtK5U1q8g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:qA+EEQ/Pg+I=;0AYlbh9uzt+e/dkLtNqhiwtmGbH
 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
 jQYj

Hi

kernel build / boot test on x86_64 (Intel).

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
