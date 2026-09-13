Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C819D360EDC;
	Sun, 13 Sep 2026 11:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789298792; cv=none; b=mAfT+QHPZjTbHvInLyic7rNA9STV0IOjSMd9LgmYrZn3Z8HFUFU2A6TI46nMQuz0uAFRK9HC6GxrgBEsPXFP4TaRR67HhQHpfKIzWesZinQ9Yju3IJpGwhKVpNf4NMgNecQs7dDlxzImw4D3zsCH4OdxGaXc4dMpC0SIms1cMIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789298792; c=relaxed/simple;
	bh=h57M2gwxUjqj85U5UGWB9Jd6/ZwMHliSjF5bZMrZnQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trf//TOnLOsiRteSJd2Qiyz/pWYJ09fG6aIQ50kQc/SIXuNkWusccxT9sgr8BHaGVn2Afmm33VQgUd4skluN3fs6Z7G940MBInk2voHkr8VqpvBoTBBeWUkgckw0CAJ3DH2fSluVJe+CN3mBPzanM8WT/Bn9fR7DU9qMI3WH2yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b5K8cl0F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b5K8cl0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51141F000FF;
	Sun, 13 Sep 2026 11:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789298788;
	bh=9FMvGvPkBUkhp1MkHu67cqu6/GnxO/3ooO4BCzZnyM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b5K8cl0FWo6Sa5gqGP8fKOevgrjSjpq5f9jDFVExQDEV0XpwO9Gj79kBJao/QG/nA
	 ojEpYVWakSqzG8EKmjiFtcSgNLXYOy+9WPzlaIik64HK+6W8jVbb2hhCRsTneRqv1i
	 89BxET0iK5LsaOKXgfWe5oeLi+3+a7tFvgrKW1vyGix1c+rdWsMOjkxzIpFGvDOzuS
	 XMcvPRTggPXi+sMP+DU3/M6O2JpRabfUEM6O/oOPNzyZ6ucGKKc0NpqDLt5igK5lvp
	 9ocu6IJ9s/yplmIRt+v8BByvSXwmWKmBoLDBxxLakhpL/bm1iStmSXS34yVAH72xhL
	 3e2TkfjUnlJvQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
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
	Francesco Dolcini <francesco@dolcini.it>
Subject: Re: [PATCH 6.1 0000/1191] 6.1.188-rc1 review
Date: Sun, 13 Sep 2026 07:26:17 -0400
Message-ID: <rc-reply-report-012-hisi-ptt-20260913@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260913081439.GA8024@francesco-nb>
References: <20260912065548.086904252@linuxfoundation.org> <20260913081439.GA8024@francesco-nb>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> 6.1.188-rc1 fails to build for us: the tools/perf host build breaks
>
>   | util/hisi-ptt-decoder/hisi-ptt-pkt-decoder.c:14:10: fatal error: linux/unaligned.h: No such file or directory

Dropped from the 6.1 queue. Also dropped from 6.6 for the same reason
(tools/include/linux/unaligned.h is missing there too).

Additionally dropped from 6.12, even though you didn't report it there:
unaligned.h and bitfield.h do exist on 6.12, but GENMASK_U32/BIT_U32 are
absent from tools/include/linux/bits.h on that branch, and this commit's
decoding logic needs them, so the build breaks there as well.

> I would drop this patch.

Thanks for the report.

-- 
Thanks,
Sasha
