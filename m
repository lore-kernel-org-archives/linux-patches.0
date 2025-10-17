Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E19369992
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 15:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715178; cv=none; b=t6sjq9w94nWCy4HkaGO6Cil9kzMc94nqXu8Rgtk0y92yTXOhMFOiEb0nOvw5pCrnBJh5RkfaPywiM/KtWmUh5BwvEB46tiq4FsakNAqXMBQ2WZKDWnzM0AAtXiNtG/9P1c8LCpUUQCk443zkSmNgXXqd34kem/YiV/UcMCFL6DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715178; c=relaxed/simple;
	bh=vlFINlIUzr71IDawQwgT8J2QIKrP0fq+2EouGnnCeyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rZhmakFLCN3C624vafjGpdOApx5V4Cy6Tob9m/BQZkksKBqqMN2fAcpTtSOM1VJVdjIZd7bFor33NLrnQuBhYzW6LmjP4uB6O4DCIGfoiXpfLTJ+zrYdvT3BFhdIk/n+ASxDYOg76kof7EBtBSwJuWfj1nkNnv89Rs2Xz6/Kx1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UFIwcReI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UFIwcReI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760715176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iaSrld+WRHrdjqVerkRIoqC2NMjppi7RtHUE+pf7glI=;
	b=UFIwcReId4QmcYeR79W0leXBLpuq9Hsa9ThxXVygc1JmvF+hrKgg7+BwOiQUfUPnfs/buu
	Zeu0AVfQvkQ++y+VoQ10AVOLKc5gl0rU8DBvsvBdKRj43kVjIIj1GQsjm1gnorfLM/GJI6
	1b05PC6Yv8p0pQFCYjScR9CledKsNdM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-507-99HP3pS4PQ6OTriM-B6SjA-1; Fri,
 17 Oct 2025 11:32:52 -0400
X-MC-Unique: 99HP3pS4PQ6OTriM-B6SjA-1
X-Mimecast-MFC-AGG-ID: 99HP3pS4PQ6OTriM-B6SjA_1760715170
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 10A181808985;
	Fri, 17 Oct 2025 15:32:50 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.44.33.241])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 84E841800353;
	Fri, 17 Oct 2025 15:32:47 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Fri, 17 Oct 2025 17:31:30 +0200 (CEST)
Date: Fri, 17 Oct 2025 17:31:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	=?utf-8?B?6auY57+U?= <gaoxiang17@xiaomi.com>
Subject: Re: [PATCH 6.1 163/168] pid: make __task_pid_nr_ns(ns => NULL) safe
 for zombie callers
Message-ID: <20251017153126.GD21102@redhat.com>
References: <20251017145129.000176255@linuxfoundation.org>
 <20251017145135.053471068@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251017145135.053471068@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 10/17, Greg Kroah-Hartman wrote:
>
> 6.1-stable review patch.  If anyone has any objections, please let me know.

Well, I don't think this is a -stable material...

This patch tried to make the usage of __task_pid_nr_ns() more simple/safe,
but I don't think we have the problematic users right now.

And please see

	[PATCH 1/2] Revert "pid: make __task_pid_nr_ns(ns => NULL) safe for zombie callers"
	https://lore.kernel.org/all/20251015123613.GA9456@redhat.com/

because we have another commit 006568ab4c5c ("pid: Add a judgment for ns null in pid_nr_ns").
Which too (imo) is not for -stable. The panic fixed by this patch was caused
by the out-of-tree and buggy code.

Oleg.

> ------------------
> 
> From: Oleg Nesterov <oleg@redhat.com>
> 
> [ Upstream commit abdfd4948e45c51b19162cf8b3f5003f8f53c9b9 ]
> 
> task_pid_vnr(another_task) will crash if the caller was already reaped.
> The pid_alive(current) check can't really help, the parent/debugger can
> call release_task() right after this check.
> 
> This also means that even task_ppid_nr_ns(current, NULL) is not safe,
> pid_alive() only ensures that it is safe to dereference ->real_parent.
> 
> Change __task_pid_nr_ns() to ensure ns != NULL.
> 
> Originally-by: 高翔 <gaoxiang17@xiaomi.com>
> Link: https://lore.kernel.org/all/20250802022123.3536934-1-gxxa03070307@gmail.com/
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Link: https://lore.kernel.org/20250810173604.GA19991@redhat.com
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  kernel/pid.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/pid.c b/kernel/pid.c
> index e1d0c9d952278..62a8349267de1 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -497,7 +497,8 @@ pid_t __task_pid_nr_ns(struct task_struct *task, enum pid_type type,
>  	rcu_read_lock();
>  	if (!ns)
>  		ns = task_active_pid_ns(current);
> -	nr = pid_nr_ns(rcu_dereference(*task_pid_ptr(task, type)), ns);
> +	if (ns)
> +		nr = pid_nr_ns(rcu_dereference(*task_pid_ptr(task, type)), ns);
>  	rcu_read_unlock();
>  
>  	return nr;
> -- 
> 2.51.0
> 
> 
> 

