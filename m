Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3750410E3
	for <patches@lists.linux.dev>; Wed, 29 Mar 2023 05:46:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C72C433EF;
	Wed, 29 Mar 2023 05:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680068797;
	bh=+iww93uuVjdBhdL0/L8gZYSOkFBuwO8g7kYZXV0Bk/M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZlRhu5f5otMVqSpA3zlttXBVbmcSXqMzRTDVDn+SFVKcIYGvS5O037AptWC0fF+dR
	 odGGjujVEdBIpNVASHexeGHQh/pusth+SYQYcoFWWsPyi3GPY/zbtBCCgs/bGt+O6U
	 6xM+i8MpWOImV7SibLT8qt9mTHD6nvQi2JuuDQ6I=
Date: Wed, 29 Mar 2023 07:46:34 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: david@redhat.com, patches@lists.linux.dev,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pmladek@suse.com, petr.pavlu@suse.com,
	prarit@redhat.com, torvalds@linux-foundation.org, rafael@kernel.org,
	christophe.leroy@csgroup.eu, tglx@linutronix.de,
	peterz@infradead.org, song@kernel.org, rppt@kernel.org,
	willy@infradead.org, vbabka@suse.cz, mhocko@suse.com,
	dave.hansen@linux.intel.com
Subject: Re: [PATCH 6/7] debugfs: add debugfs_create_atomic64_t for atomic64_t
Message-ID: <ZCPQug6kTUbCgGnu@kroah.com>
References: <20230329053149.3976378-1-mcgrof@kernel.org>
 <20230329053149.3976378-7-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329053149.3976378-7-mcgrof@kernel.org>

On Tue, Mar 28, 2023 at 10:31:48PM -0700, Luis Chamberlain wrote:
> Sometimes you want to add debugfs entries for atomic counters which
> can be pretty large using atomic64_t. Add support for these.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  fs/debugfs/file.c       | 36 ++++++++++++++++++++++++++++++++++++
>  include/linux/debugfs.h |  2 ++
>  2 files changed, 38 insertions(+)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
