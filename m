Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF5A1E0DDC
	for <patches@lists.linux.dev>; Fri, 13 Dec 2024 13:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734098107; cv=none; b=mcLAhiNrzye91d/CyXhAjDp80pK0NTWFzRQVZLTtRGgdSp79MiSFgUz6a6N1p7ndKs+eTyLJBVjj95AKy2q7qK4bUlrrELkzv8I5nw41IsPvR5CK4454QEjf1YkUutrt+Wehd9OX9uHVt5pe/iJXQ3/Q9n2xQI41oSGUe+B/HyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734098107; c=relaxed/simple;
	bh=26Bafj+z7PhHgr5lw9zvsTI6tdl3kohtMbqisDomtCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ESGYRtlCyAphGOG8QWHlRyAc7SNIXu4K0etwymYUPv4uB5XdXqiNVJyxduAVqoL2ndSDt+R1RETOc04c0pHoSE6JhP90spNm4wMVaSlFI55IIh6m9OpMKWNwzqw2GGDgww9SaPjl2cDxtgVZhPPqepwSwRSDV8j00PnYi8ER+Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=dbOMxGJ5; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Vqgdzmdo; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ma+jVbtT; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mzMg5Kgy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="dbOMxGJ5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Vqgdzmdo";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ma+jVbtT";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mzMg5Kgy"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A0C7C1F785;
	Fri, 13 Dec 2024 13:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1734098104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fNqUB8mbGb3Mza9CFQRmuUePzkHL5AhzBAkZGi3fxYI=;
	b=dbOMxGJ565lChGNcncbAloDiU0hkRnx3XKHb2QKcjMEem4UsWlA8mtPDKfEwMpfRTAXjB3
	T0YCafO6V4zTcbRI2usxKzZWXiP7LusgtOeoPztpVH23QDOAezuv3H4SJZqfi2Q4kSYq7q
	NNnmP+CrKLY3ueT3i/VQGmacD7CysDw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1734098104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fNqUB8mbGb3Mza9CFQRmuUePzkHL5AhzBAkZGi3fxYI=;
	b=VqgdzmdoMdjjF0lEwEQrACY5kM4gQxZQn3s4PbKDauEch3Ymxmf/26rF2w2dk7QgoXUJUw
	cSnw/k9qlZcfFIBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ma+jVbtT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mzMg5Kgy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1734098103; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fNqUB8mbGb3Mza9CFQRmuUePzkHL5AhzBAkZGi3fxYI=;
	b=ma+jVbtT7a8AFMq7gCSvCrDjRAaxHLzcPcGN+/MQGiph0bfdHAm7BFU2OZViLi8KXuHrW2
	pFcc4+F5vGztd3QJHAfZ7kBX3TykJYXamFW1llvv3QQZhMban+cWpaewm45WKDQkwR0N+6
	Ej+YOtrxX5w8f8HUwckO4p2P05Ho0eI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1734098103;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fNqUB8mbGb3Mza9CFQRmuUePzkHL5AhzBAkZGi3fxYI=;
	b=mzMg5KgyGJPHGBqlrDn7MU50HbYZYBuo0noY/YQ701rPqr6WwyQYWxzJwqXf355udg9mgk
	VoICQXcOdqeFuTDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8E5DF137CF;
	Fri, 13 Dec 2024 13:55:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wD35Ibc8XGfzEgAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 13 Dec 2024 13:55:03 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id ECF43A0B0E; Fri, 13 Dec 2024 14:55:02 +0100 (CET)
Date: Fri, 13 Dec 2024 14:55:02 +0100
From: Jan Kara <jack@suse.cz>
To: Philippe Troin <phil@fifi.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev,
	Anders Blomdell <anders.blomdell@gmail.com>,
	Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.12 162/466] Revert "readahead: properly shorten
 readahead when falling back to do_page_cache_ra()"
Message-ID: <20241213135502.bgtghwphkezyfvob@quack3>
References: <20241212144306.641051666@linuxfoundation.org>
 <20241212144313.202242815@linuxfoundation.org>
 <4ab51fdc37c39bd077b4bcea281d301af4c3ef1a.camel@fifi.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4ab51fdc37c39bd077b4bcea281d301af4c3ef1a.camel@fifi.org>
X-Rspamd-Queue-Id: A0C7C1F785
X-Spam-Level: 
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[linuxfoundation.org,vger.kernel.org,lists.linux.dev,gmail.com,suse.cz,infradead.org,linux-foundation.org];
	RCPT_COUNT_SEVEN(0.00)[8];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim,suse.cz:email]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -2.51
X-Spam-Flag: NO

On Thu 12-12-24 10:12:54, Philippe Troin wrote:
> On Thu, 2024-12-12 at 15:55 +0100, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let
> > me know.
> > 
> > ------------------
> > 
> > From: Jan Kara <jack@suse.cz>
> > 
> > commit a220d6b95b1ae12c7626283d7609f0a1438e6437 upstream.
> > 
> > This reverts commit 7c877586da3178974a8a94577b6045a48377ff25.
> 
> Isn't that moot now with 0938b1614648d5fbd832449a5a8a1b51d985323d that
> in Linus's tree? It's not in 6.12 (yet?).
> It may be worth backporting 0938b1614 to the stable tree, but it's
> beyond my pay grade.

Hum, I don't think it is moot. Due to the change this commit reverts, we
could have been calling page_cache_ra_unbounded() with huge nr_to_read
value. I don't see how upstream commit 0938b1614648d5fb helps dealing with
that...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
