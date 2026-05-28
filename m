Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD4E27A476;
	Thu, 28 May 2026 20:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998519; cv=none; b=BF0Adbl+1Tt9OPG5owwl2Gh5emJXWcnT70W1z/W0oj9geyZGCx1sOQT1fu7rutjIMcjJwpDdTxg9vtqOvqq9l/ZXraE8CQkvL440GcEbyn9qJbvU5JnVZUvsIKNQIbNGWPDEDypaE9ZctLiy2gfZP4fOcLTClJyzyyneHvtVfas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998519; c=relaxed/simple;
	bh=Coc/G7HMtDzg1iGnm8Pyyc5O4WFsS4WqcHpnKHG5OGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enfm8r5g2OounC2cGuW7ZlgoSHpiD1lMoYO4u2mXo2rC8GE+kzhKIo7UEgT5Yu4MKykUNGHKdgzBqrMLenoLgAzaq/BEyvyNKaS2Z/ymIY/FzqupgmcOQFsLKfIwKSPPomYHYWS9n33iuvt2a6UiOgTqtL18VLBQvJsEJGmWSnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNPYWZIS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNPYWZIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF951F000E9;
	Thu, 28 May 2026 20:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998518;
	bh=kYu4mxURHUB4504Nmu7jYnEVq56ROG3fehdkDPasqQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LNPYWZISsttto3Ho6QRrkxvI0hcLhvvRL2h+FNOqi0O2UhpcbJ++2FxGEvxXR1fi8
	 d5IbY92+vT9munkUUdlWocj+2bulOdmnm/abTTokwHM+3bYg8qFG+O0VpvYNbNMKSu
	 vNt7DMBeIcaftbbeBgtAl1ZqmBZgC7181i9RqFoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 195/461] kunit: config: KUNIT_DEBUGFS should depend on DEBUG_FS
Date: Thu, 28 May 2026 21:45:24 +0200
Message-ID: <20260528194652.728190733@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index f80ca3aeedb05..94ff8e4089bfb 100644
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



