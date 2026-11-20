Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=99.33.87.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795198962;
	b=uJlz00jUva29O6j8KbD5p8MB8zngukPKI+U2wKJ9mw6eCXlOI2DASRgbbSn9XCMnlxF1
	 1AJ5zD902Ka+2HhqXYp7FHs1TPfnpXx0e0oHKPK/4PVznSMNwJd64BdRRivaDj8qBwsHX
	 SjOAEMTvH753OoWH3TqAvV5PJSYtvBNqFECyJGJD3kSURA6eKzgPhqs3iG1wSvX1GagRM
	 6IlpRNv53xGh8s151D6/VZuvb/tILkiyH0w+GBOX+mCY8uYrJPMktc6zQlucfZ+UkftGe
	 UwJH4eEeGV21bryx29DGunlBbxHULR62vMkeD460DtgJlsuCZV72aKG6GLHEJeVlKeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198962;
	h=DMARC-Filter:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:
	 Message-ID:References:MIME-Version:Content-Type;
	bh=2jkde0bQ5ks7RbXj+AFz+mtlYLhKUbqkJFme+5XX6Ug=;
	b=teMK75s4Thns/XD1y6KCAC9HJ5J85+gmcjWuXqtq9jcvSwJzJMn/P51MwyQO5o5+iuG7
	 /5BPp1nqxBdCW/amnC0lKgktVd7U8ezxeH+p4YVyZBZC7tqkDGm5zxK+ZFLismoyzeCIK
	 g4HYBdzZRyBmvxtU6wCat4Z7XF/xjTdmGayQnsHFnrbaJX3STrWRuEYndkIscYfry9gWm
	 Qn+3DhVvPn9eQYNegbLIl/b7lHpgIBAtRIn5UMPh9n88V+gY2T1gJyOvEe1wewfsq/S9X
	 zqvgxO8sFpT38E5P5tgJXQCh90ct73u2gvXpLeLixnBZq3Dc9MK0UBmBk78sgmZI/hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=aaazen.com;
	spf=pass smtp.mailfrom=aaazen.com;
	arc=none smtp.remote-ip=99.33.87.210
Received: from mail.aaazen.com (99-33-87-210.lightspeed.sntcca.sbcglobal.net [99.33.87.210])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51ACE606A890
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 18:22:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51ACE606A890
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aaazen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aaazen.com
Received: from localhost (localhost [127.0.0.1])
	by thursday.test (OpenSMTPD) with ESMTP id c85c3c94;
	Fri, 20 Nov 2026 10:22:29 -0800 (PST)
Date: Fri, 20 Nov 2026 10:22:29 -0800 (PST)
From: Richard Narron <richard@aaazen.com>
X-X-Sender: richard@thursday.test
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: stable@vger.kernel.org, patches@lists.linux.dev, 
    linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
    akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
    patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
    jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
    rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
    achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.15 0000/2178] 5.15.226-rc2 review
In-Reply-To: <20261120055015.328810133@linuxfoundation.org>
Message-ID: <278ed82d-ba22-1cfe-67fd-260158b5b63@aaazen.com>
References: <20261120055015.328810133@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Fri, 20 Nov 2026, Greg Kroah-Hartman wrote:

> This is the start of the stable review cycle for the 5.15.226 release.
> There are 2178 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.226-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>

Tested on AMD    amd64 12-core and 4-core and x86 1-core systems
and    on Intel x86-64  4-core            and x86 1-core systems

Tested-by: Richard Narron <richard@aaazen.com>

