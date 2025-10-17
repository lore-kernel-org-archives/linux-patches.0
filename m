Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE1932E151;
	Fri, 17 Oct 2025 15:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713528; cv=none; b=WyYuS1lNWE731qejTgchmth54rGe3ptb68oTLu4JrqmhM4dAIfZmFhStTskee6HjHsjsSAJ60Pt2iCcoutN27j9ro4SQjoUiNYDgLHcfO19/xxWCgHBvFitKAElzesER8lq1l13n1ReNM6OwiU3mQSXUa8G7oQQUOGkmLHcQZjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713528; c=relaxed/simple;
	bh=DRNRSHc4iBCHGmq+dMOu8qvIuH0mm7jNIPtwbA0XPHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m241/oaf93IeYqJNMzN5266iHPIc0vRH693NEslVhF4k8anCHf6OP35Ld51efM5djTLdF3PNOQ1LfeIBA1lnFgiyUbN0r89kYS5V3AtMSiTgSDpPNnmZSs1ecSkOKPLSiHY7NtcFFRnA7mHafFG2NMfuhUHtyncEtBcCSKHm2Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lt+/8jQ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lt+/8jQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D7EC4CEE7;
	Fri, 17 Oct 2025 15:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713528;
	bh=DRNRSHc4iBCHGmq+dMOu8qvIuH0mm7jNIPtwbA0XPHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lt+/8jQ8CQ2EJFVCRgQfoYcVLRsTxCHLH9xQ5tshiWVBjbeUpxlxxubDZppKRKws+
	 lnnAE2Zp4bw7OaD86xyPCgDUd5W03P4XqW5UZsaMvCahiPEgx35CyZrEDaPi3mC0OK
	 LX6xDvaXPRGSrW3rJtIp5jjeQfCDzsD+SlwrddZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/201] ASoC: SOF: ipc4-topology: Correct the minimum host DMA buffer size
Date: Fri, 17 Oct 2025 16:51:29 +0200
Message-ID: <20251017145135.778888014@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit a7fe5ff832d61d9393095bc3dd5f06f4af7da3c1 ]

The firmware has changed the minimum host buffer size from 2 periods to
4 periods (1 period is 1ms) which was missed by the kernel side.

Adjust the SOF_IPC4_MIN_DMA_BUFFER_SIZE to 4 ms to align with firmware.

Link: https://github.com/thesofproject/sof/commit/f0a14a3f410735db18a79eb7a5f40dc49fdee7a7
Fixes: 594c1bb9ff73 ("ASoC: SOF: ipc4-topology: Do not parse the DMA_BUFFER_SIZE token")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20251002135752.2430-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-topology.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/ipc4-topology.h b/sound/soc/sof/ipc4-topology.h
index 0fb759c6eeaf9..07bd84204baa7 100644
--- a/sound/soc/sof/ipc4-topology.h
+++ b/sound/soc/sof/ipc4-topology.h
@@ -59,8 +59,8 @@
 
 #define SOF_IPC4_INVALID_NODE_ID	0xffffffff
 
-/* FW requires minimum 2ms DMA buffer size */
-#define SOF_IPC4_MIN_DMA_BUFFER_SIZE	2
+/* FW requires minimum 4ms DMA buffer size */
+#define SOF_IPC4_MIN_DMA_BUFFER_SIZE	4
 
 /*
  * The base of multi-gateways. Multi-gateways addressing starts from
-- 
2.51.0



