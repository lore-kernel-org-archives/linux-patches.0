Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8B92EA485
	for <patches@lists.linux.dev>; Tue, 15 Jul 2025 13:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586491; cv=none; b=HM2lMWHSKqMvYNf4q9ngh7anoWe0cwMgzU9/SRjKF+Xp0Q1U2opcI84I2lpKI/vzDYYV85zk6Ctj1+4T/nUJtCYGRJb15Om2jxQISmU32kuXhKqMOy8QzJ/dKwxzN5yy+u7HcNV3gVD1vuUiKsH+pOZs4RWOtUOm7SJuil/4fzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586491; c=relaxed/simple;
	bh=iUpd48ECBkPiuyct/vZAJK9F0N4rajDwyoaH0Ude+y4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eXfB+m7lzjkj61UDijoumQbRIccQueYd0ezROi6UoCv8ZkckeYiXAfKdSuM58DPy0GQPi6hs5eMcMoSu7urdqA7QL75QQpBOsM8zLIQSRVnpBrKwc1C3XywVji+RYWwp6/sUbquwWfaq/52akW3xBdpWy2ZDu6wXbeqmCy1yl2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=svVzzuDw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=sX8V6H/k; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=svVzzuDw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=sX8V6H/k; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="svVzzuDw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sX8V6H/k";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="svVzzuDw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sX8V6H/k"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0D6B52118D;
	Tue, 15 Jul 2025 13:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1752586487; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XqOtuf8jgkW+eNB0tNQckGjSSiVTpxjV2xNoI2fidTw=;
	b=svVzzuDwvy1DIlpynk7UN8tMdjYXqfoG+VcnNWoimpln0xMmHHNPWr23EeyXAKnMoB3mnS
	hyIZ8TOczRcUFzZ0bhvaNcMmAiBb1Aeadx9QsE8s1SHUOLm40PiW6/HURq/N/CaMBnsYWM
	vhQOyPIFxgVoHJqnn8BLtlTy6VGWTaM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1752586487;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XqOtuf8jgkW+eNB0tNQckGjSSiVTpxjV2xNoI2fidTw=;
	b=sX8V6H/kl9k3v21STL6Em8JDgNt7wZSm7K9CyEQm4vzT4CWnYQpwpW4X1Yh992K5djN1Vo
	Re5/19/Ie4zWLMDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=svVzzuDw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="sX8V6H/k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1752586487; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XqOtuf8jgkW+eNB0tNQckGjSSiVTpxjV2xNoI2fidTw=;
	b=svVzzuDwvy1DIlpynk7UN8tMdjYXqfoG+VcnNWoimpln0xMmHHNPWr23EeyXAKnMoB3mnS
	hyIZ8TOczRcUFzZ0bhvaNcMmAiBb1Aeadx9QsE8s1SHUOLm40PiW6/HURq/N/CaMBnsYWM
	vhQOyPIFxgVoHJqnn8BLtlTy6VGWTaM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1752586487;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XqOtuf8jgkW+eNB0tNQckGjSSiVTpxjV2xNoI2fidTw=;
	b=sX8V6H/kl9k3v21STL6Em8JDgNt7wZSm7K9CyEQm4vzT4CWnYQpwpW4X1Yh992K5djN1Vo
	Re5/19/Ie4zWLMDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6D1D813A68;
	Tue, 15 Jul 2025 13:34:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VhQbFfZYdmjvOAAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Tue, 15 Jul 2025 13:34:46 +0000
Message-ID: <532e8c1e-e294-427a-a276-87b34a4a5022@suse.de>
Date: Tue, 15 Jul 2025 15:34:45 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 077/163] drm/gem: Fix race in
 drm_gem_handle_create_tail()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
 Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Simona Vetter <simona.vetter@intel.com>,
 Simona Vetter <simona.vetter@ffwll.ch>
References: <20250715130808.777350091@linuxfoundation.org>
 <20250715130811.825064108@linuxfoundation.org>
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
In-Reply-To: <20250715130811.825064108@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 0D6B52118D
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[lists.linux.dev,linux.intel.com,kernel.org,gmail.com,ffwll.ch,intel.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linuxfoundation.org:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,ffwll.ch:email,intel.com:email,suse.de:dkim,suse.de:mid,suse.de:email]
X-Spam-Score: -4.51

  Hi

Am 15.07.25 um 15:12 schrieb Greg Kroah-Hartman:
> 6.12-stable review patch.  If anyone has any objections, please let me know.

