Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9016F3E2ADB
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 11:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213557; cv=none; b=Yvc+qt5HIC3LpkiEUNfmEUeCl8Y2ektY8eLn0M4udjWuKRA/ZZfORnDq2nZs9orq0xMIkhI2CHsnj6qYgc2YkJ+TSq7YOWgBT35zeqP6piChbY9691pUnIQAzoBosWis7nXU6Z5/5dmmsx27f1PGTcWOdLnfFww4wSjbv1aBZ+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213557; c=relaxed/simple;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WYtA7iF/lAeqUH4PoA78rGnGg3naVytKY0eZvN7aWDqWmw3VHRpW7XrgiL9FpDvUMLvgdi8TCcCGiJ5fKJCwfreh2JZHo1XmcqEUBjeQxEMiD5mSshwqKmq5ZO++su/bPMKqMP+f7s0L15RayASEXbk/ahZCTFoNS4ZCCxHNxAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=d+NAlzSe; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="d+NAlzSe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1789213520; x=1789818320; i=rwarsow@gmx.de;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=d+NAlzSejjGwU7+88cZN8w3Tn6QTkw2N8c/LLUK7IHdMJtp98Sgg/1V/s+KgKANy
	 VvJ+9tI8k8UsCZ0OTqC1WxmjbetmJjnfgzArmOCVgPZg+gH2pFB9x+kgGcC+qgMBK
	 qH/lvz8CUJZ+uW4WXAYp5mEmM0v188teNUeXrdBTZz2kWOrN1Mdvz1mJSVRThPzAJ
	 Ov4DevXnPxfiZFo7s9JbvBXBfbyh9LsQNGkbZ6BIq7zzW0yPmtohxv9be9dzTX2IM
	 OBzk/0n0C6nHPXcpFrgbEnlxNz1ClBq9u0hGIABElewP1TCGlCjP/QMEe230R/teG
	 2Sqq5wtmL0Mdqpnjuw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mf0BG-1wdQ0Q1qzC-00nKsa; Sat, 12
 Sep 2026 13:45:20 +0200
Message-ID: <9d3c1016-7873-4787-949d-45df19d3a09b@gmx.de>
Date: Sat, 12 Sep 2026 13:45:18 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 0000/1815] 7.2.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260912065648.999753832@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:H4g8eR/HZ/omTIvkYy9tleffxsEqPz3oxgcDlzACrN/JIKTNVJv
 QEIZxWQFjqwQry1A3eKN1vEW+IiLkgktZ3XCFce98BQX9OUW1vaaeZa6t/s+rOYdlaf0LU1
 P99OL9ByyVH1IxMY25kn6sBvdewHzLdNLBWglsQpWnktlESTnHMhO23cn2PlSCpz+2EFBeZ
 WB2Un4Pjg96cSZ5wLhI5w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:5qKu0LuJU1U=;9lhweU+q7WkKhI1Tveim8B3R7t1
 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

Hi

kernel build / boot test on x86_64 (Intel).

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
