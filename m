Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0464CDF9
	for <patches@lists.linux.dev>; Tue,  2 Apr 2024 10:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712054277; cv=none; b=WTcQwD1EcDZ9Qny4JMffmr1sCAE70A2Tzh5PkPfqaVJSk+QzxbM+9IJjY7VUuqt2zC0YzrUw+CrCKBuvzXHGeoAb50w9SPUW6qwoQOTB/+oIYT7zaq8tqpuf49QLrKK72sroyxFr7znlbElXPT7LlagezGKrv+CIvyWpcZP2gfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712054277; c=relaxed/simple;
	bh=r91xpWnGr3JVgNBrgKZPO2sDxnqrY2gA5+Cyn/xLnOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cnw0hzybDdYLQCYl+ZGFvJUZnRUBhQYAB1ijw9TxcIjNmPMwjH8pXhp9cxGfZNsRhrkBnk8OV0/Pamy1ul8eCRRj53q9tzsTM0VllLfuu40GfGt/I1kvVX5Ay1aEhLF/0z2JvCfYDpEQoCsVAd1JdTkWfVWm6e0vlts3ehDIZpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Mmgc0xMr; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Mmgc0xMr"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-56df8e6a376so45361a12.0
        for <patches@lists.linux.dev>; Tue, 02 Apr 2024 03:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712054274; x=1712659074; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jz9Y9PjigYVKEbCw1GNYP1RDI4ZuVwZ4udJg2a4ZlkM=;
        b=Mmgc0xMrUjelp/IdQzIk8BDI/faq7TNX8/ADSvT1f39/hkMQuaVsSjuk6IzV45bIyF
         M6UwuXw9vYMt/eo0iQoFljmL6D/WbgSpQsX6SET1zkKwzA9cM6jC6qYKhqkK7gc0rg8R
         LFYrPelmNg5kEIPlKg00K8EjoPjB8sh9p4qshS1G43IiTS19mmnOdkhUJEKQYl6jzqE6
         xQq5uOCp/YXJFYzTA1vwXr/9l15oTNEE6pXTiqP7wrgktE67y+rYYUWBh8h021a1VM6Y
         NRoGD9QGQUYrRCJ5PjC3KUADATKsh5WCOj/sJJsG1mKIAui/nusTvFCtZfVr9/6rYUAG
         dd/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712054274; x=1712659074;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jz9Y9PjigYVKEbCw1GNYP1RDI4ZuVwZ4udJg2a4ZlkM=;
        b=fo22yuP26ei6F7mz8XlijptBUXHlgUZ3f0mWprEgUGmhvgs8W7Saf7145Q5qsZAiZg
         RT8TMiSS3YElHKckOeQc6ry9DTsQQeCT51chHDgBZmA+giZvBcB+zATkGgzMQXCTdgeQ
         36HAJBvrPAX5OG6JEy3U3v7S9aRCN8YHGxAUotDBf7DwqUsJYGBVqDOzKYcT9GRbwjwQ
         A6T99T4BzUnQofkENLAxFVmqfXarcsT5bDuSs6EO1wbFYG9W70Dt/+aLyDf/UxGlcfqI
         iZliq4rdwNNzN1AmP4LbzHS4ziAdloWW4l+gVzC9j/7Loa6bIDCeVgn0RCkWYrvyaeb3
         UpRw==
X-Forwarded-Encrypted: i=1; AJvYcCX2PLujtl2wj7DU96bW+zMXJTa5Ewt7JslM4OwH+k1am8/5rZPL3aD2YpyOlP3isCE5RhxgXhpvFsDbeZAazGwRbdkW+uvFhQ==
X-Gm-Message-State: AOJu0Yzqnm+0myrg3K/FJzFyQy5QzuDa+XTEDOK8psAkHyFAfzJQ7ted
	0UMF4E8NbZbO4nymqQKFnBtG771m+/dvY21Ej9547zAXDbMXFZ57DRmNIiJTsNs=
X-Google-Smtp-Source: AGHT+IFLXanUhL+rTkL5dhPieUFNxekE62yhWKGrRFO2Vdc9oBu4cKCdI7vD6zG/l7HO+KOWLoErNA==
X-Received: by 2002:a50:d5c8:0:b0:568:aced:e5a0 with SMTP id g8-20020a50d5c8000000b00568acede5a0mr13872744edj.14.1712054274194;
        Tue, 02 Apr 2024 03:37:54 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id k7-20020aa7c047000000b0056c443ce781sm6591488edo.85.2024.04.02.03.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 03:37:53 -0700 (PDT)