Might not be worth it. We're discussing a rework of this patch if not an 
outright revert. And you wont see the error in 6.12 if you haven't also 
backported 1a148af06000 ("drm/gem-shmem: Use dma_buf from GEM object 
instance").

If you take the patch, you should also take commit f6bfc9afc751 
("drm/framebuffer: Acquire internal references on GEM handles").

Best regards
Thomas

> ------------------
>
> From: Simona Vetter <simona.vetter@ffwll.ch>
>
> commit bd46cece51a36ef088f22ef0416ac13b0a46d5b0 upstream.
>
> Object creation is a careful dance where we must guarantee that the
> object is fully constructed before it is visible to other threads, and
> GEM buffer objects are no difference.
>
> Final publishing happens by calling drm_gem_handle_create(). After
> that the only allowed thing to do is call drm_gem_object_put() because
> a concurrent call to the GEM_CLOSE ioctl with a correctly guessed id
> (which is trivial since we have a linear allocator) can already tear
> down the object again.
>
> Luckily most drivers get this right, the very few exceptions I've
> pinged the relevant maintainers for. Unfortunately we also need
> drm_gem_handle_create() when creating additional handles for an
> already existing object (e.g. GETFB ioctl or the various bo import
> ioctl), and hence we cannot have a drm_gem_handle_create_and_put() as
> the only exported function to stop these issues from happening.
>
> Now unfortunately the implementation of drm_gem_handle_create() isn't
> living up to standards: It does correctly finishe object
> initialization at the global level, and hence is safe against a
> concurrent tear down. But it also sets up the file-private aspects of
> the handle, and that part goes wrong: We fully register the object in
> the drm_file.object_idr before calling drm_vma_node_allow() or
> obj->funcs->open, which opens up races against concurrent removal of
> that handle in drm_gem_handle_delete().
>
> Fix this with the usual two-stage approach of first reserving the
> handle id, and then only registering the object after we've completed
> the file-private setup.
>
> Jacek reported this with a testcase of concurrently calling GEM_CLOSE
> on a freshly-created object (which also destroys the object), but it
> should be possible to hit this with just additional handles created
> through import or GETFB without completed destroying the underlying
> object with the concurrent GEM_CLOSE ioctl calls.
>
> Note that the close-side of this race was fixed in f6cd7daecff5 ("drm:
> Release driver references to handle before making it available
> again"), which means a cool 9 years have passed until someone noticed
> that we need to make this symmetry or there's still gaps left :-/
> Without the 2-stage close approach we'd still have a race, therefore
> that's an integral part of this bugfix.
>
> More importantly, this means we can have NULL pointers behind
> allocated id in our drm_file.object_idr. We need to check for that
> now:
>
> - drm_gem_handle_delete() checks for ERR_OR_NULL already
>
> - drm_gem.c:object_lookup() also chekcs for NULL
>
> - drm_gem_release() should never be called if there's another thread
>    still existing that could call into an IOCTL that creates a new
>    handle, so cannot race. For paranoia I added a NULL check to
>    drm_gem_object_release_handle() though.
>
> - most drivers (etnaviv, i915, msm) are find because they use
>    idr_find(), which maps both ENOENT and NULL to NULL.
>
> - drivers using idr_for_each_entry() should also be fine, because
>    idr_get_next does filter out NULL entries and continues the
>    iteration.
>
> - The same holds for drm_show_memory_stats().
>
> v2: Use drm_WARN_ON (Thomas)
>
> Reported-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
> Tested-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
> Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: stable@vger.kernel.org
> Cc: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Signed-off-by: Simona Vetter <simona.vetter@intel.com>
> Signed-off-by: Simona Vetter <simona.vetter@ffwll.ch>
> Link: https://patchwork.freedesktop.org/patch/msgid/20250707151814.603897-1-simona.vetter@ffwll.ch
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/gpu/drm/drm_gem.c |   10 +++++++++-
>   include/drm/drm_file.h    |    3 +++
>   2 files changed, 12 insertions(+), 1 deletion(-)
>
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -289,6 +289,9 @@ drm_gem_object_release_handle(int id, vo
>   	struct drm_file *file_priv = data;
>   	struct drm_gem_object *obj = ptr;
>   
> +	if (drm_WARN_ON(obj->dev, !data))
> +		return 0;
> +
>   	if (obj->funcs->close)
>   		obj->funcs->close(obj, file_priv);
>   
> @@ -409,7 +412,7 @@ drm_gem_handle_create_tail(struct drm_fi
>   	idr_preload(GFP_KERNEL);
>   	spin_lock(&file_priv->table_lock);
>   
> -	ret = idr_alloc(&file_priv->object_idr, obj, 1, 0, GFP_NOWAIT);
> +	ret = idr_alloc(&file_priv->object_idr, NULL, 1, 0, GFP_NOWAIT);
>   
>   	spin_unlock(&file_priv->table_lock);
>   	idr_preload_end();
> @@ -430,6 +433,11 @@ drm_gem_handle_create_tail(struct drm_fi
>   			goto err_revoke;
>   	}
>   
> +	/* mirrors drm_gem_handle_delete to avoid races */
> +	spin_lock(&file_priv->table_lock);
> +	obj = idr_replace(&file_priv->object_idr, obj, handle);
> +	WARN_ON(obj != NULL);
> +	spin_unlock(&file_priv->table_lock);
>   	*handlep = handle;
>   	return 0;
>   
> --- a/include/drm/drm_file.h
> +++ b/include/drm/drm_file.h
> @@ -300,6 +300,9 @@ struct drm_file {
>   	 *
>   	 * Mapping of mm object handles to object pointers. Used by the GEM
>   	 * subsystem. Protected by @table_lock.
> +	 *
> +	 * Note that allocated entries might be NULL as a transient state when
> +	 * creating or deleting a handle.
>   	 */
>   	struct idr object_idr;
>   
>
>

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstrasse 146, 90461 Nuernberg, Germany
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Boudien Moerman
HRB 36809 (AG Nuernberg)

