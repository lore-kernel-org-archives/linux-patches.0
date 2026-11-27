Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=80.241.56.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795811021;
	b=V+3HkOvSqOkRqucTZSMW0nbd3hpJBZ0oHb0OCnKCk/ntiDi/F1RGGbw5PHR1HY3MTHwm
	 8OavBnpCPADBBtHm2rFO8MXn/kq9dkHeJiqvrQkV5QgT8gZgAz56zoh1Gc16lESp9+3iD
	 WFV+GkWvWMAa2VnGoWMDEWPih7qs/zoh8wH1scfJG/f8wBUlcrG84UFdmpCfY9k2zNhYz
	 Eo5rH+dBSCPnhGQ1lIfG0CKd+6Hpbbsso5zlOrUBa8IQ3gsjo3TOPWmqIOqxvWTmljVKt
	 EKhYTKdWQrxANq57TxANdQQjaMhG4GyB9YnBkhK1hNfDb8zz1Ln0ZNql4bfjQ0LX8EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795811021;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-MBO-RS-ID:X-MBO-RS-META;
	bh=prGHkgX8EzWGe78aNVP3e+KL4WHhb14qYjHkPoXJfIE=;
	b=kIkBHBERJ45WDiawE5sDTx8GrSxxL6XCWSW8a2icallt6W+4FoCvkeQXDZhk+6Y6wjby
	 so7YcHxCYncmQusFytS9B6ouy1ka21gptEoME6drMuEdYjJOY0S4YeSuxJoLh69Ys8nYl
	 H46xT6xTOoojcdtulTXv2aRyOBEFQ2lEqcBEGkrNB03Z2vo4D41hdxAUJnjNDfSP7EPYa
	 2pDEHHX1J0bCxjk5L0O4TCpuqZmUEQIu344+hUfNCq6LroBXoLFOGb5ranQIwVjkRoAX1
	 RBspFfrqRHcCWV4wZDQwc92NUxzTg5ehOp2dZp0keiS0nO+rE0xwVbFk0a06Caxk6Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mailbox.org;
	spf=pass smtp.mailfrom=mailbox.org;
	dkim=pass header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=nEHyF3u4;
	arc=none smtp.remote-ip=80.241.56.151
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA012606A323
	for <patches@lists.linux.dev>; Fri, 27 Nov 2026 20:23:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA012606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=nEHyF3u4
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4jblHF3Gf5z8vXw;
	Fri, 27 Nov 2026 21:23:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1795811017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=prGHkgX8EzWGe78aNVP3e+KL4WHhb14qYjHkPoXJfIE=;
	b=nEHyF3u4U/MDoSkk54nAhbr/rAgMw9nqT5Jna+h5XdAMuQ3/a9lv2rVlFgm4Sz3IxXVlEa
	/YHrEBvs4MecruRaguO6Rk/5LK9VnUGNETF7a8MDdUXuOSHA6MGF1gmtDnvDGNcDFxJw2z
	u8PWrIQxbqwB62K6kJO9j+nXQZBCsnyHNRowPZ5IgQc1+gBmk+XcPs2SPPj1ahAivGX5y9
	iER3T3J28nFSM/QGThIv4s6u/IByJXN5scS/SQ6xwpbpskxJZ8BnOztz0cqwcgAkcMn+ZO
	yIw9KXj7NXSMeP2dca4IiF+FWcuZJ0Bljp82mltjbgwbmpGTIF1lOIh/jmMLLA==
Date: Fri, 27 Nov 2026 21:23:35 +0100
From: Benjamin Boortz <bennib@mailbox.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.3 0000/1002] 7.3.7-rc2 review
Message-ID: <awnmdqGWYZ7GMbYt@bb-82jq>
References: <20261126105729.110697432@linuxfoundation.org>
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
In-Reply-To: <20261126105729.110697432@linuxfoundation.org>
X-MBO-RS-ID: 39d3dc8004c07938cef
X-MBO-RS-META: cyiarbbj1r68xtyex9woodgainbdc37q

On Thu, Nov 26, 2026 at 11:58:20AM +0100, Greg Kroah-Hartman wrote:

>This is the start of the stable review cycle for the 7.3.7 release.
>There are 1002 patches in this series, all will be posted as a response
>to this one.  If anyone has any issues with these being applied, please
>let me know.

Build and boot tested with QEMU for x86_64, i386, arm64, and riscv
across multiple configurations, and boots on AMD Ryzen 7 5800H.
No regressions observed.

Tested-by: Benjamin Boortz <bennib@mailbox.org>
