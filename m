Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075F119F40B
	for <patches@lists.linux.dev>; Tue,  4 Nov 2025 12:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762260210; cv=none; b=khkjlskjkeXAXc3ZiMxnGIazptBFyBRurZmTBWn+j1EqXEY0zqI9Fcn7CXWzJBnG8tyUW+Kj1SG+ViuBvPkdRYNNRzdIYGhIuJxrCWC2dAlqecxywqtlyJdHMl4DKqTcdsysuiinYDvzYzu9gckD1hsVOIh1TYUOjJp71HPQ4qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762260210; c=relaxed/simple;
	bh=2jHRwxU1AoDeImyghdh+OByTSTRuW5yroDJci7amRnc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O9UUnmyQnFjkv2g5oa7hOCdrbdpuw6058tTsKFwKW9RIWKc0yTQj+TjUNBO6ukCNu8PyL5Aq5/MU37kWvNmEHxXfB/kcx8ZhkRJN4j7Q63+Xp2IHoF/0iiTi42XcKlng6nWvgRFzjn1neVOtZCM7QDOeGjyOF3DuYY4/OtXAetg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oFsh3x5L; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=si81+G+O; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oFsh3x5L; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=si81+G+O; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oFsh3x5L";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="si81+G+O";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oFsh3x5L";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="si81+G+O"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0DB001F385;
	Tue,  4 Nov 2025 12:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762260207; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=seJoJrRxVzIiiIJntuQlp8cn06xUkhipNZWVIEq3udo=;
	b=oFsh3x5LgkyLYZtrfs62QbMWrBdBRto2vHvwJKqWN2Iew/JEp+y8/ss2TRF+TPcxSPXqiy
	jfEC2FXCK8snIbtzLWPyoxArzQCx+FUdEFVYXPMpuaN+Xqqb4nVcmNeQhrNpM8A5tA/Vga
	dsWKiFDij9EC8vQKf4Zgwf+VPuDUJdE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762260207;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=seJoJrRxVzIiiIJntuQlp8cn06xUkhipNZWVIEq3udo=;
	b=si81+G+OaBwJt12Qqc2HvHW/b87uIQqwJkqFTFOD4bmb2FbU+yAKv2EfczeUjoeDZbOGcj
	MlP8VsAQTAoSB2CA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762260207; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=seJoJrRxVzIiiIJntuQlp8cn06xUkhipNZWVIEq3udo=;
	b=oFsh3x5LgkyLYZtrfs62QbMWrBdBRto2vHvwJKqWN2Iew/JEp+y8/ss2TRF+TPcxSPXqiy
	jfEC2FXCK8snIbtzLWPyoxArzQCx+FUdEFVYXPMpuaN+Xqqb4nVcmNeQhrNpM8A5tA/Vga
	dsWKiFDij9EC8vQKf4Zgwf+VPuDUJdE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762260207;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=seJoJrRxVzIiiIJntuQlp8cn06xUkhipNZWVIEq3udo=;
	b=si81+G+OaBwJt12Qqc2HvHW/b87uIQqwJkqFTFOD4bmb2FbU+yAKv2EfczeUjoeDZbOGcj
	MlP8VsAQTAoSB2CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C07D4139A9;
	Tue,  4 Nov 2025 12:43:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TBPNLe70CWlXYQAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Tue, 04 Nov 2025 12:43:26 +0000
Message-ID: <c1aecfba-fa12-4572-885d-925e9afa1494@suse.de>
Date: Tue, 4 Nov 2025 13:43:26 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] macintosh/via-pmu-backlight: Include linux/of.h and
 uapi/linux/fb.h
To: Nathan Chancellor <nathan@kernel.org>, Lee Jones <lee@kernel.org>,
 Daniel Thompson <danielt@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Simona Vetter <simona.vetter@ffwll.ch>, linuxppc-dev@lists.ozlabs.org,
 patches@lists.linux.dev
References: <20250925-ppc-fixes-for-backlight-fb-h-removal-v1-0-d256858d86a6@kernel.org>
 <20250925-ppc-fixes-for-backlight-fb-h-removal-v1-2-d256858d86a6@kernel.org>
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
In-Reply-To: <20250925-ppc-fixes-for-backlight-fb-h-removal-v1-2-d256858d86a6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[linux.ibm.com,ellerman.id.au,gmail.com,csgroup.eu,ffwll.ch,lists.ozlabs.org,lists.linux.dev];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,imap1.dmz-prg2.suse.org:helo,suse.com:url]
X-Spam-Flag: NO
X-Spam-Score: -4.30

Hi

Am 26.09.25 um 01:46 schrieb Nathan Chancellor:
> After the recent removal of the fb.h include from backlight.h, which
> transitively included of.h, there are several errors from
> via-pmu-backlight.c (errors from bl_curve not being properly defined
> omitted):
>
>    drivers/macintosh/via-pmu-backlight.c:22:20: error: 'FB_BACKLIGHT_LEVELS' undeclared here (not in a function)
>       22 | static u8 bl_curve[FB_BACKLIGHT_LEVELS];
>          |                    ^~~~~~~~~~~~~~~~~~~
>    drivers/macintosh/via-pmu-backlight.c: In function 'pmu_backlight_get_level_brightness':
>    drivers/macintosh/via-pmu-backlight.c:63:38: error: 'FB_BACKLIGHT_MAX' undeclared (first use in this function); did you mean 'BACKLIGHT_RAW'?
>       63 |         pmulevel = bl_curve[level] * FB_BACKLIGHT_MAX / MAX_PMU_LEVEL;
>          |                                      ^~~~~~~~~~~~~~~~
>          |                                      BACKLIGHT_RAW
>    drivers/macintosh/via-pmu-backlight.c: In function 'pmu_backlight_init':
>    drivers/macintosh/via-pmu-backlight.c:144:17: error: implicit declaration of function 'of_machine_is_compatible' [-Wimplicit-function-declaration]
>      144 |                 of_machine_is_compatible("AAPL,3400/2400") ||
>          |                 ^~~~~~~~~~~~~~~~~~~~~~~~
>
> FB_BACKLIGHT_{LEVELS,MAX} are available from the userspace API fb.h so
> just include that avoid dragging in the full fb.h header unnecessarily.
> Include linux/of.h for of_machine_is_compatible().
>
> Fixes: 9f218f9bb9d2 ("backlight: Do not include <linux/fb.h> in header file")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   drivers/macintosh/via-pmu-backlight.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/macintosh/via-pmu-backlight.c b/drivers/macintosh/via-pmu-backlight.c
> index 26bd9ed5e664..f7b7853b3802 100644
> --- a/drivers/macintosh/via-pmu-backlight.c
> +++ b/drivers/macintosh/via-pmu-backlight.c
> @@ -11,7 +11,9 @@
>   #include <asm/ptrace.h>
>   #include <linux/adb.h>
>   #include <linux/backlight.h>
> +#include <linux/of.h>
>   #include <linux/pmu.h>
> +#include <uapi/linux/fb.h>

Should this not be <linux/fb.h> ?

Best regards
Thomas


>   #include <asm/backlight.h>
>   
>   #define MAX_PMU_LEVEL 0xFF
>

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, Werner Knoblich, (HRB 36809, AG Nürnberg)


