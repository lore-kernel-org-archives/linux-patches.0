Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF8A1FB5F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 13:09:52 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E91AC1FD71;
	Tue,  1 Aug 2023 13:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1690895384; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lsa5moaEw3yYrBGKqxNgGv59gqUakEyFOpX7t8BOEks=;
	b=gPOhGG9H3rjEN4F1EisHlpNNC/goGO0c3G0dzPfmNUUPEZG0Qy2FlemX1z7Z7NhYxZUlrp
	53GVfRkfpL7gISvnzFca0NSDuTKE3o9jSxYqENHMDdshD+bO/cSHRXNWNWd0KrNFlfGyLG
	0dTtMIFO6irdcRD1um2kxfRzRmsglug=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1690895384;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lsa5moaEw3yYrBGKqxNgGv59gqUakEyFOpX7t8BOEks=;
	b=XAxXu+Wrjffn+l2uaY0IXmXe6S+BTUuVcQ6YlqmxmrI0//AJpUmb+cMgLqRLKentEyepEv
	H/oIqSPkcPHI9bBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DA780139BD;
	Tue,  1 Aug 2023 13:09:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id TXRMNRgEyWQMPAAAMHmgww
	(envelope-from <jack@suse.cz>); Tue, 01 Aug 2023 13:09:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 72152A076B; Tue,  1 Aug 2023 15:09:44 +0200 (CEST)
Date: Tue, 1 Aug 2023 15:09:44 +0200
From: Jan Kara <jack@suse.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>, Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 047/155] jbd2: remove journal_clean_one_cp_list()
Message-ID: <20230801130944.7e3hhyosweufeuaf@quack3>
References: <20230801091910.165050260@linuxfoundation.org>
 <20230801091911.867814225@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230801091911.867814225@linuxfoundation.org>

On Tue 01-08-23 11:19:19, Greg Kroah-Hartman wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> [ Upstream commit b98dba273a0e47dbfade89c9af73c5b012a4eabb ]
> 
> journal_clean_one_cp_list() and journal_shrink_one_cp_list() are almost
> the same, so merge them into journal_shrink_one_cp_list(), remove the
> nr_to_scan parameter, always scan and try to free the whole checkpoint
> list.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Link: https://lore.kernel.org/r/20230606135928.434610-4-yi.zhang@huaweicloud.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Stable-dep-of: 46f881b5b175 ("jbd2: fix a race when checking checkpoint buffer busy")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This and the following patch (46f881b5b175) have some issues [1] and cause a
performance regression for some workloads and possible metadata corruption
after a crash. So please drop these two patches from the stable trees for
now. We can include them again later once the code has stabilized...
Thanks!

								Honza

[1] https://lore.kernel.org/all/20230714025528.564988-1-yi.zhang@huaweicloud.com


