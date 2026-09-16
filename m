Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E922941E6CD;
	Wed, 16 Sep 2026 19:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586934; cv=none; b=TESyc/ULsyQs0KMBgSldzMdWLzKShSnFtPBbDQP+RbLx6hmyzfpuX2bDgvX7dttouDpUVtL19TwSB7S0QnoLGvgK9S4mjD7tpWSdWSazixeJQsXSy+B0D8H7vE58TcCceSepY5c5q3OCpzSGT7jtdlblrZIpspZFlRTkrFLi8e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586934; c=relaxed/simple;
	bh=fvzOvAg+6CL6TYbbGh8hUbB70IXVNzcD/KLCvYEempE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7bv2YZ6S/YROETt/9zddSbGOwj906qyDUrcy2IaUzIXat89tJ+kEJ1eWEdH85gCX5YzY4H0YoyeuSBpVpLMnLsIZuHtPOjBFRpO9jca1/ZncxSkAXzvaCsQKUiAuIekpnkEgG0gxOBFZY4xcvIBH7TLLlkdb8b0KBwFh90RjIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B0InN1HW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B0InN1HW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61691F008A0;
	Wed, 16 Sep 2026 19:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586917;
	bh=EaZslBDXffXVWoEXC8TWVsxseAqRdIjzyvtc5IRFpuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B0InN1HWmyH+YZtqtF3jiy1Fylvt75dkiSuzX6nXznsM3wMR4Yax4/P6IMaZB1n7R
	 NB+VBcHJY4FlMkfSeuYoYba/UF6qPHvXMgNn7vexh1g9pOCRinluu0UL+Dy2uhPKzs
	 MZP3MIn7D7UeTd+kEm9BscwrLPKdw4U+kmROyR1RnBpep+FO6prKZeFolbXe48uWB+
	 Bv3HzIFYHNvO4ulg/fyOW4ro+S6oKu5FqGrqX6bMny5PUJWXJhmEdYPyuRlBqW7+BR
	 Bl5UcVf99xN2vcFHfwq9LlJvsNgvFx0OqAShjnbEifxK9YscB6Rl6b1MO/MCGSR6xN
	 asrv+zbWtAG3A==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Aaron Lewis <aaronlewis@google.com>,
	Alex Williamson <alex@shazbot.org>,
	David Matlack <dmatlack@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 1096/1376] selftests: harness: Mark test fixture objects __maybe_unused
Date: Wed, 16 Sep 2026 15:28:00 -0400
Message-ID: <daily-reply-20260916-0010-re-selftests-harness-maybe-unused@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <9a88dda4-16e8-4205-8f28-428f2da245d1@oracle.com>
References: <9a88dda4-16e8-4205-8f28-428f2da245d1@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I suggest taking the kselftest.h definition from
> a7498388b099f08219bad5f19d00e436da27fbf9 before this backport. Thoughts?

37ffa24c9d07 ("selftests: harness: Mark test fixture objects __maybe_unused")
is a cosmetic cleanup with no Fixes: tag and no Cc: stable, so rather than
pull a second selftests header commit in behind it, I reverted it on 6.12.

-- 
Thanks,
Sasha
