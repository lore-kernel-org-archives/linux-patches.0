Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9CB2EAD1B;
	Thu, 24 Sep 2026 00:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790209283; cv=none; b=n1pzEUT/ov80CWr9cbOVHyROHoCu1IkVghl2IY0gecKeGDWR0eyAuumKG7s9HknC96JREF6oe0woEpr11N0h73beWg/Ne6Kb9JbPIijSOdRw/VVFqGQ/r6DfSIl5TsLJ5Anfdqk2mBFvXxxWVmOqEDSUzaV15r8butbvp9xWHFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790209283; c=relaxed/simple;
	bh=Yec/zZtK9xVy+fMXhVV1KknjYomzD5CRlRvF8KJ/hSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArguJp4pKgzZGKfxEOtCdB6cpLJVId4tey/YYW+s7sC9kP0PdwylZVfl7U4ruqA3SJazqhPLVi4hcbTd13BlKbIQmtWBw2PXW1psx8U7WoCGfNqypVlTRnKvBhugIWXsk9ZbRcjUChz1ZVFZjzaE9tIa3XeCDN7NrXK04cWXgWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mxoKmjGf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mxoKmjGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1B51F00898;
	Thu, 24 Sep 2026 00:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790209281;
	bh=yco52VnvGR8Ilc9xwCu/xe3MP4YAQM7JoEiExTTVQLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mxoKmjGf3uzKXGjg6NoOA/Lp8PgH/MUM2DHBwVyPKcliTxirfTv7PRWcfWR1nFjpD
	 OLiBCiG7VnvB8W1Oc174QnBNsa4Qio9lrYdckT2uEzpXRX7kfi2EtzXti6xhseHnxM
	 eGhjszaCGK9PRO2sgTzyJ1nN0KmkMNaQxk4qZBFr4yDrsUoujyvcKzzpvHd1WgMbZc
	 8R62TUhIyOjBoWBc0cBnxL6tZLrs1IWFYChP8v1wXuI8Wh1SES19BRgPpkHeFbS8Wb
	 eb/5JFSQkEEG9fM/ZLgH9jyfda76YScIwY6Gz9Igh6IH1YVOQYaZnrKpFkxH+CYnBy
	 t1/oqsGQInEcQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Paul Moore <paul@paul-moore.com>,
	syzbot+bf4903dc7e12b18ebc87@syzkaller.appspotmail.com
Subject: Re: [PATCH 6.1.y v2] selftests/landlock: Add layout1.refer_mount_root
Date: Wed, 23 Sep 2026 20:21:02 -0400
Message-ID: <2026-09-23-daily-reply-0013-re-landlock-refer-mount-root-v2-6-1@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <6d6d7bd89976cbca94e4797cd60d4b155eb96393.1790169454.git.mic@digikod.net>
References: <6d6d7bd89976cbca94e4797cd60d4b155eb96393.1790169454.git.mic@digikod.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Changes since v1:
> https://patch.msgid.link/661e8a7821258da80d7ab0e2c2d7e19b07ccfae0.1789655724.git.mic@digikod.net
> - Move <linux/mount.h> below <unistd.h> and restore the upstream
>   header-conflict comment (requested by Sasha Levin).

Queued for 6.1, thanks.

-- 
Thanks,
Sasha
