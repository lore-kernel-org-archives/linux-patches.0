Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BF450B8DF;
	Wed, 30 Sep 2026 16:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784842; cv=none; b=czg6K+Qd3P6eLkNI5MbJcud2rtdBMW/8cIQkHmrIbW/wIUgHQE9CP3kBCVhQhax80OHI4oYCAVE8ndIt6MxB4kzagL4B6ooEszNOScDoXf6pwL+M7BRc4025fTJMT2UOX7qQmFWiOIXZfslbBVNVtPbZ2J0EvUIpxF+UzTp0beY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784842; c=relaxed/simple;
	bh=L/0CelVnoHHewS6ddshfqzhYX1K4EIaNBq8Pnd8ikRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0BwDD8OTvXcEyifJrDPaRde8xri5qpKU7bAsk3/sLvNuU+vL5W7nkgT/OAjfHegsU8qJNi2t3HdDdgeJjsGFj+tOLLcCIl8oLd4eWiHx5avXCucMYUQrWQ2cq+QHUdanQQHItrKBDsGPBJK1G3DxLfx8QcYvCFjKDIkAcCjf+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xot5jfS+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xot5jfS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4D01F00898;
	Wed, 30 Sep 2026 16:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784836;
	bh=JicajmPda1jM3qFj//OQtqXzdZvu2x909hMt/0LwYIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xot5jfS+FxEQ/m/DhrptwAHwL8c8GM7csu54VlRel5A1RsOpMd/SZvHKiQZ7jMija
	 UCrsLs9gzlC5eyeiJbiDK9rQYnSBrVI+S0NvK1I3bGkLykl/KQN1Ng+E7fcJl2hk14
	 utk7kGc21wieG/M/v3NjnwWL7tNJ9znFL6hB4wJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Genevieve Chan <genevieve.chan@altera.com>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 294/982] firmware: stratix10-svc: fix FCS SMC call kernel-doc
Date: Wed, 30 Sep 2026 17:17:10 +0200
Message-ID: <20260930152423.121141462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Genevieve Chan <genevieve.chan@altera.com>

[ Upstream commit 9b9a6e31bdd1ff20c3ffdab87431672d8bfc2a07 ]

Correct kernel-doc errors for two FCS SMC calls:

INTEL_SIP_SMC_FCS_SEND_CERTIFICATE:
- Describe as async to match STD_CALL_VAL usage
- Replace INTEL_SIP_SMC_FCS_REJECTED with INTEL_SIP_SMC_REJECTED

INTEL_SIP_SMC_FCS_GET_PROVISION_DATA:
- Replace FCS-specific status macros with standard status macros
  (INTEL_SIP_SMC_STATUS_ERROR and INTEL_SIP_SMC_STATUS_REJECTED)
- Restore return register documentation for a1 (mailbox error),
  a2 (physical address), and a3 (structure size)

Fixes: 4a4709d470e6 ("firmware: stratix10-svc: add new FCS commands")
Fixes: 4b0a32016347 ("firmware: stratix10-svc: change get provision data to async SMC call")
Cc: stable@vger.kernel.org # 6.0+
Signed-off-by: Genevieve Chan <genevieve.chan@altera.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/firmware/intel/stratix10-smc.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/firmware/intel/stratix10-smc.h b/include/linux/firmware/intel/stratix10-smc.h
index 4ae295c4e9cc1..118be73846ccc 100644
--- a/include/linux/firmware/intel/stratix10-smc.h
+++ b/include/linux/firmware/intel/stratix10-smc.h
@@ -557,7 +557,7 @@ INTEL_SIP_SMC_FAST_CALL_VAL(INTEL_SIP_SMC_FUNCID_FPGA_CONFIG_COMPLETED_WRITE)
 
 /**
  * Request INTEL_SIP_SMC_FUNCID_FCS_SEND_CERTIFICATE
- * Sync call to send a signed certificate
+ * Async call to send a signed certificate
  *
  * Call register usage:
  * a0 INTEL_SIP_SMC_FCS_SEND_CERTIFICATE
@@ -566,7 +566,7 @@ INTEL_SIP_SMC_FAST_CALL_VAL(INTEL_SIP_SMC_FUNCID_FPGA_CONFIG_COMPLETED_WRITE)
  * a3-a7 not used
  *
  * Return status:
- * a0 INTEL_SIP_SMC_STATUS_OK or INTEL_SIP_SMC_FCS_REJECTED
+ * a0 INTEL_SIP_SMC_STATUS_OK or INTEL_SIP_SMC_REJECTED
  * a1-a3 not used
  */
 #define INTEL_SIP_SMC_FUNCID_FCS_SEND_CERTIFICATE 93
@@ -582,9 +582,11 @@ INTEL_SIP_SMC_FAST_CALL_VAL(INTEL_SIP_SMC_FUNCID_FPGA_CONFIG_COMPLETED_WRITE)
  * a1-a7 not used
  *
  * Return status:
- * a0 INTEL_SIP_SMC_STATUS_OK, INTEL_SIP_SMC_FCS_ERROR or
- *      INTEL_SIP_SMC_FCS_REJECTED
- * a1-a3 not used
+ * a0 INTEL_SIP_SMC_STATUS_OK, INTEL_SIP_SMC_STATUS_ERROR or
+ *	INTEL_SIP_SMC_STATUS_REJECTED
+ * a1 mailbox error if a0 is INTEL_SIP_SMC_STATUS_ERROR
+ * a2 physical address for the structure of fuse and key hashes
+ * a3 the size of structure
  *
  */
 #define INTEL_SIP_SMC_FUNCID_FCS_GET_PROVISION_DATA 94
-- 
2.53.0



