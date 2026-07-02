Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204BF360EF2
	for <patches@lists.linux.dev>; Thu,  2 Jul 2026 17:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783014431; cv=none; b=gdYwBGXIo/bBHxwwRQMzIqGM9Zw7e+G2W5JJr3t4ihqOx5zlByEAWDmzfNhMDUxlIg4lE0OqnpWrQLjwN5+02fZyFZNjXqVGQYuu4RUo/RURrWQ/p4o9p0uu29DUC9qSbgZvF7fFNey+TKNe0LSVw37Rf3wKk/PFXZgZgW/6jlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783014431; c=relaxed/simple;
	bh=1PO3YHl+btPykbwTM16jfcwADiOLFguz3RVcskKvjrA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tjZ2BD3OpRUUEpEmRsBHQB9veFvKJjFY9Xv8k71hFBP5V1m61HZEqN0H147qEhvYyLsE9wRRuXrGDi8xrjw7mzaMF325/JDERj7jPPEm/S7yeBzjTL5THP5mT+Yx27iE3D+CA7eLUVX5mPjHHYd5uv986n8rsUWqT/G+njy6Hgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=Xj/kZIaV; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="Xj/kZIaV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1783014398; x=1783619198; i=rwarsow@gmx.de;
	bh=1PO3YHl+btPykbwTM16jfcwADiOLFguz3RVcskKvjrA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Xj/kZIaVHCk8nSIzOzBwPRaVXl5yyHMNsSxE6JbFqztab2D6spGweqyH2vAmmn5z
	 X4Gmfu3KeNXjbVVrCZTmHdebkJhe3j/otcucMngdfEeUozkiWg7JbX5WGdDuzCNk3
	 qsIs0B7oSWXyZ8+Y/PyVsT9tM5/Jv3dhflhdwhQOhXChmiEeCmu9L5oNwLuUOaGP2
	 2dCAp/G5tr15LpCXpbPcOCsc5I0AHUsS+LcTySua5Yy8nbq2ZXkZ3JN63e28zxSVJ
	 L1WS90hu4dj787qMbkTCsqOphxQ+ER6L6yJiN64cDjf7aeiSYtPJRqPVKKaZvyNi6
	 8a3BDby9XuaFWEP7+Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MWih0-1wdCnm1WOm-00N9vT; Thu, 02
 Jul 2026 19:46:38 +0200
Message-ID: <d7829ebb-2a5d-4ea9-82c9-35bf2f923466@gmx.de>
Date: Thu, 2 Jul 2026 19:46:36 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/120] 7.1.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260702155112.964534952@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:1DSixhzeI2nprKZH/+B2wgxxP/eDTnuxwOju52FKgG2hAq4yKnc
 vHZeFx5nsVQHxtcwOaiye/gyMfFi18sAU4u2r274EbSPM/+lgIanTKgcx0Dty6iIMQl34ko
 huUKFy3xnTysaut6x2o6j07RTkpje/6XnTlEPK9c9LNooKdcDbP31aYUHXsH56zhYVR+me4
 hrM9/ZSTCTUjVwm872aMA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:J5/5aJns2Lo=;GkpZvDp1wbiOTRKVIKw1EcZg1/a
 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

Hi

kernel build / boot test on x86_64.

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
