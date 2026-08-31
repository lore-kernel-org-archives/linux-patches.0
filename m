Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0BE442382
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 16:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788193137; cv=none; b=kgI7WSF3DsP62ItozXTPZuN4eM+Oyr08sPF0KvaxsqvC8SuDzlbOmuxLmhcD+I31ZEsVISEVwle6izjqP+UxDQ/iQ16kuzUttqpVAKr+SsL2DX+hFdly2OJcS69qtfP8VSy4b+VLJjUbqCjO1GCrSExe3zbiEq6QYZ6NOBINH+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788193137; c=relaxed/simple;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NU8DstVhrC+8fK+soBEvJSd+Xk0UzjdnLhcfNX94z5APsGTmSw0APacGZrlf03blk1XpOnGbMXrotMH4Pp4gr3o9rFEhL6oJcBJ5pFRjL6RiLUE3SQTGPljjMqeF5Tm9iQrUQxFAH4yoQt8O5VI+BulxowTcn/m9NgZEdRcJvzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=sOvBTQRL; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="sOvBTQRL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1788193132; x=1788797932; i=rwarsow@gmx.de;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=sOvBTQRLtAIWgAkjFOIkpV4Ars+65+RF+mjER9QPIIsewXxXVIy4cnHTpYt9D4pM
	 SXJiDrlKLB7SW9B2GN8WOOLa4Pz5dzqLIRmFG/8xUDkyI6YXqdai8XDHA6d/svgrX
	 qSENgfpLGRS0FRSGxhRr5KdZB7N+LMrZVz326hCEp5rZ1ZcW2ObjlNiZXsp1l6/6d
	 OL5c75dQw3L4SIx3iFdqSSJp1rWATDy45BFOd5AjPONCFqn9408d6f5OocQ6u52LJ
	 VixUm7pxHuWq+b8nlS2NJ8YxXx+Ghn4DIPeYieYvHeUBQXYkZWHG2glAsyqUMSc+m
	 7yiQvQezNpDpAxN7SA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mzyya-1weTvu2C2w-00tnYF; Mon, 31
 Aug 2026 18:18:52 +0200
Message-ID: <725cb9ae-3ecc-4562-b436-8b289fc07230@gmx.de>
Date: Mon, 31 Aug 2026 18:18:50 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 00/71] 7.2.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260831133359.055927882@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:hEH+qjznRpJ77En/lcI+a7h4b9aQRbV0oJ4jwE2icxxb/UK0VoU
 q5nzzj7a9/U6LYs6gcWB8O2KJ5NqvyCnBFb9Vn30IbP/3WCjCFQV3zXsFvhz/oxw72t0RmY
 dh/F7CTR9DyxjnwsvUO/PaZ13jWE/k1Y8aVzfwNYTSWUNtTWk9z1r0rfG/bJepDwGaYwsRK
 2BHX8UjIkiHjDvQoHo2tw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:zBEQX+c5vYY=;DY4FFIfqkQlfQQNGPICGrZGt1Gx
 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
 et18Q5hFW8dzI9sGg==

Hi

kernel build / boot test on x86_64 (Intel).

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
