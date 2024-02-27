Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E68140391;
	Tue, 27 Feb 2024 13:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042071; cv=none; b=dqY7DBOp1WRmXyt0kPyR2PbR7hZQmgj1BKRNzDCvRQkxjXg1lBD/G390CyeSiHHKKXZK8NoNr0yOTi8eN+p6dgFTQfauBsBvUee3Oen7qyiwS+PKc6j9OMnO/dsoeAn+WubeNNKmhLoEQhO6IC/zyF1NET6YgOEIEfNz11roMmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042071; c=relaxed/simple;
	bh=TUwX6nB+HmAQmVMt6l/04CXSnZ5ggwIRMwc+MNd80EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHbQDqOlrsUnD9MCKXYu8uZNGxhHrZmlo5q16JEj6OfJBM2ZluhSQwvyOdwBXGRFVKC3xbUM5Yi5qWN7V7CLaJApXu9RdSdhDOqgghbQZ0XK8Z6r/3pWNBpe/4nSzbc5AnIqUMs41CzyLMA3mMbOHdQhUyHrKRKDrM4Mli7mLb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hv09vt3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hv09vt3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D11EC433F1;
	Tue, 27 Feb 2024 13:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042071;
	bh=TUwX6nB+HmAQmVMt6l/04CXSnZ5ggwIRMwc+MNd80EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hv09vt3kKEfl31NvHHiFcdMXc6fKhbosFT9n+YVh6rhmdLtJd/I5Kts8J2M3mhiUD
	 KrU2oorshV6vvWVLo7reKRvWCwKaMTv0L9pnFPYqp+AG9kvq9WcNAiRvpoKO3n+UY8
	 /XBiGfVoDNtPGjQ5m4jHWZbz+43hE/OhBA9J6zo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Kacprowski <Andrzej.Kacprowski@intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>
Subject: [PATCH 6.6 169/299] accel/ivpu: Dont enable any tiles by default on VPU40xx
Date: Tue, 27 Feb 2024 14:24:40 +0100
Message-ID: <20240227131631.286484060@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrzej Kacprowski <Andrzej.Kacprowski@intel.com>

commit eb0d253ff9c74dee30aa92fe460b825eb28acd73 upstream.

There is no point in requesting 1 tile on VPU40xx as the FW will
probably need more tiles to run workloads, so it will have to
reconfigure PLL anyway. Don't enable any tiles and allow the FW to
perform initial tile configuration.

This improves NPU boot stability as the tiles are always enabled only
by the FW from the same initial state.

Fixes: 79cdc56c4a54 ("accel/ivpu: Add initial support for VPU 4")
Cc: stable@vger.kernel.org
Signed-off-by: Andrzej Kacprowski <Andrzej.Kacprowski@intel.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240220131624.1447813-1-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_hw_40xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/ivpu/ivpu_hw_40xx.c b/drivers/accel/ivpu/ivpu_hw_40xx.c
index 1c995307c113..a1523d0b1ef3 100644
--- a/drivers/accel/ivpu/ivpu_hw_40xx.c
+++ b/drivers/accel/ivpu/ivpu_hw_40xx.c
@@ -24,7 +24,7 @@
 #define SKU_HW_ID_SHIFT              16u
 #define SKU_HW_ID_MASK               0xffff0000u
 
-#define PLL_CONFIG_DEFAULT           0x1
+#define PLL_CONFIG_DEFAULT           0x0
 #define PLL_CDYN_DEFAULT             0x80
 #define PLL_EPP_DEFAULT              0x80
 #define PLL_REF_CLK_FREQ	     (50 * 1000000)
-- 
2.44.0



