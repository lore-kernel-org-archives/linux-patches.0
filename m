Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198AD42E42C
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 16:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229023; cv=none; b=hd1hfczldm+WOX7FGQ8rbuWr2eJcwFYTS041We0lkqz1/52vjDFLdP4nYsAaiK3isle+jKZsKt73AP/pawRLNpk2CBIpJV9Yd3C5XKrKs0ICeRDUwYTmiVPPd6KRRVkHTFCoSmdDogWxdiSD7nEvfjpyZ+i8pj+rJCNRYGub0wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229023; c=relaxed/simple;
	bh=qePAE4jmLpHxhUVzwkdmKLx3xN+XPi9VGu84W3vuaTA=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=UAZLVg6iW4yZSLitXGFEXFN2HDnvqThDEbixzqr9hU33AfZcJ0uea4iBe56DZ+ydiWTndEWHqQJzTkPW0GYUfuKuHWT88QAx9SMoQ9Jx8UW2XFr+u/ZCTHltgaGGo0Dh8xUgkoIpQ94IVfS1/kC454eJbc3KmR92gzVY8Dvxi8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=R25S9Gqi; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=TD0LnE67; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="R25S9Gqi";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="TD0LnE67"
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 86CE77A006A;
	Sat, 12 Sep 2026 12:03:40 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Sat, 12 Sep 2026 12:03:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789229019;
	 x=1789315419; bh=IuUEttLZwYgmgS1qzzH6usVzx4SHiuPSU/d6HwtUBMo=; b=
	R25S9Gqi7jPW8+e8neFmW4yarQe2Ua9TnyzGOpVcqQB5TaED5p27yHmVu6qGkiGV
	LJLf1JUUB4cz3Tjr8i9e+bij2wppPV8URghX16VnrVXDqOiYBZ55NTe4HvvMMXWd
	UTL+NQKgatF9A4T78So0pscO6jIpHA8FdYfoOfIgVKWRrjT7Bqv4dxRN/q6eq3Xi
	lXClAXTnR++X35JBOd+OCqDrB9avDgI5t+MzjWIK1YC0flNCBqBt+J7PM5pxvHSD
	EtPHcZJgtLiOYAqe0mgn08YtcfQGMkV0sjeIiHbnngs5dOEyoLUWiEkav8Jhcs0E
	BHtYa/pS+qrNhh00yveJ/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789229019; x=
	1789315419; bh=IuUEttLZwYgmgS1qzzH6usVzx4SHiuPSU/d6HwtUBMo=; b=T
	D0LnE67Xy7fCeNJQWEYnbJmAREH24stR7+3C/Mg+xmwiMOWSQUH381PZhkQSSSPe
	wrrP3N8tcvcB5n3M9Dpu5PXjPaNeIraxQJTk0OVJ+szIpYppP5KCrw6qD7wh+F1d
	XVMYGPuxFfc48+Oax88R+4sSAPZtekzIWXcgYZZ6L2s8dd84EveP7VJd6ZZHazpt
	lUxRXyxJ/jMlFUyebDWdiEsJKeET0XI6Z9dlUh1C0WBFghUXmg5HD9ptFKzsfS+B
	p0aISxfTM2PevFh1WykTlUnmxIsRiOmTDi1K68LhHHlXybd8T/y9ogg8g37JqDsV
	lMIu09jEHCR2Vp/rUVfUQ==
X-ME-Sender: <xms:2HelarD2Fl-F4YJXhpNFrD7DImdDkyK43Prse-kBeD7U2E1kwc9_Sg>
    <xme:2HelasX8NwSLWjKW4TJuUqvtO9jZ25GSK59oXhuE9Klexe-IKD96PPvNdzTE22KXt
    iOCpZ-rAwhG6lsENgiTbPXNyGBCi3osuSjvYv3_0iwaI6Thp3L3gVc>
