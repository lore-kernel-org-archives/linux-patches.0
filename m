Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F12B4A84
	for <patches@lists.linux.dev>; Thu, 17 Mar 2022 18:53:16 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3EE5C1F38E;
	Thu, 17 Mar 2022 18:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1647543194; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sg6FmafrPdR1KtYNg/JwS0y/weg8uwWLi0b4wB9DaB8=;
	b=CW+6aHqwJGO16ayz+hSnPGa0OPbIHWsUKut3I4UlP3B9++g8YafKAZteQjBFUdF6bEJfoH
	hpy6Ebcd2p94U4iCH9Lc1apwE77b13nAy1ZvtBdnmBxqwOdyTaVCwhE1JXtYPQ4Uq7QOy7
	s1DPlV+jNFXxC91mvrPiXyLcTnNioUY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1647543194;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sg6FmafrPdR1KtYNg/JwS0y/weg8uwWLi0b4wB9DaB8=;
	b=o8CjYA0ITGwkIvMJKFrEfzWkeowZgmhKOTbhiqLw0rKG8pL+AQyrQ9lPQ17fvlbiiikol3
	lPAUcMEz8wfNLADQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0DB7A13BB5;
	Thu, 17 Mar 2022 18:53:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id G5OlApqDM2IkKwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Thu, 17 Mar 2022 18:53:14 +0000
Message-ID: <34856139-e2db-4d34-07b5-c0af2bdf44f4@suse.cz>
Date: Thu, 17 Mar 2022 19:53:13 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v2 1/4] [PATCH 1/4] mm: refactor of vma_merge()
Content-Language: en-US
To: =?UTF-8?Q?Jakub_Mat=c4=9bna?= <matenajakub@gmail.com>, linux-mm@kvack.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, mhocko@kernel.org,
 mgorman@techsingularity.net, willy@infradead.org, liam.howlett@oracle.com,
 hughd@google.com, kirill@shutemov.name, riel@surriel.com,
 rostedt@goodmis.org, peterz@infradead.org
References: <20220311174602.288010-1-matenajakub@gmail.com>
 <20220311174602.288010-2-matenajakub@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20220311174602.288010-2-matenajakub@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/11/22 18:45, Jakub Matěna wrote:
> Refactor vma_merge() to make it shorter, more understandable and
> suitable for tracing of successful merges that are made possible by
> following patches in the series. Main change is the elimination of code
> duplicity in the case of merge next check. This is done by first doing
> checks and caching the results before executing the merge itself. Exit
> paths are also unified.
> 
> Signed-off-by: Jakub Matěna <matenajakub@gmail.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

It's a nice cleanup on its own. Removed duplication and reduced indentation
levels helps.
