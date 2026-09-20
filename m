Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6993339394;
	Sun, 20 Sep 2026 17:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789926657; cv=none; b=KxNc8ncvjpFc/7ByCfUCZgQkrSyWYzGJT4sUGcKskRrIMQsSmRUxQVQi4Bi4wRP5uMhDzNIjOdelM0/OHg6IFt/K+0JX3b08yCh0zeX36zzmeyVVTCLA60pWpiqbt2bToD43S5PMK8klo3yw1FO+tqNbysuY0hXjffyCpkGHpTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789926657; c=relaxed/simple;
	bh=iluovNO9tbvFJPUuqsbE4neWvGMroohmhwwcYTm9J3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJspnbLKJ0fkDfFRIbbXpx8QS5+zrR2Fwv2JBWC8tu4GA7G/bgRrpT248Vde4tidofb+5YPdY/kYI9/cMECdzO9XhN/JGpJQ168VnSPrUd1y1qnaSpQTkHwWOmHKhMTan8aKqDebl6XZHr9vgb3mHzMmTHUl8PVkJLeX/RQI788=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LtvFjb2M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LtvFjb2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7CA1F000FF;
	Sun, 20 Sep 2026 17:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789926656;
	bh=sh6PD9neCYVc9sJyYUFzkZ0D4zgOkh6toUXpB1T0aB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LtvFjb2M6FPDou6/QcYuYhhzbj8rXKQcJdAWwbMZn7FyJAtRPZsFKTPrZschuDLam
	 NV/Bxxbb1BhQkcHe2pawe5dzwf7DURtCr0eLRUjc7zMogAohbp6T8L4WFZ7FZxPosj
	 3ckpovqHFhVu3hoUMNBuBwfbvmzrg4T7iTPLrNhACGw/Uje1t0tUnIuHnpk/wWFpSO
	 /XyBMIVlxrVSRdApLhh7GDsutz3oBhP3ZLntjzlA8eORNpNdZFFkNQNNjklBgVLQBM
	 5zcW7NVtMicTEFGhGHA1ygs+X6zruGEk/NimdlkKyBOfaDNidQEolOGVodWvfkZ6fM
	 5h9/agtOLFPzg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	"Barry K. Nathan" <barryn@pobox.com>
Subject: Re: [PATCH 6.12 0000/1102] 6.12.111-rc1 review
Date: Sun, 20 Sep 2026 13:50:38 -0400
Message-ID: <2026-09-20-daily-reply-0006-re-ipv6-mcast-rtnl-requeue@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <98538a44-63c3-455e-96f3-00124a825f9f@pobox.com>
References: <98538a44-63c3-455e-96f3-00124a825f9f@pobox.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I have now retested with 6.12.110 + stable-queue as of commit
> afa3d2e7536e9034a4917d4b6e228a99d5bd7aa6 on my ThinkPad T14 Gen 1. I can
> no longer reproduce this kernel warning (as expected with the patches
> being dropped for now), and it's working well, and I have not observed
> any other regressions.
>
> Tested-by: Barry K. Nathan <barryn@pobox.com>

Thanks for retesting so quickly.

The complete ordered set is back in the 6.12 queue, with the missing
prerequisite in front this time, so the assertion is retired before the
patches that stop taking RTNL land.

6.6 and 5.15 are held for now. The conversion needs the two TI cpsw
follow-ups that fix the ndo_set_rx_mode path, and those need
disable_work_sync(), which neither tree has, so they need adapted
backports first. I have asked Kevin Hao for them.

-- 
Thanks,
Sasha
