Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E2A36197E;
	Sat,  3 Oct 2026 22:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791066994; cv=none; b=RKpBpRx5LN1xxFR3FN9oEZAhooCK6YzFXccKBGa6eLtY1L6dKRA2yUC81zHT+xlLS7vjGUGwEptBsl61S1ilIz2EbgcCyokjVG2lmIlJMkIoah6+G1CcP9AVmp7g/GHH13GJLFyC4GDb3wAfl2oxgBmwXdRV9seZ3Jy5Rnhz7Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791066994; c=relaxed/simple;
	bh=6uXQSVa80ue1ve+9qg9AIByLJluqzWQm2hgb88R2E74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKfCFIp95kmokh17UkjKZaX0CgqLOjgz8IqPg8JDtRXO6jtzf3fe+vLYs1XiyjRnGBuWrDTXiaoYTo7I24PLqCMCWA00maO3Olcjry140TpF6zd6foCwtQqqt87qIZVwLY+PVpQXjFZBC673TUeQJ5Y4G1fVP0tsGyGfS09J3E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ge5UU1kr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ge5UU1kr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3F61F0089B;
	Sat,  3 Oct 2026 22:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791066993;
	bh=ZAh1+NUvcyhqmr0PfDJL3K1ygNoT235EjuzbmYaKAyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ge5UU1krYvuRbgi8ZYYGKXJscZ5Taf+aEIn5LIJOb82hOC6yVw9PgJpBCDh/Q6802
	 0igI59B36nYHhLTnz7TG6jM3h/sfVxWKtkyZ4MHx038qVSz+kuMLCBuV5WM4IrLLbe
	 H/W/r24tV0DEP5dQ9mzYrFRdZ3dNT0qMopb3w+S9L6nQMRobcWKgx7Slz+yI1HgzXy
	 4bT80hDMNIPj4Dz++tEmDv6kvDCH9TMePhcuzfGi+RUuvl7L0MdiqKnonF4RHNuHRx
	 QaR1CCxPyOzj4pbx28a0HM6vuAp88CwI49UTTgKfmLVKVCgsmBak4lF8UdS2yCGf8n
	 NBFVqNZ7M8ncA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	syzbot+cc867e537e4bd36f69bb@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 223/752] wifi: cfg80211: validate IEs in cfg80211_wext_siwgenie()
Date: Sat,  3 Oct 2026 18:32:54 -0400
Message-ID: <2026-10-03-1-daily-reply-0013-re-cfg80211-siwgenie-unlock-fixup-request@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <93db0eae-f479-4343-a126-59987ae0dc22@oracle.com>
References: <20260930152358.131179731@linuxfoundation.org> <20260930152403.080560860@linuxfoundation.org> <93db0eae-f479-4343-a126-59987ae0dc22@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I would suggest keeping the validation and replacing the direct return
> with err = -EINVAL; goto out; so rejection reaches wdev_unlock().

Agreed. This already shipped in 5.15.222, and the same bare return is in
6.6.158 (where it also leaks the wiphy mutex), 6.1.189 and 5.10.271.  6.12 and
newer use guard(wiphy) and are fine.

Could you send that as a stable-only fix for 6.6.y, 6.1.y, 5.15.y and
5.10.y, each with a Fixes: tag for that tree's commit?

-- 
Thanks,
Sasha
