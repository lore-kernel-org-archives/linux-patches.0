Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4212E274B44;
	Tue, 21 Oct 2025 20:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076834; cv=none; b=G8VrLw/WUiiciWCWCnlgFf8sIkCKz7xu7Coy0Pjfx4JR7C8o4RtNUf2EapgCHKTTlOZ6FVlk2W8cFDMjFsBhc9AScoe/LcKsyGqzS6cEer50I8yv7GjF7Vv38utpxdxVxucGgRs1iSjYC3vTk8pATI4SvjzQbKlurmnktqQ7HiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076834; c=relaxed/simple;
	bh=ZID80Uof4DAeXepPETVA9nS1ya/kPWgN7cgkqkvVB2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=laWt3i3d98GbO4fVEye5lYBwG1kO3Ok/ZUaWTPJnOcwBqSM8UF/GLrguhh4KoZ4cgFEKExS1XA8YoWLdj5tFo98pJkCNqhf5LgzRv2ed52fI7A9S8pY3REFlMHwam5LYzyEa2i6XMPEmIUfXGSy1QbkNtKTEyWkNk5b2gGcJj9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OGi6o3r0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OGi6o3r0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FDAC4CEF5;
	Tue, 21 Oct 2025 20:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076834;
	bh=ZID80Uof4DAeXepPETVA9nS1ya/kPWgN7cgkqkvVB2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OGi6o3r0+sHBJysPrvDytkOQ2focklDA4k43g5mTckRPN2XF1r9aRuCo2rnp3NqVM
	 H/ISRlAohSFMNN77LfXQN2klNdXD/n2We/GBG/E9bUqIs21qFlTMdHS6RGhP/qSHhd
	 +U7RjZmJO7cXc0kWT4i04hk/Js2LxUpJsrMjaZto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrik Flykt <patrik.flykt@linux.intel.com>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/136] can: m_can: m_can_plat_remove(): add missing pm_runtime_disable()
Date: Tue, 21 Oct 2025 21:50:33 +0200
Message-ID: <20251021195037.069992490@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit ba569fb07a7e9e9b71e9282e27e993ba859295c2 ]

Commit 227619c3ff7c ("can: m_can: move runtime PM enable/disable to
m_can_platform") moved the PM runtime enable from the m_can core
driver into the m_can_platform.

That patch forgot to move the pm_runtime_disable() to
m_can_plat_remove(), so that unloading the m_can_platform driver
causes an "Unbalanced pm_runtime_enable!" error message.

Add the missing pm_runtime_disable() to m_can_plat_remove() to fix the
problem.

Cc: Patrik Flykt <patrik.flykt@linux.intel.com>
Fixes: 227619c3ff7c ("can: m_can: move runtime PM enable/disable to m_can_platform")
Reviewed-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://patch.msgid.link/20250929-m_can-fix-state-handling-v4-1-682b49b49d9a@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can_platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index b832566efda04..057eaa7b8b4b2 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -180,7 +180,7 @@ static void m_can_plat_remove(struct platform_device *pdev)
 	struct m_can_classdev *mcan_class = &priv->cdev;
 
 	m_can_class_unregister(mcan_class);
-
+	pm_runtime_disable(mcan_class->dev);
 	m_can_class_free_dev(mcan_class->net);
 }
 
-- 
2.51.0



