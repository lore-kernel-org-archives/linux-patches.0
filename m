Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C591922DA
	for <patches@lists.linux.dev>; Wed,  9 Oct 2024 11:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728474879; cv=none; b=rCfPug/1sSeePrmw6reMFVOrEEhZxoz34EOXeEEA037Kr+2o2ItImrUprj4vbuk7KgUpC+h4I6lzESA9NKs8p1QhfzoDX+ZhFCCIlKd2IJjwRwThOnapR0BcosuyNO7RE2s7/Ss0WYM40gm0crkXfOR3kBGdNIeJClxWzqWcRlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728474879; c=relaxed/simple;
	bh=mlMIwJbmsMcapczAeVjnxlgtadHyKjGMSsBtOH0MOw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h6h329waMZFf/lmu/WVQEkJ5m4ne2pLgi7a7jnhFE2aUPCRwhmQwxdEv9MY55iJctstvpEu2XjvERhOJ5faDNlvjkUM3oBRjlHJAMikXXJOWazvP+h4plGeo/tJdHNKu5cdqUkJ9YzB7UDYu8It7Sk99Awc/kltxCM2RMqx3J9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mLYPyait; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=WrkZoEAS; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mLYPyait; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=WrkZoEAS; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mLYPyait";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="WrkZoEAS";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mLYPyait";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="WrkZoEAS"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4DD6321E5D;
	Wed,  9 Oct 2024 11:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1728474876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oUvGL+sPmRmjMQqWkjor2e4sPlA8EZDWqN+kZ9oteLo=;
	b=mLYPyaitTcegU8E6eMKZAutBgCCB+zCZWUJZ7wim12jFiEspOZvA3V6NiE3bIBNbtPPT7+
	TCVlQIgLf7hGe/KAv5n0f6LTjrquvho33fWCAxCo59ER7P6E5y1jzEo6FWEjR5WuDRjl0O
	r+TOz/770C5FysmZNwI8N9X5kNYWdnc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1728474876;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oUvGL+sPmRmjMQqWkjor2e4sPlA8EZDWqN+kZ9oteLo=;
	b=WrkZoEASi/jBZ/ULqsAMhbXUKb2xpyb5lgf8fp+HhmzKwvVriwuOzDnucnHbnnVB64ppsn
	oGEuo4Z4/rLUizDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mLYPyait;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WrkZoEAS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1728474876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oUvGL+sPmRmjMQqWkjor2e4sPlA8EZDWqN+kZ9oteLo=;
	b=mLYPyaitTcegU8E6eMKZAutBgCCB+zCZWUJZ7wim12jFiEspOZvA3V6NiE3bIBNbtPPT7+
	TCVlQIgLf7hGe/KAv5n0f6LTjrquvho33fWCAxCo59ER7P6E5y1jzEo6FWEjR5WuDRjl0O
	r+TOz/770C5FysmZNwI8N9X5kNYWdnc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1728474876;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oUvGL+sPmRmjMQqWkjor2e4sPlA8EZDWqN+kZ9oteLo=;
	b=WrkZoEASi/jBZ/ULqsAMhbXUKb2xpyb5lgf8fp+HhmzKwvVriwuOzDnucnHbnnVB64ppsn
	oGEuo4Z4/rLUizDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 36E8A13A58;
	Wed,  9 Oct 2024 11:54:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TRdICvxuBmdoEAAAD6G6ig
	(envelope-from <chrubis@suse.cz>); Wed, 09 Oct 2024 11:54:36 +0000
Date: Wed, 9 Oct 2024 13:53:31 +0200
From: Cyril Hrubis <chrubis@suse.cz>
To: Anders Roxell <anders.roxell@linaro.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, f.fainelli@gmail.com, rwarsow@gmx.de,
	pavel@denx.de, conor@kernel.org, shuah@kernel.org,
	allen.lkml@gmail.com, LTP List <ltp@lists.linux.it>,
	patches@lists.linux.dev, stable@vger.kernel.org,
	linux-kernel@vger.kernel.org, broonie@kernel.org,
	lkft-triage@lists.linaro.org, srw@sladewatkins.net,
	patches@kernelci.org, akpm@linux-foundation.org,
	jonathanh@nvidia.com, torvalds@linux-foundation.org,
	sudipm.mukherjee@gmail.com, linux@roeck-us.net
Subject: Re: [LTP] [PATCH 6.10 000/482] 6.10.14-rc1 review
Message-ID: <ZwZuuz2jTW5evZ6v@yuki.lan>
References: <20241008115648.280954295@linuxfoundation.org>
 <CA+G9fYv=Ld-YCpWaV2X=ErcyfEQC8DA1jy+cOhmviEHGS9mh-w@mail.gmail.com>
 <CADYN=9KBXFJA1oU6KVJU66vcEej5p+6NcVYO0=SUrWW1nqJ8jQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADYN=9KBXFJA1oU6KVJU66vcEej5p+6NcVYO0=SUrWW1nqJ8jQ@mail.gmail.com>
X-Rspamd-Queue-Id: 4DD6321E5D
X-Spam-Score: -2.98
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.98 / 50.00];
	BAYES_HAM(-2.97)[99.87%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.de];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[25];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[linaro.org,linuxfoundation.org,suse.cz,kernel.org,mit.edu,gmail.com,gmx.de,denx.de,lists.linux.it,lists.linux.dev,vger.kernel.org,lists.linaro.org,sladewatkins.net,kernelci.org,linux-foundation.org,nvidia.com,roeck-us.net];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim,linux.it:url]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

Hi!
Work in progress, see:
https://lists.linux.it/pipermail/ltp/2024-October/040433.html

-- 
Cyril Hrubis
chrubis@suse.cz
