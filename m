Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AED04279F9;
	Wed, 16 Sep 2026 19:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586960; cv=none; b=BmOQFEHYWkIBU2/iUexI1T6SFJlONgw3EPQQDqJ7cexgdoNcRLNNuXEYLEzwop0eKH9UqtCt8I4muFc0NalhM+jnxubIT2j0LWPLfdfNdAxWBO5CYHtbCYgzuyUIEeaWltJox62mAKyfPOh82ypV+C/o+MNvxH4oT2ZZBguXE88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586960; c=relaxed/simple;
	bh=su2s6FraLVODJMga0xyL4LC6k1gvAAoBM9koNN6gwOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxVxy4WjSrJnMrM/e5CEkydy8BzuqTnEJxsM4YdnvFuCnxZA9/Vpr6AQBK+W8pOsg3lt9kwHt6CPL+F2601FgKTLOHHAD8eleDSalcWpbZLa3onpU4XNUkP04nCkHGN3QZQbjOah3sApvniYpRHuuv6ZtjnXcmR5/XJY3aBbNWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E1BKNVTj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E1BKNVTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D071F008AB;
	Wed, 16 Sep 2026 19:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586934;
	bh=wC7t0oAWJa8NAFtLiTSXnCmDKBIqZ1KapPYK19zOGiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E1BKNVTj8DoHTb/nxb/9QI1Xy+DpWdX9VZv99yXzWgknzKp8ClFkjwbTLzqPm+EbQ
	 BEg0mWCbYUNKgPbXGAXeYG879S2eq2kaPUf+BvS65FXnqQXH7jwIN4sS1SyJjkHRtU
	 Dn0CQWllp/3nH0Dh4poD9vYMwvCWrpCRjfjRY9bwS/pKWN7fZz9ZmPUBdDc/4wYeSy
	 u/4WBE66k9vSjsNQCd6I9CWmgrkmHroMeUNawtm6J4uOzsEg1SCv5rLd98Bad4Lqaf
	 bKEmwio+rDC/7Y5NjDl1uu9S5wx294IoN4RWFRvgUSrQMbpIW4YVL3Dq9V3+Lis3zy
	 sRcF2MaV+6Y4A==
From: Sasha Levin <sashal@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	syzbot+b7f6f8c9303466e16c8a@syzkaller.appspotmail.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5.15 879/935] bluetooth/l2cap: sync sock recv cb and release
Date: Wed, 16 Sep 2026 15:28:14 -0400
Message-ID: <daily-reply-20260916-0024-re-l2cap-5-10-revert-hold@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aqoaFdvSsDiiLb5I@gmail.com>
References: <aqoaFdvSsDiiLb5I@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> So the revert on its own trades the deadlock for this. I will send the
> l2cap_core.c hunk, which also fixes the unbalanced unlock you found, plus
> 89e856e124f9 without the recv_cb locking. I will repeat the runs and test
> on some real hardware before sending.

Thank you for running that down. I am holding the queued 5.10 revert of
89e856e124f9 ("bluetooth/l2cap: sync sock recv cb and release") out of the
next release until your series arrives, since shipping it alone reopens the
NULL deref you reproduced.

I also withdraw my objection that f1a8f402f13f ("Bluetooth: L2CAP: Fix
deadlock") is unlandable on these trees. You are right that the fix is the
l2cap_core.c and l2cap_sock.c hunks and that the hci_sync and hci_core hunks
are an unrelated hci_dev_cmd() refactor.

-- 
Thanks,
Sasha
