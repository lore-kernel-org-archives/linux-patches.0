Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6691F18E
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 16:34:11 +0000 (UTC)
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6237faa8677so18818016d6.1
        for <patches@lists.linux.dev>; Fri, 02 Jun 2023 09:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685723650; x=1688315650;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LGApg1SSBEe11skXmvplXNx+M197fUVxt6voaPZdmOE=;
        b=AK8tZnJIfmaLsBHYzDziIMFt513KMbEiaKprIhTtFuEgUeJPgD7mwsokNCEIRMCcK2
         xpg7Z1meCvC91+NhJSpE/KkSs/u0TqUBN3ZlnuOHlhDY+HBq/QSE2ORKA2bzJKXNkLMm
         4377w+EJE7gZf4EJlyHsG4E7rdFKcXNw+tCfgkucRU8rNJ3MRrI7wXmwLNbPDoCpOieC
         RaT3BWcqZU8/IrDKcEib87DdzPdd5AxoMg7ZGj07efG5ik65vsp3QzQF0wBWW7S+AZ/x
         SK1fKrvyaUENdKgwHbEsqhIf5uTrTGW6Pw8OZUi+X4dALsjhjUqgMaUhjbyMvlM5mDzE
         fPWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685723650; x=1688315650;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LGApg1SSBEe11skXmvplXNx+M197fUVxt6voaPZdmOE=;
        b=c8EXBxjmqYy5OsX8Idyqens1rYuepDV5lBPP0uATJUwyZCNCS+3d2lju5BuyuNUfS3
         k2s2FiX5XdzRmy/eymYzMAA29Oo4jpj8YXJ8DyLNsPkJQUpU3cIpoTNs8R41ikBVQO/E
         C9r9qEKru7Tm8rawHXd9uOtPn1qRE27h80q9egt7t7cVZqLIO/Fi84+EEPrXRrgPQCuU
         DKmmcroCD7Qfoe3JoXn0sXzRcl3i1oN4mM6thUszVhu8bLw5566Nf5ul9uomSU9iZHmv
         gdmDeG84WmarlhS357FyE43dQ4Un7AbYdgpfkeANip+Wr81IRaG6jn4920M0q50w+5ZX
         MUyg==
X-Gm-Message-State: AC+VfDyq1xjRkxHMSUT81gddN78QZ88LDcMKts3HDHdtbecLA9xutDNG
	bJcOLTj5GEA6ilbVPhlyLgg=
X-Google-Smtp-Source: ACHHUZ6wjf7ZdJgQtHUTohP3vL3ZskcmF2H3hNSOL8GJPvUGEz//YtOeDfJqRfF1E9CA+TjwQ0OM4w==
X-Received: by 2002:a05:6214:628:b0:626:dae:db6c with SMTP id a8-20020a056214062800b006260daedb6cmr14164658qvx.21.1685723650041;
        Fri, 02 Jun 2023 09:34:10 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id bu17-20020ad455f1000000b00623819de804sm995730qvb.127.2023.06.02.09.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 09:34:09 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailauth.nyi.internal (Postfix) with ESMTP id D6CD427C005B;
	Fri,  2 Jun 2023 12:34:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 02 Jun 2023 12:34:08 -0400
X-ME-Sender: <xms:ABp6ZFeuAC6oX6t3B2vvBPyTz1lXfyzyRgDJcyOZaC0sV1beTyfBHA>
    <xme:ABp6ZDOBFqUO9ZYZjTTXNIJ_w3su1tl0Emssi9BXFG8G8DaaBFTrr-AT2qv7gp-uw
    XNdFZbspmPm2B-qww>
X-ME-Received: <xmr:ABp6ZOgsDc_TnifAId0a-dNecDxPuGwJeO_4Q2dFT1OD_fbotWk7DoLb7Vw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeelfedgleelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpefhtedvgfdtueekvdekieetieetjeeihedvteehuddujedvkedtkeefgedv
    vdehtdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhh
    phgvrhhsohhnrghlihhthidqieelvdeghedtieegqddujeejkeehheehvddqsghoqhhunh
    drfhgvnhhgpeepghhmrghilhdrtghomhesfhhigihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:ABp6ZO_6t9mp4JaQNXq7OjS91B9ZotNM1ry3C1H0-n1Ihk6XUgP9fw>
    <xmx:ABp6ZBtWYNHcpSXIWOQOeFudRSVtJNrcgp6Aku3A2XWXpyYcHWbBQw>
    <xmx:ABp6ZNGHK_9tS7FauKYe1pglkE0IS70VpQC0QXguzwWUjXZyuxLUGw>
    <xmx:ABp6ZNEwZ0rCFEDAwtw98yYgCDMbuq6NYLlWhF1kz2Pm_lpsx5gpIA>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 2 Jun 2023 12:34:07 -0400 (EDT)
