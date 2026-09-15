Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453943CF1ED;
	Tue, 15 Sep 2026 02:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789437831; cv=none; b=ESzzbTa/y7wrPLRGnZIsNMEfWpqd/byH8x+SK6YnOXN4AI74vXZEWZVCB/l5DnJhmo0qVNYhWay9R0fb5LrhY6v/RfWfD6FcXthTULa/L0//Vkm/OXRUspxGNdI8H6CyjsUvUIeG5RjP0iEVIad847vfFo1MFE+dX+8GYH4pEKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789437831; c=relaxed/simple;
	bh=WhC2bj5kb6iEqBerXQhQIWB0A7Iyf7r3pO97PkxW5wY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxQ60RB4lL/zBEowGroyVSWIKDDfjxbdpoXThyIad2kos0JKf6ya7g0sc5WmEeb3VZn/AA2HsVEP5af8kPfm+ernE8IDe5c2HjIhkDPt0Fal+lJWvE0FurrYghcSFz3GgeIQ3Uw7Je6tQQuqaYcz0N5/RGQD9mcpBjAKNTE6XMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VMgNxZFO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VMgNxZFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A669F1F000FF;
	Tue, 15 Sep 2026 02:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789437829;
	bh=3PZlCzXAeVDKpiVMf4wbPUmBmc5EvcNg5hQfnwFiiM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VMgNxZFOzJBW0OBIYIh/yk9eytzT3NzaHnRx9qlgY7Ga0dIzq+td532aGHWBslCm3
	 aGREh99+xoCXmgiqiSCshwExOhWZqdhO0lTfVex2CvuBkHkA1G5k1wpWuiLoyg/7gn
	 SRS3rGs0p/OI6tkSythiYpgxdTqVT7oXbl1SM/l8npZEYTEbS7mULFUFhwx+A3F9QM
	 A63ESy78B9HV22KT/L/ttzalh7aYcyFxMxLlS0NBJ/SKxNzFeoTR2tmtg3AY+O6HO1
	 Kf7VFmi1b2MTxs4RzvF/FaeltxYv7B155QfS+GEL0mY5S7cBPI0pFdYaSYqAeTbfRc
	 AQvzLCx7X8LGg==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org
Cc: Sasha Levin <sashal@kernel.org>,
	linusw@kernel.org,
	ljs@kernel.org,
	patches@lists.linux.dev,
	rmk+kernel@armlinux.org.uk,
	stable@vger.kernel.org,
	xieyuanbin1@huawei.com,
	xiqi2@huawei.com,
	bigeasy@linutronix.de,
	wangbing6@huawei.com,
	lisongze2@huawei.com
Subject: Re: [PATCH 5.10 613/798] ARM: 9485/1: mm: acquire mmap write lock around show_pte() for user faults
Date: Mon, 14 Sep 2026 22:03:26 -0400
Message-ID: <daily-reply-0010-re-arm-user-fault-irq-enable@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914024820.11063-1-xieyuanbin1@huawei.com>
References: <20260914024820.11063-1-xieyuanbin1@huawei.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This commit depends on commit e79ca91165d4fd18549c ("ARM: 9484/1: enable
> interrupts when unhandled user faults are triggered"), otherwise,
> mmap_write_lock() may trigger a might_sleep() WARNING.

Queued for 6.18, 6.12, 6.6, 6.1, 5.15 and 5.10, thanks for flagging it.

Could you send a 5.15 and 5.10 version that places the enable after the
hardening call? The other option is to take fd2dee1c6e22 ("ARM: fix branch
predictor hardening") on those two first, after which it applies unmodified.

-- 
Thanks,
Sasha
