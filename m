Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239F437CD40
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 04:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790828324; cv=none; b=l9WqPyOuTu5xzX3U7xjBKajqKkc0of+kQOOY7lREGAXATGYKWMep/+w0GfkZRcOL5WpLqyrc3RajfOrPe/er2p3dToNIK09h+cygkWL8SffiYahA3XlMlLUvA+67wZB7sV9TUzgvu6jTPEpruYo5ONa3D6V25CqJGTgPC6BM984=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790828324; c=relaxed/simple;
	bh=pWpjYwESBgghhbi17h9NHGq8BY4+lAFwr9TqvjkzoBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qOKC8hCqm5BN8+c0iGOh+3WXzNG0JyD9n0hzGUDgffKMU0N/oOjFeCMcLr4xF6MuBA2WB5vu4rlZ9M4vtAhsdy4xIW1otOW3l/UfpnrWLjxgguVGPsk36dn7zQGpYX09oBbH4it34BxYd8g6FujzUFrRM0lQJMFucHDLb0pl9Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=fogj3nX1; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="fogj3nX1"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4hwJZ03KgqzKp6C;
	Thu, 01 Oct 2026 06:18:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1790828312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eKzGji1tT8nPOQX1BL8JA0tHdv3towUd9zeEqKtmteA=;
	b=fogj3nX1kKXpRc8svllEuG2iPpStghbtQliaZ/uO3ZCQ//87JgfVxQGBSpTnQw5Wf16Anv
	7W1BBOOLh6TsBymcFLrHISYixQxsE/O0M6hCQUi6Xn1Vu+tAvOBNlqqiR2fhvtTW2xNsSH
	3n6TPAGhxD62Rrq+siFleJSEga2r7sqR4zUh4cea59IVP6XtVeFJk+jmk2PVZxQ6zN0TO0
	IjdbKWs+NOyiXeQx2cgPbeJXFrUA9+/Jgnguygz+CvPNsDVXiqJSMsYPo5BsObD7U+qgkb
	/iM/qTxSflMkEpsHL0MJXMxCckrUP6MbMp37rbhV1MQ9Qg16mAD3Woyq7+fR0g==
Date: Thu, 1 Oct 2026 08:18:01 +0200
From: Benjamin Boortz <bennib@mailbox.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.2 000/457] 7.2.9-rc1 review
Message-ID: <ar12c_ste3iiTfOb@bb-82jq>
References: <20260930152346.024115587@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
X-MBO-RS-META: epr14s1fxky9wisxy59imfqr5o5ufza8
X-MBO-RS-ID: 44d6f00fe22a6576cb4

On Wed, Sep 30, 2026 at 05:21:45PM +0200, Greg Kroah-Hartman wrote:

>This is the start of the stable review cycle for the 7.2.9 release.
>There are 457 patches in this series, all will be posted as a response
>to this one.  If anyone has any issues with these being applied, please
>let me know.

Build and boot tested with QEMU for x86_64, i386, arm64, and riscv
across multiple configurations, and boots on AMD Ryzen 7 5800H.
No regressions observed.

Tested-by: Benjamin Boortz <bennib@mailbox.org>

