Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=80.241.56.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795674273;
	b=VK5O8OhUsLNglhx3LsTD/nl2CVMSwEDnBDlRFqNtZ5rlVvIjwm+ITkSU+sdJluib9XGb
	 rEI6HgF5/nnyjfSgrzlmZ5bmNCQgxseUFAZoKuY3ypOpQY1b5ZgrfF50XQ/sf5Q4Exekg
	 +D7gGXKVlDzWCZi1JoLK06p0sZIgdceBa96hBWlnjevICwwYxq6UeERKUQvFZNBDTyaYa
	 I9EHEhhwZAhc72nzHQ9k+W4vzxbRjDU+LX+gHb3MnakkjeQs50ZSS8xvYSRAtBIo0KRZG
	 oNaVxBUY9AUgrJ5Hc8gVQbVlW1931xTZ6R198mW8aldt3bPSrN6+xR40M6pk+JuMw9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795674273;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-MBO-RS-ID:X-MBO-RS-META;
	bh=54Gr52l2TYE8K41+i/7jlgfFtHwpt1TqVfCkux0de5Q=;
	b=YDT54Iqh+IwZ8e/uRTXY/WXTSXW5xmrDe1ZH3l0LcRNyVK/uRBM7irj5j0sU/4SMQzpw
	 DPt/z6gbE1KtxpNDsoD9IJDszpn8b9bSSZAVvd1DmLlHFWLWQQZyN8H7e6KahwYBqBvKN
	 Pdzi1ajH4uqtssGeO9+PJx3wXwGmhQoRl/8/Ppos6xs08e5Vw2eGcSx4zPz2EGllb1NAd
	 7bu8sy8topokkKsC1tJikPri1iD8at2G8uNcn78QkOLMMbVa4DflLEdrwqukSnLetKBnf
	 E98PKk6M+C7UxNzm5shIkFAspqcmlMhq0nY4vtIBlCrjFIXaNi2GYSS/S00qoeyiUMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mailbox.org;
	spf=pass smtp.mailfrom=mailbox.org;
	dkim=pass header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=A5GSzsYV;
	arc=none smtp.remote-ip=80.241.56.151
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFE3606A32D
	for <patches@lists.linux.dev>; Thu, 26 Nov 2026 06:24:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8CFE3606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=A5GSzsYV
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4jZmjM3PxSz8txw;
	Thu, 26 Nov 2026 07:24:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1795674263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=54Gr52l2TYE8K41+i/7jlgfFtHwpt1TqVfCkux0de5Q=;
	b=A5GSzsYV5F7cxfaqKo9VMJQlSCwz02VM+yywBG1eoNEDgFi5GisMOszZbpKPU+VdOSRBOv
	sU0LqZ4o/arXqts/A2jdPYCjoTe4l4pRz8v1jwrZjlz5zpeE8DZaswHGfn/joRNWDKgdgp
	PkLm0Bo+fKbRh3IHctapS+7cFzzx8B+IfQgSjTfp1aB/FbT13PyoqTZgwCPuAKtJltGYsa
	QctkjB0b9FGZ3Mx+quXZ4WCEMyLRWhx2IHvnUgjEW7H8yQbFNH/XWEhtCB2a7yldcz4F2t
	EjN9fQOEZYX/17sVHO3HTsBliXq7ixpJSb1nsIPTYCLh7zxjYREAH7kTTOY9VQ==
Date: Thu, 26 Nov 2026 07:24:21 +0100
From: Benjamin Boortz <bennib@mailbox.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.3 0000/1005] 7.3.7-rc1 review
Message-ID: <awfQdrf18IeLxpOT@bb-82jq>
References: <20261125143821.729802100@linuxfoundation.org>
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
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
X-MBO-RS-ID: 4dc762b175a24d5dc2e
X-MBO-RS-META: qsbj16bmgfeeyqgahx3zsdrj5rc9ir3f

On Wed, Nov 25, 2026 at 03:22:18PM +0100, Greg Kroah-Hartman wrote:

>This is the start of the stable review cycle for the 7.3.7 release.
>There are 1005 patches in this series, all will be posted as a response
>to this one.  If anyone has any issues with these being applied, please
>let me know.

Build and boot tested with QEMU for x86_64, i386, arm64, and riscv
across multiple configurations, and boots on AMD Ryzen 7 5800H.
No regressions observed.

Tested-by: Benjamin Boortz <bennib@mailbox.org>
