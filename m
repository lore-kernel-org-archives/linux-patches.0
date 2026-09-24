Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652CA2E2EEE;
	Thu, 24 Sep 2026 00:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790209282; cv=none; b=CJ+Mpywciki1cimjE3aYqI29zzO3Y+1L4GIo6MuHrTStGDx3Y+BoHXDF3Skr0uLlDdiLgOv6/t8SVv+6VfY0gxkRlhgZm+pH5+Nh5n/9zoeWkzqe4uNMOt5VSYUDlR421oScgJSsqqG5x6mRbcFrbeMP0zrr0bPhBV8hE7BmH10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790209282; c=relaxed/simple;
	bh=oJBDwbulhQv+3dl/6JmOr8DE/kmdjKbXF18qWfxprno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDGLD7ulkgGa8jCrQIwz1hMh7iA3Glg2h/BR2gm+SnRyO5NcWmdwXFTvlpuJTQcUx9sQCjqwl7S4mz8iQrEoERtTSsXjZ1XovgaQOxi9GlQjvv2DkkV2s/esnEZLr0FglN/OLw6Ov9u4X5XTk0EwpshA4YuBB23htrAsDjNB9rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Co/AoPqq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Co/AoPqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70ECB1F0089C;
	Thu, 24 Sep 2026 00:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790209280;
	bh=nGMTxiwjgEFtjgmebmTFVMfHhqpjVxwsdK/Gaqrcz44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Co/AoPqqybyHfyuCFtAOVPZ1CRaINUD4GS7hNDThvJdxhEuUgSKUzslDnr7Dhc073
	 Maq5qT3a6VZO0oKgQl5cSQ/HoWJNe3YkXb8oSsXCj+rEEgBrHTi6dL4FHloqQpE3b0
	 Xt79y0FJBGF/FtW09GPYDx1giJ8vEiZaDY8K9FJK5IR0SYAZPCkR0722O8+pPjLjUG
	 9sWXhIC1oy0tH19OlqBdWpM8XYpeV0nzRdlav2VB5Rs2SuKD1V8YhCCJEfWHuT/ovT
	 C4IpNDKfabRxAitEmLorG1mRy6Q23F4GZ6YQzr33WQsI2XUmlu4XBV9UOjrA8dfJmF
	 pq/gCcyIGAITA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Paul Moore <paul@paul-moore.com>,
	syzbot+bf4903dc7e12b18ebc87@syzkaller.appspotmail.com
Subject: Re: [PATCH 6.6.y v2] selftests/landlock: Add layout1.refer_mount_root
Date: Wed, 23 Sep 2026 20:21:01 -0400
Message-ID: <2026-09-23-daily-reply-0012-re-landlock-refer-mount-root-v2-6-6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <6bc11809968399ed4d29493d5666d9af5db14bb1.1790169454.git.mic@digikod.net>
References: <6bc11809968399ed4d29493d5666d9af5db14bb1.1790169454.git.mic@digikod.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Changes since v1:
> https://patch.msgid.link/761a7c88d1ed83c222b845fb767d4a271dcaed70.1789655724.git.mic@digikod.net
> - Move <linux/mount.h> below <unistd.h> with the upstream conflict
>   comment to support older libc versions (requested by Sasha Levin).

Queued for 6.6, thanks.

-- 
Thanks,
Sasha
