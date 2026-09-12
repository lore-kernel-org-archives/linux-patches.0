Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50977457E7A
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 10:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210288; cv=none; b=usWIlEFWI1XSy4fYSedYVQxoeT7MeL+YVloTGRrHCGJsZsEI0j0SMcPX6aQTFY+Gt1THF8VhVdVv0VCbdTzy16hmnWw5mHennOQJDuUOsRYZuY4mpN9XU3NHvBlkkUcA9e61AJePD+qgUjlR7wfK7s2/Ee9NFKLY7vC9GtkbnLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210288; c=relaxed/simple;
	bh=kfZYYuUFbJTQGoup30atkQPBjnVw5wRiDR0CI2dunH4=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Bt6W+J39tCZ3+QDRrkWx2+6C+6TiHezU9Bi+nCpOsCR9waKsBdDRa64PR+uavUamXjR2hPgvgV804AaYVUe5DOVhOnxebNG3SZdNPFidLQkI1g/YXNJlX1VO0nvOTV5OZp+SSs4aKYaCMa8TVUQys9H0jfJ8CJut34QrV5pgawc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=cqcpWp3c; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=rOuIZIV7; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="cqcpWp3c";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="rOuIZIV7"
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.phl.internal (Postfix) with ESMTP id 4A299EC01E5;
	Sat, 12 Sep 2026 06:51:24 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Sat, 12 Sep 2026 06:51:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789210283;
	 x=1789296683; bh=WH2F7AJbni8Dzl3uqCt7O33cR/X9wnZEukCQQDnJ5nE=; b=
	cqcpWp3c9J6sJufRPEg0f/AxRt6FttTwSea7C0zr3rJP6Xxw6kVoMCi45L1kP3Hv
	8KnwfHXTLX85phfmoGKF5ywAPcdiq3j+7PrjF3zQ0tqNsd7uXMXF55bjuY7qOazp
	wEHot5y5FZyWCZTwivtDgtfDz2z/E+zFkPG/ELWdPv80lbDEQgU7K8GtsGX9h5tQ
	U0b+48wESii5Lm5hm50kkZdVFeT5ivA22JcZocuQYd4e0oEj6zBGVw8MUsisuCoW
	eDxe+Ji5TYHrS/dCoiDWeZF/gj8ViQwqLoLoR8t41+lufVohRtgn9KZR7j3XIQMv
	7slTuDPvIq5X94XZeT8NDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789210283; x=
	1789296683; bh=WH2F7AJbni8Dzl3uqCt7O33cR/X9wnZEukCQQDnJ5nE=; b=r
	OuIZIV7ydqdV4iFg6ZlSjAjX+IJ+NTBCTlT13eNofB4aiyi9YiD9KrBQn1/e6bZf
	LgF16KK28l8fNxXCfXZVIdxPXT+KUrEIx0N72BEvon6BaxpnqOmVixaD9tGy1cl1
	Uzwo04oVJ6RyklesICNHQBGyNrc5KfHQZlRP92dyZAq649E6tmR3Dh1B4+P14d4z
	M4G7+eBSB1tcwTVqY13ODOoNCLOAoXbFpR7y8cpwpcQmjRKR3+PPc4B0DOcLETzt
	HhsJ6BtovW/uSuUvS/qiEbegUqLp8gqTRak1X6DIRrP3EYtDHc5V3szDTZ62KzIt
	mbZINn9cnzCu4dMiq8oEw==
X-ME-Sender: <xms:qC6latyS5-en64OV1eH-6gWaab2euZ86ckiy9O3RBtzZbthTBgWQbg>
    <xme:qC6laoED6tEL-fZcbd-EDUcxeLL7mBiOvBvSrvzDuD1qYoTbvBEW7jXMGj8WhQlvb
    iB-gGVfUM8EHMcXnD3Ry-8bSv65RMNx_9jmO-HgGnFVVnpEYqwxYw>
