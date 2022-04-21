Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318441FDE
	for <patches@lists.linux.dev>; Thu, 21 Apr 2022 19:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B79DC385A7;
	Thu, 21 Apr 2022 19:09:03 +0000 (UTC)
Date: Thu, 21 Apr 2022 15:09:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: mingo@redhat.com, YueHaibing <yuehaibing@huawei.com>,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: fix building with SYSCTL=y but DYNAMIC_FTRACE=n
Message-ID: <20220421150901.002a0083@gandalf.local.home>
In-Reply-To: <YmGo/TcNVzOK4Bjn@bombadil.infradead.org>
References: <YmGo/TcNVzOK4Bjn@bombadil.infradead.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 21 Apr 2022 11:57:01 -0700
Luis Chamberlain <mcgrof@kernel.org> wrote:

> Ok so hopefully this is the last of it. 0day picked up a build
> failure [0] when SYSCTL=y but DYNAMIC_FTRACE=n. This can be fixed
> by just declaring an empty routine for the calls moved just
> recently.
> 
> [0] https://lkml.kernel.org/r/202204161203.6dSlgKJX-lkp@intel.com
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: f8b7d2b4c192 ("ftrace: fix building with SYSCTL=n but DYNAMIC_FTRACE=y")
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
