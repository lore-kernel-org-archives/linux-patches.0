Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325C951B16E;
	Wed, 30 Sep 2026 16:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784663; cv=none; b=Ua0tPg/1fZkoOsSeVuwtEpDLIStbYo+rB/ttGIH4n2Jtfq8cYb7VzjmLU41csrWRwUE3byjkVci2iarxSWER7w7tMbIFnW8AJd9lpIJn4QbknJgiqlt6zcqL4TXYnn5XU7GsDBoAsBEjJZLNMAkYpzpOz7VDkDzLmli4F6qL41U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784663; c=relaxed/simple;
	bh=+iHHdY0kx+f4oi7YsMNETbmhfBCl7WNF+HeD4ZZiG1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMTlERCm4eMnfoZkgBkn0/aYTxxWeXJva85Bemw5fCAB+VpyFCO8u9J+BVp2k9UvQSHQ0+9m7Vtc4DDWQAQeoQU0HMIPw9bC58KPuCEQonMGt0gA0OPEJczdLijXgOJyCxWdASEJyUI19FCULLA9Y456KSfkugPEMSnndtrCM1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sISfHlat; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sISfHlat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F851F00898;
	Wed, 30 Sep 2026 16:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784660;
	bh=sVeFB31VEIGZIP+o/DnKs63C0+7hDNWaKa1+rdZF9Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sISfHlatiu8ZrYApt105uGMUx8SyDyCaBRB+zyjK6R0XmKegU8HEOlZL/PRyN68Rd
	 4Cf/2X4bxCo0eM3eUtSfNJCj44yYEaWEvh8GUy2JIzWJIqXLXJWfivqDaaNZpsJrdz
	 82zgAyoheVSmMH90qZPsZz74f84UO5+sY0lBwVnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Bystrin <dev.mbstr@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 207/982] mfd: rsmu: Add 8a34002 support
Date: Wed, 30 Sep 2026 17:15:43 +0200
Message-ID: <20260930152421.256146093@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Matthew Bystrin <dev.mbstr@gmail.com>

[ Upstream commit d18fd55c780c2bae3d353024cab7f8746d3d9e91 ]

Add compatible string, i2c_devcie_id and spi_devcie_id to support
8a34002.

Signed-off-by: Matthew Bystrin <dev.mbstr@gmail.com>
Link: https://patch.msgid.link/20260429072047.1111427-3-dev.mbstr@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/rsmu_i2c.c | 2 ++
 drivers/mfd/rsmu_spi.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/mfd/rsmu_i2c.c b/drivers/mfd/rsmu_i2c.c
index f716ab8039a06..332ca76518ace 100644
--- a/drivers/mfd/rsmu_i2c.c
+++ b/drivers/mfd/rsmu_i2c.c
@@ -156,6 +156,7 @@ static void rsmu_i2c_remove(struct i2c_client *client)
 static const struct i2c_device_id rsmu_i2c_id[] = {
 	{ "8a34000",  RSMU_CM },
 	{ "8a34001",  RSMU_CM },
+	{ "8a34002",  RSMU_CM },
 	{ "82p33810", RSMU_SABRE },
 	{ "82p33811", RSMU_SABRE },
 	{ "8v19n850", RSMU_SL },
@@ -167,6 +168,7 @@ MODULE_DEVICE_TABLE(i2c, rsmu_i2c_id);
 static const struct of_device_id rsmu_i2c_of_match[] = {
 	{ .compatible = "idt,8a34000",  .data = (void *)RSMU_CM },
 	{ .compatible = "idt,8a34001",  .data = (void *)RSMU_CM },
+	{ .compatible = "idt,8a34002",  .data = (void *)RSMU_CM },
 	{ .compatible = "idt,82p33810", .data = (void *)RSMU_SABRE },
 	{ .compatible = "idt,82p33811", .data = (void *)RSMU_SABRE },
 	{ .compatible = "idt,8v19n850", .data = (void *)RSMU_SL },
diff --git a/drivers/mfd/rsmu_spi.c b/drivers/mfd/rsmu_spi.c
index d2f3d8f1e05af..56195ca4fc614 100644
--- a/drivers/mfd/rsmu_spi.c
+++ b/drivers/mfd/rsmu_spi.c
@@ -230,6 +230,7 @@ static void rsmu_spi_remove(struct spi_device *client)
 static const struct spi_device_id rsmu_spi_id[] = {
 	{ "8a34000",  RSMU_CM },
 	{ "8a34001",  RSMU_CM },
+	{ "8a34002",  RSMU_CM },
 	{ "82p33810", RSMU_SABRE },
 	{ "82p33811", RSMU_SABRE },
 	{}
@@ -239,6 +240,7 @@ MODULE_DEVICE_TABLE(spi, rsmu_spi_id);
 static const struct of_device_id rsmu_spi_of_match[] = {
 	{ .compatible = "idt,8a34000",  .data = (void *)RSMU_CM },
 	{ .compatible = "idt,8a34001",  .data = (void *)RSMU_CM },
+	{ .compatible = "idt,8a34002",  .data = (void *)RSMU_CM },
 	{ .compatible = "idt,82p33810", .data = (void *)RSMU_SABRE },
 	{ .compatible = "idt,82p33811", .data = (void *)RSMU_SABRE },
 	{}
-- 
2.53.0



