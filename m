Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C64A41D647;
	Wed, 16 Sep 2026 19:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586960; cv=none; b=ADTvhEJ9rwpK511/0PqQ1zNpRdAxZ5bc3yQu0ILtNM6u7YwCcRVYDVIsUc1wxEmr0rQvwOXzpHqFHrIPGsN/nq2Nc6si+1id1qxzv/DiY+QZ3u0Q4qlk6fuB+DS5j3ofZvxocLjL9bHx6BTKgNiM+LVtFDKEK7T3pE/5wqPIKds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586960; c=relaxed/simple;
	bh=rHUqm2UjLAeB7U8JQscQw++E1G3DyMz0xDIKonFQOBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Au7Dt4r0NB0StVjcCmAVTLY4bjfBFqZxgp/8NtDCD9zSfu63ab4Fd5IS44p6XVMxRzj6BiUZISa1iAi1giKjooqUErQKtPPIbLgSoyitt7D4ZyiUHVGc5xNqhN/Z9eQ3nN51ZYbvE/vG4UPtShEYbPIWYjtMVpTJaHRwztmte4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KNwrYgbw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KNwrYgbw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9011F008A7;
	Wed, 16 Sep 2026 19:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586931;
	bh=+K90hUcY6+CNytfsBDoQHthfqgg8vJ0wOdTslSe6LSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KNwrYgbw19h4zpVCAfofuie66fylf9fROKATaFJOvCQn5WF6roJfxlWfPtQrrPF/o
	 PLM3WL1IdW6T9uzEES6h+/bJIYpxppIkzmw3mIUdSlDXGHEDd5RrlU545Ps9TqDgPX
	 a+Rt+JMxgVELilXc8phXyCFHIac4bX0EJUNIjiMwphEi0t8sgo/Hs3co1tfLJPBSev
	 SMnx2rTHxCo/xfN4GT7PFbtpxF+RaQqap+Yu2yf+rh8hnBgiSks5VV7ndhUNVMrorG
	 mXo1kI6xynX+OG4NLX9i1PDDV8cCh4SGrp6z8vJcDWVk45kfVW0yORwi3fjuPttYd4
	 R6aFb9qr3oUPw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 1268/1376] s390: Add ARCH_HAS_PREEMPT_LAZY support
Date: Wed, 16 Sep 2026 15:28:11 -0400
Message-ID: <daily-reply-20260916-0021-re-s390-preempt-lazy@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <1910ceb0-7b9e-44c8-8ee2-a6a86c7f6095@oracle.com>
References: <1910ceb0-7b9e-44c8-8ee2-a6a86c7f6095@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I don't see this defined in 6.12.y.

Correct, ARCH_HAS_PREEMPT_LAZY does not exist on 6.12, so the select is
silently ignored and 9de3e4bf6cfb ("s390: Add ARCH_HAS_PREEMPT_LAZY support")
is inert there.

Same answer as on the powerpc sibling: it came in off a Kconfig context line
rather than as a real dependency, it is already released, and reverting a
no-op buys nothing.

-- 
Thanks,
Sasha
