Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7AF2F34
	for <patches@lists.linux.dev>; Wed,  5 Oct 2022 13:30:00 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1664976592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rSSwYd6bNGmbm7XR1pdYVuGlgLSwQidyg20JnQan5Iw=;
	b=Cs8k8+OGDvgHiVyruHBqz8gkI4o/qRuqJJrgIV/hlA1ejZjrgawxQSSIMG/+Be/nGr49NA
	rhR/Yd8g+GZqdDI9mxBswpMmHppc6qehVPpCpXVRLdcI7rlahJbug4oY2RDm4aaFrBav6A
	vyk1DFPbv7Dpn6Mv74VjeEDcEzdnLVNG/AZNGtoF+pmyulhaV2zLN7ik7uYx/M96yvqCZN
	shOot6k3zTl/wgEB9kvbdQM5ZumemXu6lbvlr9blqjHpMM2YlzEhs2n48HANMVg3VMonOS
	qEmxWXRGG6zMMa1wuxyPbpnKK3QudcsBfsNRZ+m5tPcTMj7KI4Y00zteCNadKw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1664976592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rSSwYd6bNGmbm7XR1pdYVuGlgLSwQidyg20JnQan5Iw=;
	b=HAoSXkCh7FSr0W/t57leT0N1I5E1HI27lBWiKB08Ei+FxyO8edwLz2Lp05YIxqBAYLOHNO
	HCJ/a2MGuNjcmjDg==
To: Guenter Roeck <linux@roeck-us.net>, Stephen Boyd <swboyd@chromium.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, Guenter Roeck
 <groeck@chromium.org>
Subject: Re: [PATCH] debugobjects: Print object pointer in debug_print_object()
In-Reply-To: <20221004225817.GA2749300@roeck-us.net>
References: <20220519202201.2348343-1-swboyd@chromium.org>
 <20221004225817.GA2749300@roeck-us.net>
Date: Wed, 05 Oct 2022 15:29:52 +0200
Message-ID: <87edvmtn3j.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Oct 04 2022 at 15:58, Guenter Roeck wrote:
>> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
>
> Did this patch get lost, or was it rejected ? I don't see a reply,
> and it has not been applied.

It fell through the cracks. /me adds to pile...
