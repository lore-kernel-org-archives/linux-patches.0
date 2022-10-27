Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058ED7B
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 00:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3BEC433D6;
	Thu, 27 Oct 2022 00:26:20 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ijvBgS35"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1666830378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HZh5FWwEvzCuhST+974hqDrLBeiYLFft+qhaMj5G6Ho=;
	b=ijvBgS35qx77Q6OuYWVHQQhN8Ek5O5KVhCos6P1XBafKefl4iX8B8ADsQekO31PsV4DGkd
	YEafpYICYmF9bPegSuLwXUzTJB0AI4608lLCydPDsYBz7iUjxg9Ql8UxV7azbJVvfC35KC
	GSKpDJj1ctp4+Df0DzHIjBtRAM1Mqrs=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7e9c09b8 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 27 Oct 2022 00:26:18 +0000 (UTC)
Date: Thu, 27 Oct 2022 02:26:15 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Marco Elver <elver@google.com>
Cc: kasan-dev@googlegroups.com, patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] kfence: buffer random bools in bitmask
Message-ID: <Y1nQJ9ZFizv0bzgI@zx2c4.com>
References: <20221026204031.1699061-1-Jason@zx2c4.com>
 <CANpmjNMmHa04Fqf5Ub5-vz6HuqT_Gg8GmEfKD6rv8JeMfBZ32w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANpmjNMmHa04Fqf5Ub5-vz6HuqT_Gg8GmEfKD6rv8JeMfBZ32w@mail.gmail.com>

Hi Marco,

On Wed, Oct 26, 2022 at 05:04:27PM -0700, Marco Elver wrote:
> Is it to avoid depleting the entropy pool?

The entropy pool never depletes, so no.

> kfence_guarded_alloc() is supposed to be a slow-path. And if it were a

Ahh, my huge misunderstanding, then. For some reason, I was under the
general assumption that this got called for every allocation. Given that
this apparently isn't the case, let's indeed just forget I posted this.

This then means, by the way, that there are in fact no fast-path
users of random booleans, which means get_random_bool() is totally
unnecessary. Before I thought this was the one case, hence open coding
it, but luckily that even isn't necessary.

Anyway, sorry for the noise.

Jason
