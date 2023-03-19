Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCB17C
	for <patches@lists.linux.dev>; Sun, 19 Mar 2023 20:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bpylSVII1FYDPpIVeV+6MThI+CQatbJ+23qCa7MroYI=; b=h79wg4kJj+IQX0Ct/ULTrC7dxx
	v0HiZsAxr9rRp7MAlzrIs6Qon3wmZm355l7uwPG+9CwpJ3SVqcIllLqxIVBoQIrKj4NVoM62ach6f
	sFjamd25p6gWQDmSMtexer35BP89oCUHk6yZk8WHnAIFMegzx9Y6G5iwL5g1M5zV48U7EFd/ZXCBh
	nv9hgAc7XcvLw8zVCPpn5nakGDILXl34n1bbIamb2erFNDuFs0loLUhRTWSiIHRXWDzvzJK5W0Y2e
	2S5BIWC1xBAToDLYy8pqvRXgYTFPUeCO3nUzOC1vlEofgKDXiZeZB7ITDzKmkSu3hb0/hUo2vImMW
	hF2zuyKw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1pdzvo-007PPe-0v;
	Sun, 19 Mar 2023 20:47:08 +0000
Date: Sun, 19 Mar 2023 13:47:08 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Xu <jeffxu@google.com>, Eric Biggers <ebiggers@kernel.org>,
	ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com,
	john.johansen@canonical.com, paul@paul-moore.com, jmorris@namei.org,
	serge@hallyn.com, luto@amacapital.net, wad@chromium.org,
	dverkamp@chromium.org, paulmck@kernel.org, baihaowen@meizu.com,
	frederic@kernel.org, tytso@mit.edu, guoren@kernel.org,
	j.granados@samsung.com, zhangpeng362@huawei.com,
	tangmeng@uniontech.com, willy@infradead.org, nixiaoming@huawei.com,
	sujiaxun@uniontech.com, patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org, linux-csky@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/11] kernel: pid_namespace: simplify sysctls with
 register_sysctl()
Message-ID: <ZBd0zOqlH2H423ux@bombadil.infradead.org>
References: <20230302202826.776286-1-mcgrof@kernel.org>
 <20230302202826.776286-9-mcgrof@kernel.org>
 <CALmYWFucv6-9yfS=gamwSsqjgxSKZS0nvVjj_QfBmsLmQD5XOQ@mail.gmail.com>
 <ZApZj9DmMYKuCQ3g@bombadil.infradead.org>
 <20230309142746.0bc649a31e76bc46fd929304@linux-foundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309142746.0bc649a31e76bc46fd929304@linux-foundation.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Thu, Mar 09, 2023 at 02:27:46PM -0800, Andrew Morton wrote:
> On Thu, 9 Mar 2023 14:11:27 -0800 Luis Chamberlain <mcgrof@kernel.org> wrote:
> 
> > Andrew, kernel/pid_sysctl.h is new, not on v6.3-rc1 and so I cannot
> > carry this on sysctl-next. Can you carry this patch on your tree?
> 
> Sure, no probs.

Andrew, this one patch will have to go through your tree as kernel/pid_sysctl.h
only exist on your tree. I'll drop it on my end!

Thanks!

  Luis
