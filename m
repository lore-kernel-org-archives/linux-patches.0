Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51605474E;
	Sun,  6 Sep 2026 15:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788706962; cv=none; b=GwCYVBzrcI23XprV2qoWScZvit7dA6zC4zdOG/0ZsYA+H1F0bTbzPbo8Hl1g+y6qcMP6QHD+0cZ2+fyK9vM0/c09Sdp3i93IRh6QWzw8XISy/y+jTjGzxEJtg6LTRpvmPUzL8SUmCS0Gue2x3yHo1bk0YlBf2amlowG0HRc7mIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788706962; c=relaxed/simple;
	bh=Jd7YoDN/HfVyhZpm26+KyGu0CDla4avLVMGAzF+8aqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CF8u7rs0XbA6XW9wts49ucB5Bq0nVCUsW1NI1WtEE30TjtkN7ppZC/nYn/xVCEPR64uZWy5aLA4kqjw9O+hubYVBrlz/SGwWoz0IrBPJ02yb1DN3v3SAME6Tpg8bbUlwUF03ju3L7H/z84YZ+SU7LPyBty7utTEmt6i8xn2oTh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=on9oiWv+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="on9oiWv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41791F00A3A;
	Sun,  6 Sep 2026 15:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788706961;
	bh=B3suhubz4AbdZoXAHXrlO4sE3GeAAT/KGaHnrfUjoBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=on9oiWv+2dApIoB2B8Twn56e3GJTqN1qqxyDHh7qx3BZZ1zsRSq9Kt3GtD6Qne9r6
	 A26LF3XkFnqMv3vmx/4UG6QLtG6Tb8z8bG7WqIdDCLc1NhcCQmrm6ohsmdVDOQqyeR
	 xUHIQnA9U+1BevyjaCXEGEvZlUT+/ShNpXgVR9vzeclVRsTO2AuWknmmlSdgQg7pJJ
	 FPgSPzrOEMQ7FO3SdR41WPmOF1XUVL8r8q7IeH6s9GTuwuHf/Eyc56fCCVnmRvRfjm
	 ST66Yw9tpQpMylUfOKbRzA4ytNHr2Onql/ZSufhV8wknX07Y6MmGVJ55Zhh8EBKdf+
	 MW3R30SxLHKow==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 219/403] svcrdma: Use svc_xprt_put to free listener on create failure
Date: Sun,  6 Sep 2026 11:02:31 -0400
Message-ID: <20260906181200.reply8-sasha@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <a49a7c72-62b3-4fec-96f3-8c2067f93dc0@oracle.com>
References: <20260904045734.806166532@linuxfoundation.org> <20260904045739.846116733@linuxfoundation.org> <a49a7c72-62b3-4fec-96f3-8c2067f93dc0@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This needs a coherent 6.12 teardown adaptation, not the visible hunk
> alone.  Without those prerequisites, I would suggest dropping this
> commit.  Thoughts?

Dropped from the 6.12 and 6.18 queues, thanks for digging into the
teardown ordering. 7.2 keeps it - it already carries both
prerequisites (4488e9129737 and bf94dea7fd4e).

-- 
Thanks,
Sasha
