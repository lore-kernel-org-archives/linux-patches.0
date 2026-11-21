Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=99.33.87.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795224584;
	b=TFR1NOr2lqAQpW7az01IBV1TMXhCQF/aPXlYrGdhux8uRlQM3EByb2FMU3z7YoE2v8Mo
	 B/9Xcs0Pb9roLhapl+wS5S0rnICfaaHk2/270xqR5jzqZ0cbaTxVyuLIoatDOsrM5nuZG
	 f1IVABjixUIpCLafxeWAHc13zD1khqBWdJxKfj3xqF8Uv325XBsAnWtw5M392ZRI3e9NP
	 zeuQj43JA/+lpS42HhAycXjOh4pfDbLGaW1+Pnn8L+fglWXhPKMp2JIUkjcROQi+7SYH2
	 WRp6JbnqvNxoV8+VDs7qrEf58GNhNRp1CKEV/hHLhHk+emdidrUYy+IQu4BPVJkZVcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795224584;
	h=DMARC-Filter:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:
	 Message-ID:References:MIME-Version:Content-Type;
	bh=9FL9NdAaHkUAR72XW5UibBcROfDZ4xitgUbBNOiHdmc=;
	b=3NL774z76mNZkjjpfxmyIoegL4o/d/jKW7vYUVW6wVpZDyundKZsWlbHGLv85wBMByT9
	 vi87/zr+H7B/948kxi1DH8kDF/Mx9DNGnK9pv1k/xOMfaOskLclcN602kgQeLIP3+YMdZ
	 V08Wuf2xncPdZgn/I0ohjGFZiEx2pmJUsnmgqKfi/HrytYNo0wwtrI1aNZM8EpYOQBh5R
	 aQTt+Km+0YmFsFYkAneTyPz1+s5Sci81fuXcAtD8lkyncWJXcGDvz7DRmrZ5yn2R+sK4f
	 FpazomrFe03rtf+bo0CpCWlkoYVZ8wBdCT+EsdNXaoTQan8p90FnVh49mUaC20vPFNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=aaazen.com;
	spf=pass smtp.mailfrom=aaazen.com;
	arc=none smtp.remote-ip=99.33.87.210
Received: from mail.aaazen.com (99-33-87-210.lightspeed.sntcca.sbcglobal.net [99.33.87.210])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF62E606A6A7
	for <patches@lists.linux.dev>; Sat, 21 Nov 2026 01:29:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF62E606A6A7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aaazen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aaazen.com
Received: from localhost (localhost [127.0.0.1])
	by thursday.test (OpenSMTPD) with ESMTP id 4903d535;
	Fri, 20 Nov 2026 17:29:30 -0800 (PST)
Date: Fri, 20 Nov 2026 17:29:30 -0800 (PST)
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
Subject: Re: [PATCH 6.12 0000/1736] 6.12.119-rc2 review
In-Reply-To: <20261120054951.366579794@linuxfoundation.org>
Message-ID: <46e267f7-5027-a34f-aa43-3d70ecc991db@aaazen.com>
References: <20261120054951.366579794@linuxfoundation.org>
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

> This is the start of the stable review cycle for the 6.12.119 release.
> There are 1736 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.119-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>

Tested on   AMD  amd64 12-core and 4-core                systems
and    on Intel x86-64             4-core and x86 1-core systems

Tested-by: Richard Narron <richard@aaazen.com>

