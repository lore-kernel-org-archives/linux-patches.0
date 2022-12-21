Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8281E7E
	for <patches@lists.linux.dev>; Wed, 21 Dec 2022 14:04:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B314C433EF;
	Wed, 21 Dec 2022 14:04:24 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="lagTYOtC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1671631461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IGwYRqmYe1tulaCQh1AZycwBWtT5OF47TSgo9FHLK5I=;
	b=lagTYOtCAGuSUYb+3GhNLPs3gh4BK/ut2Ty1C0Zx/sNDZM3HKgGiXpx98TDP1cPHAMtqLv
	oAGcsn0dxWMuMfzdzx69weIAPh2P482PdMfkYbtTgVx2dppl2WcyBQlOxO5xiwZ63ZAEh1
	fIqORygw+AM/2k3hIVRyob1MkEkdBHc=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 65bed60f (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Wed, 21 Dec 2022 14:04:21 +0000 (UTC)
Date: Wed, 21 Dec 2022 15:04:17 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>,
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Jann Horn <jannh@google.com>,
	Christian Brauner <brauner@kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v12 0/6] implement getrandom() in vDSO
Message-ID: <Y6MSYWHl1dV2nFzK@zx2c4.com>
References: <20221212185347.1286824-1-Jason@zx2c4.com>
 <86cfa465-2485-ff24-16f5-9014e25a0e98@csgroup.eu>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <86cfa465-2485-ff24-16f5-9014e25a0e98@csgroup.eu>

On Tue, Dec 20, 2022 at 05:17:52PM +0000, Christophe Leroy wrote:
> I would have liked to give it a try on powerpc, but the series 
> conflicts. I tried both on v6.1 and on linus/master from now:

I'll send a rebased v+1 shortly.

Jason
