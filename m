Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F87A15ADB2;
	Tue,  9 Jul 2024 11:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524055; cv=none; b=DbYdMPgDWSsYhJ5nMDrvm0uND+jKALwtmlR0iDj6WHtmLddxd/FqEXCBMeX4fi2774cwtAjps4SxWpX1X8+/xytIdCjp4ruevsh5BGIPKj4C0uK1rwQkLwtD1S38IFqJHZm65aG6isdtJCNOs9R1CXzHG2Uuj+vO6Rum3iwldAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524055; c=relaxed/simple;
	bh=1HqkgwLxtkmrfDPj75OZ9WMzOJXWCoHGW5r/mc0fC8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGtQa1fquDYs0aozaW7jh1ERL/Ri0iuXF7ENYnPEVGrktU834boaOk6Kb8YlKRygUNAC7uAjnAgFiB0DIMMSy5pxRO3gfgXjFSwA8OzXNNE6qs086ojosD8ks4GWlkKl82SNaA1fQ4rDMNbe0vcAVdHk/19/zIE6x3ZS0TCWh7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+RnCWkq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+RnCWkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0514CC4AF0A;
	Tue,  9 Jul 2024 11:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524055;
	bh=1HqkgwLxtkmrfDPj75OZ9WMzOJXWCoHGW5r/mc0fC8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+RnCWkqoSvH6hNYWGQUuOjpJ46s4B0wz/0FrKhBtgrCfgkQn0rxe7PNMI8tJ5mox
	 uoS7W8/51wl0vUokg2M9mpi4sf/npXGGCkzwegoE3udmkcaqeO8wH7tXYtOr2ub8oP
	 o5/pPKXNYlzKv7AqUFc+43Hf/v9WSJy914L2j+ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenkai Lin <linwenkai6@hisilicon.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 056/197] crypto: hisilicon/sec2 - fix for register offset
Date: Tue,  9 Jul 2024 13:08:30 +0200
Message-ID: <20240709110711.131268724@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenkai Lin <linwenkai6@hisilicon.com>

[ Upstream commit 6117af86365916e4202b5a709c155f7e6e5df810 ]

The offset of SEC_CORE_ENABLE_BITMAP should be 0 instead of 32,
it cause a kasan shift-out-bounds warning, fix it.

Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index c290d8937b19c..fabea0d650297 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -152,7 +152,7 @@ static const struct hisi_qm_cap_info sec_basic_info[] = {
 	{SEC_CORE_TYPE_NUM_CAP, 0x313c, 16, GENMASK(3, 0), 0x1, 0x1, 0x1},
 	{SEC_CORE_NUM_CAP, 0x313c, 8, GENMASK(7, 0), 0x4, 0x4, 0x4},
 	{SEC_CORES_PER_CLUSTER_NUM_CAP, 0x313c, 0, GENMASK(7, 0), 0x4, 0x4, 0x4},
-	{SEC_CORE_ENABLE_BITMAP, 0x3140, 32, GENMASK(31, 0), 0x17F, 0x17F, 0xF},
+	{SEC_CORE_ENABLE_BITMAP, 0x3140, 0, GENMASK(31, 0), 0x17F, 0x17F, 0xF},
 	{SEC_DRV_ALG_BITMAP_LOW, 0x3144, 0, GENMASK(31, 0), 0x18050CB, 0x18050CB, 0x18670CF},
 	{SEC_DRV_ALG_BITMAP_HIGH, 0x3148, 0, GENMASK(31, 0), 0x395C, 0x395C, 0x395C},
 	{SEC_DEV_ALG_BITMAP_LOW, 0x314c, 0, GENMASK(31, 0), 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF},
-- 
2.43.0



