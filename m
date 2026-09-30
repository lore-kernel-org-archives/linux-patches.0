Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40513BE163;
	Wed, 30 Sep 2026 19:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794825; cv=none; b=KDqD0SYa2sqIhqfYmLMeu7w3pox5dKXHFeIdN/3uncIdUmHCcChPEPPNDrA9UsQw7pZxjKlQRZ0cGJe/2EbsWGI3zW9UBLN3COxFMSFxd/V9tFh2eE9+GMYPbrf9ADIXkqh11dB2Y+N6MtZu3/Bqj4waKVKyNIg7sa9v30WoTDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794825; c=relaxed/simple;
	bh=Fkj6z1T1izoMOGt5amKb6jWR+cjTZDLAJLP60g4PwJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZF94FaGsapV5jepAERVU5B/TEYYqwiZqJKmdYskX8yUfbY737GVvHpCqIl2nVtLCS0H3H2jutjlfvp+2880Pvaw2ocTLYAmWEg+ixRn+DkTmuinyfc6lvwYWBTLesDUhmS7WdpAtPAwstYAAy9aV+P194HE4QI1gPXTza4rfX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KjeqkbZZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KjeqkbZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002C61F00898;
	Wed, 30 Sep 2026 19:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794824;
	bh=1HU0tcXDphyTRJfujBWCT1NKsPRXjf2h8kTugSbl8Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KjeqkbZZ5guFW4mcaTFXGgooZbETcwS7IKKwizm67bXXRSqR4zUwrw6dA/tMTbxBJ
	 vxFV6ylQKzkmstXtFRIQXrxBkxpecO1lpiHW4JPiQyM0bXsrfFt3MRW8egOz/uERUM
	 M0T9EHWNowyPSGZMkKkNeXb8qW63wGxZ7cvw4qNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Genevieve Chan <genevieve.chan@altera.com>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0346/1193] firmware: stratix10-svc: fix FCS SMC call kernel-doc
Date: Wed, 30 Sep 2026 17:17:10 +0200
Message-ID: <20260930152441.848610852@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 1e60fd6210c3b..f0d0f980b0798 100644
--- a/include/linux/firmware/intel/stratix10-smc.h
+++ b/include/linux/firmware/intel/stratix10-smc.h
@@ -582,7 +582,7 @@ INTEL_SIP_SMC_FAST_CALL_VAL(INTEL_SIP_SMC_FUNCID_FPGA_CONFIG_COMPLETED_WRITE)
 
 /**
  * Request INTEL_SIP_SMC_FUNCID_FCS_SEND_CERTIFICATE
- * Sync call to send a signed certificate
+ * Async call to send a signed certificate
  *
  * Call register usage:
  * a0 INTEL_SIP_SMC_FCS_SEND_CERTIFICATE
@@ -591,7 +591,7 @@ INTEL_SIP_SMC_FAST_CALL_VAL(INTEL_SIP_SMC_FUNCID_FPGA_CONFIG_COMPLETED_WRITE)
  * a3-a7 not used
  *
  * Return status:
- * a0 INTEL_SIP_SMC_STATUS_OK or INTEL_SIP_SMC_FCS_REJECTED
+ * a0 INTEL_SIP_SMC_STATUS_OK or INTEL_SIP_SMC_REJECTED
  * a1-a3 not used
  */
 #define INTEL_SIP_SMC_FUNCID_FCS_SEND_CERTIFICATE 93
@@ -607,9 +607,11 @@ INTEL_SIP_SMC_FAST_CALL_VAL(INTEL_SIP_SMC_FUNCID_FPGA_CONFIG_COMPLETED_WRITE)
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



