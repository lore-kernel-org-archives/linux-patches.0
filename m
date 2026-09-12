Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C7745D910
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 10:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210093; cv=none; b=Mm4cR3HdRaEHAN3Jb+hX3D6RfnYt4qRIHNxKMPO4WzkFA/+Yym3v35H3blpReLBxjo6HE0T+GjzqTf8xW4jg0CeoZBWLSH3255aOtZ75/A0wOxZdrtWfwsSc6QCPkToWbd2dMEO8KATyLGA36Y66bq2HITo1JFjP7igx2/61zx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210093; c=relaxed/simple;
	bh=xwZH2BrrtUd6CNkSesnvotVmIBQM+DUIlE7L4suBmBE=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=VUo+bUOid1Q+3FbAOPbVLR7hjkTEbrhKWH14j5WomdZSZfJvXXMzbP7QFioQIV5pwtFixHE1P1v3D5j+bjX7SX7KUVjUv8P1PxguhIhBBKOr09Jzz34a42oiyBX95KKOXJcVYOWVe2yDYGUm+aorx5W2TII5ESNTp77etmQwrj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=YDxyFp8I; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=VnOjMVa9; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="YDxyFp8I";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="VnOjMVa9"
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfhigh.phl.internal (Postfix) with ESMTP id B400B140005A;
	Sat, 12 Sep 2026 06:48:09 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Sat, 12 Sep 2026 06:48:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789210088;
	 x=1789296488; bh=dnK/vcVPNI7F6TuVIaoAkkf9vew+kt7rOJ/nuihA5/o=; b=
	YDxyFp8ITmVg3UyQWC2dRhFqfk1sBzWV/DuVd30ZDYnmssMlFNg7yPUUA/YUF2wD
	1cZtKrx/oH6TenflECK7hlsvF9LSiyzdLxrMvkF3ghr3uvypvcKqsC0TissFXJLB
	wmUP/DXAd9G8pEoFkIJn8c76nqRmNkHCHIgBJwEL7MNc0N5d3rfyJ9s0sd6lpr5N
	NlL3ocH/OU9ohAABfpljjC0cr9blw4Sfs5FPxrrDZRdO9NmRwNYtqtazZar/Fd81
	fddLno6Duo7w7+PvSADEjiQH0e6cmbd1vmogWRK1M7Vyh/bi7eSV0U0RfQ83hkU1
	uJ0XuQCGp7PJwh7/mjzIEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789210088; x=
	1789296488; bh=dnK/vcVPNI7F6TuVIaoAkkf9vew+kt7rOJ/nuihA5/o=; b=V
	nOjMVa9Q0Qt15wKwKgTLd0elpZ5KeLqHmcdLVWvzg6eFzaFQse947plHn48FI2F8
	eMC+IjJkJRq1pbZOaCh08h5YNRd8OetGlnJ0cTJV6T8fhOUIkOxngCeouzT5fQe6
	teKn8bWbu7BoBwsjGz9y9SdYkW4pRn/+fgZWJD9gHvHSn2ctpj0EvFsU3GVApkDR
	q5+4dKGrGO1HS0QKpegCh054T3zagpuoRAkb8uKjKBbKPLAyeJaJBcoZb9ELQ5AD
	n7fTFtvcwbFUV44bOtaw7jaUHpF2eaDc+agDdzG8BCuLKBDoMqwQWCNas3yGpu0P
	Wmj1lSIB3SiHCxPv38+6w==
X-ME-Sender: <xms:5i2lajxzQDuO1omNwdkKRlGN_NFG6GavdyMdp9I2oMEob4C-UR_NFg>
    <xme:5i2lamHM10BjTlme4iwQR8Bch-wqEZzRRUPEkCom7_buvxi_P9IByRzejRjP2sjTk
    A01lJinJxOPlHrvD6HnAvPCnf4Uz4A7gd8Sf5eA44fbWibWhphmIA0>