X-ME-Proxy-Cause: dmFkZTFtqyNcYZ6AO1LnkterpRLweIs9GYQOM1e14Tr7ykFXCnz6rgeRDxgLjuQqeBfIHH
    KlttIVK6rR3Ao8+96S9sXS+mpAd6jx2ZCMT8Dt2BY+HGMPAYQH4ahp1dUytetaUdZ/UXDF
    R6n6YaS7HpodFbJFEW6vRkoFMQZXyTjqYZFIsZ5VOQTlWF4oOXVCk9pRJxg2afC3d/5OxR
    71LH5L9BZAzt7eB4nkIgRjFiNRWHuk2LCtpQ2ibJeWmDuHizc0dg/OypbsTl1fvmIb1lOn
    2WaYfr4ig/3gxtmAlY/Y1qRX0T46Toy9cGswawQYmIGpbARlruYl3WQ1aDlowTAdD3p5jm
    xnEglC5gegke9Jh9+00y6iP38jRM85v3ux8okegb3LTEaXU9pCFaCzNSPZ0nTqMmwdcTAh
    BEht4IfCiwlU34mvnmucEWNYfsiIu596oIa2FcuPs6oAwi5lijOHnh/JhrDseQIhla593u
    bBCWQyST1YWOo4U14wQ2GpQVQqHNmovR5RzyTwo+euX/QoT/JkMGAreS0A7cSDU9iSzxj8
    af/KMCu6Br17wiGiw0JW2U063/jbS6Gu56Bz4oVo8fXRxLSY4MTBe2kECf4oPLrYC1du1g
    HgoWb8hRDQ7DkE/zl4XIFMlsf7i2tSlQSt7L0CyNw28gu2gtVvXygFZhGGqA
X-ME-Proxy: <xmx:qi6lal2e6OkVXOeBwcRfutAuNk0NHxmZbBWkhBMbwnoJ-XCgNOxqgA>
    <xmx:qi6larL2d8g0B8nCYf-Lnv5c3A78e63RRyh7HXzZUvC6L6N6ej_aTQ>
    <xmx:qi6lasGzXH5v8Bk_eC64RC3UYkkZVcwtZKSVrb5X_9MjjVDi0YA2SQ>
    <xmx:qi6lavUMzZ-NbjvEwPDuOiHh58MJvPWZKLWnBAXI0e0tBfXztdcZbg>
    <xmx:qy6laiBxoTFDgVqYndGby_KrYjMNcGAQ5Oh6I6fLiIl6ALr3mv2GO-c->
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 32B3532A0081; Sat, 12 Sep 2026 06:51:20 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: AXS3V7etlNE3
Date: Sat, 12 Sep 2026 12:50:59 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "Karl Mehltretter" <kmehltretter@gmail.com>,
 "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
 "Russell King" <rmk+kernel@armlinux.org.uk>,
 "Sasha Levin" <sashal@kernel.org>
Message-Id: <d6e2ea6a-0297-41ec-bdbd-ae06b5e2f952@app.fastmail.com>
In-Reply-To: <20260912065715.005565892@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
 <20260912065715.005565892@linuxfoundation.org>
Subject: Re: [PATCH 7.2 1107/1815] ARM: 9483/1: select HAVE_POSIX_CPU_TIMERS_TASK_WORK
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, Sep 12, 2026, at 08:47, Greg Kroah-Hartman wrote:
> 7.2-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Karl Mehltretter <kmehltretter@gmail.com>
>
> [ Upstream commit 8a58a41100ea377e978d99600ec24a9bd0273662 ]
>
> Commit c6e61c06d606 ("ARM: 9463/1: Allow to enable RT") enabled PREEMPT_RT
> on ARM but did not select HAVE_POSIX_CPU_TIMERS_TASK_WORK. This leaves
> CONFIG_POSIX_CPU_TIMERS_TASK_WORK disabled, so CPU timers expire in hard
> IRQ context.

Are you backporting the RT enablement as well? That may need additional
patches, while without RT support, this patch is not needed.

      Arnd
