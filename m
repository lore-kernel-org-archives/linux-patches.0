Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5EF2BE7A7
	for <patches@lists.linux.dev>; Fri,  7 Aug 2026 17:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786123463; cv=none; b=ry7NDj6s8G4bwtV/EOVMQRktAwscR1blr2O0eVCsa6mXapzlTkWFknt/ONyCleVEGNr3VZJ6MGx9qn06oBns7W7VIhfNdreCKQDikSf2bMUzMIcu+HR3cM+83lN/QX28iY6UotF2H+nbO25NnK7OPyDmrpvQphR8HvEy5UpnOok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786123463; c=relaxed/simple;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gndQlnNUkiisGq65fwcxDX7wckIiVuqVb4EF2oLJQu+PVkXv3xGs4YMnl9syauxA4LWELFEA+VzaKht0mpWi754T/cU2PklnPmiPhplMMsTK+TLlarR5kV/cHVf2+gtFxROrUWpJarGUWfCevERAEeskEfu7zZ3KmUzy9o9nB4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=JlRZrgUX; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="JlRZrgUX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1786123452; x=1786728252; i=rwarsow@gmx.de;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=JlRZrgUX1Sv5ovc2MCZKqcUSvBXdeA0IaNcIdoN5wa475m+mxe8YpyPLQonTnd/T
	 Z71cWEvRaWVDVzNnk0brPA9BN3uhG49VzCJEcYne08lRKycRPMPURLSyBsNLt6+bz
	 0wm6HA5IGNDbX8ecMWllBVGFDlDafp4+xArGFWNPGO0bVffXtYGtbecxJfzCQW+Gg
	 myL9c/sureQWHH2p5YMiM8/K0jHg4j0onsg3CJySIBZNNCF+0IQbdjoDYaYrbujbd
	 bzLTVsh8TGHQtdtyYOU0qGG3wqTeR5/L7bogX4RlERc/NFwYBgUtxnWyRha87WH9e
	 jcK0s8jcDxnZk/u/mg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MmULx-1xJEj71ajp-00fsO1; Fri, 07
 Aug 2026 19:24:12 +0200
Message-ID: <9ec1593e-3a83-4495-be5c-31611b2c6c9e@gmx.de>
Date: Fri, 7 Aug 2026 19:24:10 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/438] 7.1.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260807143428.008222056@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:IL+JGa7maNNNtHkslmt4cVsmgI6j/rcatbGjx8ESwoqBXRpe5+e
 /SKIsStybUq5Z01CHcL17cL5sZFtwqTkGu+AWktt+kCj33H30W5CaWNB4O5daWHwA181BaQ
 oT0WDhvPtCzmOXU7XSWJzvt7Y/nnHGbjkgHbVDSgmkHk+MVEa637oroCpSMP2sI6R5QvlDc
 PZMpl5vASUcpXfK+P5Euw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:GkUTgPaEHQo=;/0QNezfKs7tG1tuBxpJX+JVq26w
 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
 mmi7cMerT1HwbdzIwGnRbXT3A==

Hi

kernel build / boot test on x86_64 (Intel).

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
