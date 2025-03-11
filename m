Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AC6262D23
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 17:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.10.202.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741715139; cv=none; b=W5VfD95NCJRx9389HXIvwzNEqh7uAWyBn5SQoxcYDLUozUL3v/QOCWdEw8q6JMZY4wHzOzmmoOQrCEZJpjmePLBKRSpX7fzTo5DldOrck7mGwd2rg8BHXqb7xcbxwSwwX7tzXnGCqDi/jnfIFEnGsFQGK56tIQzqK3pkvguRIzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741715139; c=relaxed/simple;
	bh=oBNKbBfoZN+PnsRdMsU0/8plghVODuKU5KQcscKfyfY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=uUzbDv6ikUFLf3owWMupckzD7CLy6CHXrPQicNPL2kT9rDKZJvKnH8fXwBKD9mBx9JrMwSK8dZGBJJB+MrXCw5KG7YgF9luOWOkpXN+r/t0NX9kBegnPHOVSkEVKKSm8+5E0ecmfB+NNEnwHkFTCGPRGd5/0EBFP7AZ47xIyc10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com; spf=pass smtp.mailfrom=applied-asynchrony.com; arc=none smtp.client-ip=85.10.202.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=applied-asynchrony.com
Received: from tux.applied-asynchrony.com (p5b07e9b7.dip0.t-ipconnect.de [91.7.233.183])
	by mail.itouring.de (Postfix) with ESMTPSA id 2017B12560D;
	Tue, 11 Mar 2025 18:45:36 +0100 (CET)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
	by tux.applied-asynchrony.com (Postfix) with ESMTP id D375F60187F25;
	Tue, 11 Mar 2025 18:45:35 +0100 (CET)
Subject: Re: [PATCH 6.13 000/197] 6.13.7-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Benjamin Berg <benjamin@sipsolutions.net>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250311144241.070217339@linuxfoundation.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <00f382c4-1347-bc6d-b3ec-427de5658cf5@applied-asynchrony.com>
Date: Tue, 11 Mar 2025 18:45:35 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250311144241.070217339@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 2025-03-11 15:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.7 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Still missing a followup for iwlwifi as mentioned on rc1:
https://lore.kernel.org/stable/5d129bda966b7a55b444f4d48f225038361e9253.camel@sipsolutions.net/

Not sure if that refers to the whole series or only the first patch,
maybe Benjamin can clarify.

cheers
Holger
