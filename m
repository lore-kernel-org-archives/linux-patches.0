Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF3C35973;
	Mon,  6 Jan 2025 15:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176759; cv=none; b=kd1+Mdu0RjjO1yolARdqI+D9jmlVrUQygmJo8WM2LzD6Dqy7/SuLATOt4Ngcj9jrTtXVkyLurqD18jfmoswwivkJrDbr9QKqwdWip7UhjTQabepTN/pQQmuNgMPTuuCEb2QnA1dNq4oAZfZEaUYkYKp4fEPYz1m8S9gcFf0WQT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176759; c=relaxed/simple;
	bh=Kz4hb3ddqJTd8mEGiPwshJFo6YkJxdb8z6iY7r61znY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3ebmHxCSBjB1DM4YKbr8wtu92b8XAyZ1sJn83QsaMaVJ3KYNaIqPxEfyMqPeBwdmZQfmhLvqpNw8O6b8b6gPpH1T2YjBS/yRXqow3ClEDrZzYvrpDNwOx71JZUv9szpS1mnyffcHzj7n+/8VqwYcznkJR97jW8KFgooq3yk33Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oE66qYEq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oE66qYEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9CCC4CED2;
	Mon,  6 Jan 2025 15:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176758;
	bh=Kz4hb3ddqJTd8mEGiPwshJFo6YkJxdb8z6iY7r61znY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oE66qYEqBIVsJqzo3NL1DGhpOHiDS1vcCiVoGAik83z/1uB8RqsZczbn/q48+m054
	 waH/L1DRaCDcRL/qVlBHw1ROiPYAaZUkVxnlag2L7LTPxzRbWYky6eYlLkp5bwyBxA
	 KI992jKhsADN3d4Kaeky2lgvNeBbLu8/0DnjqrFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 05/81] thunderbolt: Add support for Intel Lunar Lake
Date: Mon,  6 Jan 2025 16:15:37 +0100
Message-ID: <20250106151129.641702600@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 2cd3da4e37453019e21a486d9de3144f46b4fdf7 ]

Intel Lunar Lake has similar integrated Thunderbolt/USB4 controller as
Intel Meteor Lake with some small differences in the host router (it has
3 DP IN adapters for instance). Add the Intel Lunar Lake PCI IDs to the
driver list of supported devices.

Tested-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Stable-dep-of: 8644b48714dc ("thunderbolt: Add support for Intel Panther Lake-M/P")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/nhi.c | 4 ++++
 drivers/thunderbolt/nhi.h | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index 288aaa05d007..5301effa6ab0 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -1479,6 +1479,10 @@ static struct pci_device_id nhi_ids[] = {
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MTL_P_NHI1),
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_LNL_NHI0),
+	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_LNL_NHI1),
+	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_80G_NHI) },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_40G_NHI) },
 
diff --git a/drivers/thunderbolt/nhi.h b/drivers/thunderbolt/nhi.h
index 0f029ce75882..7a07c7c1a9c2 100644
--- a/drivers/thunderbolt/nhi.h
+++ b/drivers/thunderbolt/nhi.h
@@ -90,6 +90,8 @@ extern const struct tb_nhi_ops icl_nhi_ops;
 #define PCI_DEVICE_ID_INTEL_TGL_H_NHI1			0x9a21
 #define PCI_DEVICE_ID_INTEL_RPL_NHI0			0xa73e
 #define PCI_DEVICE_ID_INTEL_RPL_NHI1			0xa76d
+#define PCI_DEVICE_ID_INTEL_LNL_NHI0			0xa833
+#define PCI_DEVICE_ID_INTEL_LNL_NHI1			0xa834
 
 #define PCI_CLASS_SERIAL_USB_USB4			0x0c0340
 
-- 
2.39.5



