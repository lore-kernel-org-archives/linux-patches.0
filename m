Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5C2A23
	for <patches@lists.linux.dev>; Tue, 19 Apr 2022 04:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20CCC385A5;
	Tue, 19 Apr 2022 04:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1650342533;
	bh=bDjmhzMYqTgqG2GfbpE8Stb1MOGn045R+b8pIar3cMg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=E1lDdzoAgkxozYxF6LYVZLUqlyIMMOfgZG+WFgRVsYR8LcTs1keXlNz8l9pXjHsFz
	 1kvh8H53MBi8/toYAja+H8SiSB8TFeLu912iTOxc1bUNGzJb5uA/8aqfFhQP8TWn8j
	 sEe9Gx2o52ixuxGiHdvxk6kI1Vwk2EZaXkpAKhPs=
Date: Mon, 18 Apr 2022 21:28:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: zhanglianjie <zhanglianjie@uniontech.com>, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, Linux Memory Management List
 <linux-mm@kvack.org>
Subject: Re: [PATCH sysctl-next] mm: fix unused variable kernel warning when
 SYSCTL=n
Message-Id: <20220418212852.269aa7cd2bb7ecb5aa925f62@linux-foundation.org>
In-Reply-To: <YlnuZrhMc7OydWm7@bombadil.infradead.org>
References: <YlnuZrhMc7OydWm7@bombadil.infradead.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 15 Apr 2022 15:15:02 -0700 Luis Chamberlain <mcgrof@kernel.org> wrote:

> When CONFIG_SYSCTL=n the variable dirty_bytes_min which is just used
> as a minimum to a proc handler is not used. So just move this under
> the ifdef for CONFIG_SYSCTL.

Acked-by: Andrew Morton <akpm@linux-foundation.org>
