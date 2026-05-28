Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB7C2F1FEF;
	Thu, 28 May 2026 20:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001368; cv=none; b=lYGPuWo8lIXAP13cc1b3ocfzWqpCRw5jugSuaRaFNuqh4WR9HvtadDadWfj0yhD/WQl7GntWoEcxgwD7LcDCAknYDH3F5d0SenOY9E1e//y843MAnfHPCklhl72KHoeiMPsKjrulZ6dDArByv41luR9p4JvhJgzZS4HpUUiuPn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001368; c=relaxed/simple;
	bh=r8rzMALaKOfSNF4nyyYeAXJygQ79lKFqw9Dy5YFovdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iC9QI0pW+kWZu0Us4nSY6V6ipEVI44y1EvoCAT7lWeaKrRQyCY8CpgXjNSbY9ITX3ubCf0r29Wp9vHK4lRAFq9a6AW8u/f37efn7JYcvOwhUpLUMy9Id6xFu8johjiSBpj8ZlzgNR8b8n+Ul//5BS6004aqa9P3He4yoH+9IqGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2TxGKL2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2TxGKL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E991F000E9;
	Thu, 28 May 2026 20:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001367;
	bh=9Crm+9rvhveSjh5/81BUs0SfLJuxCZ4XLcv6xS6DuOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h2TxGKL29bOuREPtYM+3GV2TJCN76pCa6Dl0Gy3XbGVtGY2FZnEBNujhJb1Eq7ube
	 /GTx1KT4nzC59aootBWSS5FpFju502GaVewH4Zsr/cYVXrKx3A7s0Ood6sUP2AD5yx
	 +Le1SajAY8Pau0ATfrCZC/zLROs+dY9h0roOj7VQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/186] kunit: config: KUNIT_DEBUGFS should depend on DEBUG_FS
Date: Thu, 28 May 2026 21:49:41 +0200
Message-ID: <20260528194931.661849152@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Gow <david@davidgow.net>

[ Upstream commit 8f80b5b227ef9ea422080487715c841856339aed ]

CONFIG_KUNIT_DEBUGFS is totally useless without debugfs, so it should
depend on CONFIG_DEBUG_FS.

Link: https://lore.kernel.org/r/20260425034155.53913-2-david@davidgow.net
Fixes: e2219db280e3 ("kunit: add debugfs /sys/kernel/debug/kunit/<suite>/results display")
Signed-off-by: David Gow <david@davidgow.net>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/kunit/Kconfig b/lib/kunit/Kconfig
index fab3458c54e4c..f5ba590373907 100644
--- a/lib/kunit/Kconfig
+++ b/lib/kunit/Kconfig
@@ -17,6 +17,7 @@ if KUNIT
 
 config KUNIT_DEBUGFS
 	bool "KUnit - Enable /sys/kernel/debug/kunit debugfs representation"
+	depends on DEBUG_FS
 	default y
 	help
 	  Enable debugfs representation for kunit.  Currently this consists
-- 
2.53.0



