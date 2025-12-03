Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB453AA182;
	Wed,  3 Dec 2025 16:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779565; cv=none; b=BK4AdZqMThMfyqos+RYFr+FPvQfZdx/rsAfLr76HbJ+efIvbfZ+uR9hqwki5Neuc0uX7lhZIVW8gjBLkT0AtYF95QhIpNF9lkyPnIbdGVSvd0SJxanV+7bbkjzigg8PTzBeqzXKDp+n9VHA+ObF3PceeHquwz5CWDv0N3GjaNew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779565; c=relaxed/simple;
	bh=6ZRLlSHLvIN82zVW2VTpa/LMN7YvPWgVLNam3OgiZns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mx/iMs2ZSaVcumuOOzGzplmYjQClpbf1268E0o+T18HmN/2oZpT1MXwWFtwjdgtUmdetLi+hxtWe8ELucxK3O5GlOkXkzPo7NgAkJ8J/ncWNYwJFu0Xm338TKC2jcjub/jXj+9LQhjRP/yk/6tnpBULo6fxyclHqh4HZWIASuVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTNq0sun; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTNq0sun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDAEC4CEF5;
	Wed,  3 Dec 2025 16:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779565;
	bh=6ZRLlSHLvIN82zVW2VTpa/LMN7YvPWgVLNam3OgiZns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DTNq0sunDQVkH0BvAJYxc/83oC+pEs9Dqoy61R/2uR7s9swVMlId/yJaTOG4leYMC
	 uVYsle6uiKgx5Nqf3qv6kXAzuSFCZAN4ywSF0xNBOu/K0Wmpn909eBmriFG42pUZgm
	 0O6r08WBcSqiUFwXYNl3k1lDmMNjmLSN5CLsTED4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Dahl Juhl <juhl.emildahl@gmail.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 296/568] tools: lib: thermal: dont preserve owner in install
Date: Wed,  3 Dec 2025 16:24:58 +0100
Message-ID: <20251203152451.545985836@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Dahl Juhl <juhl.emildahl@gmail.com>

[ Upstream commit 1375152bb02ab2a8435e87ea27034482dbc95f57 ]

Instead of preserving mode, timestamp, and owner, for the object files
during installation, just preserve the mode and timestamp.

When installing as root, the installed files should be owned by root.
When installing as user, --preserve=ownership doesn't work anyway. This
makes --preserve=ownership rather pointless.

Signed-off-by: Emil Dahl Juhl <juhl.emildahl@gmail.com>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/thermal/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/thermal/Makefile b/tools/lib/thermal/Makefile
index 8890fd57b110c..1694889847caf 100644
--- a/tools/lib/thermal/Makefile
+++ b/tools/lib/thermal/Makefile
@@ -147,7 +147,7 @@ endef
 install_lib: libs
 	$(call QUIET_INSTALL, $(LIBTHERMAL_ALL)) \
 		$(call do_install_mkdir,$(libdir_SQ)); \
-		cp -fpR $(LIBTHERMAL_ALL) $(DESTDIR)$(libdir_SQ)
+		cp -fR --preserve=mode,timestamp $(LIBTHERMAL_ALL) $(DESTDIR)$(libdir_SQ)
 
 install_headers:
 	$(call QUIET_INSTALL, headers) \
-- 
2.51.0



