Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B168F34BA28
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 14:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784731927; cv=none; b=TTqpBB2/508Lxqd7STlR9u7YNiY4ipaAyNrS8Gcp18EK9r77u67QUEfnT3/2K+HnffMfxXNZPxnkisYAmiOyKL9EeH2Q6fvV8IiBRojukvD4H9NYDQNiHsUQDRw52R5lrGGYCGts3O7tzVbPNbPC+bNVeLg1ZnlPePOENl0O1wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784731927; c=relaxed/simple;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=okte/+/RoxnLx6hE7xvm/KRO5eSapS7nFb+nglAsKwrnndkYidPVL4ugiGbGEbK70YmiWDfLZUosi6kz/Nxav9jBlszv7GCIFY/uFKcz0G1G8xNI7SnyHMHxMf/JSJrZmdQTVe4SMDfPwVr1tCPN/U5t4klV1SBCdwXk8JIAGaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=VIklC6AD; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="VIklC6AD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1784731917; x=1785336717; i=rwarsow@gmx.de;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=VIklC6ADQ4kNCJ/qoBEr9uC1xQS9ZpwF7l3vyGk4vwfBEapeOaQmBzmTQxWHAkaj
	 ctEUa1+3UomFcZp4HphAtj65qDWvQK2v6SvGeR6lipY+ZnWzV1O2Rf0iSHIrJ1taO
	 hkG7q3sSfWxu/j1tLURyhAq+5UMUvCdiqyF/GXNqW+FGHvK3c9k8IIBK6Mj7ptUye
	 WWDGyh3fysSQSgscg5cIGZefodeDfsnKnA6kMYqldKcQEJzFx1gc4kkJWSMxWleE0
	 cRQBx/vEgo+FfJ0NpLW+44lxA0RanSHT6ceTYthThAR6u9l48STvKWvF3pUB2++d5
	 bZ8bJAbAOkVrTPkvsQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MGhuU-1wiipL0jZ4-00H4YX; Wed, 22
 Jul 2026 16:51:57 +0200
Message-ID: <8cae785e-2331-434f-89d6-d8ddaaf4795f@gmx.de>
Date: Wed, 22 Jul 2026 16:51:55 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 0000/2079] 7.1.5-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260722142947.085426486@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260722142947.085426486@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:kD+P3Ba1EN0UfohW4W+d1U0dd/EWF+c8Q7AX9DLB5Edffyolshb
 FfTNdVIbcEvUDfG+Xvg0TcS27iYeaaZ1QvhVWbBHZtWFSHepECjTJy1GFF56r4F9y5SQ2df
 6RAHNezY9KpkGKh/QjeV2pfHlYMwdvr/rzAtEpERZLCKeTo56n+RzQ/RNIY+UhtBu4kS/Hv
 XCLttPv/2U2F3k7T71WQg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:JvtODYpbKzE=;BFu+F3d6AZqfdst6BqUgcB7/1vQ
 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

Hi

kernel build / boot test on x86_64 (Intel).

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
