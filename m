Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D88471421
	for <patches@lists.linux.dev>; Tue, 21 Jul 2026 20:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665286; cv=none; b=RPXlBbhggBQAnDnMaq3NGc0ZoriW4WgCDEUK7mCz4aOLkSQh3XQwJyaShktShxZPL8eKe7jwHE7wQIC/G2QrFSpC5tqtuL1LAJwRadng7+IRQhflOYnYOcxyn6AIamAoLnZXyd7udsQVmJG41nbI+2kw6KYBiQOGADOScSGrZQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665286; c=relaxed/simple;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YHGYWMZu4a6yYUPMv3MGZBUZxPPr9zl5s12RY5nY+iRcBEVMVGRh52EJ8+xxc4/b/T8EZRruaXuPYIexby77BCqZfwiELhaC3UvmzlX6IcOKzzCboBtXK+dSnA+dXYYZl576AW4WQiP325Gtkj/SIRycGC/qi2O98yCPnyYc0NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=OFfr3Ji5; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="OFfr3Ji5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1784665277; x=1785270077; i=rwarsow@gmx.de;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=OFfr3Ji5HDWO5cP/BieP2FWbcfKhcZ3/+Tdl2mTUSFkXEddsYRGQtMCJcXzCx62i
	 P1QnZ8QeLrmpf3vrOBaw0BBBGjDAT5WD99w9LUEB3KLviqVjjyyTI3ZWTEBy5vqNw
	 3zPqcNTRsqiVEOZT20JoOmQpyflBbO63y8CEy8xghorFKI3VJZ1KPH6e0ycPrIvhs
	 Hzh5CG6ULwAPtab/DfYLyIM5Xl6ozB3jY5wCAmCeyo1mQg0blPgzipBN37hImJ31U
	 HipIXUA9fMFGklgW+/VHvkqTPVYst0nTs1sH88Dqs1wOMpeh0wvQPDxxBUS3/QLSt
	 /jit1fRn8d39uilmkQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MnJlW-1xT3tI3fs4-00eJb9; Tue, 21
 Jul 2026 22:21:17 +0200
Message-ID: <fcc1b6e4-1691-46bc-82f5-ab6a6d0f1b99@gmx.de>
Date: Tue, 21 Jul 2026 22:21:14 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 0000/2077] 7.1.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260721152552.646164743@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:+DKn36so8T+XzMivzZqFVXhiTmAt+nRuCbJpTrYoRevkEDj+rkS
 4Qy2zV1BOg7akngodmIuautcM0/k+mFOW2uzbbO0C//m7pWqjFzI4K6oLIEFVQyogA0cf0D
 e/4qrN66W7tUOuTAgDTQWTWsDt9i54GQiQ7lUKcfBC6B43AWfaA2v+tmzZNBJ/FnN27JGZI
 4piIksdNjorcZFps8xYMQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:uL27r/QfEH0=;3Px3eWODIyHaSiaPD5bNJADiePH
 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

Hi

kernel build / boot test on x86_64 (Intel).

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
