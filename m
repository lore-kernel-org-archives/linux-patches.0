Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=80.241.56.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795279494;
	b=MueDhwWYstbVDHEhmuOG2jivSa+DX6y4e2fIhpXnXntoX9ZzNuqptxCjwdiz0L0fppW6
	 GmmsjtuR0Da9eAOa7QSi25AQk9BB8ylRuU4IkU40VG4h4vHRa3RuLC/jiCwdZVq8nxqFP
	 6kuKpY118OChW8Du7HPiYOkGB3jW7dM3/Ig8ek1wUh7YebcibQ5YltzxXW/TwDrhwjKuJ
	 iUlTtaDjdzPg7eaQx0K9fOPdXrJhSZiereZbZSqejdBpdqDxIwIonlNEmv7tTsEBZv4OI
	 KqP1hfQ9XDJW/4zEA4m7lHSqCxeJlhEB84wq8EUektoCe69YwUvGntzRwYTp1Yub6Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795279494;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-MBO-RS-ID:X-MBO-RS-META;
	bh=gXdiQTGe7ntn4WDHykrLhcHPhiWr4wJSEg0jkdiWb/0=;
	b=cbYIkZMdUX306gxTirVk1fN547xhgXuZTp3K3oKCFgpaEB3qTI+18r0V9u2xUTDLxWga
	 hTmUPkV6gY7BeRixw0StYqQAoKRQ7GKCxCyAc5bocrvSyY6JxAZDCLgv81QWzz8uKF5qz
	 zWZ2LCeikLXLa2gP4BpIWty+uiUfrdJkZ2cFRbYGSho6kyT/AphBwr7KHi5itkUS8qzBW
	 vrnBN5gIT1tbrvA+P1anQKajmKgPn1FsJBNv1tqq7lGFqt1mgBEHGhKDCa3iEP2lBNgp/
	 lqb0poM21DsgeP30BgLNXYBtL0Aqc/AW0rDuCZr8736hTNvwMPV3RB2Jxvkixy8UIaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mailbox.org;
	spf=pass smtp.mailfrom=mailbox.org;
	dkim=pass header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=aAppkJCg;
	arc=none smtp.remote-ip=80.241.56.172
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82603606A32A
	for <patches@lists.linux.dev>; Sat, 21 Nov 2026 16:44:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82603606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=aAppkJCg
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4jWyjY57YTzMlvY;
	Sat, 21 Nov 2026 17:44:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1795279489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gXdiQTGe7ntn4WDHykrLhcHPhiWr4wJSEg0jkdiWb/0=;
	b=aAppkJCgcENAr7PYI4JfGigWesGGVopxya53uWu0JL0VwYX7Y/fY9lQXgKKKPCR+UpHTa/
	JqsThSkbfJQBXVi4LskErLYaBTL0oHzaftInvXpLklZcYWslZhlciQof2Cn8ieLd8fEo+M
	C6g+Wij22eFKqZFLhnAKDN6jfRMlkxsH7KqnhfCf0eia1Z9a6n4xVu+Icb7Q9EhV4L7GOV
	ltujv2ZXIQTaOL/6cD2RE6oMXI5u3hhdRSoz7cAuOjOuuQJI/bnRNddW02EAX4k6WtLEDc
	J9Ha9JiXsqWIU54xne7TD5sMVwp2+bs7/hMbjKOgydb6WSK2bVYApRCKHvYi3A==
Date: Sat, 21 Nov 2026 17:44:47 +0100
From: Benjamin Boortz <bennib@mailbox.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.3 0000/2642] 7.3.6-rc2 review
Message-ID: <awHKZxVgql08UqXC@bb-82jq>
References: <20261120055248.913352689@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20261120055248.913352689@linuxfoundation.org>
X-MBO-RS-ID: 85e19a1006fad7ae188
X-MBO-RS-META: 7i9pjc1tff9p8aesbftkn7yzxojh5pu6

On Fri, Nov 20, 2026 at 06:58:20AM +0100, Greg Kroah-Hartman wrote:

>This is the start of the stable review cycle for the 7.3.6 release.
>There are 2642 patches in this series, all will be posted as a response
>to this one.  If anyone has any issues with these being applied, please
>let me know.
>

Build and boot tested with QEMU for x86_64, i386, arm64, and riscv
across multiple configurations, and boots on AMD Ryzen 7 5800H.
No regressions observed.

Tested-by: Benjamin Boortz <bennib@mailbox.org>
