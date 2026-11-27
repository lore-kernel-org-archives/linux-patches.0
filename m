Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795768553;
	b=3uem0D7O2Jmm47ajl81PgROPfe/138lCRVe/Zc8PMP6gGok97Bb0CNgX/I+gxNcfcA37
	 fNjr2Ys5wBUmSgJkuL1MKF7jmTkNvu7FLUKOB90Xz25O+cwRF0X9nZm4an39bCqIZ4Z0O
	 R6jNg4fQut+hk7oKEW24Mlmc6QfmyS0+ymwB8jzm726V71MUtATiMBdCNPDy6H/JuXODw
	 k5CQFoFd2jtnCIf7aQnkdjzXHU+hF2DlmEM1KltU6IGj9Zj8pRZ6fuwunfImbA03xl3Dy
	 een672TWiSvT/HhNrSN6SJ8U006fS2WlQhn3mSO+Y9Zp2imukahKD/OLREVM68BoFJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795768553;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=2gExnDziqQCLCOyyBY+NmvOXjuQh1t7xPz+6DQ+plyY=;
	b=FU/X3FwNJ/uKzKUdWs1LamFHudAAC2hsowZ1sVP/v1oADJL8iLwT3hlgYuqZr6WLPye0
	 8vgyByUPF5Mbn2ZlYg/wP3tqmuv3lzNI6ZUdiShxbpJMklNhXl5npVMxDi3H+9Qq5ZFWU
	 ik3FCxV70chfG6f5USIKR8cOFWi5CbmeB/c6xG2FLDC/74IwOBrope2kiK8D2eJkhCgKL
	 +MjGkSd+3b57rDhQ5xwaNklZSvwKOzjn5XQMHpcyuv7av3U5ZMqVzlm/pI8O8axDP75FM
	 NFPJhrXUS0OMIZkFkT9UAqJ3ARRhdWS677ni87WnKzjiZwTd+PQ3vQ1jf9ZeE2QlaZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=seanlyon.dev;
	spf=pass smtp.mailfrom=seanlyon.dev;
	dkim=pass header.d=seanlyon.dev header.i=@seanlyon.dev header.a=rsa-sha256 header.s=fm2 header.b=JtE+tbmN;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=g+jnpqDs;
	arc=none smtp.remote-ip=103.168.172.155
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8CC606A32F
	for <patches@lists.linux.dev>; Fri, 27 Nov 2026 08:35:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD8CC606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=seanlyon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seanlyon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=seanlyon.dev header.i=@seanlyon.dev header.a=rsa-sha256 header.s=fm2 header.b=JtE+tbmN;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=g+jnpqDs
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.phl.internal (Postfix) with ESMTP id DA3801400346
	for <patches@lists.linux.dev>; Fri, 27 Nov 2026 03:35:51 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Fri, 27 Nov 2026 03:35:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seanlyon.dev; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1795768551; x=1795854951; bh=2gExnDziqQ
	CLCOyyBY+NmvOXjuQh1t7xPz+6DQ+plyY=; b=JtE+tbmNziMNaO93RAJLljr9UW
	iU+b7KrkXpHjOTp6jFDVkjRDjUxLhbUyx+N9bjA4TKhEW6PaJHSzQwdHS8G2JejE
	XUin9HxNpxZsjBYzOLkqudRBAKa4N8r3LiWG8JVm438+z9MrCF1/8G1RiY9ER3vW
	kaOOmO3w2Vi0nsXXvPScDAcyKrbxeIyjaCDhxJto6kHWgqFaZJDLtJPET5psyulI
	+t9WufGuLd47qLgCfcC2joQssK3Fm/U+4GZvO6rTO6XKqIEGzOp0S51qe3or5BTy
	hdNBlb/ALDoANFhxI6NC9vEq+GtnhlRLnHQCv45FMLO7eAaoTKzxHbzaCo0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795768551; x=1795854951; bh=2gExnDziqQCLCOyyBY+NmvOXjuQh1t7xPz+
	6DQ+plyY=; b=g+jnpqDsqlBpvZONwehvJQMmClYUGx2knwQdsMbO4+qKiF6pBVO
	At2eoxrtb0KNro68wC1uTQyvRDmN7e+bYG533lefrqBxQqO4Ysn2JFGFaGxuH0Ea
	cRVlKvWt2GvL3o/VwnImhEnIRcKn/SwbjnRfpnxX8iUO7fAYW6Bp5K2njnzXQkwF
	7O+QC5ViFquJu1L8zDnUP/8kISe6ehO97L4hfwv5byryiM3qMC9FgiQujGboFpf6
	X6oW6k1XXfvLIpV8MJo+9ly4jW4SXcYFgBugu2u5ji9Xsu8VNYbH4n4kYZIPALu1
	uPuNKjV6mWQsTXgMRdjJV8X0x0NKd3oddbQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=seanlyon.dev a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795768551; d=seanlyon.dev;
	mf=PHNlYW5Ac2Vhbmx5b24uZGV2Pg==;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm2:rsa-sha256:LvmjjsXUEWNoULi7NBO/+17obhzRzsA3Q7TcW/XRMx5yYPs
	iING2eqUL1MQ+OrZWpf6BkMIpCs7imLSDgpBv1QJo0cEyQ5fBeq8W9wni2UWKFPi
	ocVfB6e5cALQRIDswWkT66W2IsfcEXwPBopdloqg7qOac8/owbjjP0sh26Qy7fX1
	WR3DhKDRxhH3HPfLMp5FSCQjZ3lZteXw4OnR1cLR+jmWilwlrDon5QYLxKQDC+My
	Q2UyTBM6v5WTuVjewRofctN3LzEthH9Zd16bo+YgrslYSJ67vSGc21YY9vc8jYtU
	HUq8UriS0rKxxGMzPqTzKI0IsTdjV8LO6YWv0DQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:0HH+WWnIssLmjrsR5pRxMSaIJ2DKYH2PiV8zt1WK4bM=:OLvQCrDXRome2oCJAbqXihGX1pPGBiEVaG5msmOY7GQ=;
