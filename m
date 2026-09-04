Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359D4442393
	for <patches@lists.linux.dev>; Fri,  4 Sep 2026 09:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788514293; cv=none; b=gOKX3gF+MpxVZFlQgoZiPCjdW5e/KLfrcE1a8f0NBmvIpnp0IU7oqsDoGAZQfYaKRZlPU2HqY6k8u0kGCS855qXXykvQO3ThVoviaYEct68i4rNPCj92zsO2I2dqX3q4YvAnBCPwRt+nrWIzNqXvA9jO/f+5yK8q4il8CwqS+hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788514293; c=relaxed/simple;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qbUj+cDsGRRqtAcBG/L8X2sb9cODwAOuD2l6a6/Nbkf63XlQo8Zjmr0MzY1E5rbD2jxNR6Ra+O9T9idHvet/WaLq9sIVsWvC/DbnRMA06jWIvozJBmwjTTyv0/jwcq1mMxASG+avA76S11EfBQwPuua5/EhLzhF/hLFBVHVxipc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=qtr+Ch0g; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="qtr+Ch0g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1788514285; x=1789119085; i=rwarsow@gmx.de;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=qtr+Ch0gyBkk9O3nRD6UbaCoy1fWcof8hIfpMKucUpzyK4CghmOpyxx4b9jf+Wuw
	 xVUv2XanBAu8vIPoanD3q52H0wGyHA4+ZavdmKoC3bCpX+9IijIS4FqCDDUKtqBgx
	 hBFVTvHCKf7maLcP+P18f7FYRVrC477rZ7Mciyvy7AJ9e3QpU5Sx/OvCmZB0NYP37
	 c8WPqWb98B0d7HJB9gO6XaJaLY0LvhVMQtBcQPGqw4D29kWGEkV3OX+Xq0shbe7ce
	 2xZnUYVl/u3M9/3idK9jWLn63mS1Ntg68J3v46d9VbmT8izMgmQmlD9em5Pleq6LG
	 gG46YVs9ftuUh0ceYA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MOzOm-1xEavp2h36-00IgAL; Fri, 04
 Sep 2026 11:31:25 +0200
Message-ID: <ed1c95fa-279b-424f-b230-f5618e3a4695@gmx.de>
Date: Fri, 4 Sep 2026 11:31:23 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/713] 7.2.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260904045803.810145556@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:OT384EFXixUADbI8RvreZkS9qfFz0ci+TLqOOJXbI8pJYHocwQE
 1r86Dr5nxZfIJKqkMGeBQAcOlFRNj4/+1nYcl05q2GayJeIsJgy6f7z7qCXk7Vjv8tM5ZYK
 tYtojwZGTsbgeQQzbJ2DqLQzeDY6fFi7eODMhMGV5An0rcvwRW4V70wZ2XQfTkQIIwkYAC3
 uUfTQh/IZ3sJZhRlfg+bQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:YDim9XWMhIY=;SBMC8VMwHjrFSAolODEXDxBarem
 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
 KoGRGSOUOYoS5aYkvk4=

Hi

kernel build / boot test on x86_64 (Intel).

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
