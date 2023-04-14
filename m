Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426D3620
	for <patches@lists.linux.dev>; Fri, 14 Apr 2023 06:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DEFC433EF;
	Fri, 14 Apr 2023 06:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681454157;
	bh=+Yp7RZWfuDeZqFhwRrrTAzpa2PNfsGknk0RMVV2+zIg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uqnmZUG7Zox6U9sbFwAS1zMLed9wKPDZRUtXGdg2a24IJWiqmlO3aKqrvU8oYgfAd
	 pdT3hmHcCPq1rH6MOidIq8tFOB1mYepA9j00Ascyd1Xt3K3nz5YNQcYRRJPst5N5vH
	 puDsuKpLBUBrG4T4ZOeisfXrR9qmBdkZuO4HRtPA=
Date: Fri, 14 Apr 2023 08:35:53 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: david@redhat.com, patches@lists.linux.dev,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pmladek@suse.com, petr.pavlu@suse.com,
	prarit@redhat.com, torvalds@linux-foundation.org, rafael@kernel.org,
	christophe.leroy@csgroup.eu, tglx@linutronix.de,
	peterz@infradead.org, song@kernel.org, rppt@kernel.org,
	dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz,
	mhocko@suse.com, dave.hansen@linux.intel.com,
	colin.i.king@gmail.com, jim.cromie@gmail.com,
	catalin.marinas@arm.com, jbaron@akamai.com,
	rick.p.edgecombe@intel.com
Subject: Re: [RFC 2/2] kread: avoid duplicates
Message-ID: <ZDj0SVelrvh1xaEv@kroah.com>
References: <20230414052840.1994456-1-mcgrof@kernel.org>
 <20230414052840.1994456-3-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414052840.1994456-3-mcgrof@kernel.org>

On Thu, Apr 13, 2023 at 10:28:40PM -0700, Luis Chamberlain wrote:
> With this we run into 0 wasted virtual memory bytes.

This changelog does not make any sense at all, sorry.  What are you
doing here and why?

> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  fs/kernel_read_file.c | 150 ++++++++++++++++++++++++++++++++++++++++++
>  kernel/module/main.c  |   6 +-
>  2 files changed, 154 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/kernel_read_file.c b/fs/kernel_read_file.c
> index 5d826274570c..209c56764442 100644
> --- a/fs/kernel_read_file.c
> +++ b/fs/kernel_read_file.c
> @@ -4,6 +4,7 @@
>  #include <linux/kernel_read_file.h>
>  #include <linux/security.h>
>  #include <linux/vmalloc.h>
> +#include <linux/fdtable.h>
>  
>  /**
>   * kernel_read_file() - read file contents into a kernel buffer
> @@ -171,17 +172,166 @@ ssize_t kernel_read_file_from_path_initns(const char *path, loff_t offset,
>  }
>  EXPORT_SYMBOL_GPL(kernel_read_file_from_path_initns);
>  
> +DEFINE_MUTEX(kread_dup_mutex);

static?

I stopped reading here :)

thanks,

greg k-h
