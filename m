Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7FC3CAA57
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 11:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783079827; cv=none; b=WTW2xorzbtDqv0debrusoRG1/WEv9egOpryftTyZUOqtKAvICJ1eaiSzkrLLloGJ5/9k6pC6Wp2k8/I3Hui+rem1Ms/maHmDSYN4hQck2CQ6EpsXgnUz0tb2dmLcJT157igy084NYqRUDmpztxPdMaiV3ZskFrL8C3vSPreRIN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783079827; c=relaxed/simple;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dekUi7ESntDZ3c6VK64hLrvwsrUkPzaJkJrKCKTmB/VEHtK6Btm/gEVyfnwqmzpt1PAxjW+JFpSZxx1xCvnYuyfZ1vS3KQSicQKMUe9xBAhG2YZax41J+9g/8F4CPxuSoQ9/1fVp1Gf/mVSNcsz9ivvzS6aCGTycP5bu1c4e30A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=tQ4IcsZW; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="tQ4IcsZW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1783079823; x=1783684623; i=rwarsow@gmx.de;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=tQ4IcsZWkABVDpLxsalHA27cPTgTsJqtFxGRSAb7ibMyVpw/daRUb71ElvImJzOj
	 4wSYgkpnTHn2KRXTzb9iMqlP5iUJyBoE4A3O6SSxCwtBHNbFjdkVXPzNxKSiKDCjU
	 BMEmrd2VfDW+XJRRkPJrf8z2I5R0xTxIspI982vJCqFuIemhPug2U4gsszHch7Ziz
	 ZBuuAjyKg7OfLFW9peZSogH0z8Fj1T9ky104dpuw3T+2iOJH5IFO3E9BMAtgnA3Ek
	 5/A0XVCPxOCG9/Ct1BWPPVZQaefvD8Dabs39WLv0ItuYp4QmkZ4qtvkOVb2lnlrfV
	 Fcnvqohhp/5R5ucMIw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mk0NU-1xPea72N9k-00ifwe; Fri, 03
 Jul 2026 13:57:03 +0200
Message-ID: <663f38de-c1e9-40f7-a84c-4141a4f88596@gmx.de>
Date: Fri, 3 Jul 2026 13:57:01 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/121] 7.1.3-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260703072822.817328079@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260703072822.817328079@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:mRSqgdLkY/Sos3hgsh1yx3siBt+QxK+mSVow2xmgrmsz7u6htps
 rnXzSDG+6vzlwh5/o7SQTpL1FGzwfpZwcsIxIRaF/DKDeuwh3bU/qltoKNm7Zmrg/T3qcyr
 1dPWbvRg/ZpdnqOdts5rtgm5yxJGCLYwwpMlNQD9xRgNMZkrypKhZHhh8FptCNy1Q4Cz4Pu
 lwQnYyI5KBPAzniGv8CkA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:n6MnykovWjQ=;tPyjd0Oh3KqEGwdKrS1ACYP4+aI
 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

Hi

kernel build / boot test on x86_64 (Intel).

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
