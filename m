Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795318765;
	b=PT/I2HYM1Y5fFJE4d+o3e2JXWViKSiDWTq/mUDrre3WoYXJ9KrExLBpJMSVDHCcsLBHX
	 ivwuyw/SOtkWGrWLVF3HPrGZ6lRTg28MO8mKSisPZ8nOTeZUqpdpfekTnCzLpoxxcEg9G
	 OB/D0Oi7zIpxjH0Nk2mBG/5M9WESj800OZTEKJq4fo6b/9NspStN6u2hXjJWRf2SXM3Ih
	 8SdeSehP87Ggt2Df1wAKxhoaajZcnIgnwF4wCEjow1qb4VdWQMTfq5EnIe54J0HtiWATK
	 GrM/JWil95W8DYx9CICjj2vMaTVKyPh3YVXGTWC8p4c6pp+2OukI/Ch/8RbXNOHlm0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795318765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ELP1Gi9OydRgeoQUw8lf/RVUC//Ff1/9sgqvB+TA2bU=;
	b=XuYW4ivWsbiD+eRlrbra/mCp44fUsL5PeKznImxlIISSixEmFGQ7q87BSt+AuV2cd9mA
	 2H+oY+d78NHgXmjIP+WIuZyr6eK0ZG+nAE4aN0Ppad8FpOY2ZEO/5l8u0qsyqONZP0fxl
	 ZjrZMrvIpN3m4piHCK0dKtnR9jJkM2wJy3EqXXG68LNe6HATFpnh4JvEakMvjMBwjNv0+
	 JDcI1T3z0nkec5022Ehxx32YqWbAMPOHG7BFCJWLawBIuzjZ++rSru0gdSncspdhThYxg
	 ZKWH2bZ0wrHNhDkbfbD9gd4U3jZb4zH/8lggzYGdVIni3dShczUf2+/6YsIlpdvkD2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C0FnPg59;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF6F606A320;
	Sun, 22 Nov 2026 03:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C0FnPg59
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6381F000D1;
	Sun, 22 Nov 2026 03:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795318764;
	bh=ELP1Gi9OydRgeoQUw8lf/RVUC//Ff1/9sgqvB+TA2bU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C0FnPg59WEqH1PjLaUG1QWQMWWSKkz7yyWLd3Q2jMR2/t8zzkD1S4TV/yrA1jd8se
	 AOiviHoOOuZknmYGm7FX0ttq77CMYw+tuQzU2PlWoAt7vVKiz757j4UeJGdHhznTxm
	 D409oWmnDageMan9rD4iYpGeu9mOK9hdOz522m5skB8odTXq8oVlJTU9qagyS/fVNZ
	 2Vat7PgdfyD9RLHr+TU1r4B9boHo4A62SI7HQGvXC5liE2wy82Ua/kNc9e9lsM/Bfk
	 suJovdGsTrC0gE95dRzPqATN7irKS3yD004vq2/kAS41CzSb8QAotVCdINsosl2lpC
	 DNFf0ELUAcTag==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosryahmed@google.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Hellwig <hch@lst.de>,
	Justin Stitt <justinstitt@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Petr Mladek <pmladek@suse.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Yun Zhou <yun.zhou@windriver.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Kees Cook <keescook@chromium.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 1835/2214] seq_buf: Introduce DECLARE_SEQ_BUF and seq_buf_str()
Date: Sat, 21 Nov 2026 22:38:50 -0500
Message-ID: <2026-11-21-2-daily-reply-0007@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <789028fc-ea60-4ca6-ab07-065d0244daa2@oracle.com>
References: <789028fc-ea60-4ca6-ab07-065d0244daa2@oracle.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Maybe we should check allocation before seq_buf_init(), preserving the
> existing failure return. Upstream already does so following 68aaee147e59
> ("mm: memcontrol: fix potential oom_lock recursion deadlock").

Queued 68aaee147e59 ahead of it for 5.15, thanks.

-- 
Thanks,
Sasha
