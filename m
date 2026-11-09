Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=65.109.113.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794188822;
	b=b+5YiYwHFEq6LBfmpTN4rUnBiH2/JNqnruCUBqxcQjsCGwtYX7iRtzcZ1it6aJ7RCLAR
	 vjFDSDB1gI8oTPnT5FDlHoNR7Kyj49tZjpqr3EM2uaFRc3x1BlWcn9pcAhNfE3So2GxzV
	 re1jK5QjlXepiJCoaWDyHgigfFVVXViItRh6d2ShfDe+m4CprW9XmwHYNYZ3aTIk/K3AF
	 5Yqbu8WUBJTg7EW+U1o2AKqF6keooryE0QVRACWRP8FPsBMJs14qoPONMDbe4Lz8JvyeA
	 r58XA0Eo39UZhp3VUDBaPPSyg1Dc9ghvJ+yMVy3cY9/tpF8zVIFwC08U9uYxzALeosg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794188822;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:DKIM-Signature:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=fedi2FVynnyOJO1ineshwdOa6R54PcmKGeFqXDNuo4Y=;
	b=LrTL++oiVzQa3rcateQhqLLkJGi3CfOAYkbhHEy9Np2PNToN6qv45lhw5AXz0AGzEBkQ
	 n4aN92dj6I4nXETFrcuCRnqs2eED0NBD95twVoGM5kjJMMq+FTf1HphQZLVjVS8BJ5hXz
	 esm7b/TK8Qb870XpdvFzhda7D/B1Eu7uUTxfTq/5MuytbZAUTIZCVyChZYXqfG3w6DXQR
	 lyICNef7poRZRwUCnoU8gl54kNf5wScCK2h4uLmDDHkgPhHb3m9tEgCTPxajKzsSmNYjo
	 isZY0jhspEKxUg1m4DOYPM9fAyZiIXVXKnk2oHgUG6YXLZ4bJzLzyzQacbJKGJwRkUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=alien8.de;
	spf=pass smtp.mailfrom=alien8.de;
	dkim=pass header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=ewSrOaw1;
	arc=none smtp.remote-ip=65.109.113.108
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C77606A321
	for <patches@lists.linux.dev>; Mon,  9 Nov 2026 01:47:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1C77606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=ewSrOaw1
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 63DAA40E04CF;
	Mon,  9 Nov 2026 01:46:52 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id deQr1jtHEFED; Mon,  9 Nov 2026 01:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1794188809; bh=fedi2FVynnyOJO1ineshwdOa6R54PcmKGeFqXDNuo4Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ewSrOaw14xWo1pOPOQplULOYL8edYcpP8wqCSNU7W9k1cWrQ4VzcwlqwV5qkQP9kP
	 RPq607t9kudr8qHOAj8kuV1nMSJ8KCMjrdYGMTEr5fIKeXLhclKtdbefVgr7/U6rYT
	 c2tVARkvqZU7yp+k0713BmTzKoPC0anxOijocHVT8L1eaxMOKeUI/xii69WuHBeMdt
	 INIbP1VI+s+CQm1BQZCKJGYAyzDGMvO4DxMCBpS2XBOM+a0YuSimmZP0v1WfV9Z4wD
	 Svvp8Ezx24l5TgxYsZsb+MGyGm7BTPHHi5ZjMtQkmMn0SET8L1CLxDy6otdly/+yqW
	 0o4dS1ic7rUGz8x9MV0FBuAmXMXHYpVtToFe62h3MsaIB/wVJhnVGM5W822v2uFq8J
	 zIsdcuktLvOO5yBZYMvFt7gIHY6XwDEm0M8iGoo4ls9a2Q5rEbgKwRxTAr6JMVGWk3
	 dlzHiqTDfq+v9EcyVsz5U8KfmR0yHpK5HfjeCB7sQ2W6pjOeyMAyaZubMI8FNx8Lp1
	 wfoFkhIWSbyHHDJRSd17HkDE1wf9+d0zxER/UeaY0fNp1mIWWGrTXN9bFnjOdGgK/q
	 JngSngGHU6+zTHQ2CE7EJiO0t4uvY9YiGwnEeXwuJHNlGy0sGqXQEZ5A8zhn3rtGXY
	 TkzOlyL6eq4LZZW2AUmV76jQ=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B91B640E0140;
	Mon,  9 Nov 2026 01:46:32 +0000 (UTC)
Date: Sun, 8 Nov 2026 17:46:29 -0800
From: Borislav Petkov <bp@alien8.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: tglx@linutronix.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, fustini@kernel.org, fenghuay@nvidia.com,
	peternewman@google.com, yu.c.chen@intel.com,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	tony.luck@intel.com, ben.horgan@arm.com, james.morse@arm.com,
	Dave.Martin@arm.com, babu.moger@amd.com
Subject: Re: [PATCH v3 0/5] x86,fs/resctrl: Cleanups in preparation for
 multiple controls support
Message-ID: <20261109014629.GEavEl9ds0dVxaOqER@fat_crate.local>
References: <cover.1793834224.git.reinette.chatre@intel.com>
 <0dfb141b-7b92-423b-8603-12d99ad1b2e7@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0dfb141b-7b92-423b-8603-12d99ad1b2e7@intel.com>

On Wed, Nov 04, 2026 at 04:26:43PM -0800, Reinette Chatre wrote:
> Dear x86 maintainers,
> 
> Could you please consider this series for inclusion?

/me is looking...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