X-ME-Sender: <xms:50AJawvII7EtQhN3CZnpTORI7nB06iDFGfEAcEoQE8XwiLjDmKgQ3g>
    <xme:50AJa5VdHWIgMoWNxtSK9Rsp4rrbRRcDOHxdRxIqjSnhRUzHlnPeoTHz2OOxVhUKT
    7rdusvsGpkywCyBcUxO-sljLa-YoMQCXlwIHpB3otBCnkB7ba9BBoSJ>
X-ME-Received: <xmr:50AJa3SdBK1XCbNQqft8EnNmKZT81Irhr6TZtSSK-mwS3g09TrmWhX-kOVVzSgqb5xIkujx49pApKIN-PV089rkMsPg>
X-ME-Proxy-Cause: dmFkZTEPFTcbPrtJb2BDJpmV+LLckDLJ120FG/dSg5R9gIApwBSoWB5a3yow5Ny7VlMIc+
    Vpf6MkxMJrn8byQ4qAbuxTB+fscGrNsYzjAOaOjwaDX4Mdec2sRl4e+tvaNvYTJyp2hZ87
    9H1DvUeTvoJNmt6fAaqLGRl9lloU1osBcAOc4p4a5rLlIB/2Fl16SVuThXChlvNpkybBS9
    VawgdRUxDJcj1K3Mop0YQNXPtlobss07/xHfFninC9ub3KbFT/EswPQpxsnSCTJy0Tpkzk
    q3J+10m6WyzipM6/Qq12v9r8EJ1s2YW+gc3t0snCFKScShjozuTyZ5h4KBftTxZNjBHZkQ
    ZJPBjySHok2+hjZpsTnUQOUKGPJunjkuKBSgzNcOVrAKqTqqNpJmqf44ccZCtiRhT0WC7Q
    OAN4aElpBnQslYbXLQhWxD+UKrjBMdsYxvvWcV+U36DLgAlFiMpKUbQ5EOW9KEoKpHv+z1
    XYhbiqgOSS6gx5JJeLI9dcF7hFLW4CfngBr0aSMARPifoTkPj8JePIc5j+deQxvoxhumGI
    eXOLBx7RYn4QcC02qqeI9C+LLTEqKHBm4JQHjiglgXDwtVppFvE9gpKwC9nTyKhSyZdQp+
    XP7/G9+viSC/q9rew0xfmRvcN9Q8HWQEJLX7/Rd7rU9Sr9zFcSpwTUfDePhg
X-ME-Proxy: <xmx:50AJa3Is0OKyPL2d8E7LxELR1rlovtXCOQ_isZeruI4jrAib93R4HA>
    <xmx:50AJa40RFesTBybewboMRcEDacHB0Ggexd3tLzu8cLSYWqdVghNZRQ>
    <xmx:50AJa6K9FDrvC9KXd_MMR9Cd6R5rJbNOUBuHQmQIWqaJC9Dztk-rIw>
    <xmx:50AJa4lrVrTGjP8JIXaaiX17J0QEUXu2A5cfImnuB-hFtLVijKmSew>
    <xmx:50AJa9x3GLWOp5dpr82Th-B7iTneqfzsl1hzMisIsHlTDIKNdJhznN6Y>
Feedback-ID: i07c64b5b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Nov 2026 03:35:50 -0500 (EST)
Date: Fri, 27 Nov 2026 03:35:49 -0500
From: Sean Lyon <sean@seanlyon.dev>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.3 0000/1002] 7.3.7-rc2 review
Message-ID: <awlA5QWvNxlXr58e@ncase>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261126105729.110697432@linuxfoundation.org>

On Thu, Nov 26, 2026 at 11:58:20AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.7 release.
> There are 1002 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Built, booted, and tested on hardware for x86_64:

- AMD Ryzen 9 5900X, Nvidia RTX 3080 (nouveau)

No regressions found.

Tested-by: Sean Lyon <sean@seanlyon.dev>

Thanks!
Sean
