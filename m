Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A355622652D;
	Thu, 28 May 2026 20:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999776; cv=none; b=UdWxDB/VB6Ce8cUYqzIGwqJGIC93N+wkk4jAxuVGbzeVZtOXyfIIQRXS9Fw0XCoriR7obhWfN6y6OP7OjdnBvQmG5DJRG6p8YAADeuqMfLQwdk+oYvFe/5IHn8NXeM9NqKZ2xNSkxRPGv2TKBfdoxEJxwVvm2Ywl5RFXPVZETHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999776; c=relaxed/simple;
	bh=z/Fs+dVQGNWcK2ZMhEWfMbs/GJDCsdBVhFfr0LwhCLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mdv2SzTpKbo5JqqWYkX1dZ5R1yxwmaSMoGlvRn1Bq5lAg07AF1yJwsTfG8KlXiRHaal7jrIclb1KUn8dYaJBCBjcSO4SKQyNDkZYYhlOrvtccLUyzhSVabECk55P5BsAq3rBzTXAXRqcHmREPmkGdGIMuPf5VGgycGU+MF/QfI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vr/6x76D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vr/6x76D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7F01F000E9;
	Thu, 28 May 2026 20:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999775;
	bh=cA/sdSBHZexvd/iHhL50vvYq75pMwK2MOnPRcOeYzlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vr/6x76DqdHMrxIw3o19GJaUgIFRPWZrFkBd4hcSyt4TY+PmUD/NzMNuMQnBZqpRd
	 qz4Sc9BF9y4heTeYfjXXZM+UrFZfiyHG1jYo4xJcSLmJTzIeojA2rk4DoQDykhry8t
	 xJdIPsm8ZFk65J7R0fTkQxmPHYLsKbmeGL7T1NrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 186/377] kunit: config: KUNIT_DEBUGFS should depend on DEBUG_FS
Date: Thu, 28 May 2026 21:47:04 +0200
Message-ID: <20260528194643.806484010@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2b9fd107a69fe..889380c2702c3 100644
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



