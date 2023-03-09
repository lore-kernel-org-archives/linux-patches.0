Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA7EC941
	for <patches@lists.linux.dev>; Thu,  9 Mar 2023 22:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=0Iy5i1KRt9BRu51UqkHEc8TWm2Sma1QI6oHERNxIFTE=; b=4avk2FIZAloQ6Je2ulx3/bhxiD
	KZ0Rb78uqiP3BhAhEbXxg+9ZAm7d8f7Bk8zJDQw1jeCBK6hshVwpaUDpWh0wr1ubr+P6j656/rTo+
	NEcAbZGe1ztYqtdFZVe9HZJaK8qentKzwQ34m3yiHt7K6h9fBlaaiqPOlw4bA1bdbdIcYwTLfFJMd
	5RIH2wnpqdyASvO8vvmzKSS07e0mXlLEcGiWhoY30d7FBmgLBQrKZgHiaCKOLji1IhrrFivzc2Wqz
	JrT9bLZ/l4Mw3pDNSibfSLYuQ6r9YLlB+uqSCswBw6H0KXPLAnWTGvDUHL4iOMEE+cDBPl+pKiy2I
	JoQR9yDQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1paOTv-00C7rj-Sk; Thu, 09 Mar 2023 22:11:27 +0000
Date: Thu, 9 Mar 2023 14:11:27 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Jeff Xu <jeffxu@google.com>, Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Cc: ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com,
	john.johansen@canonical.com, paul@paul-moore.com, jmorris@namei.org,
	serge@hallyn.com, luto@amacapital.net, wad@chromium.org,
	dverkamp@chromium.org, paulmck@kernel.org, baihaowen@meizu.com,
	frederic@kernel.org, ebiggers@kernel.org, tytso@mit.edu,
	guoren@kernel.org, j.granados@samsung.com, zhangpeng362@huawei.com,
	tangmeng@uniontech.com, willy@infradead.org, nixiaoming@huawei.com,
	sujiaxun@uniontech.com, patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org, linux-csky@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/11] kernel: pid_namespace: simplify sysctls with
 register_sysctl()
Message-ID: <ZApZj9DmMYKuCQ3g@bombadil.infradead.org>
References: <20230302202826.776286-1-mcgrof@kernel.org>
 <20230302202826.776286-9-mcgrof@kernel.org>
 <CALmYWFucv6-9yfS=gamwSsqjgxSKZS0nvVjj_QfBmsLmQD5XOQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALmYWFucv6-9yfS=gamwSsqjgxSKZS0nvVjj_QfBmsLmQD5XOQ@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Thu, Mar 02, 2023 at 03:13:54PM -0800, Jeff Xu wrote:
> On Thu, Mar 2, 2023 at 12:28 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >  kernel/pid_sysctl.h    | 3 +--
> >  2 files changed, 2 insertions(+), 4 deletions(-)
> >
> Acked-by: Jeff Xu <jeffxu@google.com>

Andrew, kernel/pid_sysctl.h is new, not on v6.3-rc1 and so I cannot
carry this on sysctl-next. Can you carry this patch on your tree?

I see Eric Biggers already took in the fs-verity patch, so I will drop
that from my queue.

I can take the rest in this series.

I will also hold off on the last patch which deprecates the routine
register_sysctl_paths() until after say the first part of the merge
window.

This will allow all of our trees to work on linux-next without conflict.

Let me know if this is OK with you and Eric!

  Luis