X-ME-Proxy-Cause: dmFkZTGfMRNOJ3a+w2E7gDo13nWE0ASTlWwzGVVKCABdXOd9EwMVTILkfRHrkZX8K4aGVn
    HPRppEq9/oCjahFmB7NYnBbv8P24uaiqWhRGeVVnzxyDSimraawQ6CTtrnRyCLJK4sGHOL
    U5FsQ7e9Q59hToMx4Jo4QpWN1fqaBxu8zzs7WV4JNxR2lWN3F4IS0u0OJznwaFTII9Xe1w
    oIW10VxqufyphlJOcvgveqTtxTohn8wA5X5iJJBXoh/03p3B5VjE2CnhsAIFEkpzU5/XQR
    YtI04IdM0e/D4jQH4AnI9Dfp82atHdqtXqswnnLESIV33SzpKou0liyy3ClDQQAU/08vs5
    RgHp+HezrfQtjRnOMnBCuGfZ0mDYs3Y0ThvNPg02uAeE/9o44WG4TUvRciSjRwVCJy+Cpz
    hE01ANneIjKYguTQFTJ75WY2fv9Xia2jgHixLI2I1+1sFZW0sGf0rUpb8m0laDOq7yHJ7r
    KN6tWuwyWUMRFsO1+n9Jko+6yT6FGBeOqtZIzT7oNyo3vpGahF75pH8L6P7fl4QvmAB91E
    kSTowlh8qW74iQGzuDUGR+cf7R7rtfERfklBdqjpda2xXFd4+E+xrshSBngyA8Hn6oMzzy
    wrhyPt1wAp3Fp3y7a/yXfu+Rysp0MZaqO5r3CJiRJm08nPUMfywAWnDCv7tA
X-ME-Proxy: <xmx:2nelalHH75oY1Ih-IpYCkuFC18Oc2g0RP6bo-KJHsKen6ftrHlx2lw>
    <xmx:2nelapaeP_D0FL0synPP5QNJZO5VXFhta7tQbk_JT60m70Xof-DL6g>
    <xmx:2nelatUHZk2WWVn_WreSae4LP_Yeu3UM3G8l-EIcHVsUVpA2mBkMuw>
    <xmx:2nelannRvwIXdQHFuZEtZ35X_K3xWLr7ii9EyUzSZLK_vcAT7KOi8g>
    <xmx:23elalQoKMX1c7964xtDZrv3Aj5USTfYu2fFX4B-Q4rGpKMVvd33b7uH>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 5165A32A007E; Sat, 12 Sep 2026 12:03:36 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: AXS3V7etlNE3
Date: Sat, 12 Sep 2026 18:02:55 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Karl Mehltretter" <kmehltretter@gmail.com>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
 "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
 "Russell King" <rmk+kernel@armlinux.org.uk>,
 "Sasha Levin" <sashal@kernel.org>
Message-Id: <d5ab6af3-091a-4399-93ea-3bc76e87f8b1@app.fastmail.com>
In-Reply-To: <20260912155003.96209-1-kmehltretter@gmail.com>
References: <20260912065648.999753832@linuxfoundation.org>
 <20260912065715.005565892@linuxfoundation.org>
 <d6e2ea6a-0297-41ec-bdbd-ae06b5e2f952@app.fastmail.com>
 <20260912155003.96209-1-kmehltretter@gmail.com>
Subject: Re: [PATCH 7.2 1107/1815] ARM: 9483/1: select HAVE_POSIX_CPU_TIMERS_TASK_WORK
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, Sep 12, 2026, at 17:50, Karl Mehltretter wrote:
> On Sat, Sep 12, 2026, at 12:50, Arnd Bergmann wrote:
>> Are you backporting the RT enablement as well? That may need additional
>> patches, while without RT support, this patch is not needed.
>
> RT on arm32 is already in 7.2. It went in with 7.1:
>
>   c6e61c06d606 ("ARM: 9463/1: Allow to enable RT")   v7.1-rc1
>
> So a 7.2 kernel can be built with PREEMPT_RT as it is, and nothing else
> needs to come along with this patch.

Ah, indeed, I mixed things up as I was had just read some 6.18 and
earlier backport patches, and didn't realize this was just for 7.2.

We definitely want this patch then.

      Arnd
