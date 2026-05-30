Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4428D238D52;
	Sat, 30 May 2026 18:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167128; cv=none; b=SKGsx2j2wo5o60il+TNyUgnoDhotBqPQgW3Mnxdw/xESE1sVPyLW9E8tfeuk4aRg57glos5GS9OeiMW5hSOFmhUtUyEBv9X9rACzZrlBgvIaj8P4PSpDrIvVcGKZI2DZeCe7JL+dCNMwfLh/zWVZjcvYzQyHPNQb2uNUldOTjRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167128; c=relaxed/simple;
	bh=ZwiXyHMMXayKq7qjQQ738qHKcl9++EacUdK6p9MUGaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0RpeSxcdhowDvrr60wBQKCJi/2gKCra8OxgzERWVzahuWb64i/t57ld93zqFRFjo3SxvSeq2Ty5HRsdx7kW8iH+B9Owktdff7tV27mSgRkkRKiGn70x5DCFA3jI+tADLCcEgsSO2XXmfchkzozw2Z7p119L394wGaYm2NggeRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k2hnA+HT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k2hnA+HT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DF01F00893;
	Sat, 30 May 2026 18:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167127;
	bh=AggY5FCkA+oFkY/w7DUSMvbjiguTOKRxud9qlN8LjVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k2hnA+HT6gSVWSBKefX3nCBnXf+oguPiOdm0IFaBaoqCdlOK1h6Zqjiytn9J0PLKc
	 wKw9ZcIZq2MBqgfuFQ4C05t8sSyGHVxE0tZvsaenU6aMQcucf+bW3BLByTIJ4BzumE
	 yMMKeB4/Jbq347ZmplTLyx1VlPLKOTo7ziEDDAtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 570/589] kunit: config: KUNIT_DEBUGFS should depend on DEBUG_FS
Date: Sat, 30 May 2026 18:07:31 +0200
Message-ID: <20260530160239.603172659@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9eb78ea5e90fc..48d4a2d95fd80 100644
--- a/lib/kunit/Kconfig
+++ b/lib/kunit/Kconfig
@@ -16,6 +16,7 @@ if KUNIT
 
 config KUNIT_DEBUGFS
 	bool "KUnit - Enable /sys/kernel/debug/kunit debugfs representation"
+	depends on DEBUG_FS
 	default y
 	help
 	  Enable debugfs representation for kunit.  Currently this consists
-- 
2.53.0



