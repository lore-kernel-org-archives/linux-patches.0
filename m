Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058700;
	b=xkj+1v+TT9xVydhm1Lu2DuBLnHMmBjbZfRa7nLKlyQk/uG34cvSkY/+27boCgAmb0BMo
	 F0+RyfXLthxr0CMiDJ89SOrH4Kc6Mwj9movxZlM2bgmCJZN4jy4gMd8tgURFgiGsiPMr4
	 sKvK3gUgqD7To+BGzbWFwhLZHfcFW2V4PhT7Rb4GI5tz83ln8oqYUOFYLul7RoeYdTUoB
	 aY6M1IzTWTAfWItbLI0dLJBPOHsqTimV2Qd32eKKej9lNiTv5ORscyhoJwUYjteuRl9oy
	 /9cYl4buCHv9FxGW5J16RDoxcJClz8ygTWYN9BEEDE6hErNGYBwCVDOiQiFnkreaNwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e97VrV4xoPbtN30p0zsb1qdVsg4op3bdvFmmO87TYxY=;
	b=2zz5lwxO1lYUgOb9BP5m4TTZud6S5QdrmFq8dsbV8pjw25Y2y4ri2YnElrNB9zu658Ja
	 UWAUJF5O9cHV1ggvO6wgokeBTSbS66TMJYJ5Ca4jQchnJD5BlJJd+92F8YxqRJSutlrWL
	 eiAiS+KMPpj3QefgvrbmrCS8Too9pdQ7k7+lvwujOfwwJAahT03+npF06Y5+svp+roOXA
	 QvNDb33KyPhJMBPtIOnqXawU8Fle15pGNcvn73b/sneV/RmcsLsFsZ22AXgHn7jXs6HaI
	 mBBSvfWQCTpDoDpPv4QHNeyC5FMAYsq1cli/6IO4W0RXKX6i6e6rgS2aqjVQR7rB7uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wr2OJ2Zo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3DC60A2603;
	Thu, 19 Nov 2026 03:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wr2OJ2Zo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17041F000C6;
	Thu, 19 Nov 2026 03:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058700;
	bh=e97VrV4xoPbtN30p0zsb1qdVsg4op3bdvFmmO87TYxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wr2OJ2Zo02LOUHyjvYl8R4rJK84e4cQlS14Kjtj41wKIc/gqHMueNeCcKkwr5g+U+
	 140Qn4cUYTGdHqIpJ+ulnDqKbyCKSKkLi9xen6zA6cWuZlshsktIA3Em1heVqY+lnD
	 EZCiiJi+W/ahlSmhOzKV33E99yHYhRZiyPoSMktM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0528/1848] dax: Return errors from dax_core_init()
Date: Wed, 18 Nov 2026 15:42:46 +0100
Message-ID: <20261118145936.988857421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianyun Gao <jianyungao89@gmail.com>

[ Upstream commit 4da700e2cadf84a6e858391d5be51d64dcba080f ]

dax_core_init() returns success when either the character device
number allocation or DAX bus registration fails, even though the
error paths have already released the initialized resources.

For modular DAX, this allows the module to remain loaded despite
failed initialization, leaving subsequent users and module removal
to access resources that have already been released.

Return the error code from the failed operation so that module
loading fails rather than reporting successful initialization
after the resources have been released.

Fixes: 9567da0b408a ("device-dax: Introduce bus + driver model")
Cc: stable@vger.kernel.org
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20261012151857.22534-1-jianyungao89@gmail.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 260a247c60d2d..d1058ad64fe65 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -748,7 +748,7 @@ static int __init dax_core_init(void)
 	unregister_chrdev_region(dax_devt, MINORMASK+1);
 err_chrdev:
 	dax_fs_exit();
-	return 0;
+	return rc;
 }
 
 static void __exit dax_core_exit(void)
-- 
2.53.0



