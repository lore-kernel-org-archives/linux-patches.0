Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A87F3624C5;
	Mon,  1 Jun 2026 11:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780313964; cv=none; b=arIRuR8ZZdQS6/y5Jh4r/W4NgIBNvKSg+doUwxRTq0ooyhKvvhzl2Ji9O6vkU8n0vCq3W+eeCAB/I72tpW7IEt0jMAMD3kPyxDn+iCvt19M9ycQWOUZ2NkdfqzKhdn4LR4wuMpY+g2BMcG4p1AXYASwoAX/ywyTpwIA0SqWNLYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780313964; c=relaxed/simple;
	bh=xeJPerOtPlGsNmIwybWbAMdHt/J8RboC7i4kzQvYfSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFJ7SN2ECo8zBDQEZJz5NTWoUsM0tn/jkAdXjy19T6h8aanCn0nljN5340OQTqOp1gRGesyMkk/QBHMXjjL3hPFcwYW51luJp8JQwmPrgg1I/pAo+4NoGfKDRT6R5fu2+D5xTDzEFC1yizQC6iyRVd7J1N7LhzY/a1rMBsIQMRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EeLQEutC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EeLQEutC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60E71F00893;
	Mon,  1 Jun 2026 11:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780313963;
	bh=xeJPerOtPlGsNmIwybWbAMdHt/J8RboC7i4kzQvYfSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EeLQEutCamdHjdKK4pfsfBuxfEi7kogr1qBRgkuhxucNq6yLGno1DvS7JwftohkC3
	 8gEv1U4b13FNuxioUWqs+KUW3NikA2kPMuJQHiQbOu3tm9BrYu9x9tdDhs97CC1xNY
	 LTJYX+nRvlSENmJQ3mkan3AmpSk16t2EqLMxQtCwhD/3vahBP2WsRJyxKIadPC/9ah
	 AuzmTVk9kxPQNJo+UFDhE7fo19E91AjrWBC174b3RWx04+6BL/oU/bECkyngEdJzEM
	 LlN6lkPy6kl0cue/R5yMgzPUz0SZjZK0Mb/x9E4OgWpXodoaU7wyjwuebayZjHkasM
	 NFjX381MfTFmA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Bean Huo <beanhuo@micron.com>,
	Stanley Chu <stanley.chu@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 5.10 096/589] scsi: ufs: core: Improve SCSI abort handling
Date: Mon,  1 Jun 2026 07:39:20 -0400
Message-ID: <20260601113715.scsi-ufs-abort-keep@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <70620d4eddfa13b0b5333e482bb76d7f4b323114.camel@decadent.org.uk>
References: <20260530160224.570625122@linuxfoundation.org> <20260530160227.218464986@linuxfoundation.org> <70620d4eddfa13b0b5333e482bb76d7f4b323114.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 2026-05-31 at 16:31 +0200, Ben Hutchings wrote:
> Since there are no patches to ufshcd in this series besides this and its
> revert, it seems like you should drop both of them.

We could, but keeping this structure makes it easier to track in the future.

--
Thanks,
Sasha
