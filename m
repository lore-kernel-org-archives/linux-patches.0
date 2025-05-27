Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2896F2CCC0;
	Tue, 27 May 2025 16:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365090; cv=none; b=rF7QTYuIzWVdDZDFX4IGxTcwNCTTHG9sUusvgWJwajmyCy4BTpJsP/H4jcFXVbW8v8vNSXL9Sx7mfWxLVVMGPICyCr2/pZYWXfddZ9dYPgiY6y4/JlMzus5I/MDtJeQGJKAl+Op8iXJzis0w2VKG0qNHCJXDjgSwNs2FCc8VcQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365090; c=relaxed/simple;
	bh=C8CnfhOyEuVSSshbz/rPfVUIup1upxW5txyiFAfi03o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3ZGazON/AodEfTFWLI7g6qIHL7vWdDgMAtTJ44Srz2EBVImVKWzzS0JnGEDzhPBUj5BPKZFbNks45MrFeC+DpSx4f1c9TBr6Iv0W1l87WSFqwmtQUL00/0ogkkjzCB9Gs2JQYFh4xuckNfONcMzANrs6Ju8RDDvYJfZtKwyKS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1w6jf12I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1w6jf12I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A75C4CEE9;
	Tue, 27 May 2025 16:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365090;
	bh=C8CnfhOyEuVSSshbz/rPfVUIup1upxW5txyiFAfi03o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1w6jf12IaWd3YOiBAu3JsbNfVC/Q/rDAJygxoP6Zp/xcFo/qxkVgisuhmH6UIgWML
	 INQWRA/xK12uXQiZvOsBF4eCD8uGtSSE+8kZLoQyNC+6yB9dy2BcICVg4Ujfo15PTq
	 lbpR9d19jphCQ3ejm47ZCG3KFmnwv5hjy2fyoe6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ang Tien Sung <tien.sung.ang@intel.com>,
	Kuhanh Murugasen Krishnan <kuhanh.murugasen.krishnan@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 263/626] fpga: altera-cvp: Increase credit timeout
Date: Tue, 27 May 2025 18:22:36 +0200
Message-ID: <20250527162455.694324135@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Kuhanh Murugasen Krishnan <kuhanh.murugasen.krishnan@intel.com>

[ Upstream commit 0f05886a40fdc55016ba4d9ae0a9c41f8312f15b ]

Increase the timeout for SDM (Secure device manager) data credits from
20ms to 40ms. Internal stress tests running at 500 loops failed with the
current timeout of 20ms. At the start of a FPGA configuration, the CVP
host driver reads the transmit credits from SDM. It then sends bitstream
FPGA data to SDM based on the total credits. Each credit allows the
CVP host driver to send 4kBytes of data. There are situations whereby,
the SDM did not respond in time during testing.

Signed-off-by: Ang Tien Sung <tien.sung.ang@intel.com>
Signed-off-by: Kuhanh Murugasen Krishnan <kuhanh.murugasen.krishnan@intel.com>
Acked-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20250212221249.2715929-1-tien.sung.ang@intel.com
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/altera-cvp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/fpga/altera-cvp.c b/drivers/fpga/altera-cvp.c
index 6b09144324453..5af0bd33890c0 100644
--- a/drivers/fpga/altera-cvp.c
+++ b/drivers/fpga/altera-cvp.c
@@ -52,7 +52,7 @@
 /* V2 Defines */
 #define VSE_CVP_TX_CREDITS		0x49	/* 8bit */
 
-#define V2_CREDIT_TIMEOUT_US		20000
+#define V2_CREDIT_TIMEOUT_US		40000
 #define V2_CHECK_CREDIT_US		10
 #define V2_POLL_TIMEOUT_US		1000000
 #define V2_USER_TIMEOUT_US		500000
-- 
2.39.5



