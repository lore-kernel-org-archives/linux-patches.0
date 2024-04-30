Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABF212C462;
	Tue, 30 Apr 2024 11:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474949; cv=none; b=JVzA0oLgDP4vV2htfxJPFvNHtvJF8XoneigoVoD+hZt5t9PA4pVLFnEjrExOPYgfSzmkw2yISmvPoBe0ocH60FjnUtdIZKKcOwh2+dwc7pgpN5qx4NdfAADEICy2euUkWeq7MxVjJEcgmYXcrhKLdXVcA0oXWLQuyJPHMR56bNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474949; c=relaxed/simple;
	bh=CTlGQwnt6zZ4gRDjl6Pq2EvwdRcBr0GNI04fCXD7VuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MuHVTQ5sJKg7CjhSznMjngID1rPdtMDAF5JOWNXsY1PGfe0tJCvFyc1tpkMQQwCtk2aDPKoQJs1n3RXGpcfKoE/z3UQoBswozGQ20tUi/KGX6yF9kn5iNCWLlqDpOV7+wjOkV0Ak5kg00oIRx6SfF+gpicVJwpH3OFDkvX9dYrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=op6q2jDX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="op6q2jDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DA2C2BBFC;
	Tue, 30 Apr 2024 11:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474949;
	bh=CTlGQwnt6zZ4gRDjl6Pq2EvwdRcBr0GNI04fCXD7VuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=op6q2jDXxoyqGn+iYHW8/6IWxhehqo9HPw123+/giYY6vRV6QZDim5IjxcylukE8o
	 D36MGFAhfZlqG3DZw25oYouBHAXsczRUs5zp0BeNFibxhDY91ryd9zZUMcHTTNojJM
	 NKjehBrenIXqZLv8ApWl3kmMyw+PK17mIhLII8K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/138] clk: remove extra empty line
Date: Tue, 30 Apr 2024 12:38:51 +0200
Message-ID: <20240430103050.785575397@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 79806d338829b2bf903480428d8ce5aab8e2d24b ]

Remove extra empty line.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220630151205.3935560-1-claudiu.beznea@microchip.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: e581cf5d2162 ("clk: Get runtime PM before walking tree during disable_unused")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 1043addcd38f6..f6be526005bbe 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3631,7 +3631,6 @@ static int __clk_core_init(struct clk_core *core)
 
 	clk_core_reparent_orphans_nolock();
 
-
 	kref_init(&core->ref);
 out:
 	clk_pm_runtime_put(core);
-- 
2.43.0



