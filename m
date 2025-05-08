Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1EF266F1E
	for <patches@lists.linux.dev>; Thu,  8 May 2025 15:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716429; cv=none; b=LtrxvrlQAQ/K41QHJtX3PBpLYKNNL8OVCvqk8Z6de5ocB3InC86z2hOvu5B96KixwvdTnteCO4tr4W3Pc/JE+GorqNeJMEAZ1MYgSi3x59Y03zrq/Ia5j1grOba7kMe2Foca6IWIlm66xbEHy3I2si5yhtGq/XIw9Q9018kmmsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716429; c=relaxed/simple;
	bh=vuI8mZcdxJUi4El5D1n0UXvd+Ekab/G2owZzCrAjwU0=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=aNKCDbxCxA+5cAKl/XAvjVsoGYihmB/6skMVvggJhnMZVD1Fb1o9A2lbXkcx9s0m+YqMEL5OnEJ0mr6rPRci2gWmFouTdTtVHMJz0GlJjV/gI8kojBMwV6p0X8WKYKt/j4m/u/5iuufXg1P7xXGANVFMcGOCPzP5AcwFBAaq8r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com; spf=pass smtp.mailfrom=fastmail.com; dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b=H1Ao3Qgq; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=RPZ72NJd; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b="H1Ao3Qgq";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RPZ72NJd"
Received: from phl-compute-06.internal (phl-compute-06.phl.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id B623411401C1;
	Thu,  8 May 2025 11:00:24 -0400 (EDT)
Received: from phl-imap-03 ([10.202.2.93])
  by phl-compute-06.internal (MEProxy); Thu, 08 May 2025 11:00:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1746716424;
	 x=1746802824; bh=R4tHhY+iRIU131/IDjDN2WxbdLKZLYEtFqTjCB5Dyes=; b=
	H1Ao3QgqFN8LrPjMmhMELIZSw/I+4j+BckPgnkg2lDkwgyuPIBTmBZJbIZ1EBMhn
	BOojRQ1pdh9C9myq0wZS79kS9oXXuAV4Qx/fd9BoRYXNrucGfbNxw7UazMZQgckv
	3PCVglnQuhmVYcm8UAnEvj3dba5b1hHNWB3kOn2wbpev0T5RkvHUmuCdmGONbAju
	BGRnQqK8NRvZ2fcoK/HGWpz1gXazjJydMm+TqukW5HY18LH7/aDr+pA4YYs+MZkk
	YukkWXtmRgx6wFLVnwdMkWE2soCvQ8K5klrCZqqqd2AIp5F4Nz7XkoofrcT0F+SX
	Xmpvlo6SI+ntqkubY7BU9w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1746716424; x=
	1746802824; bh=R4tHhY+iRIU131/IDjDN2WxbdLKZLYEtFqTjCB5Dyes=; b=R
	PZ72NJd7Uk/vZ4GVhutPnN1UyC0vkGjBYSM48zc83vUDQE3oA7t27+3VFBpbYDOF
	LzCNu9H/7jsmxZvuf39CumOuTAOujI2IVYQO/M6KVYVgqiEZfqLJdzztmvdZLgeJ
	eV9abnNA7IhNl7DWFkTtfls5IxrUQ/5GifPBZVoQBUsR2fPCiAVukCKZXvfXQeS4
	h801VbGzafDAd5Z9SRu/geVO13T2Wz6bvQ/af8S6ECMlgwBMxCKXvqN3u6C3LnJp
	3e6YcLX/BtS97CM3kmjM8Y08zbFqJmj9negfAoHF8P1xVEkKE7AIXrGngzijnSsO
	mxakPOU+JGIYrnqUO7W9w==
X-ME-Sender: <xms:B8ccaJ1cScHWASYXBkR8B6QZ2fVXynwFVUkjS6F0Z0WRuPqPkrMrVQ>
    <xme:B8ccaAGZIwTRSAga_H275hLVM1eUzCi6shJM8c7TGE3nFT_reIlL_SCioIotxnkK_
    T9pmSVylOnUgvx-2rg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvledttdehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtjeertder
    tddtnecuhfhrohhmpedftfihrghnucforghtthhhvgifshdfuceorhihrghnmhgrthhthh
    gvfihssehfrghsthhmrghilhdrtghomheqnecuggftrfgrthhtvghrnheptdetfffgkefh
    keekleevtdehgeehgeeikeethfehgffggeeiheejjeffuefgheegnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprhihrghnmhgrthhthhgvfihs
    sehfrghsthhmrghilhdrtghomhdpnhgspghrtghpthhtohepudelpdhmohguvgepshhmth
    hpohhuthdprhgtphhtthhopehprghvvghlseguvghngidruggvpdhrtghpthhtohepfhdr
    fhgrihhnvghllhhisehgmhgrihhlrdgtohhmpdhrtghpthhtohepshhuughiphhmrdhmuh
    hkhhgvrhhjvggvsehgmhgrihhlrdgtohhmpdhrtghpthhtoheprhifrghrshhofiesghhm
    gidruggvpdhrtghpthhtohepsghrohhonhhivgeskhgvrhhnvghlrdhorhhgpdhrtghpth
    htoheptghonhhorheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhhuhgrhheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepphgrthgthhgvsheskhgvrhhnvghltghirdhorh
    hgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrgh
X-ME-Proxy: <xmx:B8ccaJ5j66BPuGTVjLiazddzfIM0ZScXM5eNFrGbus97AjW8fiTz8w>
    <xmx:B8ccaG3KRB5lZiZ5ddbxwxE-2HymTje4VkrccPa2-eIlSrMYAcRaTg>
    <xmx:B8ccaMHi5w-VXEp6Yj_nCYMOSue6Fg-KMhuhAgDQcv_nqlb4_6h8qw>
    <xmx:B8ccaH-ORwTk1DpiohAQfRbGg2aq3PoMfdalHSJqv5UxPFl6ZDQTcA>
    <xmx:CMccaN--dM3EnHs5E4F3l4KMHXMoc_OFXKI6mrGCdfph0EbJf5JjXBBQ>
Feedback-ID: i179149b7:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id A8AEB17E0071; Thu,  8 May 2025 11:00:23 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: Tdcd242bfffd4c373
Date: Thu, 08 May 2025 11:00:03 -0400
From: "Ryan Matthews" <ryanmatthews@fastmail.com>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net,
 shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org,
 pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Message-Id: <874d8d99-0cf4-43ce-8057-c7068084326d@app.fastmail.com>
In-Reply-To: <20250508112618.875786933@linuxfoundation.org>
References: <20250508112618.875786933@linuxfoundation.org>
Subject: Re: [PATCH 6.6 000/129] 6.6.90-rc2 review
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, May 8, 2025, at 07:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.90 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds and boots successfully on an ARM i.MX7D board.

Tested-by: Ryan Matthews <ryanmatthews@fastmail.com>

 -- Ryan
