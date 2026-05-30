Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9251F233D9E;
	Sat, 30 May 2026 18:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165023; cv=none; b=EKXxXqRieFicOQ0DZMp2I1HCSJtjQVanXiGku1SM+TGDlbMc+rFaiXX+QayWjNbPqAgzBgYgaRIkEUaVgT7dgKnHWq8Ytna9E3sWqxxubhe/6Zso4uI1umZ1Kfw3lf1+N1gdUZC7ehezUmMbv/F23KESDmUrOr4UlDimYJUWjKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165023; c=relaxed/simple;
	bh=Qhy+qJjBFoVZeOP8mFmOJreB8wxRZqA2zG9u//Ok2Xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxblI4PHDpW12PF6mEpPH21qBAL4RGniu0BMlLkx9SR9qOXmSc8+wD18mD3RNkRXdxbUwMm1/QkprjJV1ysNJl9uWn761TDGCn9/ED4TyDF0T2ekyKq/XXNDRI/cTbPiMaOHm2GHc6lTnupWQUWSaStkZbkrGds09FZTKG9lUvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QzK4+9Hz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QzK4+9Hz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07791F00893;
	Sat, 30 May 2026 18:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165022;
	bh=UomOgOw+jSBP7fbA8wVndPmxzt6UXdcWlrA6MIyQul4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QzK4+9HzHMt6odwYj5wt7DqioetukwfAl710A/hak2yqwjXE+TS+YcdYJUwyqemGM
	 S0k3Pr1o4MxXuErZb4vK2PVE6ul7wpdt9EebFd9Y4OxjmeO8x9TU30fmYZzgskQdlw
	 QIP+nLTVNBSL3phrFEeIr8h/i35xYRF5waFa8IkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 728/776] kunit: config: KUNIT_DEBUGFS should depend on DEBUG_FS
Date: Sat, 30 May 2026 18:07:22 +0200
Message-ID: <20260530160258.636997504@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a32943555b67d..b27ef9f1af1d3 100644
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



