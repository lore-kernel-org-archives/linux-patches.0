Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7093909B5;
	Sat, 17 Oct 2026 17:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258200; cv=none; b=dHBq4hkYwv7oSjf6JfDsLVDqVLwwQRrR9T4xKH7mQAnuHXnO3bUGsIJp//RxZA9RQN7VyrfwkfME75lvZ9nOh+qjAgWhmDBYOVGXis1D9ZUiKGLw5bL5+F0EMPPWQHHnAeOiU07Y4TKP4FyfJT9nhlfi46lfFzB7hhvgOKH0Ayk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258200; c=relaxed/simple;
	bh=jAadii5SYfrPB7QBzJ6NcEsoDUMPlX0aDowRBaHxaAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnsBtog7LzpU4A9LrVvgrA3ZJPAFXxNAkZNjvQhgA8l+BOrL9uv6CTDIdiGFBJsdAH8Cpebjhd1DIERon90UJG4JDC3i2/DjZpReFBv7IgeIRvZYkjU/VtLg6qxxB0gK+EXLE+RQIYvb6ndLf+wTOtuHrZCkybT56GTHK4yUAyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZvEthL4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZvEthL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6911F000C4;
	Sat, 17 Oct 2026 17:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258199;
	bh=QQtpacpNHKPGc38OxIyx0NxRdY+0w6KPbXtXvML3DDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZvEthL4ChTmIqKBaed/Vj7lgRcNVE58Uisc7UiP27drWq29v8pDKBZo8VI0QgpeP
	 zELA6zvob9uHGMUocKsUOzIYuyciNZxvJkXVbJY2USKq0UNJejl+DilFs55vKSNfdL
	 sdfxe9fL+ONvJICTlNKstPQn0T+k5FFm+vxaW4wA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Levinsky <ben.levinsky@amd.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0806/1674] mailbox: zynqmp: Move of_match structure closer to usage
Date: Sat, 17 Oct 2026 17:51:18 +0200
Message-ID: <20261017160451.802483284@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Ben Levinsky <ben.levinsky@amd.com>

[ Upstream commit 6efb495826a905814e2aaa68dc756694686e864f ]

The of_match structure zynqmp_ipi_of_match is now adjacent to where it
used in the zynqmp_ipi_driver structure for readability.

Signed-off-by: Ben Levinsky <ben.levinsky@amd.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Stable-dep-of: 0aead8197fc1 ("mailbox: zynqmp-ipi: Fix out-of-bounds access in mailbox cleanup loop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/zynqmp-ipi-mailbox.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mailbox/zynqmp-ipi-mailbox.c b/drivers/mailbox/zynqmp-ipi-mailbox.c
index c3953abe74b8e..6a523759efa8b 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -415,12 +415,6 @@ static struct mbox_chan *zynqmp_ipi_of_xlate(struct mbox_controller *mbox,
 	return chan;
 }
 
-static const struct of_device_id zynqmp_ipi_of_match[] = {
-	{ .compatible = "xlnx,zynqmp-ipi-mailbox" },
-	{},
-};
-MODULE_DEVICE_TABLE(of, zynqmp_ipi_of_match);
-
 /**
  * zynqmp_ipi_mbox_get_buf_res - Get buffer resource from the IPI dev node
  *
@@ -694,6 +688,12 @@ static int zynqmp_ipi_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id zynqmp_ipi_of_match[] = {
+	{ .compatible = "xlnx,zynqmp-ipi-mailbox" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, zynqmp_ipi_of_match);
+
 static struct platform_driver zynqmp_ipi_driver = {
 	.probe = zynqmp_ipi_probe,
 	.remove = zynqmp_ipi_remove,
-- 
2.53.0



