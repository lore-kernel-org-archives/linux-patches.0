Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927E74FD791;
	Thu, 17 Sep 2026 18:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668700; cv=none; b=j8XOSM7XqNn5XjIqCZdaHDJIVT74B7x08Tc4HgE2dFatdRC6BMmtCNMsVCNh6X0VwY8arh/xsVzQ2jxEK48ScVkrfi77xMCP3HmFoADkIpxI5ni3Wqdufx73Y2G/rivzMa3NI8okMpb5tzIhGoMdv/mjt522rqsi7NKmegmgYJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668700; c=relaxed/simple;
	bh=E0LNUW5J8psFEPGhCMyPSmFNOk5NgLBEnBMpg05qt6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOTn6YGm90czmDf2gML9lxpZ/X0kgnXCc/fMkXo+6/Du0QZ05tDV0mYDjbb7Yv6Wg8in3Hq2lxnp7I1Td4gUVU9vrz7obGAwKCM45uyW6V3avoL0EhTZWkpcuJ51+wILph2s2bdDJQ20kRZTwnH+GTZPbeqqxmfLUWGHzPy9MbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OPjbmp2g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OPjbmp2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18C81F000FF;
	Thu, 17 Sep 2026 18:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668699;
	bh=M+z3vjY9SCY/lEFKWBfkpQlYay2VZCysVViAKeYNTwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OPjbmp2gZTmW4xzoLAvaLbuWwr9TG2bzJnlAbsXAfFbHBpo3QNx+Smf3CPNezcGxb
	 9FqYBEbgynwQZMdi+r4hIKo2tu1nl91HDN5Qj3TpT1mpjeXTYEGYSBLULs5t7m57ww
	 YDPIFcR55Hhi0k5A/Y60eew0Sk8hfoH7gXwaZ3JQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Genevieve Chan <genevieve.chan@altera.com>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0465/1102] firmware: stratix10-svc: fix FCS SMC call kernel-doc
Date: Thu, 17 Sep 2026 16:06:48 +0100
Message-ID: <20260917151551.363246133@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



