Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E56D367B97;
	Fri, 18 Sep 2026 00:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789692793; cv=none; b=rmA8mXc2n6be3XyhQyayRlrr5utig4eLc+fwFIkRIAYloIUa0A9Vzp0RWvkCvgsYXHkxHwnucESbwP67YyuQ9+cLQB14Vv90S66BmgepMFJyZBg1Mh1i42zb+CRY3VNXepOJij8carifuatASHcw723ZUFR0puT3r4nifY/MxNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789692793; c=relaxed/simple;
	bh=Cb2fAPFkBcm5gY9VRKyDx1JATwDJlhj4xPtBKX8kKuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJBioJfrTf2IPX3i8Evo0xi8aldAC/Mqif+mvlmrn6loY9PGnrIyX8kqlbDqeRe7rastxJqmcrXnn5tN41rFAttyzBo5b9VoAtLSkq8c3/Q/agB8Jy4Ej3NzZllJZRlwp4Nq6WJ296hByUAvC21TeSCmnx2YhRiqoQIxtbd+xGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LQHT8shs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LQHT8shs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20571F000FF;
	Fri, 18 Sep 2026 00:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789692790;
	bh=W2KM8euJe77EXQqJtFQ/HTIiWp6H8RHlhrfBb7NJzYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQHT8shsKSIlkjUZ3lu/ImbMdCO/AQLSOedhpgJt7WOiJVN+9zM6oB8v9r77B6uMr
	 wv6AvoU85fXH0mDbLpdo777g6UUpTMMtg2HvMKa8gS5VGOmeE6vXzX286t598YSxOZ
	 Mrxp6a0Us0qN8p9OSk0YJj+mEUaW0Fq89rGtBgn0eeMabgdgbaQBt1133QiNA7AnBD
	 U5NTx6kYUCUg9LKRIW/1LHPfBFFHgLvo7flWMAKPxpwWp8gpLu1j6+glnxQPG+Oj2x
	 FPyS/1ds+nbw80gHHVcdt75t7qwqyj57iE1T7EjMuDJik4NBQshG58QtdPa9Rsl5id
	 YSAYqVw2WGqYA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	=?utf-8?q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?q?G=C3=BCnther_Noack?= <gnoack@google.com>,
	Song Liu <song@kernel.org>,
	Tingmao Wang <m@maowtm.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12.y 1/2] selftests/landlock: Add tests for access through disconnected paths
Date: Thu, 17 Sep 2026 20:52:43 -0400
Message-ID: <2026-09-17-daily-reply-0016-landlock-disconnected-paths-tests@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <4803353002ba5a3842e1d99ec29dcefe87d28f1b.1789655724.git.mic@digikod.net>
References: <4803353002ba5a3842e1d99ec29dcefe87d28f1b.1789655724.git.mic@digikod.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [ Upstream commit a18ee3f31fd714173a62515d049d77e76ab55649 ]
>
> This adds tests for the edge case discussed in [1], with specific ones
> for rename and link operations when the operands are through
> disconnected paths, as that go through a separate code path in Landlock.

Queued for 6.18, 6.12, 6.6 and 6.1, thanks.

-- 
Thanks,
Sasha
