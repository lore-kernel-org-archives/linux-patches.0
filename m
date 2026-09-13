Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6DA3EB105;
	Sun, 13 Sep 2026 11:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789298801; cv=none; b=LtXWcw7PsHfy8vN4UmJBLskfTtYVvOZFWZwRHOiShK+sZwNO1ANy8B6j8zjHgm6Bg7XDiJYshhwY8RHmfb8wZJPU+OTbIMZgTMYGB1tNyMCboJM2xPph1mBwtkaOcagSC30eCpRZGmydIW8O+Ndd/Kf09buzrgrAnlQl/+Ng5lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789298801; c=relaxed/simple;
	bh=cvVHYZPrICfZHq5DI2sq7sTG0Qihjl7ic9Aw/C2Ut48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1a3JcnCOuOP/hb8gNXVWaMKLNNLgZlPukLjeBwA23aPOl9stRTAC6FT4mQHNc5shp1fm8r3sV8MN2HVqp3OpVKRdSMn9h5mmVfc1LnqPn2buEKFbIrKbmbblSOMoCs/QIW1d+uwt7/IvV4xEadMc47r9MNLrbuIO/ZAF4bCPNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L6/dLv9X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L6/dLv9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA7F1F0089A;
	Sun, 13 Sep 2026 11:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789298799;
	bh=+/MKqkLmpVM9wR80B6Re3EtQG78nQQ8BxYwTwIiGKOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L6/dLv9XgQGhtOfy0Yz8uOivpOeiYQvdWu4w+J7phlTJbrApVHqD0dqAHEFOsHFSM
	 pm/JcgcumySAEe2fgqRYokaav7UaJSzHSs3oOvXEhClPlHuou8iwniEvtWcyCs22gi
	 sJtqOHSUu8AOC0eonZ0ZXiOGv6EpslCSijq4xnsdARpbJXzi6k2V8jjtZgc9u9evl5
	 qk5pV90l/LtfFd7G5/X+hQgWQpG9Dim4AfYb6d7uOBMrdnO3FehTp+Umxfg+Z1/8lc
	 C8lYoCcaUuMLIH5VwiZWmIkIi9Vf7aFOHoSRhpMxgpGuuRwZsXoopqL334MaQTZpp8
	 1F6Qem875JOGA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 6.18 0641/1518] s390: Remove compat support
Date: Sun, 13 Sep 2026 07:26:23 -0400
Message-ID: <rc-reply-report-015-s390-compat-20260913@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <eeda754b-8da6-4071-86fc-257db902bbd3@app.fastmail.com>
References: <30fec0a7-619b-44d9-9ca6-e5de551a8c0b@app.fastmail.com> <daily-reply-0009-re-s390-compat-removal-6-18@kernel.org> <eeda754b-8da6-4071-86fc-257db902bbd3@app.fastmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> but an old distro release should certainly not break existing userspace
> when installing a bugfix kernel.

Fair enough. I've dropped the whole block from 6.18.

-- 
Thanks,
Sasha
