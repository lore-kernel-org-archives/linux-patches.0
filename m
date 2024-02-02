Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912DB7A730
	for <patches@lists.linux.dev>; Fri,  2 Feb 2024 09:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706867067; cv=none; b=kZbJ++X3n9+puxSiiXTTkIF92Z87nGKu0bcYPf/srL8iL4oY2iKcXOp/l+wCjemQwytR870QCTPfKJUW1GdFZWz+i4iR+LWlQBvkjgt/24ShwmhdkkarzsVdwJEqg0U3GsEuxEOb1TDIovKRk2byByra5zL6Emsi1gD5REXjA7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706867067; c=relaxed/simple;
	bh=4C8yqLscGbnAQyCnhdY9F5UwJGAkB5x3ituB1Bf3L2E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NxOO8nvwFs9SPJF+I0fQ5jEK2K6PWhzJuNZLYwTAxJjoxqWrJ6Ibn0mAD0Fj5kZEGMLRZVkrX2I+OtmqMUQ69HUTCvu9yaBoI/SrhS4PZjo7nNSYUvwJ3InIoOGOPtgGjwhkFLdkBeOkEscQeJqo4UG08QYLDejJcxf5JqnI21o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yBEWQn9u; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=asDjMhw8; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yBEWQn9u; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=asDjMhw8; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yBEWQn9u";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="asDjMhw8";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yBEWQn9u";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="asDjMhw8"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B767821FAD;
	Fri,  2 Feb 2024 09:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1706867063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zxuuVTjvjojBTHSuuoDaHXOL2DhktOJPf+obkrpgaKs=;
	b=yBEWQn9uzBmsz8nlDjKCm0lVFki6nKxPbpu4hw8D0kYfd+75y9KdX7d1EINvWY627cmllR
	baVQv2fsgpC3XC4ttYvBWp04BOrEWDgrXJ2l/deoIUsjHRQH6MHqwA1/A10bbS/FrPoH3s
	R3iiqQZaMYZJUL5+APdHdTSuYYkDHxw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1706867063;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zxuuVTjvjojBTHSuuoDaHXOL2DhktOJPf+obkrpgaKs=;
	b=asDjMhw8aGemrx8uxVHngkufrYNMacy4psLvXVT5C2JIU/rrvNYiJq6/Lamqh3daVsX/mb
	Dcqx2Ll2rQt5y5BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1706867063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zxuuVTjvjojBTHSuuoDaHXOL2DhktOJPf+obkrpgaKs=;
	b=yBEWQn9uzBmsz8nlDjKCm0lVFki6nKxPbpu4hw8D0kYfd+75y9KdX7d1EINvWY627cmllR
	baVQv2fsgpC3XC4ttYvBWp04BOrEWDgrXJ2l/deoIUsjHRQH6MHqwA1/A10bbS/FrPoH3s
	R3iiqQZaMYZJUL5+APdHdTSuYYkDHxw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1706867063;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zxuuVTjvjojBTHSuuoDaHXOL2DhktOJPf+obkrpgaKs=;
	b=asDjMhw8aGemrx8uxVHngkufrYNMacy4psLvXVT5C2JIU/rrvNYiJq6/Lamqh3daVsX/mb
	Dcqx2Ll2rQt5y5BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9926B139AB;
	Fri,  2 Feb 2024 09:44:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HiMoJXe5vGVPUgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 02 Feb 2024 09:44:23 +0000
Message-ID: <7d963e3f-2677-4459-b60e-2590d6cddc79@suse.cz>
Date: Fri, 2 Feb 2024 10:44:29 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.7 125/346] mm/sparsemem: fix race in accessing
 memory_section->usage
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jiri Slaby <jirislaby@kernel.org>, Marco Elver <elver@google.com>,
 Alexander Potapenko <glider@google.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Charan Teja Kalla <quic_charante@quicinc.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
 Dan Williams <dan.j.williams@intel.com>, David Hildenbrand
 <david@redhat.com>, Mel Gorman <mgorman@techsingularity.net>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
 <20240129170020.057681007@linuxfoundation.org>
 <81752462-c6c7-4a65-b9f2-371573e15499@kernel.org>
 <2024013044-snowiness-abreast-2a47@gregkh>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <2024013044-snowiness-abreast-2a47@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yBEWQn9u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=asDjMhw8
X-Spamd-Result: default: False [-0.77 / 50.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 TO_DN_SOME(0.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_TRACE(0.00)[suse.cz:+];
	 MX_GOOD(-0.01)[];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_MATCH_FROM(0.00)[];
	 BAYES_HAM(-0.47)[79.21%];
	 ARC_NA(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 FROM_HAS_DN(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 RCPT_COUNT_TWELVE(0.00)[13];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 RCVD_TLS_ALL(0.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: -0.77
X-Rspamd-Queue-Id: B767821FAD
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Bar: /



On 1/30/24 17:21, Greg Kroah-Hartman wrote:
> On Tue, Jan 30, 2024 at 07:00:36AM +0100, Jiri Slaby wrote:
>> On 29. 01. 24, 18:02, Greg Kroah-Hartman wrote:
>>> 6.7-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Charan Teja Kalla <quic_charante@quicinc.com>
>>>
>>> commit 5ec8e8ea8b7783fab150cf86404fc38cb4db8800 upstream.
>>
>> Hi,
>>
>> our machinery (git-fixes) says, this is needed as a fix:
>> commit f6564fce256a3944aa1bc76cb3c40e792d97c1eb
>> Author: Marco Elver <elver@google.com>
>> Date:   Thu Jan 18 11:59:14 2024 +0100
>>
>>     mm, kmsan: fix infinite recursion due to RCU critical section
>>
>>
>> Leaving up to the recipients to decide, as I have no idea…

Let's Cc the people involved in f6564fce256a394

> That commit just got merged into Linus's tree, AND it is not marked for
> stable, which is worrying as I have to get the developers's approval to
> add any non-cc-stable mm patch to the tree because they said they would
> always mark them properly :)
> 
> So I can't take it just yet...
> 
> thanks,
> 
> greg k-h
