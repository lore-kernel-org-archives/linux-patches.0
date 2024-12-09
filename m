Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D7A14F9E2
	for <patches@lists.linux.dev>; Mon,  9 Dec 2024 17:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733765368; cv=none; b=MsWxRrFjnw20aZY/wWkn3Ov9jcdhlgT1R89vCzsLVQYufrG9EerNUmPkr0RZvbd9jaKOIgxlv+pQj1utscfDuu76B+tgKVz+fv5p9vKfvwXnlUhg4KQo+NAPisVugLadG1TPAVhHyN8MnGvcH50JICzGIa62wzG6/eLSpm8gGdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733765368; c=relaxed/simple;
	bh=E6kQHEbP/PmMJ4s9H+cnQT7mpoICPz6qHRoFj0eCDFw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YnP2iCuh9GkpqbKnNZoa9S+cwFAbbtoUPgWwt3HaHluv3F/2myCSmPTzeX4sHeZc71moY2/yroO6YYT/lKorXIoE6YyRzcY4rOGLjrsZPy7IH/45SJym/4pivZn4Qjpwc1eX7htHpzrL70x0klsqN8FAGmN5d1VQs1IIL9fGO88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=RXTTfvFw; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="RXTTfvFw"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9F7C140E019C;
	Mon,  9 Dec 2024 17:29:24 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id MZgXk7yP4KSd; Mon,  9 Dec 2024 17:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733765361; bh=bgzrTT8oxCyDVwNbM6fB2WpAUPtugHtZ7j6VSpKq45U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RXTTfvFwhMiw2/AyMGy7lBf2h8H4JodH2yNtEohd75UWFcnU7yyuRiy8sIauX4wcf
	 r7U0XSp94zcwtwX5G5JwH+Z13E7fiQHHC7obgYI6zDWHxI4TnIAikh4+Os6JZp0uXq
	 y+Eo1NgHD1TDn2AZ4lF5CprIzHPMYDKbKjSMdEPtcWEd2jRiH2XSAwJv4KO+hAWU3N
	 ZqmKALZYBeRzfW41gZCuRU29AIwBAc81FOgp5yGQWwExrkqfso/E4kFHAOdMy8qDPP
	 f+FOngwCxt0l2C6TwxpUn6U529ZeiCRL2HcxYu8eXHJhiODgi5w7zIBS2pYGnLptnW
	 2yb9B+eiW4bT7dXSjNV8ozwYIyM2m9n6bWYlnp8OSbWs5tnydemNEj5Recu/oev8iA
	 DDUOPUs0KgEwRsWxW8I/N7flJ3Y3IUC2SJ89msD42fgdWMz6vS956wx7wnrFag0q2Z
	 AsShVUycqpqjRxp7G7f1aZPrMO/G32vjj12fI+Ior9/lgdjfIkHDPkwhCiNzM9ZpVP
	 q4kXdU/ciFAOSd+Y4KIFFsPCHSg8ukMykHHg0bkFWQP2XFUSs619grblB0bpPnuRTo
	 N4j/iRnZJC8qMq+WirfMuKPTauoK7hZl87OH8T+keoZWvO+CRMU9sNBmLhC/SdUF6R
	 E1L1Lecp4rJARecaO8Ies4dE=
Received: from zn.tnic (p200300EA971f9307329c23FfFeA6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:9307:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0BE3D40E0288;
	Mon,  9 Dec 2024 17:29:06 +0000 (UTC)
Date: Mon, 9 Dec 2024 18:28:59 +0100
From: Borislav Petkov <bp@alien8.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>, x86@kernel.org,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v11 0/8] x86/resctrl: mba_MBps enhancement
Message-ID: <20241209172859.GHZ1co28T-rRiQtIMp@fat_crate.local>
References: <20241206163148.83828-1-tony.luck@intel.com>
 <7e7c01c5-f64f-42c3-9364-ddcfd01b25c1@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7e7c01c5-f64f-42c3-9364-ddcfd01b25c1@intel.com>

On Mon, Dec 09, 2024 at 09:10:20AM -0800, Reinette Chatre wrote:
> Could you please consider this series for inclusion?

Lemme take a look...

> This fix has been merged into v6.13-rc2.

You mean, I should queue the set ontop of -rc2?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
