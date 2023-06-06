Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D15A125CC
	for <patches@lists.linux.dev>; Tue,  6 Jun 2023 18:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=p+0nLSoJG17KKuiydwKjkEWK72qSSTBX227sDUKnkMI=; b=K8PQtgjHzFM8DsR8pdTrGnhVD2
	z/OYfEVC48yKut8wf6Nopa2FNs7aMyMSR1EpbfpI/r54+qbSB2Pw4GxeQxJaNXQClit6dBePXMvbv
	SiWVAkmZuBZcHKLlad7NRqmVtc6k/3LvY2Q0oei4CWLvLZr82F+ikRzih/Z3KirO1b6M7PK87axeR
	8bLPwahj/gRcWyWZHFvv23YgeMUyO7WGZXM6onH+v9iuibrPt52d1Rr4t/nZrIVOCk91CCVtUn5rd
	0588ctSoNdj4cxSLilu1LKMGFtHsF5072LwMPxAm5kh/Ul0folqF4paXyeLdgqTAnQfnd9cqBxR9G
	2Ye0363g==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q6bgf-002nx4-2g;
	Tue, 06 Jun 2023 18:45:45 +0000
Date: Tue, 6 Jun 2023 11:45:45 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Paul Moore <paul@paul-moore.com>
Cc: keescook@chromium.org, yzaikin@google.com, dhowells@redhat.com,
	jarkko@kernel.org, jmorris@namei.org, serge@hallyn.com,
	j.granados@samsung.com, brauner@kernel.org, ebiederm@xmission.com,
	patches@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] sysctl: move security keys sysctl registration to
 its own file
Message-ID: <ZH9+2WFsru1VMPqT@bombadil.infradead.org>
References: <20230530232914.3689712-1-mcgrof@kernel.org>
 <20230530232914.3689712-3-mcgrof@kernel.org>
 <CAHC9VhRA_XkkiZpg=d1RiME+VUYe7bsuV6pOpsseDRWfwV+q9A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHC9VhRA_XkkiZpg=d1RiME+VUYe7bsuV6pOpsseDRWfwV+q9A@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Wed, May 31, 2023 at 05:20:46PM -0400, Paul Moore wrote:
> On Tue, May 30, 2023 at 7:29 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > The security keys sysctls are already declared on its own file,
> > just move the sysctl registration to its own file to help avoid
> > merge conflicts on sysctls.c, and help with clearing up sysctl.c
> > further.
> >
> > This creates a small penalty of 23 bytes:
> >
> > ./scripts/bloat-o-meter vmlinux.1 vmlinux.2
> > add/remove: 2/0 grow/shrink: 0/1 up/down: 49/-26 (23)
> > Function                                     old     new   delta
> > init_security_keys_sysctls                     -      33     +33
> > __pfx_init_security_keys_sysctls               -      16     +16
> > sysctl_init_bases                             85      59     -26
> > Total: Before=21256937, After=21256960, chg +0.00%
> >
> > But soon we'll be saving tons of bytes anyway, as we modify the
> > sysctl registrations to use ARRAY_SIZE and so we get rid of all the
> > empty array elements so let's just clean this up now.
> >
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > ---
> >  include/linux/key.h    | 3 ---
> >  kernel/sysctl.c        | 4 ----
> >  security/keys/sysctl.c | 7 +++++++
> >  3 files changed, 7 insertions(+), 7 deletions(-)
> 
> Ultimately I'll leave the ACK to David or Jarkko, but this looks
> reasonable to me.
> 
> Reviewed-by: Paul Moore <paul@paul-moore.com>

I've queued this onto sysctl-next as I haven't seen any complaints.
I can drop it if there are complaints or regressions reported by
folks on linux-next.

  Luis
