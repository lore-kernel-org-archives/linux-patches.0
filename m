Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5844D145A12;
	Thu, 13 Jun 2024 11:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279906; cv=none; b=DsX3IaIp5+GHs2jnT/20tSLuzj4CDD0Zk6N0gpIU+FiZm+IjEnjpG7L2ZRHucg5bpvcmTgLvonMMXETZixOlXcBelEfNY88cQOhNnn9/Hgt3S+VjA0wz4+X1215A7rTmmagXYlMRPI4kOvqIUKbs0OI6pscKyAUjPaZ7OrqnH8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279906; c=relaxed/simple;
	bh=cGZKsdNgdviCV9yNBoUugDx2SuyyKWR+ZICm/wDIw8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QD0+IAvv/4nH1tpGMWxGE7n57hmQ4e2fl4TDfHxPVDFc26HW3Z2cHhkyIDELImHXBpXbhATNmLLkWxteKyg6Q99ts0J7a8J+fjezOCctE/YI84A2MRtKpnRa/tLOQvNIZfXe5IcYpSD2McooYjuSEWImxDyqAHj3/DVPL+jeSyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wx0Kvumc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wx0Kvumc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4649C2BBFC;
	Thu, 13 Jun 2024 11:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279906;
	bh=cGZKsdNgdviCV9yNBoUugDx2SuyyKWR+ZICm/wDIw8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wx0KvumczyIn4oUHT3J1Lutsp//JMdXkgodJRWz9AP4uKdKS0E2kE6uxq0l+4d/VO
	 eTyOAPETWxuI2p1DuS8i7wjdTh2DWg40tDtP9l0e0nstL2TtQYBryc04xsmormrhwj
	 V9lJP9njaFfs2ByB0Rrfvfv9qlFwTVC1GVjjcvKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hulk Robot <hulkci@huawei.com>,
	YueHaibing <yuehaibing@huawei.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/202] platform/x86: wmi: Make two functions static
Date: Thu, 13 Jun 2024 13:32:54 +0200
Message-ID: <20240613113230.706885617@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 713df99a9ef0133c09ad05bac10cf7d0163cd272 ]

Fix sparse warnings:

drivers/platform/x86/xiaomi-wmi.c:26:5: warning: symbol 'xiaomi_wmi_probe' was not declared. Should it be static?
drivers/platform/x86/xiaomi-wmi.c:51:6: warning: symbol 'xiaomi_wmi_notify' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Stable-dep-of: 290680c2da80 ("platform/x86: xiaomi-wmi: Fix race condition when reporting key events")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/xiaomi-wmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/xiaomi-wmi.c b/drivers/platform/x86/xiaomi-wmi.c
index 601cbb282f543..54a2546bb93bf 100644
--- a/drivers/platform/x86/xiaomi-wmi.c
+++ b/drivers/platform/x86/xiaomi-wmi.c
@@ -23,7 +23,7 @@ struct xiaomi_wmi {
 	unsigned int key_code;
 };
 
-int xiaomi_wmi_probe(struct wmi_device *wdev, const void *context)
+static int xiaomi_wmi_probe(struct wmi_device *wdev, const void *context)
 {
 	struct xiaomi_wmi *data;
 
@@ -48,7 +48,7 @@ int xiaomi_wmi_probe(struct wmi_device *wdev, const void *context)
 	return input_register_device(data->input_dev);
 }
 
-void xiaomi_wmi_notify(struct wmi_device *wdev, union acpi_object *dummy)
+static void xiaomi_wmi_notify(struct wmi_device *wdev, union acpi_object *dummy)
 {
 	struct xiaomi_wmi *data;
 
-- 
2.43.0



