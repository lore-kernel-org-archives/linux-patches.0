Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F4134C141;
	Mon, 31 Aug 2026 01:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788140374; cv=none; b=Yi3IxbQt76VGMu+lCtA3MkhRpK1hRk4QfUhBrwAKKRa093fbWASOtCuTYeiGNaeRYt+xO+A0nrgoy+4qqKIABN4hOE0dPJUzYJH+he74TGMz/dA7PiBJAjqaBTqAjKs5MmwXA5dVojUxE8ssRWyvfLdtTPKrWpQvLgccP/aXaZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788140374; c=relaxed/simple;
	bh=jN/Eef2CQp6uwThsMQNjRdFl3omHiWZVI0eNVKgY7ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0G0ayL8vAduYRQKn+hNstp7vyFQDVETRnTakuGd6h2fFzwMdVnmb5PlO4qrIjFXlTD/CQN4KLC0qiqzTuZagY+p2UvztvDMwrfuE+wTH31doPOVcMFzPLOD21bRC41EHDh3cKhp4KbunmUO1yamtQKIrYuMW9Nf9F0mHCSX5y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NDTjQJYn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NDTjQJYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5EA1F00A3E;
	Mon, 31 Aug 2026 01:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788140371;
	bh=TtHp65eCD4sPOL76PfZK3YFfZxTLfjNz8bWmTDdEmTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NDTjQJYnzmeMzahZV9v/buSs6l9K9vIt8+IdquTGdjECO6YNitzS1+4DqeIwwXoFP
	 9N7JoV2Y9aJ5ihrODzb7q9hk0LbWmBJlapZoV0uF/X2upX5XVCr2QuFncaIEBSRnqw
	 mt9fpP1KwHme3k2PWURsufUkEwnBn4hLicb9aD9Jt6eWoKKdDZQl4/HN+SwUQQ5xVy
	 hVrd+VG1pYkcZW8FyrItx0IltBcqvNbzDFYTJ9+Pp0u5VHBrnLG3uDC592qxpQGGUK
	 Xv2drzcUjPs3KPOdgRgiwf+/mwEZIwVd9X5OnSRFHYGBUUyoVcgZbJyKmXRGjIX1lz
	 ZbdcyLfiKrmVQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	Vegard Nossum <vegard.nossum@oracle.com>
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Tze Yee Ng <tze.yee.ng@altera.com>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 364/456] firmware: stratix10-svc: fix memory leaks and list corruption bugs
Date: Sun, 30 Aug 2026 21:39:14 -0400
Message-ID: <20260830195300.0009-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <f3b734d9-d286-42d6-b332-e4889e7bcde3@oracle.com>
References: <f3b734d9-d286-42d6-b332-e4889e7bcde3@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Before upstream 9119ceb76e98, commit
> 85f96cbbbc67b59652b2c1ec394b8ddc0ddf1b0b ("firmware: stratix10-svc: Add
> mutex in stratix10 memory management") added a shared mutex around all
> four svc_data_mem access paths

I agree. A tested backport is more than welcome :)

-- 
Thanks,
Sasha
