Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C98A3214
	for <patches@lists.linux.dev>; Tue, 29 Nov 2022 22:52:08 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1669762326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iYQ/KTiVTFwiwNmU8a7JJ846D8meD3XlX/gNgE9OSzU=;
	b=QFoUiQQiUV2VF2z1qchWWgFhF/MnTYk37NsaulOyOQzIjpR/WDG0UzMnhgFsRyKo1NsLrE
	DsERTgAkP+NhZqf8n9Kf3tTC7ibkFsQMCIMbNwpodk9utJTbwacS3kzfd8aMNLWQ+lb2Xz
	NqS4OD8RYW0u8/kOThi0EfDm9kSmIvIcpUZi86VniCTijRZVh7XFSUSmTv+tjNEa2Jq/tC
	pOtrK+PD6zEbePwiOZFMDhmYqGNe+fHsCH1JeIh8QpmwTrhOtO5Nz00yRH2EWVss1yqQU+
	UfKRxNKD153FxIMwyte+uY1pipKa8/G7ZFGdFuUxDPenquEpQR6jeBYHEB94mA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1669762326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iYQ/KTiVTFwiwNmU8a7JJ846D8meD3XlX/gNgE9OSzU=;
	b=gsYU8PR6M9rLLre6Ld7FaI8hVh5gIWrNz+uZitJu6RcNT1tYS5Fv83fK4bx2OTIvbcYUHD
	u3wX36vdz/oJ27BA==
To: "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-crypto@vger.kernel.org,
 linux-api@vger.kernel.org, x86@kernel.org, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Adhemerval Zanella Netto
 <adhemerval.zanella@linaro.org>, Carlos O'Donell <carlos@redhat.com>,
 Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
 Christian Brauner <brauner@kernel.org>, Samuel Neves <sneves@dei.uc.pt>
Subject: Re: [PATCH v10 4/4] x86: vdso: Wire up getrandom() vDSO implementation
In-Reply-To: <20221129210639.42233-5-Jason@zx2c4.com>
References: <20221129210639.42233-1-Jason@zx2c4.com>
 <20221129210639.42233-5-Jason@zx2c4.com>
Date: Tue, 29 Nov 2022 23:52:05 +0100
Message-ID: <874juhv0fe.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Nov 29 2022 at 22:06, Jason A. Donenfeld wrote:
> Hook up the generic vDSO implementation to the x86 vDSO data page. Since
> the existing vDSO infrastructure is heavily based on the timekeeping
> functionality, which works over arrays of bases, a new macro is
> introduced for vvars that are not arrays.
>
> The vDSO function requires a ChaCha20 implementation that does not write
> to the stack, yet can still do an entire ChaCha20 permutation, so
> provide this using SSE2, since this is userland code that must work on
> all x86-64 processors.

Way more consumable and looks about right. Please take your time and
give others a chance to look at this lot before rushing out v11.

Thanks,

        tglx