Date: Tue, 2 Apr 2024 13:37:50 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Alexander Wetzel <alexander@wetzel-home.de>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Anders Roxell <anders.roxell@linaro.org>,
	LTP List <ltp@lists.linux.it>
Subject: Re: [PATCH 6.6 000/396] 6.6.24-rc1 review
Message-ID: <1d1071f3-641a-4b7c-bd35-a629ba8d5a7b@moroto.mountain>
References: <20240401152547.867452742@linuxfoundation.org>
 <CA+G9fYvewkbwR_i07HHTM=8E2yS-0wRhOT-C45LP3SNtzgd+4Q@mail.gmail.com>
 <29a7a1e5-da67-47fc-b1fd-ef65902ec252@wetzel-home.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29a7a1e5-da67-47fc-b1fd-ef65902ec252@wetzel-home.de>

On Mon, Apr 01, 2024 at 09:22:52PM +0200, Alexander Wetzel wrote:
> 
> > Following kernel warnings have been noticed on qemu-x86_64 while running LTP
> > cve ioctl_sg01 tests the kernel with stable-rc 6.6.24-rc1, 6.7.12-rc1 and
> > 6.8.3-rc1.
> > 
> > We have started bi-secting this issue.
> > Always reproduced.
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > ioctl_sg01.c:81: TINFO: Found SCSI device /dev/sg0
> > ------------[ cut here ]------------
> > [   36.606841] WARNING: CPU: 0 PID: 8 at drivers/scsi/sg.c:2237
> > sg_remove_sfp_usercontext+0x145/0x150
> > [   36.609445] Modules linked in:
> > [   36.610793] CPU: 0 PID: 8 Comm: kworker/0:0 Not tainted 6.6.24-rc1 #1
> > [   36.611568] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
> > BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> > [   36.612872] Workqueue: events sg_remove_sfp_usercontext
> > [   36.613691] RIP: 0010:sg_remove_sfp_usercontext+0x145/0x150
> > 
> > <trim>
> > 
> > [   36.621539] Call Trace:
> > [   36.621953]  <TASK>
> > [   36.622444]  ? show_regs+0x69/0x80
> > [   36.622819]  ? __warn+0x8d/0x150
> > [   36.623078]  ? sg_remove_sfp_usercontext+0x145/0x150
> > [   36.623558]  ? report_bug+0x171/0x1a0
> > [   36.623881]  ? handle_bug+0x42/0x80
> > [   36.624070]  ? exc_invalid_op+0x1c/0x70
> > [   36.624491]  ? asm_exc_invalid_op+0x1f/0x30
> > [   36.624897]  ? sg_remove_sfp_usercontext+0x145/0x150
> > [   36.625408]  process_one_work+0x141/0x300
> > [   36.625769]  worker_thread+0x2f6/0x430
> > [   36.626073]  ? __pfx_worker_thread+0x10/0x10
> > [   36.626529]  kthread+0x105/0x140
> > [   36.626778]  ? __pfx_kthread+0x10/0x10
> > [   36.627059]  ret_from_fork+0x41/0x60
> > [   36.627441]  ? __pfx_kthread+0x10/0x10
> > [   36.627735]  ret_from_fork_asm+0x1b/0x30
> > [   36.628293]  </TASK>
> > [   36.628604] ---[ end trace 0000000000000000 ]---
> > ioctl_sg01.c:122: TPASS: Output buffer is empty, no data leaked
> > 
> > Suspecting commit:
> > -----
> > scsi: sg: Avoid sg device teardown race
> > commit 27f58c04a8f438078583041468ec60597841284d upstream.
> > 
> 
> Correct. The issue is already been worked on.
> 
> commit 27f58c04a8f4 ("scsi: sg: Avoid sg device teardown race") fixed a real
> issue. But also added an incorrect WARN_ON_ONCE(). Thus the scary - but
> otherwise harmless - error message.

If you have Reboot on Oops turned on (apparently Android enables this)
then WARN() will reboot the system so it can be pretty annoying.

regards,
dan carpenter

