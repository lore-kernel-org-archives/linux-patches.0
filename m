Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12CF3AF65A
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 14:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276856; cv=none; b=mDct5uCgSkfiO177hZdRFQ1lmq+t/jg9AJN+EEtJwe5HpeX2ol/B3YN9PQ1JGPFIG+E1ohClL7q+XjP9edqKL0/4TjwQwGyC+kFksnN/Vv32n+KdJrvmnThhm7QVE6uLtbKDOqUXURnDGvdP6MWxFerSkTmAOMrscwUGkGU5SBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276856; c=relaxed/simple;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ele+0Y83TyiE58snC3cyKjUguRgPli1w6ZCa+0gQ7TpVvcVdJZOtSqWAIwCZsgoZvoYuYwKIUwJStgEJ7TxLKrybgO6o3gJuWiQG5edYTJB1eTkCRCRnrn5ueujChMYoXxca+Q+Df/lFZllpZkUSwjE7G3NKVphqtiTGOSFjjPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=D7uSt6ju; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="D7uSt6ju"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1774276827; x=1774881627; i=rwarsow@gmx.de;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=D7uSt6juIGkosD2x9hULNEUIemPh3kNnP6AybJAdYB5XfqRA4yQ/T5fSmqW99ZYE
	 xbjRfrdafczpnYq8XIOHZXylsnVpmFrVFj9MpR1PGFNksXX23+wOt0c7IyUKmjfRh
	 plwzck2l7zF220gPmJQxqB67F5ZrtIecEmpFSEM1dV293oDRu3rKQSSxamYVVAFB0
	 uVobg+hi636o6ThW8W0ENZXpP6EvAVBxRpLUF5ulxpILAqmbplhMGyUHo/MsVMqVd
	 aCfLMbMDbAhBzJRq+W0LtRvNTdE+jRqYiyH2C7NQooV//MxwG5PsMi3oMjykcoQwo
	 NCHGn07EaOrjHxKiiQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N6bfq-1vV2JA48jO-00ugxC; Mon, 23
 Mar 2026 15:40:27 +0100
Message-ID: <4d77399e-ef71-4311-82ec-336f90929801@gmx.de>
Date: Mon, 23 Mar 2026 15:40:24 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/220] 6.19.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260323134504.575022936@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:Vv8kXCDNDQkWPGNUHQb8T1goXlnCk1JP4kxLyWOaciVqT2dEEoS
 vNYzZQjUDc/1G17vvPRmdAf5/PvshOTksjgGfEhKn73sLpzlBU0Tz9bw1+fgoCDmFvPyQP0
 cb4hmYBwdxa3NoAAEgIPJpF3/kpcNvCHJQpeZmkBWiLk+05l4HnZMmyVrArNXn3QUBeooF1
 FTLFA7LflUFBGrMhsnu9g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:6Ry3st8d5o4=;iine5sm0yQS6qGqYSlTZgKCsbGo
 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

Hi

no regressions here on x86_64 (Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
