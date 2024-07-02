Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9F3201260
	for <patches@lists.linux.dev>; Tue,  2 Jul 2024 21:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719955217; cv=none; b=mwnUPEQStEE1kNGkOphzAnzGVkSvH4kZFnwFUPxnF8sefwpALkJapUmDncn8TBk00b0rbImt8GCyuuDGVkKDEaiyiwe9g3JHuNx+8OyuOPl4NVMNR7FEvawWB4XeK0Qdhj/T53PZ+18JTkITSZE483018/IJWHgVZSSCd6655lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719955217; c=relaxed/simple;
	bh=CeT3SBUb+MSYc8i507anLMR58tBWbydhhxCPeXPL2PA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YOtbmctxtCEKAh07kJ8ectujlKY4OR9wm0oUjyGBM7p11SywGbMYHkI0cr+QXOUecwf1Nequ0cLG0qlt5IJNbb20iCKGeJvR4o+Vnq4+cj34hW3hXZAwp5LDu4fMxdvUfhp0it25XffwEoAvtXOcZJQkAuSbijQ+E0zeToS9FnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=znuU7Auu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9hvdvqlo; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=znuU7Auu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9hvdvqlo; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="znuU7Auu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9hvdvqlo";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="znuU7Auu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9hvdvqlo"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 26CE41FBDD;
	Tue,  2 Jul 2024 21:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1719955213; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8hcmh5ZZotEcmUXMdIiHVUXAF3W0dTMFNs3reEpg/Mg=;
	b=znuU7AuudWUhAdDFZ4iV8ETPKUi0+wXxGufJ4SdV3VFnEKZ1tfZcX8d445HRaWifgZZ3Vs
	n0B3W021vdVYOp3qA6brwK07TQp8pDc01EOMJE7Vm5dOD9Zl9lBbfurswSw4Ddx5P+Ijw+
	bzDl+CEHg6+Fu3B96ImMTZkbwgHnpsY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1719955213;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8hcmh5ZZotEcmUXMdIiHVUXAF3W0dTMFNs3reEpg/Mg=;
	b=9hvdvqloiB4asGjlHSwST6A/nGV4qVkjVrLxCiNI4/Xtt8tGWU18AnVdirpjP5431V3atR
	GIaY4AQMWz1dGWDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1719955213; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8hcmh5ZZotEcmUXMdIiHVUXAF3W0dTMFNs3reEpg/Mg=;
	b=znuU7AuudWUhAdDFZ4iV8ETPKUi0+wXxGufJ4SdV3VFnEKZ1tfZcX8d445HRaWifgZZ3Vs
	n0B3W021vdVYOp3qA6brwK07TQp8pDc01EOMJE7Vm5dOD9Zl9lBbfurswSw4Ddx5P+Ijw+
	bzDl+CEHg6+Fu3B96ImMTZkbwgHnpsY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1719955213;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8hcmh5ZZotEcmUXMdIiHVUXAF3W0dTMFNs3reEpg/Mg=;
	b=9hvdvqloiB4asGjlHSwST6A/nGV4qVkjVrLxCiNI4/Xtt8tGWU18AnVdirpjP5431V3atR
	GIaY4AQMWz1dGWDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0CE4A1395F;
	Tue,  2 Jul 2024 21:20:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ATBDAg1vhGYbCwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 02 Jul 2024 21:20:13 +0000
Message-ID: <627741f3-dd28-45b3-ada9-1efeac66351e@suse.cz>
Date: Tue, 2 Jul 2024 23:20:12 +0200
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
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
 Christoph Lameter <cl@linux.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Kees Cook <keescook@chromium.org>, Alice Ryhl <aliceryhl@google.com>,
 Boqun Feng <boqun.feng@gmail.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20240702155800.166503-2-vbabka@suse.cz>
 <ZoRVbdCxrBwmDF2s@google.com> <1ca7b081-c1f0-45a3-b901-39c503368f43@suse.cz>
 <ZoRtXgf7g5TU6HSz@google.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <ZoRtXgf7g5TU6HSz@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Score: -2.79
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.79 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_TLS_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kvack.org,google.com,linux.com,gmail.com,chromium.org,vger.kernel.org,lists.linux.dev];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]

On 7/2/24 11:13 PM, Roman Gushchin wrote:
> On Tue, Jul 02, 2024 at 10:25:44PM +0200, Vlastimil Babka wrote:
>> On 7/2/24 9:30 PM, Roman Gushchin wrote:
>> > On Tue, Jul 02, 2024 at 05:58:01PM +0200, Vlastimil Babka wrote:
>> > Hello Vlastimil,
>> > 
>> > the idea and the implementation makes total sense to me.
>> > 
>> > Do you have an estimate for the memory overhead it will typically introduce?
>> 
>> There's no new overhead for the non-debug case as the layout already
>> naturally has the same alignment as is now guaranteed. Debug has its own
>> overhead so it's enabled only when needed, and this will not add much more.
> 
> Got it, but can you, please, add this note with some explanation why it's true
> to the commit message? Because it's not obvious and the commit message makes

It's there but later:

1) doesn't change the current slab layout (and thus does not increase
   internal fragmentation) when slab debugging is not active

> almost the opposite impression:
>     Slab allocators have been guaranteeing natural alignment for
>     power-of-two sizes <...>, while any other sizes are
>     aligned only to ARCH_KMALLOC_MINALIGN bytes.
> 
> Should it be "guaranteed to be aligned" vs are actually aligned?

Yes that's the case. Will update.

>> 
>> > I don't think it will be too large though and actually can be compensated
>> > by potential performance gains due to a better memory alignment. What do you
>> > think?
>> 
>> Yeah but again, the difference would be only in the debug case and
>> performance gains there are not so interesting :)
> 
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!

> Thanks!

