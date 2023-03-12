Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5450BEC3
	for <patches@lists.linux.dev>; Sun, 12 Mar 2023 20:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99035C433EF;
	Sun, 12 Mar 2023 20:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1678653027;
	bh=7ZdJjtvONGlnyQxl/MSqAHbeDZqT//t50NNJbtDtWQ0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HLTab+6F6U4xfpJVlZUHebm21jC9SBllnhfYVVHFe8Ty93ZRAMcTIV3Yu5eX7ThIL
	 AO3ATueDhj93AQKf4xvz7s1uO+rl7GkYfUEHuaog2cIw4ArO06VEYXU6yywNbnbjpv
	 kmfAI/FU+EiZWma9+AmaQj8v/blTNProugC1Xlyg=
Date: Sun, 12 Mar 2023 13:30:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: pvorel@suse.cz, gregkh@linuxfoundation.org, keescook@chromium.org,
 Jason@zx2c4.com, ebiederm@xmission.com, yzaikin@google.com,
 j.granados@samsung.com, patches@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utsname: simplify one-level sysctl registration for
 uts_kern_table
Message-Id: <20230312133025.deb572fd12d56ffe42ab8955@linux-foundation.org>
In-Reply-To: <20230310231656.3955051-1-mcgrof@kernel.org>
References: <20230310231656.3955051-1-mcgrof@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 10 Mar 2023 15:16:56 -0800 Luis Chamberlain <mcgrof@kernel.org> wrote:

> This is part of the effort to phase out calls that can recurse from
> sysctl registration [0]. If you have a tree to take this in feel free
> to take it, or I can take it too through sysclt-next. Let me know!
> 
> This file has no explicit maintainer, so I assume there is no tree.

I act as a backstop for such changes, if people cc me.

> If I so no one taking it I can take in as part of sysctl-next later.

Please do that.
