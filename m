Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD292522EE0;
	Fri, 18 Sep 2026 19:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789760758; cv=none; b=MFtpY4RK35G+hbFJ4mDcI45HAUP99F2bqEfBPN0dwaqyNfYg1IzigW1rF6wy/JUZylJO9IV99Fwj0Ar9Zzv/fxCcCnmUXgA77qJDM8gom3kDcGOJRZQ5b2DjIGjZHZWgn8km4eAKGOfj9NGkMxpQg6ZSR8y/f6jeNvBziIBFUqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789760758; c=relaxed/simple;
	bh=6hcpN4zz/mSiC+uVxNoeNhZmRLqJE75QVYvYQkUh0bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5kRyMss1tocMTcr09pU3hKETt2i4WNOWX38uzPpPB70Ww0Q/1rdUS1HWDhLFoeQbBC/RngsLOBNGRJ66Kzj1+dEoEx/V56irBaivuwMoCIIkLOQKpKB0uVBtBJJdHRlFjIU12MY6q0zjb5SHNcvyCUOk4SPIackP76xRt19nBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l1UP64yi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l1UP64yi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5551F00899;
	Fri, 18 Sep 2026 19:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789760756;
	bh=nY2sWF+8ihyHC4RkwMM6KjNpeaATC0WBdaeX1riSbps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l1UP64yidsEab+402jz6fdRwzlWpX6gYipUw5b5be8V1T7x3dJ6mn+6UIyk5SEkPR
	 LBNmHRAEHLa3vlOK9vtu2ITz1BEJxHVcBCRDxt58bYnbdbjq1uOBrfWBPkcgynua2U
	 5W5qvgdJOX3fyo1+ba5FfEYCAIEKveuQsPzcZ3zXvBFZLNtJ4MCVmKtV7j8jiOR1jV
	 tkZncDUVQyxOT131PWUmFN+9/khH/EDXrK1h5MXtMqOIG/8nPZVzTA/KAE4GQm11vf
	 EZYoLNpqXbSjvvS87p0tDdt/lXn9lXNLs2sa3uFChy7ysKL4jw3bjEbDPTaNgZxIyf
	 WIseI3f9YZFSw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>
Subject: Re: [PATCH 6.18.y 1/3] selftests/landlock: Use an actual chardev for MAKE_CHAR audit test
Date: Fri, 18 Sep 2026 15:45:35 -0400
Message-ID: <2026-09-18-daily-reply-0008-re-landlock-whiteout-6-18@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <200794b92b5f014ec277099a0b64e4ab375a0a89.1789655724.git.mic@digikod.net>
References: <200794b92b5f014ec277099a0b64e4ab375a0a89.1789655724.git.mic@digikod.net>
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

Queued the series for 6.18, thanks.

-- 
Thanks,
Sasha
