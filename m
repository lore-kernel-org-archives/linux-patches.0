Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E182FC2E7
	for <patches@lists.linux.dev>; Fri, 31 Mar 2023 04:12:01 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so22076316pjz.1
        for <patches@lists.linux.dev>; Thu, 30 Mar 2023 21:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1680235921;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/fL6uYJqAJu4UWRofGL+uAKGAJCdSLBsLiJ3MZGh5jk=;
        b=e4BTX608wtZj4jZHDmB/1T4Gq8gzXBUP6DMAygN96mFzBhJbH8TFT2/VfRMayOo63G
         lTCJQFkxdohuSxvSyi7wtdj2gzFs7VUaboL5Yk1trxL9GdyiC7tFJelssEv8eqjpqdQG
         YLkdiqsWKS6TtftuVgzjuJki5n6e12uuDQlDw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680235921;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/fL6uYJqAJu4UWRofGL+uAKGAJCdSLBsLiJ3MZGh5jk=;
        b=A+cWtCeqaZsmJMJnFlMdDGxqJ2ntwnyM8EH8O3AS9swLNG/eUkb/+qN43DP8uU0B1P
         qVS71/xSynqWk3Rm5Eul0REJbPhCnE0PToVhv0pQPBKQnEmoizMa5q056Jqv/23+gmPM
         oUwGIhodqYVrTghz79SoJVRNFa1I1+/qr9j5b8G3QeSwMGW+E8ojurA3gAlrnJK2LJVu
         ELzPIcqyT0gVy0cH/+phc8FeszDEkkisboCErht1yb+Zb2i8zbG+2gSYvTaR21ybZ6Oy
         E3pCdsK7mziePBvA7dk8MDKYfYuwwecJE/NQHjeDKqC7GZbZyOlMeetjIXfeu3qPNSII
         A+zA==
X-Gm-Message-State: AAQBX9dyD4NLXj1iE3Yl9lhptNl24qRjUMW6Vm4xeP58+WDmcXLKBhsL
	CA6r44jC6WWmlc+6Ex/lZqV6IQ==
X-Google-Smtp-Source: AKy350Z3RDbX1XH78O/Mn6Z/g1q+VldEMG0p2DTAFVaet1gIF+cSHwqqrndzG46RRYMeO2Fqm8seLQ==
X-Received: by 2002:a17:90b:3b83:b0:236:a3c2:168a with SMTP id pc3-20020a17090b3b8300b00236a3c2168amr28524828pjb.33.1680235921307;
        Thu, 30 Mar 2023 21:12:01 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id c3-20020a170902aa4300b0019f2a7f4d16sm506889plr.39.2023.03.30.21.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 21:12:00 -0700 (PDT)
Date: Fri, 31 Mar 2023 13:11:54 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Petr Mladek <pmladek@suse.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>, david@redhat.com,
	patches@lists.linux.dev, linux-modules@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	petr.pavlu@suse.com, prarit@redhat.com, gregkh@linuxfoundation.org,
	rafael@kernel.org, christophe.leroy@csgroup.eu, tglx@linutronix.de,
	song@kernel.org, rppt@kernel.org, willy@infradead.org,
	vbabka@suse.cz, mhocko@suse.com, dave.hansen@linux.intel.com
Subject: Re: [PATCH 4/7] sempahore: add a helper for a concurrency limiter
Message-ID: <20230331041154.GC12892@google.com>
References: <20230329053149.3976378-1-mcgrof@kernel.org>
 <20230329053149.3976378-5-mcgrof@kernel.org>
 <20230329072112.GG4253@hirez.programming.kicks-ass.net>
 <ZCPuFLDgU5fBFtug@bombadil.infradead.org>
 <20230329091935.GP4253@hirez.programming.kicks-ass.net>
 <CAHk-=whF6Ta_KcJP2eC78+Mstv+vAku8ATRMbv98sf9VhdvySQ@mail.gmail.com>
 <20230330115626.GA124812@hirez.programming.kicks-ass.net>
 <CAHk-=wgF34MkhZnM_Kc1zggTWCAQ=BzEgAaAbE5wDM07bWiYeg@mail.gmail.com>
 <ZCZXcJ+KJffpFrpX@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCZXcJ+KJffpFrpX@bombadil.infradead.org>

On (23/03/30 20:45), Luis Chamberlain wrote:
[..]
> -static DEFINE_SEMAPHORE(console_sem);
> +static DEFINE_MUTEX(console_sem);
>  HLIST_HEAD(console_list);
>  EXPORT_SYMBOL_GPL(console_list);
>  DEFINE_STATIC_SRCU(console_srcu);
> @@ -309,7 +309,7 @@ EXPORT_SYMBOL(console_srcu_read_unlock);
>   * macros instead of functions so that _RET_IP_ contains useful information.
>   */
>  #define down_console_sem() do { \
> -	down(&console_sem);\
> +	mutex_lock(&console_sem);\
>  	mutex_acquire(&console_lock_dep_map, 0, 0, _RET_IP_);\
>  } while (0)
>  
> @@ -324,7 +324,7 @@ static int __down_trylock_console_sem(unsigned long ip)
>  	 * deadlock in printk()->down_trylock_console_sem() otherwise.
>  	 */
>  	printk_safe_enter_irqsave(flags);
> -	lock_failed = down_trylock(&console_sem);
> +	lock_failed = !mutex_trylock(&console_sem);
>  	printk_safe_exit_irqrestore(flags);
>  
>  	if (lock_failed)
> @@ -341,7 +341,7 @@ static void __up_console_sem(unsigned long ip)
>  	mutex_release(&console_lock_dep_map, ip);
>  
>  	printk_safe_enter_irqsave(flags);
> -	up(&console_sem);
> +	mutex_unlock(&console_sem);

mutex_unlock() does not like when its called from IRQ, so this is not
going to work very well.
