Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6906337E5DB;
	Sun, 26 Jul 2026 21:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785101099; cv=none; b=Qf5LC6MC1+ML7xKxhTAYRjPfnX5yUC3gWRdONL1E0LFwpNY/jiE6cxf2+FSaVeJbg/BWRgOORbkgkoCmCVFGjv1t+21j0BuazKafhDLSRWhq0A3ut6RPAGZ70fYBCQZezkxSD5IaHxbvEUg7cDBIvNJE/vlh2WaUWbYUoW7+OOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785101099; c=relaxed/simple;
	bh=5ZdJSOOCPBhipHepk1azdLqSrq4fY/1F3sVjK+amoLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYenAtwUb5WkjtsK7qtI7GVHmD4CycnVmGCjt12Dw/EcxkfUo1LIweg8h8voY8U65B1O9FuQmLdp+7rbAZ6A/dCtOaPJQqUBg3hbirYxtisE8qYU4M4GvIqNT5/UBuzKKEvcxhrl20/Int+h5P3ZMKIXriAmWu3aXj6f26n33/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ooEejfeK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ooEejfeK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31131F00A3D;
	Sun, 26 Jul 2026 21:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785101098;
	bh=lH95FImYy8DUaXS4D+fuUvnTWLIR9sGCoR4vzbMcuiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ooEejfeKuvNG/ge4aWMt78qOh8xtFlYQIhzLEXtxwjO0jhT8KpejKLb3ArkSx8jUU
	 hgmIbwEENdQfL+03pZtETHUp+HMnn7gTgJnIyiiNJngvS4A7pjcd5mJce80PodtZIz
	 uQMyuTxrZq8GA1fWuLYu0ymIF127KqYBViASd5/skQ9a5NanIeuQmck3rmQUjOgAk3
	 nKcHWm/nQ5vHjzR942Wh1NJMjWi8V8j+QEYEpUnLBoHe8adlTTq79GIaatiF33+uvo
	 z2062TOfY/LV5mUknHzjxQZ33lyqCY/DIDHiodJLirzXMu3GbHGBj5DutisK8TBuwz
	 UG7te8mTAGdmw==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org
Cc: Sasha Levin <sashal@kernel.org>,
	harshit.m.mogalapalli@oracle.com,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	"Zhou, Yun" <yun.zhou@windriver.com>
Subject: Re: [PATCH 6.12.y] ext4: validate donor file superblock early in EXT4_IOC_MOVE_EXT
Date: Sun, 26 Jul 2026 17:24:50 -0400
Message-ID: <20260726195203.stable-0007@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <c5237e59-280e-4cf6-a77c-c71a61c75b5e@windriver.com>
References: <c5237e59-280e-4cf6-a77c-c71a61c75b5e@windriver.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I see that the fix-up patch [1] has already been merged. Could you
> please double-check it?

Double-checked, and 6.12.y is complete: the original backport went out
in 6.12.97 and your fd-leak fixup in 6.12.98.  In the merged result the
cross-superblock rejection sets err and jumps to mext_out, so the
fdput(donor) is no longer bypassed.

-- 
Thanks,
Sasha
