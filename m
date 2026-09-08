Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2140B2472A6;
	Tue,  8 Sep 2026 00:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788828848; cv=none; b=UZf9Wi+HbF9iBDF+acz/G5wCUH9LzeP5E44cjo7E0kPlv7hEomefHg0MwY+TIwU4eY9caqwob7uHoghzAY2bzt1N7p4lEgCckqYwsDF52oLn3o8P//wty2Mop4O0hMEzBMBjJSohxq9cIzGK7IbE5a21SoanMDd7hVO9eFsivXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788828848; c=relaxed/simple;
	bh=oEVAJT7Rms/zK1FBNPVdP2B63nHgLDx9qjMY0xru9i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IWeICOpHeqhSv8phXmWkfow+0jIZFbtMI7bkW79NzUAehB3e1CejGK4Ea0IUOauJdjjh9Gcu+VZlwQldL7VtSwaOhxexirSMoQo86mtCoNsON+xYbVY2TwQN011xXQvE404ywCMs3z5lA8HWNhXpgjh0mFxWNRVm4q5rsdn2HVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K6SS3R+e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K6SS3R+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2441F00A3A;
	Tue,  8 Sep 2026 00:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788828846;
	bh=ezFAhvlLNXRJMYF0BusyoobUQ/NrQkNcePRif8khHJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K6SS3R+eYR/sZ/dRNUocuFE4jgsUbr1UzB0/fvmMJfNPZ4HoAgB/kTVObKsfX1n02
	 sX/tmnVoo9xKVZYMpdVvo+dZy7e0Tkq5xifwceVX/TEgX4pkLyUPTpIQeASGIhpG7O
	 yMBjP16e4tB1mP7VPRJ7jq3zl+7R0gla/LOwJskkUQQuFCnzuYlT55OJePAU+R6Td9
	 L6MTm1nd5wmGgHFBi4+aqHFas9c/Tkq2G/xH+d+/TU9Xsr+IljWSBykWuLhrM+oL1W
	 B50X2GH7bjcAm/VjSr9ES7jjv3pKRv5bv8JBOmvjIfI5+PptD9sc4Hr+d2FqGAUTG0
	 ocxJNj6W+HUPw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Sabrina Dubroca <sd@queasysnail.net>,
	Breno Leitao <leitao@debian.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 5.10 28/43] xfrm: espintcp: fix UAF during close
Date: Mon,  7 Sep 2026 20:53:42 -0400
Message-ID: <2026-09-07-daily-reply-0003-espintcp-prereq@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260905101704.GA47841@j66a10360.sqa.eu95>
References: <20260905101704.GA47841@j66a10360.sqa.eu95>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

> The fix actually has two prerequisite dependencies:
>
> Commit 028363685bd0 ("espintcp: remove encap socket caching to avoid reference leak"), as mentioned earlier.
> Commit e1512c1db9e8 ("espintcp: Fix race condition in espintcp_close()"), which relies on disable_work_sync() — an API that
> does not exist in the 5.10 tree.

028363685bd0 is now queued for 5.15 and 5.10 alongside the original fix,
thanks for catching the gap.

e1512c1db9e8 is a separate issue and is still open. disable_work_sync()
isn't available on 6.6/6.1/5.15/5.10 either, so it needs its own
resolution rather than a straight cherry-pick. Still looking at options
there.

-- 
Thanks,
Sasha
