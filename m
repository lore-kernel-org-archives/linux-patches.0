Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F952459E5
	for <patches@lists.linux.dev>; Sun,  7 Jun 2026 12:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780833818; cv=none; b=Z8ZR5i7tYn0pnoa/T/Gc+FURPgOfgVNoZKJOmY9iq+RH4W9d4C4rLXxdrsSC/rxXH2llhAZLUikvyLRVWfNtLf9GaWlKTInG/9Ru/d6fscqJXTj8pDIHClKOykKVhQFTNoFv4n+oMlowqe/Ak2qLZxzMtZUaQ16pRqxtNrOUIn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780833818; c=relaxed/simple;
	bh=1PO3YHl+btPykbwTM16jfcwADiOLFguz3RVcskKvjrA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T/sgAVyG7D41RnoCpbhff8Jnk5Zl3/be1lmJQEZJ9Apgj9IIC4jStn8fHN55xOVyYnHEmCxTBAwYfk5jWk2LkZWpRIvcDW/6dMQxWfsLhnkkmR4RmO/bFbkuQBNB8IRkfqfH8BzgrKSWTmo7ZxFrD8fELxDdkheXmmNuJaTLNvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=e+5CAFWE; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="e+5CAFWE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1780833797; x=1781438597; i=rwarsow@gmx.de;
	bh=1PO3YHl+btPykbwTM16jfcwADiOLFguz3RVcskKvjrA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=e+5CAFWEHpRDEAX2GxM5UUec0X+URkZEKBOn5GDeLL9O42AI+Z/4xzTh36eVQvME
	 i388hnYYHQBiUJhoqKOskKHs5aEFP5O7xlBW5Tos6p7ljUaSRGoizy6NGQKdVl9sK
	 vEJ5G7kYyIF+Bv+woTGa7eTahLvx9MKUMx7VQJh8+iM5SU3GK9sz7P7WXQCUCK+0w
	 nWV/16+HGtBZP+ca6eaz2/picQKoKGfW4yzPEKB20o7SzVCoURQLBpS47nO4jbKp+
	 heg/++MS/PBS13dDe/rLxykvpeuGvwb9lDao+eOd9ppMfYffIG1LaO8dNqpUEo8UR
	 lcya1HD7hq0j57VWIA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MVvLB-1wdaEa0bmn-00Py1h; Sun, 07
 Jun 2026 14:03:17 +0200
Message-ID: <b3e396d9-0d96-4e4d-8720-11be81a53d92@gmx.de>
Date: Sun, 7 Jun 2026 14:03:13 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/332] 7.0.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260607095728.031258202@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:J30D5IvG4QSdVhwb7Q1nXPRfyxln3VdB+Txri9W5ACWZ+U54NQq
 m372ws5MbGTh1tUFZMBJi0ZkTPh859ErXa9p4auRuzG8JNV/oBMX/pVokJYPinO73GKJwUF
 cSIBqZtUXedxyfXSjJXqfqj47LeW8to6ZEGrinKY1eVATS5atCDGfIATu+ivpvaRJaVLGHm
 JRYiML8A38v0DtesQczxA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:lrL+AL6dnQQ=;RVQ35/l8MD4GwTO1Urp46GV8H58
 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
 Fl

Hi

kernel build / boot test on x86_64.

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
