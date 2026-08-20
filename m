Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCD447ACC5
	for <patches@lists.linux.dev>; Thu, 20 Aug 2026 16:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787241677; cv=none; b=YqKbxkeFFEWWYvvZ/84M2trB3fRZHcaIRyml4SHWvaUIxEWXwJM6bfaE/8U2t0odZIoKNvR3MdHe5Qwwufba/oIbvi3QT4byCgakzlA/nPs+tqDSOh4OM3KlkmzacdYtnlAp4NdRjA3oGeIrUctO/v7GQ+Sj14tiU7o6fZ5RaCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787241677; c=relaxed/simple;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BYQYtt9J9hex7BvoYa+l0arl+Regp09dB+rta3NFIj3OOX+tJv9SZ2lQUBVQOXRpN65kF1LCjMgSCAudaHp7X3/+KUvV9TgXy62wBKvY6tmoeX6fmNT/zadn4s9vK9tYpvImZMQ0poZ+UzbO5/HiXwgkA6wQAiuM9/io+OtUzK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=W3O61Uil; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="W3O61Uil"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1787241650; x=1787846450; i=rwarsow@gmx.de;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=W3O61Uil+wTgrq4P0Bmgf0ZCuHOCA5paReQLdyd14lEmxIEvmtGTfBSyTZiUXlvI
	 mWIq3h5fUrOZ/EmwEdYzp1slvGjBbu+HWDlD6WgGOBLHLsFzxsRMJ6lfVPHGEuVzJ
	 cuyFZdAMhAR9GVxiTeh0usw+gnNKsXCD/umixvrOOlBvdQcUJxkTaVCPfN7UAOzC7
	 OQf0fKW5P5slVhSq33CJkr9hUTHp2VBGw7PAQXtklsuEIH04ISetqZNJeXyKgKdEX
	 JDWsT3N5sIIDcVabCYSGMas4NFnBmPlrLdlnETUYgyuXfXr7uOyV8lJT0laAUxuZa
	 yeuppj94YACB9HwG+A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MOA3F-1xL6OR0xMP-00OzA5; Thu, 20
 Aug 2026 18:00:50 +0200
Message-ID: <efe1d2b3-5915-4bda-8797-f62bdd6a3e29@gmx.de>
Date: Thu, 20 Aug 2026 18:00:48 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/228] 7.1.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260820145244.450574346@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:0xu0V8R6YrZjDrZ2vPqPILpR1AbV6++l289zadDFzkVyWdO1CNf
 xaHg7tmyVcugeRn4YO/2XF8b8GJ8C/9vrDJ7mrvidjwsyp2YPVXUPc3dmVwPCU4d01Vhvas
 HojGYoEHx7BHk8vucelEp+mDD3kCHHz1O+iSwAAH9h98qBR1jIgWZs8Xfza304Ia96x+wJG
 dEu3/nrzKcyHNVKAFwPzg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:eQCdokwCAm0=;xO4XtdRxR8B0CKh+hZCcFFwiiQk
 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

Hi

kernel build / boot test on x86_64 (Intel).

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
