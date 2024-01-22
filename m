Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AF94F5E3;
	Tue, 23 Jan 2024 00:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970434; cv=none; b=f+2JSmueuu+taLHFgPoxvpE5iCxb1rGNvrW2lW4FLJES95Mli86hi3Fb+uQMHEbOiI3aZQZWi2llbJ0l79bPac1adcAHD+NKCwmCTHUAckEgtkNLHmKSiq/781oFSiYRTRAcI+0he1qM64sVA5Yx972etnX4j0eqbo5vr6bl/Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970434; c=relaxed/simple;
	bh=YzP1aYGyK4P/sJ/5JfpA6CFmiJYlTE8SsUdBfyJGQc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jitEuBpl4ts23cdErb7qh2rBl8o/I/f0rsxxvPJFyT1j7UnP6RiDbzgwSMpjMfvdiABL5iQHMTsBRJwxVmVUaVum5N2Q1fCW2EJDF55xN73XSc9lAq+t6ukkmH0MQZ4sXMJcy6XjhcellEoWYhU+QQFbpDqrQrD0o8BNeT2KDP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XlQ9kOfh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XlQ9kOfh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7818C433C7;
	Tue, 23 Jan 2024 00:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970434;
	bh=YzP1aYGyK4P/sJ/5JfpA6CFmiJYlTE8SsUdBfyJGQc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XlQ9kOfhRoSm7sqmIiJ+ysWhdHXmkwM4olGRAqQr5pcutrgC5YBGqZ1tXpvUqlET0
	 sFAKV4ov0EeBCm+vGNLab7pUSE6670wJr60gJBC9MQYudHoQCPfN+ELehsxs5BG4+i
	 2oK9qk03i+oImoQYYTxTwPzmmqEWouWWtiITfUyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"David E. Box" <david.e.box@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/417] platform/x86/intel/vsec: Support private data
Date: Mon, 22 Jan 2024 15:53:07 -0800
Message-ID: <20240122235752.203100870@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 4ec5d0231d2e4aebe41152d57c6b4f1e7ea14f08 ]

Add fields to struct intel_vsec_device, so that core module (which
creates aux bus devices) can pass private data to the client drivers.

For example there is one vsec device instance per CPU package. On a
multi package system, this private data can be used to pass the package
ID. This package id can be used by client drivers to change power
settings for a specific CPU package by targeting MMIO space of the
correct PCI device.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Acked-by: David E. Box <david.e.box@linux.intel.com>
Link: https://lore.kernel.org/r/20230202010738.2186174-4-srinivas.pandruvada@linux.intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: 8cbcc1dbf8a6 ("platform/x86/intel/vsec: Fix xa_alloc memory leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/vsec.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/x86/intel/vsec.h b/drivers/platform/x86/intel/vsec.h
index d02c340fd458..ae8fe92c5595 100644
--- a/drivers/platform/x86/intel/vsec.h
+++ b/drivers/platform/x86/intel/vsec.h
@@ -38,6 +38,8 @@ struct intel_vsec_device {
 	struct ida *ida;
 	struct intel_vsec_platform_info *info;
 	int num_resources;
+	void *priv_data;
+	size_t priv_data_size;
 };
 
 int intel_vsec_add_aux(struct pci_dev *pdev, struct device *parent,
-- 
2.43.0



