Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F646277036
	for <patches@lists.linux.dev>; Wed, 30 Jul 2025 12:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753878934; cv=none; b=AolxvOsDLYfH+sd7O3aIzRYWXfEhQ9j7ICTRlxAwMvwWFQcuic0W8KjNiwGb+d3cM83jrnrX+f25mhDCesZpVoy6bWDZQlOxIl6nkuawWA08KxFQ0Ggj2TOEUfpoDWDfcddCar1TceKdgJ/+3DchBjMU3blak1PXGdDDz5vJdJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753878934; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CSlZQRiw1yAR4DMTBZQYzX+gJTgiD9MfIvKwbszH3VLbOWNXtdM8QZTe8AhPkK98YW16mDb/fOThxmGYZ1RyJMc+B7NNqJ+KktHySxh0gTfo4toq0XbVbeDmMZEv0vw8cY5VG5QCSvq5pFfza0k2a2JJELFSz1aW0cREz9+A5E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=W8RqVLJB; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="W8RqVLJB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1753878914; x=1754483714; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=W8RqVLJBtr/F+S2Jk0028V+m9CS3hcFs9/XWYtldfZR3k+Ab5TSQPGJhpdtzQ7f3
	 EEmMbNNdJI29m8cC+2X3eRAs0OuIEt/wJShvc+ap0mQkdVrUgsu8SQA5AewQnJPxQ
	 YR/ncVrZOdjCikInQBLeYSP+DJ8lIobkD04usm9PzSbwUl90a9XdpiRk5/id9osuk
	 Rg4KZd0cSwCYhdLvVia2wok25f8Z5zT6br4a6nnSHOuNjq7ol6AjcFMmGemloMg1C
	 a7/u6tVKDhhF3loUF/JXEm1l8+olH+GZMtd05bBdjECy/Z5D4Vw8x2BdUN1zAzyh9
	 CcUlO7b6fH7or8o7RA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.33.242]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N0XCw-1uVBqf3jLY-012uGx; Wed, 30
 Jul 2025 14:35:13 +0200
Message-ID: <bc57b62e-d1ac-43a8-acf9-e3cb680d205c@gmx.de>
Date: Wed, 30 Jul 2025 14:35:12 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 00/92] 6.15.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250730093230.629234025@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:5MFlGcTK8VnH6BlmuyyIW1v80aHuhQQbD+24dlqI3YvudT6PLVm
 66WB49gu8OkTJFd6WbUT9YnrTuK1lUcmCQPg+m/AMLfozVwFf/cOIBkQO+p6SsEoaUo0FKF
 v4JiqAsL05SyLE3O0WFvXg359PquQ2LpGfeYgkog23PY1/FnXD1vCHPRruMK8W7Y5YLe0RE
 YkliTqROi+V11RiVAmoKA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:nJdz57n+bIM=;AS373Yh/KnZpiEim4Ln1w4ECTSr
 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

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

