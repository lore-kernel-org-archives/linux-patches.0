Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064829;
	b=njHUtzfYR27rrJsK9nSFu4y3tTa7+BpE0CpXKgrXX2iTrD1yaQpH2SAtR5rCIL6irvvN
	 sn1AZ2D6aPaTnePqZfMMEVrBnFbAn0Row//2TeYvp/D/6ZADnHYIgYKjIXUj5iZbWgaXl
	 Q/RMUC+Xw3S30gKA92tgZfqH80YibO0g+NVNhthezayAdD4NsTwdsyp3T2uG9vtXlKe7G
	 3wu19RpKEw68SaXWg3s16MvFNCEx3fwV+l8shu5LEhhZZfkmRSN16nPvKKhCybYsFAnUU
	 +QzO1Hji9cxba7Z7VKaFUu53+385na1zgt8OG+E+d5xjlMq+fpjsp60zmecXYUphcdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qe3UtFQNz4ruWuUVPX3T5m9GKGEsj417qligNCVVv1o=;
	b=lmfRSEx37DsS2zJ8j8WreZ75y58IoBgOXXKfCKO3q4z/zLsi8zARxBn9GaFlFVIbqpJn
	 YjCj0TsMlm7wTqW6lI0iHpTlf3UuA2Iwar+Wr7XmQMwlwhZnIKwitEUIzBErcd3UUm5H4
	 1QrmLkQuFrh85e+fgYBsFju/nqrWrKPa1e0m08jYiEoHnE59Dah7N+RAFQ3KHTgXT0Jwz
	 gCCn5r9MtCrSYEr62lGgz1j1wMbKmz8wYT0QAEu28CcO2wPIIUGHVchmUsLBgAzRaBOmV
	 DCO4AZRhBSdw6PdIG6cGKYU5B4iit6e1wS9H2+j9TmIIj1xzds6t6prMsV4zY2KFKWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qP4Xvni/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38611606A338;
	Sat,  7 Nov 2026 15:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qP4Xvni/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA5F1F0089F;
	Sat,  7 Nov 2026 15:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064829;
	bh=Qe3UtFQNz4ruWuUVPX3T5m9GKGEsj417qligNCVVv1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qP4Xvni/JNlWG3En6DXKQ1fp9i8C0rXjV9UwTeviN5J8TCucfOGc2xywOAC6IXXqx
	 b+eUc+6vKFcAJa+j6xqxli+kSWhMKYtJfXSXnHV1CMVCfv8QY7bS7Mm1rTlP5Hny4m
	 P2WWuhscLXn+wsrx+7Tbjd1gSvT+g3vo3E9ValUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0761/1257] mfd: ab8500: Fix child device leaks on probe failure
Date: Sat,  7 Nov 2026 08:50:57 -0500
Message-ID: <20261107135000.307387916@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 5bf2ae8b131d4ae9c0ed5f7aa02532645f512022 ]

ab8500_probe() registers MFD child devices before completing the
remaining device initialization. If a later MFD registration or sysfs
group creation fails, previously registered child devices are not
removed.

Use devm_mfd_add_devices() so registered MFD child devices are removed
when probe fails.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: cca69b67b3ba ("mfd: Export ab8500 chip id to sysfs")
Fixes: 9c717cf3fa16 ("mfd: ab8500-core: Add device for new RTC version for AB8540 cut2")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260924144355.1604369-1-lgs201920130244@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/ab8500-core.c | 44 ++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 86fa99022cb35..44fc2ce83cdd7 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1194,39 +1194,41 @@ static int ab8500_probe(struct platform_device *pdev)
 		return ret;
 
 	if (is_ab9540(ab8500))
-		ret = mfd_add_devices(ab8500->dev, 0, ab9540_devs,
-				ARRAY_SIZE(ab9540_devs), NULL,
-				0, ab8500->domain);
+		ret = devm_mfd_add_devices(ab8500->dev, 0, ab9540_devs,
+					   ARRAY_SIZE(ab9540_devs), NULL,
+					   0, ab8500->domain);
 	else if (is_ab8540(ab8500)) {
-		ret = mfd_add_devices(ab8500->dev, 0, ab8540_devs,
-			      ARRAY_SIZE(ab8540_devs), NULL,
-			      0, ab8500->domain);
+		ret = devm_mfd_add_devices(ab8500->dev, 0, ab8540_devs,
+					   ARRAY_SIZE(ab8540_devs), NULL,
+					   0, ab8500->domain);
 		if (ret)
 			return ret;
 
 		if (is_ab8540_1p2_or_earlier(ab8500))
-			ret = mfd_add_devices(ab8500->dev, 0, ab8540_cut1_devs,
-			      ARRAY_SIZE(ab8540_cut1_devs), NULL,
-			      0, ab8500->domain);
+			ret = devm_mfd_add_devices(ab8500->dev, 0,
+						   ab8540_cut1_devs,
+						   ARRAY_SIZE(ab8540_cut1_devs),
+						   NULL, 0, ab8500->domain);
 		else /* ab8540 >= cut2 */
-			ret = mfd_add_devices(ab8500->dev, 0, ab8540_cut2_devs,
-			      ARRAY_SIZE(ab8540_cut2_devs), NULL,
-			      0, ab8500->domain);
+			ret = devm_mfd_add_devices(ab8500->dev, 0,
+						   ab8540_cut2_devs,
+						   ARRAY_SIZE(ab8540_cut2_devs),
+						   NULL, 0, ab8500->domain);
 	} else if (is_ab8505(ab8500))
-		ret = mfd_add_devices(ab8500->dev, 0, ab8505_devs,
-			      ARRAY_SIZE(ab8505_devs), NULL,
-			      0, ab8500->domain);
+		ret = devm_mfd_add_devices(ab8500->dev, 0, ab8505_devs,
+					   ARRAY_SIZE(ab8505_devs), NULL,
+					   0, ab8500->domain);
 	else
-		ret = mfd_add_devices(ab8500->dev, 0, ab8500_devs,
-				ARRAY_SIZE(ab8500_devs), NULL,
-				0, ab8500->domain);
+		ret = devm_mfd_add_devices(ab8500->dev, 0, ab8500_devs,
+					   ARRAY_SIZE(ab8500_devs), NULL,
+					   0, ab8500->domain);
 	if (ret)
 		return ret;
 
 	/* Add battery management devices */
-	ret = mfd_add_devices(ab8500->dev, 0, ab8500_bm_devs,
-			      ARRAY_SIZE(ab8500_bm_devs), NULL,
-			      0, ab8500->domain);
+	ret = devm_mfd_add_devices(ab8500->dev, 0, ab8500_bm_devs,
+				   ARRAY_SIZE(ab8500_bm_devs), NULL,
+				   0, ab8500->domain);
 	if (ret)
 		dev_err(ab8500->dev, "error adding bm devices\n");
 
-- 
2.53.0



