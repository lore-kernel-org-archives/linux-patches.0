Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECB615C90
	for <patches@lists.linux.dev>; Tue, 22 Nov 2022 20:14:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74941C433C1;
	Tue, 22 Nov 2022 20:14:38 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="NjRpJrWN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1669148076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J/NC2WYkODcETvlYjDfiBUurL8mWmC3XGmGqOxTURUw=;
	b=NjRpJrWN8QaVa4XvpPirIN8vlFcWFHita5AY6PIr2zdfXQwWv+fVsZdMxH18pEYnYNwjAy
	kjBtinOVRBYlSe+7efzZ6Dz+oRAglWCuA/BaBI+mNYRZ9og9M17PVhcAr21dTJ2NkB9wQe
	juQpM/6sDn9YXDswp0GB463XlGT4OjI=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 07a7b07b (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Tue, 22 Nov 2022 20:14:35 +0000 (UTC)
Date: Tue, 22 Nov 2022 21:14:33 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	tglx@linutronix.de
Cc: linux-crypto@vger.kernel.org, x86@kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>
Subject: Re: [PATCH v6 0/3] implement getrandom() in vDSO
Message-ID: <Y30tqdReSMn8VXlR@zx2c4.com>
References: <20221121152909.3414096-1-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221121152909.3414096-1-Jason@zx2c4.com>

Hey folks,

Exciting development: one of the glibc maintainers, Adhemerval, has
written up the beginning of an implementation for this series:
https://github.com/zatrazz/glibc/commits/azanella/arc4random-vdso

I assume it'll continue to mature while this patch stews on the
list here. But so far in my testing, it works well, and the performance
boost is there and real. I've patched it into my system's glibc and am
daily driving it.

Jason
