Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30F71CE094
	for <patches@lists.linux.dev>; Tue,  2 Jul 2024 21:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719955128; cv=none; b=jF4VN+0Qy5AreAR58fJggTCrucjbbTRbeChsDxMdX/9ffc4mczO443iD+1YVwQZWCgvEHt06LXKoeW43kMju4unYSvDNx5kbtq3zeCnOyLYx6tbc2I7afSyRGnty+YtGtU7F6HcPo9RXIosw6TTT8/rI/NY12UO4SR5Gvn9wQZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719955128; c=relaxed/simple;
	bh=H9Xq8CCPy6WivfUhmK10V6Uv964SBWArMo0hkOgZmWQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WmkPN1nenaoP3Xr12uD7rP9cN5OuaARRW062d2e3SWrAr1wB9DqQ5Jz/jw5Asgqbw63URZjLALzj5oFknCj0Gkt+K9L61q0E+z/wPdGthWjEb2SawzJhZrxSgSxodAYP06iLnybLV7i3iQfhoTPOzzoo7dAnXJemCwoLg1RoZs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ocqWw2Fc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pmi3Ix8l; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ocqWw2Fc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pmi3Ix8l; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ocqWw2Fc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pmi3Ix8l";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ocqWw2Fc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pmi3Ix8l"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 04C2221B89;
	Tue,  2 Jul 2024 21:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1719955117; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ymb8ALAHiyv9SRqovt2WyJNVuPEpG3F2/MZmgfbYbrA=;
	b=ocqWw2Fc0WgSXPhJRrct++NZ2DMDpJZDsmRtDTw+Prj0ZHy3VIlyR3QZvZv94ou3yEZxZL
	nzwVe0ulosQPS2Q2VCf9bumGzjLNXuIgLqSH9rd/97OEO866s2377U3HR/8xqPX7BzfaHX
	FQrNyu73+5gy2AzJyVGqaCLv3qU2a2k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1719955117;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ymb8ALAHiyv9SRqovt2WyJNVuPEpG3F2/MZmgfbYbrA=;
	b=pmi3Ix8lvq3X+9pEHdPoXfdBOXiTFjI+NKEI2v1b/Ut9BtrQ5I313Yl4ysrzjuJbPbx1lO
	n5I3oXJTCbcTylAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ocqWw2Fc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pmi3Ix8l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1719955117; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ymb8ALAHiyv9SRqovt2WyJNVuPEpG3F2/MZmgfbYbrA=;
	b=ocqWw2Fc0WgSXPhJRrct++NZ2DMDpJZDsmRtDTw+Prj0ZHy3VIlyR3QZvZv94ou3yEZxZL
	nzwVe0ulosQPS2Q2VCf9bumGzjLNXuIgLqSH9rd/97OEO866s2377U3HR/8xqPX7BzfaHX
	FQrNyu73+5gy2AzJyVGqaCLv3qU2a2k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1719955117;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ymb8ALAHiyv9SRqovt2WyJNVuPEpG3F2/MZmgfbYbrA=;
	b=pmi3Ix8lvq3X+9pEHdPoXfdBOXiTFjI+NKEI2v1b/Ut9BtrQ5I313Yl4ysrzjuJbPbx1lO
	n5I3oXJTCbcTylAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DECA41395F;
	Tue,  2 Jul 2024 21:18:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EKoGNqxuhGauCgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 02 Jul 2024 21:18:36 +0000
Message-ID: <c8061293-8457-4d2b-85c2-7c631c00245a@suse.cz>
Date: Tue, 2 Jul 2024 23:18:36 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm, slab: extend kmalloc() alignment for non power-of-two
 sizes
Content-Language: en-US
To: Alice Ryhl <aliceryhl@google.com>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
 Christoph Lameter <cl@linux.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Kees Cook
 <keescook@chromium.org>, Boqun Feng <boqun.feng@gmail.com>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20240702155800.166503-2-vbabka@suse.cz>
 <CAH5fLgj=uOktnNCEm+npBh8LLbYUEO8uO30YUBsLS-iK+BKQJQ@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <CAH5fLgj=uOktnNCEm+npBh8LLbYUEO8uO30YUBsLS-iK+BKQJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kvack.org,google.com,linux.com,gmail.com,linux.dev,chromium.org,vger.kernel.org,lists.linux.dev];
	RCPT_COUNT_SEVEN(0.00)[11];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	DKIM_TRACE(0.00)[suse.cz:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 04C2221B89
X-Spam-Flag: NO
X-Spam-Score: -3.00
X-Spam-Level: 

On 7/2/24 6:40 PM, Alice Ryhl wrote:
> On Tue, Jul 2, 2024 at 5:58 PM Vlastimil Babka <vbabka@suse.cz> wrote:
> Thanks!
> 
> Since this change is motivated by Rust, why not also include the Rust
> change in this patch? You would need to remove the if inside
> krealloc_aligned in rust/kernel/alloc/allocator.rs and update the
> comments.

Right, thanks. Does this look ok? (not tested as I don't have the
environment working)

diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocator.rs
index 229642960cd1..c619acb8b285 100644
--- a/rust/kernel/alloc/allocator.rs
+++ b/rust/kernel/alloc/allocator.rs
@@ -18,23 +18,16 @@ pub(crate) unsafe fn krealloc_aligned(ptr: *mut u8, new_layout: Layout, flags: F
     // Customized layouts from `Layout::from_size_align()` can have size < align, so pad first.
     let layout = new_layout.pad_to_align();
 
+    // Note that `layout.size()` (after padding) is guaranteed to be a multiple of `layout.align()`
+    // which together with the slab guarantee means the `krealloc` will return a properly aligned
+    // object (see comments in `kmalloc()` for more information).
     let mut size = layout.size();
 
-    if layout.align() > bindings::ARCH_SLAB_MINALIGN {
-        // The alignment requirement exceeds the slab guarantee, thus try to enlarge the size
-        // to use the "power-of-two" size/alignment guarantee (see comments in `kmalloc()` for
-        // more information).
-        //
-        // Note that `layout.size()` (after padding) is guaranteed to be a multiple of
-        // `layout.align()`, so `next_power_of_two` gives enough alignment guarantee.
-        size = size.next_power_of_two();
-    }
-
     // SAFETY:
     // - `ptr` is either null or a pointer returned from a previous `k{re}alloc()` by the
     //   function safety requirement.
     // - `size` is greater than 0 since it's either a `layout.size()` (which cannot be zero
-    //   according to the function safety requirement) or a result from `next_power_of_two()`.
+    //   according to the function safety requirement)
     unsafe { bindings::krealloc(ptr as *const core::ffi::c_void, size, flags.0) as *mut u8 }
 }
 

