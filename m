Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FDA2D23BF
	for <patches@lists.linux.dev>; Tue,  4 Nov 2025 12:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762260163; cv=none; b=PHFDvfj76mGUsV+RltStEZAX9mmu5zyFF5FGeeLTFoIdD0cHZkr0F25FIBPl5JvltV//zfTP9fmx8rM+NdWcwyZpdsRKyP5bQv+ejhihXe9jtCf+njIfHZFdHCgokFUwux/Rqj+nTyMhrcwD7hYuqty8EjNyP1aXTq8GWEoR3Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762260163; c=relaxed/simple;
	bh=cQAmRQg5LC13PPVUTNots7PLXrGDi5X+WTIxNY413hY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ThuyrHa5CQJnwYeViLsZ6a66EaH96sL5ac2egvX3g6eNra8dzxLHeVlN1z79f0PoNlaV78bDlC399iNCRWIm6dHKz/FXG08HUSG6/clm8daCaGQ5Xi/Et2tRqh/z3+zUVClQKIXowE1WvZEPqAX24UKuEeIHR8N5TVMQDBQBm9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=uymnNM1N; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=d5LZgSD5; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=uymnNM1N; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=d5LZgSD5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="uymnNM1N";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="d5LZgSD5";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="uymnNM1N";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="d5LZgSD5"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3AAE22118C;
	Tue,  4 Nov 2025 12:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762260160; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6MR2QIBeEQ5DO0ZkjyPiCrA6UelbA4sjuwGHoj9Td7U=;
	b=uymnNM1NXZ3O9AixAchBoUKJ1O0D6y+tK7UqhbbFPzZwZEZyjdPiqf3VSff7211Yh+51sk
	WvSNZVAFHGa23Y/jsIa4iqtc5gEI/fniWvkNL+1kAtAWcmzo93Ehdv7nXc4rxIrB5Bq5gm
	i25TOBA9yJo4LxSYxST2JtVs8PNuCDM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762260160;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6MR2QIBeEQ5DO0ZkjyPiCrA6UelbA4sjuwGHoj9Td7U=;
	b=d5LZgSD5Fi4BnAExnQ36bq3m9T6HZT36gNKecM6xxr+Clav+lq9Kfu4NySuFTQsFoEqqF3
	+du+MoVNhvoBqcDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762260160; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6MR2QIBeEQ5DO0ZkjyPiCrA6UelbA4sjuwGHoj9Td7U=;
	b=uymnNM1NXZ3O9AixAchBoUKJ1O0D6y+tK7UqhbbFPzZwZEZyjdPiqf3VSff7211Yh+51sk
	WvSNZVAFHGa23Y/jsIa4iqtc5gEI/fniWvkNL+1kAtAWcmzo93Ehdv7nXc4rxIrB5Bq5gm
	i25TOBA9yJo4LxSYxST2JtVs8PNuCDM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762260160;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6MR2QIBeEQ5DO0ZkjyPiCrA6UelbA4sjuwGHoj9Td7U=;
	b=d5LZgSD5Fi4BnAExnQ36bq3m9T6HZT36gNKecM6xxr+Clav+lq9Kfu4NySuFTQsFoEqqF3
	+du+MoVNhvoBqcDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E8F0F139A9;
	Tue,  4 Nov 2025 12:42:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id U2RxN7/0CWmKYAAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Tue, 04 Nov 2025 12:42:39 +0000
Message-ID: <defbe4a2-a4a6-4e68-89ea-e1ef5e77640e@suse.de>
Date: Tue, 4 Nov 2025 13:42:39 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Fixes for pmac32_defconfig after fb.h removal from
 backlight.h
To: Nathan Chancellor <nathan@kernel.org>, Lee Jones <lee@kernel.org>,
 Daniel Thompson <danielt@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Simona Vetter <simona.vetter@ffwll.ch>, linuxppc-dev@lists.ozlabs.org,
 patches@lists.linux.dev
