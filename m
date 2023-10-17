Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18118182CA
	for <patches@lists.linux.dev>; Fri, 20 Oct 2023 11:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="USlE3HEQ";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="+aFICXrR"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0934940E01AA
	for <patches@lists.linux.dev>; Fri, 20 Oct 2023 11:18:42 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id KCAn4S93fO-2 for <patches@lists.linux.dev>;
	Fri, 20 Oct 2023 11:18:34 +0000 (UTC)
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E8D3B40E014B
	for <patches@lists.linux.dev>; Fri, 20 Oct 2023 11:18:33 +0000 (UTC)
Resent-From: Borislav Petkov <bp@alien8.de>
Resent-Date: Fri, 20 Oct 2023 13:18:27 +0200
Resent-Message-ID: <20231020111827.GCZTJiA8IpxMPSn3Lk@fat_crate.local>
Resent-To: patches@lists.linux.dev
Received: from mail.alien8.de
	by mad with LMTP
	id SGK8KtLOLmWVECIAc81XFw
	(envelope-from <tglx@linutronix.de>)
	for <bp@alien8.de>; Tue, 17 Oct 2023 18:13:38 +0000
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9FBD140E0177
	for <bp@alien8.de>; Tue, 17 Oct 2023 18:13:38 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kfnpq4lyUemC for <bp@alien8.de>;
	Tue, 17 Oct 2023 18:13:31 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPS id 4C25840E01AA
	for <bp@alien8.de>; Tue, 17 Oct 2023 18:13:23 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1697566397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p9RqDTlfriaaHQFD8zLBqGUAxu2Dwf3vF6Ld5YbUKtM=;
	b=USlE3HEQyk/QF+OFBXltqoVe8QYQoYcfdW2EMcJwx5wTdDqYh5Y+yqmxfT5rkyD9Jsbf3k
	Vo/JZHCEfUariS7xxqFOlYCIqCsgS0e6auWlhrBm/PZ32IqOrF3By86bSNrC+WfVsdLn+R
	Dk7Ri+6dwWuQJ7I4cCgl2mZoz00aGrxAiVOk6n0PAZX5fYGYhnUaAUyIWOWOVP7lQZqCMN
	TheHjqMnE3ZlKIut9DE7HxYC3kO6eAjaM3Z5Mf04+gprBTRT6IZXQZvmAIezqQNI21Lvmm
	mEFgjYYKaqI0WETRPzkfVtH2HLddMUQXFKDjX5qRXryhfOP6gs7wa5cDj4+wDQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1697566397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p9RqDTlfriaaHQFD8zLBqGUAxu2Dwf3vF6Ld5YbUKtM=;
	b=+aFICXrRgsfI5d1evi1IiG6gQ2X9cl7HRpjzJppEJEwaS7rmvvdLldTjagdS2CQXrbEo4i
	vwN70H54WiVvEWCg==
To: Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Subject: Re: [PATCH] x86: delete unused "struct thunk_desc"
In-Reply-To: <843bf596-db67-4b33-a865-2bae4a4418e5@p183>
References: <843bf596-db67-4b33-a865-2bae4a4418e5@p183>
Date: Tue, 17 Oct 2023 20:13:17 +0200
Message-ID: <87a5sh5d8i.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 4C25840E01AA
X-Spamd-Result: default: False [-3.50 / 20.00];
	 ARC_NA(0.00)[];
	 R_DKIM_ALLOW(-0.20)[linutronix.de:s=2020,linutronix.de:s=2020e];
	 URIBL_BLOCKED(0.00)[linutronix.de:dkim];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 R_SPF_ALLOW(-0.20)[+mx:c];
	 MIME_GOOD(-0.10)[text/plain];
	 RBL_SENDERSCORE_FAIL(0.00)[2a0a:51c0:0:12e:550::1:query timed out];
	 RCPT_COUNT_FIVE(0.00)[5];
	 MAILSPIKE_FAIL(0.00)[2a0a:51c0:0:12e:550::1:query timed out];
	 TO_MATCH_ENVRCPT_SOME(0.00)[];
	 RBL_SEM_IPV6_FAIL(0.00)[2a0a:51c0:0:12e:550::1:query timed out];
	 DKIM_TRACE(0.00)[linutronix.de:+];
	 DMARC_POLICY_ALLOW(-0.50)[linutronix.de,none];
	 NEURAL_HAM(-0.00)[-1.000];
	 FREEMAIL_TO(0.00)[gmail.com,redhat.com,alien8.de,linux.intel.com];
	 RCVD_COUNT_ZERO(0.00)[0];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_NOT_FQDN(0.50)[];
	 ASN(0.00)[asn:48314, ipnet:2a0a:51c0::/32, country:DE];
	 BAYES_HAM(-3.00)[99.99%]
X-Rspamd-Server: mad

On Sat, Oct 14 2023 at 19:05, Alexey Dobriyan wrote:
> It looks like it was never used.
>
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Can you please send patches to LKML as documented in MAINTAINERS?
