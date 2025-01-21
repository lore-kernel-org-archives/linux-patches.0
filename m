Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E198C1F5614;
	Tue, 21 Jan 2025 17:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482079; cv=none; b=QPVzwhrG/Ameg4pY4U988lSCqw9GVgLzAxsRX+khWilE+O4L3laGUP8mw6jxl0adTwzecbrF0AlvYXDfD1GPZ8I1jmEfX1jHCR4kXrVzpyzHcQ/UhCkjT0+1IFVv80vozs2pc+D9bc9+MUhmwdb75P/P96efgpaniruDQxWHT94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482079; c=relaxed/simple;
	bh=RhxWKOt1M0qplYHgK+A0ok9d7DAnOv2TKN9q1zh9Bfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kIlE/e3ato6ojp3WQbeIB3ZvMpREcoGURX+cqM89l/55lXxopS4Xpmri00LYd94r1/NgR3Y0pKM2RdsAQUadAAnxaZmzqvfcGpz4myriVlAlAxqI/WoeuKNF0troGV9YN56HHDM4M/bdqXv88UhcNhzE4eSifE1+i+nCFnnH+X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sbXvCvp8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sbXvCvp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E7EC4CEDF;
	Tue, 21 Jan 2025 17:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482078;
	bh=RhxWKOt1M0qplYHgK+A0ok9d7DAnOv2TKN9q1zh9Bfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sbXvCvp82Jen19Wi60Gh6FnmhgBAf0GkVNpg1FKxrIZhK1hzJ0DPJoV0oHSmYKYKA
	 AwVUpihL9fiNvjyuDMyLVVnnJKpLzkmUfJK4E5FFSRFvvQP+RCqdZQ5Zc5A8qLjHz5
	 azauInBSR8ZS+bfIOakDN6qYlgAKbO3NzTU9n+Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MD Danish Anwar <danishanwar@ti.com>,
	Roger Quadros <rogerq@kernel.org>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 19/72] soc: ti: pruss: Fix pruss APIs
Date: Tue, 21 Jan 2025 18:51:45 +0100
Message-ID: <20250121174524.166949474@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



