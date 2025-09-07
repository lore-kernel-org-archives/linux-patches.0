Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981EE4315A;
	Sun,  7 Sep 2025 20:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277845; cv=none; b=sjLBgKjPzGMm4X0cnVAH8H3k7j0QYG/qa0CJtRhChK/U6Pn/IT/ER2/I19s/Xp7e0dr21olEP5hnRIts0SBXRBU5kHKbzh1g/lT8Qxf2VdueNn7Rwu1vFkgEdZGyY8lYflvz6ymf3SzC4fFx+Dm3JA3xi2UH3glVR7mRHJ+AMzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277845; c=relaxed/simple;
	bh=zKGgEzDSpgAepktmDH/Ewky7Rr4u748ux61qteQRMZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcAw/7xR/3RI5IzMAL/oByHX3xu7LcLeSzTsPzPY28Y4qFber0uWrRv8HxMukCpcFQXd4Hu5A2zWFu19C23gtb9YNQZ+H9CuKxhZ0XFRhNrsFMG5jBa8xufLpjLCKpzyzkVE7B4RmrIujnvhOfLb8N3umChUSRPfRlHfhEBAEmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bfR00+TG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bfR00+TG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087EAC4CEF0;
	Sun,  7 Sep 2025 20:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277845;
	bh=zKGgEzDSpgAepktmDH/Ewky7Rr4u748ux61qteQRMZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bfR00+TGjvGr/3qjcTGvBmIbsTadl4ZTU6WoU2dU9M9oPfrsV5ERkaI/pZVspDS1G
	 C4Flj2ZT2T9+8ksrn+5NAvPFOdg7bTU9lJUS3BlyYA2JHQuHzr68/5gkUUKD4QbiOA
	 IkYGTn4MDuatmpR+J8vKkfuSOgoDLq0vOOBURinc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	stable@kernel.org,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.16 141/183] microchip: lan865x: Fix LAN8651 autoloading
Date: Sun,  7 Sep 2025 21:59:28 +0200
Message-ID: <20250907195619.146288720@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

commit ca47c44d36a9ad3268d17f89789104a471c07f81 upstream.

Add missing IDs for LAN8651 devices, which are also defined in the
DT bindings.

Fixes: 5cd2340cb6a3 ("microchip: lan865x: add driver support for Microchip's LAN865X MAC-PHY")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Cc: stable@kernel.org
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250827115341.34608-4-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/lan865x/lan865x.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/microchip/lan865x/lan865x.c
+++ b/drivers/net/ethernet/microchip/lan865x/lan865x.c
@@ -425,12 +425,14 @@ static void lan865x_remove(struct spi_de
 
 static const struct spi_device_id lan865x_ids[] = {
 	{ .name = "lan8650" },
+	{ .name = "lan8651" },
 	{},
 };
 MODULE_DEVICE_TABLE(spi, lan865x_ids);
 
 static const struct of_device_id lan865x_dt_ids[] = {
 	{ .compatible = "microchip,lan8650" },
+	{ .compatible = "microchip,lan8651" },
 	{ /* Sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, lan865x_dt_ids);


