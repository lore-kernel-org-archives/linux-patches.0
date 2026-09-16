Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58B23C10BB;
	Wed, 16 Sep 2026 01:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789523574; cv=none; b=OWzvQgPsXWQ+A08leuhPs1C8F57db9nlqPUbR1XSiL1yIkrtxeDvoQ2BLU0YUAhSF8YkHNf0ie1LuHV9yhcX1ACIgNktaDs3SIRXE/QYLgjAxV+nmgT7xSel4x8jaBcBaWDmGxrFz2pSpxWGwZo0CVh5xMtiHc+ymrrTswnhmFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789523574; c=relaxed/simple;
	bh=93DDrKyF+t10Dxjufc0Db3GcFHvMOdZPrO+XQxcj+XM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2WZBvWPxafCTUxjf3k/ouRisGpU9cBLxRX714GBLrXFZ1C3jV+ruJNd5p+hnBM7mSkZxEKcaDoGEEOLUP45H+kMU8SDsg+eMIKgn/uQiZobBoyAh4UZSXbrRVDKjgcrcaaAn9sNNuin4LltPkOZYNkkfbCI0wUeufqdvm1V3hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oACRQOxM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oACRQOxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05BA1F008A2;
	Wed, 16 Sep 2026 01:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789523557;
	bh=VbVlSsyAHUKQkdxhiOzhIEaDN/XzapJHF+uYGXyqdpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oACRQOxMio3vvkvWTz6nWYwdBGEUQ1uhp0W3VAnUj8dcYj0B31LKtQnR7zYGY+7WX
	 B1Ws+xMmXsHiEQs8zAuRwHxvsHp0Yj5H/C+CI4ZScal5kVfJQWDUx/W7RPghsBHC66
	 gq2i+0VLhtmlfQWoMY7NAgk+sxK7sp/hiEVAQfSB8r/jOm4tMkfeYsbvuPOOuX1SZ7
	 TUo+tVnPzeG1E9RexKxbSBTGR6nfw+5YbIoKv93Ue+bhX4iaTDarK1A/UsrztuVvgd
	 lN28DDl6krtcLcuirTKjh5xvzkjouh7/S6a+1VcMIOl3e8gsQKxIjhdUckK3Li1zXD
	 QEgt/L153vc+w==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Manuel Fombuena <fombuena@outlook.com>
Subject: Re: [PATCH 7.2 0292/1815] leds: st1202: Stop pattern sequence before reprogramming
Date: Tue, 15 Sep 2026 21:52:16 -0400
Message-ID: <daily-reply-20260915-0011-re-leds-st1202-validate-pattern@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <GV1PR08MB84973FE9321D2874451D5DBDC5BB2@GV1PR08MB8497.eurprd08.prod.outlook.com>
References: <GV1PR08MB84973FE9321D2874451D5DBDC5BB2@GV1PR08MB8497.eurprd08.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I do not anticipate any issues with the series being applied without
> that commit, but I have not tested that configuration. I therefore
> wanted to make you aware of this, in case you consider it advisable to
> backport fd2529ba8f as well.

Thanks for flagging it. fd2529ba8fb4 ("leds: st1202: Validate pattern
input before stopping the sequence") is queued for 7.2 and 6.18 alongside
the rest of the series, so both trees match the configuration you
actually tested. No older tree is taking this series.

-- 
Thanks,
Sasha