X-ME-Proxy-Cause: dmFkZTFFp3R7M1g9YFgyAshnrvDGBjcTlmJUwxawSSQsJzabfClGN1Hh36qsTkEPUoX+QR
    26fZe6/AMvQtjztzl7UHKIaRmAUTuduryOQEmxrwZKLOCxvLi+dvhF7QV3AZ0fefUkgROd
    PcO0pakaliPUi5ZG6XOiQzGFdF7Ml6DHm+APHto+dR5DNtV9ETIHK77t7mo5v4CO6SZ4a5
    WQ9kp9BvlmZXEQturZLA+OGeV560bKIWf5/USZg8cKSBcPGc9QDuAV6Nd3dgea8j73lt9h
    /rB4lLD8heCOMjhJCosY4i8QhpWag4FtejECiNzOFI0+hp3czu0pGKHus9TgA9y0uIhJbr
    gNoqSdf8gpboxBr3CbQOxOmbYLeolblsWJFgS8i/giIDyW9KNpsOKN9XMugUw/AHYf9Opi
    aVkxgCEBXzJQLheAxzjOLoNJ70BjhHChnDExjX5uhydijKgeHbHtiHwLWcGAI/h5WOuXIy
    8oMa/oYOlHoPZDELeCqJGDMSb2i3GVC5R3vStjxJI8AoeKVzj38VE8rzcbTmT/eH7mw6uT
    8JxZuDJ81pby89uRG9GR5ICrqXyVTKTId22B5tog5KE9wrZQ62rmHb980FFZ+AaRGMKc/a
    w0+ONYoY1qmbbI2PdE7lHBwlVtqFau84cdtGB2vqBVUOxYKxX5f0zfNAuH3A
X-ME-Proxy: <xmx:5y2lanlyBJqs4Zh8P4fFBGAqq1hb8U1FZa1mDdUldy0kZ2hgCHvDEw>
    <xmx:5y2laui0uv829XqQs87CQKbpYIUmf-399sXtjFhX15Yqw94d6Bhc5A>
    <xmx:5y2lanfRqt91eb5jYK6sITSpWZBuxhv23M8xJFW-vIMBERnuYczgzw>
    <xmx:5y2lamiJjePv4TizncIm3Evt_Kq6Ph0X9vrNjuHq7iwl3tTyOwAr9g>
    <xmx:6C2lamBZDIz8uzOJA-82DC6R4j13Ud2aNCtTD36Eveom_UgOoYXWylnX>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id E1A1532A007E; Sat, 12 Sep 2026 06:48:05 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: Aay7kYN5x6W7
Date: Sat, 12 Sep 2026 12:47:45 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "Heiko Carstens" <hca@linux.ibm.com>,
 "Sasha Levin" <sashal@kernel.org>
Message-Id: <30fec0a7-619b-44d9-9ca6-e5de551a8c0b@app.fastmail.com>
In-Reply-To: <20260912065637.929815682@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
 <20260912065637.929815682@linuxfoundation.org>
Subject: Re: [PATCH 6.18 0641/1518] s390: Remove compat support
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, Sep 12, 2026, at 08:46, Greg Kroah-Hartman wrote:
> 6.18-stable review patch.  If anyone has any objections, please let me know.
>
> From: Heiko Carstens <hca@linux.ibm.com>
>
> [ Upstream commit 8e0b986c59c67e08ada646249f834655a9e6da16 ]
>
> There shouldn't be any 31 bit code around anymore that matters.
> Remove the compat layer support required to run 31 bit code.
>
> Reason for removal is code simplification and reduced test effort.
>
> Note that this comes without any deprecation warnings added to config
> options, or kernel messages, since most likely those would be ignored
> anyway.
>
> If it turns out there is still a reason to keep the compat layer this
> can be reverted at any time in the future.
>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> Stable-dep-of: dc161efb6df8 ("s390/vdso: Pass --eh-frame-hdr to the linker")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

What is the reason for backporting this? Generally speaking I don't
like the idea of backporting feature removals to stable kernels,
the entire point the timing was to allow users to stay on LTS
kernels if they still need it.

       Arnd