Date: Fri, 2 Jun 2023 09:32:56 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: alex.gaynor@gmail.com, benno.lossin@proton.me, bjorn3_gh@protonmail.com,
	gary@garyguo.net, jiangshanlai@gmail.com,
	linux-kernel@vger.kernel.org, ojeda@kernel.org,
	patches@lists.linux.dev, rust-for-linux@vger.kernel.org,
	tj@kernel.org, wedsonaf@gmail.com
Subject: Re: [PATCH v2 5/8] rust: workqueue: add helper for defining
 work_struct fields
Message-ID: <ZHoZuIz97JN1VSBf@boqun-archlinux>
References: <ZHjnDAEmimeETrNZ@boqun-archlinux>
 <20230602083856.1035444-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602083856.1035444-1-aliceryhl@google.com>

On Fri, Jun 02, 2023 at 08:38:56AM +0000, Alice Ryhl wrote:
> Boqun Feng <boqun.feng@gmail.com> writes:
> > On Thu, Jun 01, 2023 at 01:49:43PM +0000, Alice Ryhl wrote:
> >> diff --git a/rust/helpers.c b/rust/helpers.c
> >> index 81e80261d597..7f0c2fe2fbeb 100644
> >> --- a/rust/helpers.c
> >> +++ b/rust/helpers.c
> >> @@ -26,6 +26,7 @@
> >>  #include <linux/spinlock.h>
> >>  #include <linux/sched/signal.h>
> >>  #include <linux/wait.h>
> >> +#include <linux/workqueue.h>
> >>  
> >>  __noreturn void rust_helper_BUG(void)
> >>  {
> >> @@ -128,6 +129,13 @@ void rust_helper_put_task_struct(struct task_struct *t)
> >>  }
> >>  EXPORT_SYMBOL_GPL(rust_helper_put_task_struct);
> >>  
> >> +void rust_helper___INIT_WORK(struct work_struct *work, work_func_t func,
> >> +			     bool on_stack)
> >> +{
> >> +	__INIT_WORK(work, func, on_stack);
> > 
> > Note here all the work items in Rust will share the same lockdep class.
> > That could be problematic: the lockdep classes for work are for
> > detecting deadlocks in the following scenario:
> > 
> > step 1: queue a work "foo", whose work function is:
> > 
> > 	mutex_lock(&bar);
> > 	do_something(...);
> > 	mutex_unlock(&bar);
> > 
> > step 2: in another thread do:
> > 
> > 	mutex_lock(&bar);
> > 	flush_work(foo);	// wait until work "foo" is finished.
> > 
> > if this case, if step 2 get the lock "bar" first, it's a deadlock.
> > 
> > With the current implementation, all the work items share the same
> > lockdep class, so the following will be treated as deadlock:
> > 
> > 	<in work "work1">
> > 	mutex_lock(&bar);
> > 	do_something(...);
> > 	mutex_unlock(&bar);
> > 
> > 	<in another thread>
> > 	mutex_lock(&bar);
> > 	flush_work(work2);	// flush work2 intead of work1.
> > 
> > which is a false positive. We at least need some changes in C side to
> > make it work:
> > 
> > 	https://lore.kernel.org/rust-for-linux/20220802015052.10452-7-ojeda@kernel.org/
> > 
> > however, that still has the disadvantage that all Rust work items have
> > the same name for the lockdep classes.. maybe we should extend that for
> > an extra "name" parameter. And then it's not necessary to be a macro.
> 
> Yeah, I did know about this issue, but I didn't know what the best way
> to fix it is. What solution would you like me to use?
> 

Having a init_work_with_key() function in C side:

void init_work_with_key(struct work_struct *work, bool onstack,
			const char *name, struct lock_class_key *key)
{
	__init_work(work, onstack);				\
	work->data = (atomic_long_t) WORK_DATA_INIT();	\
	lockdep_init_map(&work->lockdep_map, name, key, 0); \
	INIT_LIST_HEAD(&work->entry);			\
	work->func = func;				\
}

, and provide class key and name from Rust side.

Thoughts?

Regards,
Boqun

> Alice
