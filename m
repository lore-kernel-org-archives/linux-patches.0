Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9596A1F666B;
	Tue, 21 Jan 2025 18:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482416; cv=none; b=U3Q8pLN3clTm6EQLYa8lGkaAyb0YkWyKktj/J3bCh/HAteyMkLJuz8o9mhr1ohmG/LeFoX0ipt+kyEnYlOwYGjv5KDGF8i1BqY2VvVWkH06JR9Y3yISztln3HfLa/9O459efD5hnZszB26H1KlHGtSVurF1UgpT4YWEVwi8+Ot8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482416; c=relaxed/simple;
	bh=3LnhhFX4W3gyazGoqK/LwpC6h5vKIHodmzEpL9O/u64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehFCD7s62PhAShNx8SNv/Jv52KOtxSto50q04c5Ftco6JKgyjITyJ32ihl3dc8H8ycCipC5VndztlvLH2mVvlSTQXtJiQleg9Q4vosrIg0j+mvanSc90Vh4zAkAj5nea1X1EkrFnBYlHe1zOjd6wLASInAE2NEGh5QOTwlES+Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FN8P5kSg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FN8P5kSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD32C4CEDF;
	Tue, 21 Jan 2025 18:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482414;
	bh=3LnhhFX4W3gyazGoqK/LwpC6h5vKIHodmzEpL9O/u64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FN8P5kSgbUNBnPeVHwDXUPFeYFjg+QT02+oyoKjW3nu97wS1mygzzsGH3aaeEkmsb
	 VDDjlHhd7JjMdhA5JCFwsG/Lxl766yODZQYvGmz8ghFLkoYXdIlsdNzFpaeQxughaW
	 JISTtZ2LX05c/BOEdeeiIQVl6NvODvsuXClRRSI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MD Danish Anwar <danishanwar@ti.com>,
	Roger Quadros <rogerq@kernel.org>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/122] soc: ti: pruss: Fix pruss APIs
Date: Tue, 21 Jan 2025 18:51:26 +0100
Message-ID: <20250121174534.452969464@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: MD Danish Anwar <danishanwar@ti.com>

[ Upstream commit 202580b60229345dc2637099f10c8a8857c1fdc2 ]

PRUSS APIs in pruss_driver.h produce lots of compilation errors when
CONFIG_TI_PRUSS is not set.

The errors and warnings,
warning: returning 'void *' from a function with return type 'int' makes
	integer from pointer without a cast [-Wint-conversion]
error: expected identifier or '(' before '{' token

Fix these warnings and errors by fixing the return type of pruss APIs as
well as removing the misplaced semicolon from pruss_cfg_xfr_enable()

Fixes: 0211cc1e4fbb ("soc: ti: pruss: Add helper functions to set GPI mode, MII_RT_event and XFR")
Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Link: https://lore.kernel.org/r/20241220100508.1554309-2-danishanwar@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pruss_driver.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/pruss_driver.h b/include/linux/pruss_driver.h
index c9a31c567e85b..2e18fef1a2e10 100644
--- a/include/linux/pruss_driver.h
+++ b/include/linux/pruss_driver.h
@@ -144,32 +144,32 @@ static inline int pruss_release_mem_region(struct pruss *pruss,
 static inline int pruss_cfg_get_gpmux(struct pruss *pruss,
 				      enum pruss_pru_id pru_id, u8 *mux)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	return -EOPNOTSUPP;
 }
 
 static inline int pruss_cfg_set_gpmux(struct pruss *pruss,
 				      enum pruss_pru_id pru_id, u8 mux)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	return -EOPNOTSUPP;
 }
 
 static inline int pruss_cfg_gpimode(struct pruss *pruss,
 				    enum pruss_pru_id pru_id,
 				    enum pruss_gpi_mode mode)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	return -EOPNOTSUPP;
 }
 
 static inline int pruss_cfg_miirt_enable(struct pruss *pruss, bool enable)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	return -EOPNOTSUPP;
 }
 
 static inline int pruss_cfg_xfr_enable(struct pruss *pruss,
 				       enum pru_type pru_type,
-				       bool enable);
+				       bool enable)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	return -EOPNOTSUPP;
 }
 
 #endif /* CONFIG_TI_PRUSS */
-- 
2.39.5



