Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E643B518132
	for <patches@lists.linux.dev>; Wed, 30 Sep 2026 17:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788219; cv=none; b=JJcvU0s2dfqHDiiHxpL3Z0AsMFg5HNaStRnsTKj7XNmpJaAVswGRzSFZ8Jok0BO96V5qtM+dlHPtRDxAnypa2BcSvMHsPXN9yGRgV2i1emg1E0rLLgaYduc9xBfLOQXtbrFGh8lGbe/5XTYuHkHrzS2Qk1GO/frbzG4vtKGhWmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788219; c=relaxed/simple;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=THfYZUpEVJYOQXQr0y93z19VcgJPKeFWTn9PsXR76xOjfvJ036iVMr5fg6Oy1Z4aG8S6H1kPWEpuQebqmQgcS82gSPMF7wMWjTLulOLrvxjasPJehfmmsirUkUU1SpBP5DF6LRVBkWcWG9sI6q9A7Pg9qs683kUlaDIS7YmORv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=HcW7cVY5; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="HcW7cVY5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1790788207; x=1791393007; i=rwarsow@gmx.de;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=HcW7cVY5QaROlgN3BKsLfM2YZ0pOTRrDS7t3b+N/T4eeK8LoDEClbamB6t7miPk2
	 1jLO7APGn23lCGsCkeVKDMe6bBbOXn6qFB24nmsd9K4bkBmoQ+S9GZzglH9pB9TWv
	 wXGJE2TLKOYAlES4G+mmVL2ZaZqlO5xhzx1+ch8kq/EfjvGohRp8LzbXwzrlcWxce
	 XjFT3HdKeYiHmrmyMjggd7Q6xHpoFTFN5dC5oUzL0sZP5Iz0sW0xxc+Dwo5jSbSRU
	 doEkbCKvArydr9A/PHuDOjk8mv8JprOBmRsLWLV5L47tsQ9zQ+Jpy0QWUqaKvexUt
	 +xPldxCGkwxGWWnj5g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mq2jC-1wQIvN0tSE-00laB9; Wed, 30
 Sep 2026 19:10:07 +0200
Message-ID: <0c737260-3d96-46d7-a037-9833ff7960d9@gmx.de>
Date: Wed, 30 Sep 2026 19:10:04 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/457] 7.2.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260930152346.024115587@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:C7RAbQ5ob67ZKsYrkPC37A/07znc1TJahZS0ulVlPIPEhfhKFCw
 ogDMRYqfzNo7yweGDzIRpVecqWDbFiD/M1jIAifypnLNNRx7KZhBu7tWGySc5Yuz7CQ2WWN
 8dF3nafdYqxgLi957rLEpN4UtxEdqEGCE4zUmdK8E5y2zzgTVPphplMDemjJwmxqROeUCcM
 xLwy+yqjQt/4MOOkbwyeA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:sRPZEHJmfwk=;y4mMPsHA8hTJmcSek5JCb+20V7c
 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

Hi

kernel build / boot test on x86_64 (Intel).

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
