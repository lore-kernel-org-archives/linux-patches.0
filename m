Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06DC42049A;
	Wed, 16 Sep 2026 19:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586937; cv=none; b=Ve4GFydku9UQ3ukdiwWf54/3gAKErRi3f6A1RdtdL7OmitVDg4fwZwl1w6YGx1JdlFBKpl36xv9Jf7n6oQDIViIMeOATqc+iaRGg6qXln3IBmYQeMashVFwsn4YV/lHI5ITaHLkA0ZK1EvynyCpPOs1HBMMtRWsybdXypBKWBe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586937; c=relaxed/simple;
	bh=44UBgES1IkJtvauTNaYHC0m0R8awETaFptuQlSOAcDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9SnSBHzzPdTv05ZAYvYU19lMiNlbgMxr9QgvkczmvyvgHWZ6+6UH461kAfiPQftngVkmNqPFUr6t1voJOd5/sHtDqW1JAdRNdZC/dUKX7LO9Fd2K8SiHjbTxCxLqtTccIVTVsfkODqf8NzlbtzbZomtjFwZGore76JMIVtvInk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Te6RnPKe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Te6RnPKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3291F0089C;
	Wed, 16 Sep 2026 19:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586914;
	bh=iZKIoHZ2yaBwojNtcPcwmQaPcDtxcHubfSKW9FzK/3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Te6RnPKee/lPBmv0d3R0sE+DVOk5v1yOX3/+V2z8/S9UYzSjW5YsCslAGIMz2FQYr
	 7/Il53Lu4os64JnuiVrWMhSAcNuwhk/Y93V8AkLvyNrkdjyIC/udbTayHYTIk739c6
	 aYTEdfDDGmTfctZDRhFdiHlN1QLOdAbhrz8TARp7geN+0vmtKnzeUal5/ky+bLGMGC
	 hWId9AkNT/B5urJ4rCOKB/MtFFuQniAPiEwOh2s6CnEVRzgb4RLIXY+DIe4fnWMwW9
	 f1ZNnlepGelmxZVyOfDuoi9N4hrrhYvxw+xQNnFanhIZD6xytV/XQAp2ZcC1tyM2kP
	 AyzTZa6bOyO4g==
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
Subject: Re: [PATCH 5.10.y/5.15.y 1/4] ARM: fix hash_name() fault
Date: Wed, 16 Sep 2026 15:27:57 -0400
Message-ID: <daily-reply-20260916-0007-re-arm-show-pte-series@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260916080011.170295-1-xieyuanbin1@huawei.com>
References: <20260916080011.170295-1-xieyuanbin1@huawei.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [ Xie Yuanbin: At the upstream, the following patches are a patch set:
>   1. commit dea20281ac8822661576 ("ARM: group is_permission_fault() with
>      is_translation_fault()")
[...]
>   patch 1. and 2. is unneeded for 5.10.y and 5.15.y . This patch backports
>   patch 3. and simply adapts to the context differences. ]

Patches 1/4 through 3/4 carry only Russell King's Signed-off-by. You adapted
1/4 and 2/4 and transmitted all three, so each one needs your own
Signed-off-by before I can take it. Could you resend with that added?

Please also drop 4/4 from the resend. e79ca91165d4 ("ARM: 9484/1: enable
interrupts when unhandled user faults are triggered") is already queued for
both 5.15 and 5.10.

-- 
Thanks,
Sasha
