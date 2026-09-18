Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D9D51FCC6;
	Fri, 18 Sep 2026 19:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789760750; cv=none; b=XhAG9f3yun4EY7TR8WoL5icbj/WhY8nV6PLJBQJgXujCoObqvnosJLi6KpjXITZ5aDQW0D11F9ZsZvlq/WTW0G/JGp8eFNTJC7XoFP57QzADf8TzqhB/L3cupvVsGoPCer7a6wfebQ6EnUlf93kbxFKCf36g3i51gHRiDOB+R+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789760750; c=relaxed/simple;
	bh=ertWvA029VCX6926WSmnHbqpOAJ0+vLCaPZiH+SDFYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBV1u62RKUb7W9MkTahJR0VTCAM1I2cAsEZjKtoWeIAgBM/iZW8Obd9LvbDoMfCQd8RiRFuoF8fQ1Yoq58QTa2zybvwQ5MtwXfnLF9c+sm+hCN4MMSWrEhYkpARzXB30BmU6uLX5Z0QK5Fo+Jfd/kWaYMxcFcZAvMGjK0A0EuUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zmqs2gCl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zmqs2gCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021FF1F000FF;
	Fri, 18 Sep 2026 19:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789760746;
	bh=ftMhJ+UWDvRmzCNMIn1kmzMpbgAiidIdB5+QZW+z918=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zmqs2gClQFcID9pN8WiKO39jVJKl57Cuk4LaLgQwVAAAeOyjZbmqhLzP/LOYB/MGJ
	 ksuVMY7ynIZhWqOWF91KTxz/uHf7Md/3RBhf4Jlv8jVuraP7nBG2lEAuCfmuwzLzVO
	 sXEn2FkYP+XdWG9RbSrQfA2FpsL0xcGLxdMxtPlWkNWOGimBouvErbWykMVlP3SSi6
	 f+nqxRpOlMYS6kqldPQA9sS1lSlhgWa7Xk0HbHbRgQH6ITmZGMcocZacIhSkiPmySg
	 arne6436u8KOd+FTT5p13HJQcWfPbu+fVE68COxtTnbZTRmRCotoGFXiblI2gfpxD0
	 ZT8IfmzFMzl2g==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jens Axboe <axboe@kernel.dk>,
	Stian Halseth <stian@itx.no>
Subject: Re: [PATCH 7.2 439/733] sunvdc: unmap LDC cookies when the descriptor send fails
Date: Fri, 18 Sep 2026 15:45:28 -0400
Message-ID: <2026-09-18-daily-reply-0001-re-sunvdc-retries@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <327bfd74accc71d7f125adef80d8c975b3d08ea8.camel@itx.no>
References: <327bfd74accc71d7f125adef80d8c975b3d08ea8.camel@itx.no>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> No objection to this patch, but please also queue its companion
> 
>   5067d4ba7139 ("sunvdc: fix -EIO issue due to lack of retries")
> 
> which was applied to mainline together with this one. The same
> applies to the 6.18 and 6.12 queues, which carry this patch as well.

Queued for 7.2, 6.18, 6.12, 6.6, 6.1, 5.15 and 5.10, thanks.

-- 
Thanks,
Sasha