>  fs/jbd2/checkpoint.c        | 75 +++++++++----------------------------
>  include/trace/events/jbd2.h | 12 ++----
>  2 files changed, 21 insertions(+), 66 deletions(-)
> 
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index c1f543e86170a..ab72aeb766a74 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -349,50 +349,10 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
>  
>  /* Checkpoint list management */
>  
> -/*
> - * journal_clean_one_cp_list
> - *
> - * Find all the written-back checkpoint buffers in the given list and
> - * release them. If 'destroy' is set, clean all buffers unconditionally.
> - *
> - * Called with j_list_lock held.
> - * Returns 1 if we freed the transaction, 0 otherwise.
> - */
> -static int journal_clean_one_cp_list(struct journal_head *jh, bool destroy)
> -{
> -	struct journal_head *last_jh;
> -	struct journal_head *next_jh = jh;
> -
> -	if (!jh)
> -		return 0;
> -
> -	last_jh = jh->b_cpprev;
> -	do {
> -		jh = next_jh;
> -		next_jh = jh->b_cpnext;
> -
> -		if (!destroy && __cp_buffer_busy(jh))
> -			return 0;
> -
> -		if (__jbd2_journal_remove_checkpoint(jh))
> -			return 1;
> -		/*
> -		 * This function only frees up some memory
> -		 * if possible so we dont have an obligation
> -		 * to finish processing. Bail out if preemption
> -		 * requested:
> -		 */
> -		if (need_resched())
> -			return 0;
> -	} while (jh != last_jh);
> -
> -	return 0;
> -}
> -
>  /*
>   * journal_shrink_one_cp_list
>   *
> - * Find 'nr_to_scan' written-back checkpoint buffers in the given list
> + * Find all the written-back checkpoint buffers in the given list
>   * and try to release them. If the whole transaction is released, set
>   * the 'released' parameter. Return the number of released checkpointed
>   * buffers.
> @@ -400,15 +360,15 @@ static int journal_clean_one_cp_list(struct journal_head *jh, bool destroy)
>   * Called with j_list_lock held.
>   */
>  static unsigned long journal_shrink_one_cp_list(struct journal_head *jh,
> -						unsigned long *nr_to_scan,
> -						bool *released)
> +						bool destroy, bool *released)
>  {
>  	struct journal_head *last_jh;
>  	struct journal_head *next_jh = jh;
>  	unsigned long nr_freed = 0;
>  	int ret;
>  
> -	if (!jh || *nr_to_scan == 0)
> +	*released = false;
> +	if (!jh)
>  		return 0;
>  
>  	last_jh = jh->b_cpprev;
> @@ -416,8 +376,7 @@ static unsigned long journal_shrink_one_cp_list(struct journal_head *jh,
>  		jh = next_jh;
>  		next_jh = jh->b_cpnext;
>  
> -		(*nr_to_scan)--;
> -		if (__cp_buffer_busy(jh))
> +		if (!destroy && __cp_buffer_busy(jh))
>  			continue;
>  
>  		nr_freed++;
> @@ -429,7 +388,7 @@ static unsigned long journal_shrink_one_cp_list(struct journal_head *jh,
>  
>  		if (need_resched())
>  			break;
> -	} while (jh != last_jh && *nr_to_scan);
> +	} while (jh != last_jh);
>  
>  	return nr_freed;
>  }
> @@ -447,11 +406,11 @@ unsigned long jbd2_journal_shrink_checkpoint_list(journal_t *journal,
>  						  unsigned long *nr_to_scan)
>  {
>  	transaction_t *transaction, *last_transaction, *next_transaction;
> -	bool released;
> +	bool __maybe_unused released;
>  	tid_t first_tid = 0, last_tid = 0, next_tid = 0;
>  	tid_t tid = 0;
>  	unsigned long nr_freed = 0;
> -	unsigned long nr_scanned = *nr_to_scan;
> +	unsigned long freed;
>  
>  again:
>  	spin_lock(&journal->j_list_lock);
> @@ -480,10 +439,11 @@ unsigned long jbd2_journal_shrink_checkpoint_list(journal_t *journal,
>  		transaction = next_transaction;
>  		next_transaction = transaction->t_cpnext;
>  		tid = transaction->t_tid;
> -		released = false;
>  
> -		nr_freed += journal_shrink_one_cp_list(transaction->t_checkpoint_list,
> -						       nr_to_scan, &released);
> +		freed = journal_shrink_one_cp_list(transaction->t_checkpoint_list,
> +						   false, &released);
> +		nr_freed += freed;
> +		(*nr_to_scan) -= min(*nr_to_scan, freed);
>  		if (*nr_to_scan == 0)
>  			break;
>  		if (need_resched() || spin_needbreak(&journal->j_list_lock))
> @@ -504,9 +464,8 @@ unsigned long jbd2_journal_shrink_checkpoint_list(journal_t *journal,
>  	if (*nr_to_scan && next_tid)
>  		goto again;
>  out:
> -	nr_scanned -= *nr_to_scan;
>  	trace_jbd2_shrink_checkpoint_list(journal, first_tid, tid, last_tid,
> -					  nr_freed, nr_scanned, next_tid);
> +					  nr_freed, next_tid);
>  
>  	return nr_freed;
>  }
> @@ -522,7 +481,7 @@ unsigned long jbd2_journal_shrink_checkpoint_list(journal_t *journal,
>  void __jbd2_journal_clean_checkpoint_list(journal_t *journal, bool destroy)
>  {
>  	transaction_t *transaction, *last_transaction, *next_transaction;
> -	int ret;
> +	bool released;
>  
>  	transaction = journal->j_checkpoint_transactions;
>  	if (!transaction)
> @@ -533,8 +492,8 @@ void __jbd2_journal_clean_checkpoint_list(journal_t *journal, bool destroy)
>  	do {
>  		transaction = next_transaction;
>  		next_transaction = transaction->t_cpnext;
> -		ret = journal_clean_one_cp_list(transaction->t_checkpoint_list,
> -						destroy);
> +		journal_shrink_one_cp_list(transaction->t_checkpoint_list,
> +					   destroy, &released);
>  		/*
>  		 * This function only frees up some memory if possible so we
>  		 * dont have an obligation to finish processing. Bail out if
> @@ -547,7 +506,7 @@ void __jbd2_journal_clean_checkpoint_list(journal_t *journal, bool destroy)
>  		 * avoids pointless scanning of transactions which still
>  		 * weren't checkpointed.
>  		 */
> -		if (!ret)
> +		if (!released)
>  			return;
>  	} while (transaction != last_transaction);
>  }
> diff --git a/include/trace/events/jbd2.h b/include/trace/events/jbd2.h
> index 29414288ea3e0..34ce197bd76e0 100644
> --- a/include/trace/events/jbd2.h
> +++ b/include/trace/events/jbd2.h
> @@ -462,11 +462,9 @@ TRACE_EVENT(jbd2_shrink_scan_exit,
>  TRACE_EVENT(jbd2_shrink_checkpoint_list,
>  
>  	TP_PROTO(journal_t *journal, tid_t first_tid, tid_t tid, tid_t last_tid,
> -		 unsigned long nr_freed, unsigned long nr_scanned,
> -		 tid_t next_tid),
> +		 unsigned long nr_freed, tid_t next_tid),
>  
> -	TP_ARGS(journal, first_tid, tid, last_tid, nr_freed,
> -		nr_scanned, next_tid),
> +	TP_ARGS(journal, first_tid, tid, last_tid, nr_freed, next_tid),
>  
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
> @@ -474,7 +472,6 @@ TRACE_EVENT(jbd2_shrink_checkpoint_list,
>  		__field(tid_t, tid)
>  		__field(tid_t, last_tid)
>  		__field(unsigned long, nr_freed)
> -		__field(unsigned long, nr_scanned)
>  		__field(tid_t, next_tid)
>  	),
>  
> @@ -484,15 +481,14 @@ TRACE_EVENT(jbd2_shrink_checkpoint_list,
>  		__entry->tid		= tid;
>  		__entry->last_tid	= last_tid;
>  		__entry->nr_freed	= nr_freed;
> -		__entry->nr_scanned	= nr_scanned;
>  		__entry->next_tid	= next_tid;
>  	),
>  
>  	TP_printk("dev %d,%d shrink transaction %u-%u(%u) freed %lu "
> -		  "scanned %lu next transaction %u",
> +		  "next transaction %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->first_tid, __entry->tid, __entry->last_tid,
> -		  __entry->nr_freed, __entry->nr_scanned, __entry->next_tid)
> +		  __entry->nr_freed, __entry->next_tid)
>  );
>  
>  #endif /* _TRACE_JBD2_H */
> -- 
> 2.39.2
> 
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
