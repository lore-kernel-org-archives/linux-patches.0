Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BC83A4526;
	Wed, 20 May 2026 16:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296198; cv=none; b=tH4wjf5cc4dVTUVFzYhH2ThssvEcIUSPFtpYk3jQAoijzN3yoXSh8YooM1v1NJgBvBaB6EMla4Z2wgJKEQtkv0m1YCGcKEOgvuL2yVTNFiai0egCosjunRs3rgFYwqU4CKYEAnG117wsGUJgIVI+QuLzTS9+nQj7lW9u47WvYyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296198; c=relaxed/simple;
	bh=g9AMjYoHXIzfJGCQguqkB2o0m04JPEcw+Ag8nfA1XuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SH095G1dbIWSsN9Irha5I6+AmK5KR2nOHzrmsl+ECmBJ4jbPqWxxNeGIWc2dO5deWy0n7IQyW4dkCmA0xveDrvySV8fZkOHagy4pFe1FVLFN/h7n4CyUAdfggmRTFAdYbQzjooswCA9J0oWhMZcWU9ujZ8XyvN4ihJFcMt2khRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZReB8RBw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZReB8RBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D909C1F000E9;
	Wed, 20 May 2026 16:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296197;
	bh=s4ZJ8Bu+7XvEP8+RoBAJOg3dCT7RI5tQegUPcuqimK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZReB8RBw1++ZrT6yri5o6tL7qnMDc9hqOSK2PqKZSFZaUfVJayUnUw7lsMA4JT7/l
	 5Vd1CIXPBC70okwzAK7MWMlLKEor0KHNVsl1SD1PxtpCL+LPaEZmotVUJMty6TOqb0
	 Tw2I1GZIIyK/rrEap/SjEBfVcrY6LMVP1kV46kx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0691/1146] platform/x86: dell_rbu: avoid uninit value usage in packet_size_write()
Date: Wed, 20 May 2026 18:15:41 +0200
Message-ID: <20260520162203.826692721@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit f8fd138c2363c0e2d3235c32bfb4fb5c6474e4ae ]

Ensure the temp value has been properly parsed from the user-provided
buffer and initialized to be used in later operations.  While at it,
prefer a convenient kstrtoul() helper.

Found by Linux Verification Center (linuxtesting.org) with Svace static
analysis tool.

Fixes: ad6ce87e5bd4 ("[PATCH] dell_rbu: changes in packet update mechanism")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Link: https://patch.msgid.link/20260403134240.604837-1-pchelkin@ispras.ru
[ij: add include]
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell_rbu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/dell/dell_rbu.c b/drivers/platform/x86/dell/dell_rbu.c
index eb50f1d75d0c1..3fa9de9aa47b8 100644
--- a/drivers/platform/x86/dell/dell_rbu.c
+++ b/drivers/platform/x86/dell/dell_rbu.c
@@ -30,6 +30,7 @@
 #define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
 
 #include <linux/init.h>
+#include <linux/kstrtox.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/string.h>
@@ -619,9 +620,12 @@ static ssize_t packet_size_write(struct file *filp, struct kobject *kobj,
 				 char *buffer, loff_t pos, size_t count)
 {
 	unsigned long temp;
+
+	if (kstrtoul(buffer, 10, &temp))
+		return -EINVAL;
+
 	spin_lock(&rbu_data.lock);
 	packet_empty_list();
-	sscanf(buffer, "%lu", &temp);
 	if (temp < 0xffffffff)
 		rbu_data.packetsize = temp;
 
-- 
2.53.0



