Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CD3217F42;
	Thu,  7 Nov 2024 19:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731006607; cv=none; b=CgLz9DV5RNKHfvLXHM/cHnIEuOTlKF1Z9J3FKQsfmY3xDc5c4eL5B4rlSEyztXKKTcmZBG/l+FjkwuHS8AkCfykId59IsH1e4Y/LcN4WHB0fPPPStx/XLbXwfjo9Pad6ZQmFMQdoH7lIR7Yi9yaLpFZpIVQcYsXB7tP5LOfDlSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731006607; c=relaxed/simple;
	bh=iRSK/2RrHeyLRWeWqe8y3ZN3XJ5KbezUUEVfCcRSMOg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=jMVjX5sRTppd1wnhBMAMD1fKszoxNOp4pSFnh7vMJ3RircqnJSxibzguabUChF4IhmQpS8iVtZm9dTjm2kQMXF/HWmPqiy2hF4Szwd6KQRkTOTQ7E3OpCOLr4AqfABDQ+6OO3n/GVnt06yB3sl5/7qjL8OHasfwzGdA+feK+Eps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=svenjoac@gmx.de header.b=FVC2r/XV; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=svenjoac@gmx.de header.b="FVC2r/XV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1731006566; x=1731611366; i=svenjoac@gmx.de;
	bh=PUe5dMBnM2h1ROFoHnXuf3mS3s1UtGbSIaFLr+Ktzek=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:In-Reply-To:References:Date:
	 Message-ID:MIME-Version:Content-Type:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=FVC2r/XVBZ44z6DuR2SdAP7MCwThDvlBaDpc18psWNZr01yM3yw9kyu3UUbcXgAu
	 oOPySNjeTAa+tFnedxORvhFAZx/tPe+ZPgUsVK+YPmD/4dtZuGOf4U3SJtL3Fw72P
	 y0bUMECKkSkKojGF2z/vhQCkKo40vN/8+5qrCqs4IiY5P8uYoq/oNfldp2tSQmbg6
	 l3TzpNlXGUmigD2ME9sN0qrpcb/9JKZVgPwFGXctWs47yrOLlgMskcsnsIUtE9wT9
	 4KTyzoaMyTe0Fz7XIRx8tRq/ikIFezJRADlJesWUTCL5KGNGcCxs1umdR0LCIWPkt
	 JX7D+8S8NdtIz1A5Ew==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from localhost.localdomain ([87.168.51.82]) by mail.gmx.net
 (mrgmx105 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MbRfl-1tfzrT1i7l-00ooij; Thu, 07 Nov 2024 20:09:26 +0100
Received: by localhost.localdomain (Postfix, from userid 1000)
	id A13DE8009F; Thu, 07 Nov 2024 20:09:24 +0100 (CET)
From: Sven Joachim <svenjoac@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org,  patches@lists.linux.dev,
  linux-kernel@vger.kernel.org,  torvalds@linux-foundation.org,
  akpm@linux-foundation.org,  linux@roeck-us.net,  shuah@kernel.org,
  patches@kernelci.org,  lkft-triage@lists.linaro.org,  pavel@denx.de,
  jonathanh@nvidia.com,  f.fainelli@gmail.com,  sudipm.mukherjee@gmail.com,
  srw@sladewatkins.net,  rwarsow@gmx.de,  conor@kernel.org,
  hagar@microsoft.com,  broonie@kernel.org
Subject: Re: [PATCH 6.1 000/126] 6.1.116-rc1 review
In-Reply-To: <20241106120306.038154857@linuxfoundation.org> (Greg
	Kroah-Hartman's message of "Wed, 6 Nov 2024 13:03:21 +0100")
References: <20241106120306.038154857@linuxfoundation.org>
Date: Thu, 07 Nov 2024 20:09:24 +0100
Message-ID: <87pln63lp7.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:Me4Q2xdlDEwsRvGblEi3CSToLpXpY2h1CIU8dvUTKdkcwM/vaWg
 K/zKzvhxJs+2r8nHzLx/KXIiJpLWv1Jrdu0uKusf+ORLYUR4/rmZ0C+wXilU2c8P1WkkdEk
 ZoGQ805H0Kh3S5my2H7BEtrnW29BRvkOoI40NzIo6lhRV4CiNMtJgozb/DKg70+6g7pI8PF
 v/zxxbuN4z619xg76uDOw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:RMwRqL2qi8w=;D1UJYuOuu7pZl2NFKXAZRFNIF3C
 iskN9NCphv2RpVtKCC9Cb+WSVNXwjU4Wg42nIOXJIeY0jBrsA3NRAMdGl21xCq5zDi0A7RE5z
 uKx9CM3RrwFUXjJl2EznCQAETyMXV1iLlPC37Wi28CDZd64RJSDkqAkcg/y6xSGRp6TXWX5SO
 OkoBnd0syMNncDqLRdwOoWvtG/ojii5Ge0yt63Gwsy3s+fIMpTRIztk/EwmudgvfWWTXUOQSK
 +tRJYPA6bLFGwk5Ux8z/9xYHn3+qs6cx99Scz7151lry0BgzZ86aFdgZOhFVcQpwyqrbuFRUX
 XIqC5r0mlWj6pw7QmgnvJHdbDqZGKW1NOBmpHVtTyYDdsBJV7HzgJ108Q8knLcmcEnkAY6tXj
 ce1+sQ+ZJOeAxFNKfEZ6VJWzO4Absc+2/xlVBRUrdv+ht49ekafchP1dQjU+XIDKWA2+0AdZY
 zlicQAsJfwcZOc7x8nKgjHRFq/PaVKu++w4ek11d010ojBZ6ZvZQp1bwNHYkXCvZ3EohKEh8z
 75oYebLINRyIxkOj88FTYotUaFJngitfffpUgy+1/Oylr2qxhcTr8WHAq7j4HVDDIIjw1bSL0
 /6osuBE1QROYo6hV9QOqNx+O0PXzw9PysZTvrxBNFURtIOwvMX7hz5dZayiLfOYYR3pMkHMh6
 K1PJ5yqTRCRCIRlGU6mMYrA6S0Kd7szQEVZoZ3xWyATqIrDfhwXNSgZw6Jjc7YAdAye+xUqIZ
 L04xmHkm77VEKMuc2eIr+SRwp4hisJMfI3/opZhJPRv52mWPz793QZ3HmMZjmKwziAVC5mqh0
 aGky6fyqq+MlI4tqSp5s35cw==

On 2024-11-06 13:03 +0100, Greg Kroah-Hartman wrote:

> This is the start of the stable review cycle for the 6.1.116 release.
> There are 126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.

Works fine for me on x86_64.

Tested-by: Sven Joachim <svenjoac@gmx.de>

Cheers,
       Sven
