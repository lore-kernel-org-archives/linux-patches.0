Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793314305;
	b=ySubyKemA80CHOUG0WjcV9HoLPf/9yF0DNpcLd3Uub48ro1GhTkZmYxYIQlqKXShvu12
	 6M3OQBIgWz2sqFH5itieCMLfHTYESx15/a4z4Fin1Zc+bj2jMd+hJqIfeJ7vJkpsprCs0
	 aRQydrDOUw7t9hGN5fWRrGC7SVt2+BpNlElyGe/nuu/TFqtZP7G3aZdIS44/Ll+xKzPoL
	 7GTHLLssDMorToSTFGhCkPgLRTIp3XSsCOTdlZTzR2zYxCjqOsp6FzdEiIpA4Mx2sPsCb
	 HkMEYvZFUwFXbA2qtW2nJ9Ug5lvzFW0wiXjnjOKPz3zDDkcNGFZxuTZaXuYhVX63Euw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793314305;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=8klQKhRThQNppUw+KcbxhoOsS/2ZZK1Ciz6dr6p1ntU=;
	b=YFWczpDlhi3Fb1Pf9hpSoGg91eJPwgYYkNz9mW4M8hu9sshVrSmbNzVN2cHVPkM0aNQF
	 OFgnKd9TpmD92TStWJvUfP0QQHSQG3xHdPfdiIIEOGSvdynyuTA9y6G3LGeSqjr9FqJgh
	 2ylKR3+4gvPisuEoQnfxpSpagJBC2vKpfGlS97apDsMZ+vsUkrTSK4MUeNRtEo6EpJJ57
	 ryd1XAW/i0CdrfB1Uylylzb5A1kUaO79cYS9zvdCmCoac7OZn2C6cpS3sSHs29xmvsqxm
	 HaRpBPEdaK/lpBEjvf8p0bC21FxR2W5Hrt8DvJUHBSJoildWHFS/K5ydgCtiOxpD4Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b="QQ/YEWWV";
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5565A606A31A
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 22:51:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5565A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=QQ/YEWWV
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=8klQKhRThQNppUw+KcbxhoOsS/2ZZK1Ciz6dr6p1ntU=; b=QQ/YEWWVWGkexK71Z1Vv4C8qip
	eXrah04WIy38xEnmrJViH1kekXz9n1Kpi7ZgJAiDSB107I2RFnuzdRcxY/KQ8m/nHclvlER057/+R
	Vt0xAsucJF5ljF1Y/4K/nrNpg3PYCJM8rH7WAxC7g3uK5heXKNQiAnAZ0b/KahUSgY7/acmrlAcux
	cLggaEgQP1anT3pXl1a2K5nRcEZbrmb15wC5nki40sc4glJD4hyaCo7F0CCIA4xDT3Jf/fL8rZz2F
	Bq/IaHgZQRTudWAIAby7GF+Py6ZBCayPp8seZsi6nyPIA0UKNfc5B/zqVIqDZBgzhroP0Zf1zj112
	90wdJkhQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMYyF-0000000AVGi-1qwq;
	Thu, 29 Oct 2026 22:51:43 +0000
Message-ID: <90d34011-24ec-4fdb-9b71-f4c3d0f316d2@infradead.org>
Date: Thu, 29 Oct 2026 15:51:41 -0700
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] powerpc/ps3: repair some kernel-doc comments
To: patches@lists.linux.dev
Cc: Geoff Levand <geoff@infradead.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 linuxppc-dev@lists.ozlabs.org
References: <20261029201326.2672284-1-rdunlap@infradead.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20261029201326.2672284-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 10/29/26 1:13 PM, Randy Dunlap wrote:
> Patches 1 and 2 eliminate all kernel-doc warnings in their
> respective files.
> Patches 3 and 4 target certain classes of kernel-doc warnings
> but don't eliminate all kernel-doc warnings in those files.
> 
> 
>  [PATCH 1/4] powerpc/ps3: platform.h: fix enum ps3_spu_resource_type kernel-doc
>  [PATCH 2/4] powerpc/ps3: htab.c: fix enum ps3_lpar_vas_id kernel-doc
>  [PATCH 3/4] powerpc/ps3: mm.c: clean up kernel-doc issues
>  [PATCH 4/4] powerpc/ps3: os-area.c: fix some kernel-doc warnings
> 
>  arch/powerpc/platforms/ps3/htab.c     |    4 ++--
>  arch/powerpc/platforms/ps3/mm.c       |   10 +++++-----
>  arch/powerpc/platforms/ps3/os-area.c  |    5 +++--
>  arch/powerpc/platforms/ps3/platform.h |    7 ++++---
>  4 files changed, 14 insertions(+), 12 deletions(-)
> 
> 
> Cc: Geoff Levand <geoff@infradead.org>
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
> Cc: linuxppc-dev@lists.ozlabs.org

This should have been labeled with "RESEND" since I also sent this
patch series on 2026-08-31.

-- 
~Randy

