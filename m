Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D46517BD9
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 16:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660870; cv=none; b=si/y8ilgPXTb1NiluYm0IulRZmqm/NGlnIEa1CwD6IlvealtQCMtV5ddejV5oH9QPS3DV1ghxaYbQBnajkAcaiEbatVRJCy8ABgfX7Ab2n57G8YKnpiU+iquceVaLGuqK5VTxzZIsyV6wuFpj9BF8evQB+PEl2KmtmERw124TMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660870; c=relaxed/simple;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cjJcmYStJmHXhIK7+a5OgwlPJof6rH+k2uXTCFE8osodl6ZWCHmnr/jqxwec5/H/mreNh4J0fbEljAosIsKqf4+cNQZykk+MIfCCrP0ZLjCM7JPKXMHOMD9vrkIgSDXqItTQ4e17JTEIYJ8Fel6L+Daw0P6W7oSN2LN+XHVTLug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=VQ00FTUO; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="VQ00FTUO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1789660843; x=1790265643; i=rwarsow@gmx.de;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=VQ00FTUOG0HqkC+9qMNDDQi73gC1aEuwJLMXgzMFsogkg/b5mV7/0i8VzIOk5uUV
	 x5jnSkFl4nrXaLEDz8E4I3sK6FBEK2pAskfUrAMCrhk8hZHedYt7zAUOW29cYKW7p
	 e51QklFTAScNwEvTMmCKFkQE5lAN9GcH/CWZAKFpIj1XiTW7yyj7ukATRQJbR5L4h
	 P67RxEYXtAH5S2m9ycfZeveyQtdfBQTvTIxSDgizGhop/jLvdqzHTpow7xYIqD5vm
	 obs/wKEgfs64n15r6hE8TaScbbTk1MoWebJEjgccnDwVrcdPLHXnprkBdUQ431jUX
	 dqCFo36UBS/EKrWezQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mdvqg-1wXcGy2r7G-00mFQ4; Thu, 17
 Sep 2026 18:00:42 +0200
Message-ID: <fbf790b9-0d41-4fa1-84e6-dc79dce750b5@gmx.de>
Date: Thu, 17 Sep 2026 18:00:40 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/733] 7.2.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260917151350.597953846@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:Oufpt0PXCmKgeO+NwznfZKveCWlSHhF+zGB9dduCul0+TP7hxmZ
 IPZtoqs15tla8mTBx9wxRErp8NsHLjSH/HADJRjZ44T4upG0A3V6HrV3rYIR1nDS55V8fhz
 Vf62RRbRtvF+U0yj+tK7c0GFR8crARB6mAvh+7CRcf8zWhYq4c9QUEjUSS/uZ0yAgZc7PB1
 FZeLBX1b6ZSWvZUNzHSPw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:UxE5+1mMMeA=;2RIGGfshq+RGLIT7GHMsNXXNeep
 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

Hi

kernel build / boot test on x86_64 (Intel).

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
