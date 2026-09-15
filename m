Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7337E3E9C36
	for <patches@lists.linux.dev>; Tue, 15 Sep 2026 03:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789443369; cv=none; b=e00p1bn4X9jVs6efkryvn2VqMoSeW07znCimQThy+3zWq+Sde0/AnvZEwyB2jBo16WpcBaI1okVwBZJ99EH8DUjF2Zjogneq2ExhBPslhpPz2giuLuEFZxBeyKotUizcsD/8WrWTrvB+wY8jauFAvuJM+nfwuX403/gFYH3qvCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789443369; c=relaxed/simple;
	bh=o5Peldxcu+TpkfyFny8QiSsqRNWT4bQlIsYkv/SpECM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c1I1GyaPdhHKyhLzNg+8RXeywGZmSGpIuZy+590fDeX03ZF3TFoV/13p5zV0JdntCZOmc6ii2YSCo7XjX4d+2GN0CCXtxqiRTJ4QdZOyYyxv0IJIt2RmgkMA8uJMDkiC7NLqz1Juyxb6mtaX14sfA6NQxt+X3vYogKLqyp5BgZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=xTiHF7vm; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=xTiHF7vm; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="xTiHF7vm";
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="xTiHF7vm"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=7NTM2zmOCGtafXQP+f8KiANnjbAkowGc6QwTs++MkL4=;
	b=xTiHF7vmWimFekKKNOP8ZtFrf3rDf700+FBfewZOqJ9uVvrY4s5TE6c+XceL1BEmL55tB/PnC
	QV0mNV7sB4Z9F03tAClbi8Jw43BRuWjF5tC3koagbR36Fc562RKAn7oxEKo7f2FnqXxnRkbF+br
	d2QF/9Om+OmoZIkzwu77xLA=
Received: from canpmsgout07.his.huawei.com (unknown [172.19.92.160])
	by szxga04-in.huawei.com (SkyGuard) with ESMTPS id 4hkSMn4fzLz126Lxy
	for <patches@lists.linux.dev>; Tue, 15 Sep 2026 11:35:33 +0800 (CST)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=7NTM2zmOCGtafXQP+f8KiANnjbAkowGc6QwTs++MkL4=;
	b=xTiHF7vmWimFekKKNOP8ZtFrf3rDf700+FBfewZOqJ9uVvrY4s5TE6c+XceL1BEmL55tB/PnC
	QV0mNV7sB4Z9F03tAClbi8Jw43BRuWjF5tC3koagbR36Fc562RKAn7oxEKo7f2FnqXxnRkbF+br
	d2QF/9Om+OmoZIkzwu77xLA=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hkS7K1Vh2zLlSh;
	Tue, 15 Sep 2026 11:24:45 +0800 (CST)
Received: from kwepemk300012.china.huawei.com (unknown [7.202.194.175])
	by mail.maildlp.com (Postfix) with ESMTPS id 1A6FB4048B;
	Tue, 15 Sep 2026 11:35:43 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemk300012.china.huawei.com (7.202.194.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 15 Sep 2026 11:35:42 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <sashal@kernel.org>, <gregkh@linuxfoundation.org>, <linusw@kernel.org>,
	<rmk+kernel@armlinux.org.uk>
CC: <bigeasy@linutronix.de>, <lisongze2@huawei.com>, <ljs@kernel.org>,
	<patches@lists.linux.dev>, <stable@vger.kernel.org>, <wangbing6@huawei.com>,
	<xieyuanbin1@huawei.com>, <xiqi2@huawei.com>
Subject: Re: [PATCH 5.10 613/798] ARM: 9485/1: mm: acquire mmap write lock around show_pte() for user faults
Date: Tue, 15 Sep 2026 11:35:19 +0800
Message-ID: <20260915033519.16922-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <daily-reply-0010-re-arm-user-fault-irq-enable@kernel.org>
References: <daily-reply-0010-re-arm-user-fault-irq-enable@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk300012.china.huawei.com (7.202.194.175)

On Mon, 14 Sep 2026 22:03:26 -0400, Sasha Levin wrote:
>> This commit depends on commit e79ca91165d4fd18549c ("ARM: 9484/1: enable
>> interrupts when unhandled user faults are triggered"), otherwise,
>> mmap_write_lock() may trigger a might_sleep() WARNING.
>
> Queued for 6.18, 6.12, 6.6, 6.1, 5.15 and 5.10, thanks for flagging it.
>
> Could you send a 5.15 and 5.10 version that places the enable after the
> hardening call? The other option is to take fd2dee1c6e22 ("ARM: fix branch
> predictor hardening") on those two first, after which it applies unmodified.

I suggest that merging all these patches into the linux-5.10.y:
1. commit 7733bc7d299d682f2723 ("ARM: fix hash_name() fault")
2. commit fd2dee1c6e2256f726ba ("ARM: fix branch predictor hardening")
3. commit 59e4f3b45b96a24fc9b7 ("ARM: ensure interrupts are enabled in
   __do_user_fault()")
4. commit e79ca91165d4fd18549c ("ARM: 9484/1: enable interrupts when
   unhandled user faults are triggered")
5. commit 1039bffd6ae9c75b42b7 ("ARM: 9485/1: mm: acquire mmap write lock
   around show_pte() for user faults"): this patch is already merged.
I tried, and the patches can be applied with very simple adaptation.

In the upstream version, the following patches are a patch set:
a. commit dea20281ac8822661576 ("ARM: group is_permission_fault() with
   is_translation_fault()")
b. commit 40b466db1dffb41f0529 ("ARM: allow __do_kernel_fault() to report
   execution of memory faults")
c. commit 7733bc7d299d682f2723 ("ARM: fix hash_name() fault"):
   which is 1.
d. commit fd2dee1c6e2256f726ba ("ARM: fix branch predictor hardening"):
   which is 2.
The fixed issues by this patch set also exist in linux-5.10,
but a. and b. do not need to be backported.

After the preceding patch set is merged, 3., 4. and 5. can be safely
patched.

Cc to Russell King:
Cc: Russell King <rmk+kernel@armlinux.org.uk>