References: <20250925-ppc-fixes-for-backlight-fb-h-removal-v1-0-d256858d86a6@kernel.org>
Content-Language: en-US
From: Thomas Zimmermann <tzimmermann@suse.de>
Autocrypt: addr=tzimmermann@suse.de; keydata=
 xsBNBFs50uABCADEHPidWt974CaxBVbrIBwqcq/WURinJ3+2WlIrKWspiP83vfZKaXhFYsdg
 XH47fDVbPPj+d6tQrw5lPQCyqjwrCPYnq3WlIBnGPJ4/jreTL6V+qfKRDlGLWFjZcsrPJGE0
 BeB5BbqP5erN1qylK9i3gPoQjXGhpBpQYwRrEyQyjuvk+Ev0K1Jc5tVDeJAuau3TGNgah4Yc
 hdHm3bkPjz9EErV85RwvImQ1dptvx6s7xzwXTgGAsaYZsL8WCwDaTuqFa1d1jjlaxg6+tZsB
 9GluwvIhSezPgnEmimZDkGnZRRSFiGP8yjqTjjWuf0bSj5rUnTGiyLyRZRNGcXmu6hjlABEB
 AAHNJ1Rob21hcyBaaW1tZXJtYW5uIDx0emltbWVybWFubkBzdXNlLmRlPsLAjgQTAQgAOAIb
 AwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftODH
 AAoJEGgNwR1TC3ojx1wH/0hKGWugiqDgLNXLRD/4TfHBEKmxIrmfu9Z5t7vwUKfwhFL6hqvo
 lXPJJKQpQ2z8+X2vZm/slsLn7J1yjrOsoJhKABDi+3QWWSGkaGwRJAdPVVyJMfJRNNNIKwVb
 U6B1BkX2XDKDGffF4TxlOpSQzdtNI/9gleOoUA8+jy8knnDYzjBNOZqLG2FuTdicBXblz0Mf
 vg41gd9kCwYXDnD91rJU8tzylXv03E75NCaTxTM+FBXPmsAVYQ4GYhhgFt8S2UWMoaaABLDe
 7l5FdnLdDEcbmd8uLU2CaG4W2cLrUaI4jz2XbkcPQkqTQ3EB67hYkjiEE6Zy3ggOitiQGcqp
 j//OwE0EWznS4AEIAMYmP4M/V+T5RY5at/g7rUdNsLhWv1APYrh9RQefODYHrNRHUE9eosYb
 T6XMryR9hT8XlGOYRwKWwiQBoWSDiTMo/Xi29jUnn4BXfI2px2DTXwc22LKtLAgTRjP+qbU6
 3Y0xnQN29UGDbYgyyK51DW3H0If2a3JNsheAAK+Xc9baj0LGIc8T9uiEWHBnCH+RdhgATnWW
 GKdDegUR5BkDfDg5O/FISymJBHx2Dyoklv5g4BzkgqTqwmaYzsl8UxZKvbaxq0zbehDda8lv
 hFXodNFMAgTLJlLuDYOGLK2AwbrS3Sp0AEbkpdJBb44qVlGm5bApZouHeJ/+n+7r12+lqdsA
 EQEAAcLAdgQYAQgAIAIbDBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftOH6AAoJEGgNwR1T
 C3ojVSkIALpAPkIJPQoURPb1VWjh34l0HlglmYHvZszJWTXYwavHR8+k6Baa6H7ufXNQtThR
 yIxJrQLW6rV5lm7TjhffEhxVCn37+cg0zZ3j7zIsSS0rx/aMwi6VhFJA5hfn3T0TtrijKP4A
 SAQO9xD1Zk9/61JWk8OysuIh7MXkl0fxbRKWE93XeQBhIJHQfnc+YBLprdnxR446Sh8Wn/2D
 Ya8cavuWf2zrB6cZurs048xe0UbSW5AOSo4V9M0jzYI4nZqTmPxYyXbm30Kvmz0rYVRaitYJ
 4kyYYMhuULvrJDMjZRvaNe52tkKAvMevcGdt38H4KSVXAylqyQOW5zvPc4/sq9c=
In-Reply-To: <20250925-ppc-fixes-for-backlight-fb-h-removal-v1-0-d256858d86a6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[linux.ibm.com,ellerman.id.au,gmail.com,csgroup.eu,ffwll.ch,lists.ozlabs.org,lists.linux.dev];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:url,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30

Hi

Am 26.09.25 um 01:46 schrieb Nathan Chancellor:
> Commit 9f218f9bb9d2 ("backlight: Do not include <linux/fb.h> in header
> file") exposed some necessary includes that were missing from a few
> powerpc drivers, breaking the build. This series resolves them.
>
> This should go via the backlight tree, which includes 9f218f9bb9d2, but
> I have included the PowerPC folks for visibility.
>
> ---
> Nathan Chancellor (2):
>        powerpc/powermac: Include linux/of.h in backlight.c
>        macintosh/via-pmu-backlight: Include linux/of.h and uapi/linux/fb.h
>
>   arch/powerpc/platforms/powermac/backlight.c | 1 +
>   drivers/macintosh/via-pmu-backlight.c       | 2 ++
>   2 files changed, 3 insertions(+)

Please also see:

  https://lore.kernel.org/dri-devel/20251027140646.227025-1-tzimmermann@suse.de/

Can one of these series please be merged into the respective tree?

Best regards
Thomas

> ---
> base-commit: 9f218f9bb9d274b9d5d48a4c95e1b199141fc1f2
> change-id: 20250925-ppc-fixes-for-backlight-fb-h-removal-2b6a87cced02
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, Werner Knoblich, (HRB 36809, AG Nürnberg)


