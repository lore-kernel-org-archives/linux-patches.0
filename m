Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760BB5226A3;
	Fri, 18 Sep 2026 19:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789760758; cv=none; b=GibqaBCw5EaMmlTFHOmsfnL1E99oM373YvgrSQuYL6znvnDvEs/XKdaX7MZlIheCNr9QaObOooyW1QtG5KAgKNXkgTIIE9WE+QfTL07rm7yTKoP9E8KkynhOwbUlNkJJ9zqk6/qXpqliVJpML27OfBHqoJyJHi25koDe8K+RPcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789760758; c=relaxed/simple;
	bh=Dwjeo8yoCVp1CIuQC7lFe3Q/EQfkbj8ztnJ4kqCrb1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIcPW/ogglZlxh1jaDK1T3yBEE8cAH1Adgdk/tmqtEZ0UGHWETl62GCj765PeOJEz4LbphhTiGp/rPORWLyY5cO2w8FIlMBR3wpyWz6RX2BtA8baL4sK6y0MxS0Gq49q7yGhl/rNMDFvkDQyZvEc9+KVBAcntLBHnjMLfA5qaI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JOYXd2jD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JOYXd2jD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C62A1F00898;
	Fri, 18 Sep 2026 19:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789760754;
	bh=pMoGLHx68/CtLohLjnvJ9dDPie991nMF5rPkh4IKIhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JOYXd2jDqO8zPpeVKzhVnP9VQM0tDuDpIjOLFg5n5uxVp6Or2j0uTU28+84uj/dW/
	 9fEiwc7MccJqPA24SdMrGjghBB1jROXbDV/7g6aSTT8DGCJmyykHxCY4reyllqlFyL
	 SObjS+HlovwYoBXWO1ttS+NjRurVmK+y2yOWhSx4EdxwswpHvfrIzTd4FuipyNDnT8
	 LK37yYSGwaOpt8zzqCDznVzpSUC0C5u3V2t39K8pF7FfZo0GoYvcmODnDM7hlVZzgs
	 GY2JsesuGb6szTFTu8HjGwQNQeZtXDO5RdVZf8pHKYDK58dZl9waw4yFklw2NG9IKU
	 m78GNvjw8wNyg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>
Subject: Re: [PATCH 7.2.y 1/3] selftests/landlock: Use an actual chardev for MAKE_CHAR audit test
Date: Fri, 18 Sep 2026 15:45:34 -0400
Message-ID: <2026-09-18-daily-reply-0007-re-landlock-whiteout-7-2@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <1aa1d524419bd5119577f0ccb8b6c058b32021e4.1789655724.git.mic@digikod.net>
References: <1aa1d524419bd5119577f0ccb8b6c058b32021e4.1789655724.git.mic@digikod.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> By passing a (0, 0) device number, the audit test for
> LANDLOCK_ACCESS_FS_MAKE_CHAR was accidentally creating a whiteout object
> rather than a char device.  In preparation to treating whiteout objects
> differently, use an actual character device instead.

Queued the series for 7.2, thanks.

-- 
Thanks,
Sasha
