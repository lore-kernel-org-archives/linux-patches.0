Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1237A363C73;
	Fri, 18 Sep 2026 00:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789692781; cv=none; b=KuTza4gUJRZY4i1zA6O3MO7sptuaCOn9PR9ilvOP5yjQLAktnmt3qSgh4xQ2yRbKbtgdT/JCs+6pRlN2ebM69+6nd6t18pAQ4oB15QtX1J13CaBoQydxeX6PlH2y7hoD0h2s47W6zPcY5wiIb/oqq/WvlcTG6CxBKx5jIvYdphk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789692781; c=relaxed/simple;
	bh=6EI/Gwv0g92tZOscWcupB/22V4/igo9cPcOj7P1y3Rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFGHq0pyUZGI+24V0cSjBTQwStp+eBVaqbNLrWrYvjEAsr5oLv+u7gUctAxA9glazu4QMHdgfVqafEotk0u/BQ/mG/uCFVDd4VDLIy2+g/+7xD1jnf0iyZOlmHDaebxgf7vDOEZRLFv/4kMbZZ6NjmAI6V51QYuUGF1/CqCSYVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fq6AmyQK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fq6AmyQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3DE1F00893;
	Fri, 18 Sep 2026 00:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789692780;
	bh=BnfWuAdQvvp1HzGV0Vkr5bNv+6XkbSDVMVlrqnMPLBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fq6AmyQKzJ4nDEDKCV+OOG5+kupo07SPrmu5jX9HhQiXoO5NJgyZrr1ltfeyrCk7t
	 gTzITKMctyskpyVTL6psIM5l5XTov30Z0P+/hduHN4LR3ZHIZHBxyifGRFMuw1IAo8
	 ALY+rzAWyqxzNjyFyyTcjstoLCq5hguLbwxyZelT3kS0xIrJTu6lunoR2PS6x5T+40
	 1vUEraxHwG76nZy5m6Ilhz/6+211jD76+/EYQz+WrqFajddvIxQn+OIF7affGvbxaY
	 WQYn5J2x8pKmOJ59qA48FhGZi8dcOSxfI4aWBB2HaFF66hI7Wrf2YIHIM0Gu2jHa3B
	 atgKKtbBNewNQ==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org,
	linux@armlinux.org.uk,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	rostedt@goodmis.org,
	rmk+kernel@armlinux.org.uk,
	linusw@kernel.org,
	kuninori.morimoto.gx@renesas.com,
	arnd@arndb.de,
	xiqi2@huawei.com,
	ljs@kernel.org,
	wozizhi@huaweicloud.com
Cc: Sasha Levin <sashal@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	lisongze2@huawei.com,
	wangbing6@huawei.com,
	Xie Yuanbin <xieyuanbin1@huawei.com>
Subject: Re: [PATCH v2 5.10.y/5.15.y 0/3] ARM: fix might_sleep() WARNING for mmap_write_lock() around show_pte()
Date: Thu, 17 Sep 2026 20:52:36 -0400
Message-ID: <2026-09-17-daily-reply-0009-arm-show-pte-faults@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260917023056.2280-1-xieyuanbin1@huawei.com>
References: <20260917023056.2280-1-xieyuanbin1@huawei.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This series backports all these upstream patches into the linux-5.10.y:
> 1. commit 7733bc7d299d682f2723 ("ARM: fix hash_name() fault")
> 2. commit fd2dee1c6e2256f726ba ("ARM: fix branch predictor hardening")
> 3. commit 59e4f3b45b96a24fc9b7 ("ARM: ensure interrupts are enabled in
>    __do_user_fault()")

Queued the series for 5.15 and 5.10, thanks.

-- 
Thanks,
Sasha
