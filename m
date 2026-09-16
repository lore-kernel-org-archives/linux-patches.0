Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27E038DC44
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 03:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789528104; cv=none; b=FBpY2Thh3BiMrmgdOF0q4MwQ7TObuHkCjcYY9N2hmIHNNzR3KRZE14snDjdmv/DOrhqMRkdguINX8q4qgvSxLXP9g0QaX5F28DfrokRT/YZmUXyB6evKEcyVkPJjwCsPwAe63PoM4BLW8/X9QugDRgdJ/z0P7lyoY0OMbZeyZtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789528104; c=relaxed/simple;
	bh=x8hzbvO/qn7NH6w1UttKQ0X/GvNwzhRWImYYlBOjP34=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sK6OXz77J8dn8H5aymXzW1WwJQ7avqwvV4TIGpFad0lVBSXW8Zcb3vbQSzNNO2zi+tGLVA7t5x6wspa2LMf+ZZiLjwZ5bd2K7x5bic8RI+Y6sBPr3gq7VYxBUECdnKYVP1MNE/gaJghkhtYnPfZyPWdG9XNTeZPiaPtXdas1/qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=C40AAmxg; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="C40AAmxg"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=x8hzbvO/qn7NH6w1UttKQ0X/GvNwzhRWImYYlBOjP34=;
	b=C40AAmxgQsJqGgKOWk0uj5cM1viMTYNcyc9FbyuGa0EXXTkts1Qgi1tAzLLIKaTT2mETPJpUp
	jLfHLO6QFtRhMbN36w93AfxEmLDbEY4nVQ+BK97tjrKTkL4kBbsEQbplv/ah4oAf4hFjzVKNUQM
	3z+/Sz/+v3DEvwp1dPbnQRU=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hl3SK6S80z1T4Fq;
	Wed, 16 Sep 2026 10:56:33 +0800 (CST)
Received: from kwepemk300012.china.huawei.com (unknown [7.202.194.175])
	by mail.maildlp.com (Postfix) with ESMTPS id 0490E4058F;
	Wed, 16 Sep 2026 11:08:15 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemk300012.china.huawei.com (7.202.194.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 16 Sep 2026 11:08:14 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <sashal@kernel.org>
CC: <bigeasy@linutronix.de>, <gregkh@linuxfoundation.org>,
	<linusw@kernel.org>, <lisongze2@huawei.com>, <ljs@kernel.org>,
	<patches@lists.linux.dev>, <rmk+kernel@armlinux.org.uk>,
	<stable@vger.kernel.org>, <wangbing6@huawei.com>, <xieyuanbin1@huawei.com>,
	<xiqi2@huawei.com>
Subject: Re: [PATCH 5.10 613/798] ARM: 9485/1: mm: acquire mmap write lock around show_pte() for user faults
Date: Wed, 16 Sep 2026 10:51:37 +0800
Message-ID: <20260916025137.7793-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <daily-reply-20260915-0007-re-arm-user-fault-irq-chain@kernel.org>
References: <daily-reply-20260915-0007-re-arm-user-fault-irq-chain@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk300012.china.huawei.com (7.202.194.175)

On Tue, 15 Sep 2026 21:52:12 -0400, Sasha Levin wrote:
> Your chain is right, and 5.15 needs exactly the same three commits: both trees
> have identical arch/arm/mm/fault.c and arch/arm/mm/alignment.c, and all three
> commits are absent from both.
>
> Since you have the adapted patches already, could you mail them for 5.15
> and 5.10 with Russell on Cc so he can ack the resolution?

Sure, with pleasure.
