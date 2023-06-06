Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE881ED36
	for <patches@lists.linux.dev>; Tue,  6 Jun 2023 20:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBC7C433D2;
	Tue,  6 Jun 2023 20:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686083961;
	bh=4LWysxv5nCwtynK3qS1kWwwU6nmxSsvm8Ql6bGca8eQ=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=byxcVfbsphXB0kwZukntfYzhk2vydJFqH3Y59ERQtq4PmhFYbmavWBWl3XDznKbDR
	 /+f8z6oNc4z/TFsMu3CLcjwLvIIgRw6ympyvfFvxy4QdrutpubaQwq7HqkzXIMTBcG
	 w+tF3oydEGRuSJ3EbOnV1Lp+huyj0zY4vy/Ei6vNQ86e2uSEd+bJifojrXRLQfs7xl
	 4dI1JZkSKJ+GeQt4dla0K+1Kdpe3hbhU5fNgJqFPgHnuEtpm519bhXEki79sJq8Nui
	 Az1+bxiI5i1cq/Jhc2iB7wC+JGlUxQfJbFBRuTsrT4MkkAUW+2HIjdbXdbZfNTQiuY
	 6+HiwpnOTo84w==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 06 Jun 2023 23:39:15 +0300
Message-Id: <CT5UVNZYSAPZ.1PJWWUUOCHODW@suppilovahvero>
Cc: <ebiederm@xmission.com>, <patches@lists.linux.dev>,
 <linux-fsdevel@vger.kernel.org>, <keyrings@vger.kernel.org>,
 <linux-security-module@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] sysctl: move security keys sysctl registration to
 its own file
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Luis Chamberlain" <mcgrof@kernel.org>, <keescook@chromium.org>,
 <yzaikin@google.com>, <dhowells@redhat.com>, <paul@paul-moore.com>,
 <jmorris@namei.org>, <serge@hallyn.com>, <j.granados@samsung.com>,
 <brauner@kernel.org>
X-Mailer: aerc 0.14.0
References: <20230530232914.3689712-1-mcgrof@kernel.org>
 <20230530232914.3689712-3-mcgrof@kernel.org>
In-Reply-To: <20230530232914.3689712-3-mcgrof@kernel.org>

On Wed May 31, 2023 at 2:29 AM EEST, Luis Chamberlain wrote:
> The security keys sysctls are already declared on its own file,
> just move the sysctl registration to its own file to help avoid
> merge conflicts on sysctls.c, and help with clearing up sysctl.c
> further.
>
> This creates a small penalty of 23 bytes:
>
> ./scripts/bloat-o-meter vmlinux.1 vmlinux.2
> add/remove: 2/0 grow/shrink: 0/1 up/down: 49/-26 (23)
> Function                                     old     new   delta
> init_security_keys_sysctls                     -      33     +33
> __pfx_init_security_keys_sysctls               -      16     +16
> sysctl_init_bases                             85      59     -26
> Total: Before=3D21256937, After=3D21256960, chg +0.00%
>
> But soon we'll be saving tons of bytes anyway, as we modify the
> sysctl registrations to use ARRAY_SIZE and so we get rid of all the
> empty array elements so let's just clean this up now.
>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  include/linux/key.h    | 3 ---
>  kernel/sysctl.c        | 4 ----
>  security/keys/sysctl.c | 7 +++++++
>  3 files changed, 7 insertions(+), 7 deletions(-)

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
