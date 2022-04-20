Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06CD185A
	for <patches@lists.linux.dev>; Wed, 20 Apr 2022 23:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9015AC385A1;
	Wed, 20 Apr 2022 23:28:08 +0000 (UTC)
Date: Wed, 20 Apr 2022 19:28:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: YueHaibing <yuehaibing@huawei.com>, mingo@redhat.com,
 xiaowei66@huawei.com, patches@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH sysctl-next] ftrace: fix building with SYSCTL=n but
 DYNAMIC_FTRACE=y
Message-ID: <20220420192807.75a70b44@gandalf.local.home>
In-Reply-To: <YlnpfHuZGC8H0iNZ@bombadil.infradead.org>
References: <YlnpfHuZGC8H0iNZ@bombadil.infradead.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 15 Apr 2022 14:54:04 -0700
Luis Chamberlain <mcgrof@kernel.org> wrote:

> Steven,
> 
> As with the other fixes I can take this in through sysctl-next if you
> are OK with that, please let me know.

Honestly I would love to just nuke the ftrace_enabled sysctl, it's totally
obsolete. Perhaps I should have it trigger some kind of warning message
that it will be going away soon, and perhaps we can remove it?

Anyway, yeah, take this through your tree.

Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
