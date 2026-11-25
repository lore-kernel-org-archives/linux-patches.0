Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619221;
	b=a2k2/GYuzMmq/nwvMozSuc8V818d/I5PmeZILMWRR9bqAS8HMn+aC9EXVpl+pBZsbwEj
	 Ww6XKgqs245wLDfvnXASr3Q6jK0cWHY2Zerp7CDeQwKTSnTq0kk/YjLcsX3+BKodFC5ZO
	 ha5Ig3VNphYNfXYuoD/MdJJn0TBNnPBD0Z7lY6dROvZj19SWMajrrv/FHqY6o8+x6FmM9
	 fMMikOEZhF0VvX9yiytY05sYXYOMkaRZJSLAjqtcY3EIeLpqlarZ1A13TiEeIjHCWOKUs
	 dRPG+l4hGqLKkNc8D0oTeR2FEAtM8hdim2R5soXoBn16gAoFLHQSZE13MdCuL9GId3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OgCgn0AFXt8F1guMciZobDe8zmfFji0gfaCm5kd5Ye4=;
	b=zIlVDYGrFY152QOrO4TbR4kLCXRwrS56xQsHSOpYUitx08zBS9267f1aG+kiXsziGEHv
	 DhN7QRj754nZfmsNr7SDKo05flkyht16tVmlIgxG/nsVpiHZhAf3yHuMmyJC1Xzo9pjdM
	 SrEivlXvhtm8MXxHva4z9Wl6ad/xNsRbhvcjKOtVufPd8VI3LOY9034E61o1cWItwprVG
	 WHdG15WD2BsGs/eU5uzKfEypbOgccAC1mzJt2QbWYDPJWuLBpbEkcNxrLMTFBAmTZ9xv3
	 OUZj7N4KXIVdtCW9KlZ5Od6CYlsDGcrJwSUSnSByk4cG1QOyU0g0hDCWbRjELTXLWMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Lg/alT4a";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CBB606A321;
	Wed, 25 Nov 2026 15:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lg/alT4a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B32D1F000CA;
	Wed, 25 Nov 2026 15:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619221;
	bh=OgCgn0AFXt8F1guMciZobDe8zmfFji0gfaCm5kd5Ye4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lg/alT4a3soY0/14r54JaJmlyDd1C+/5Mcz3NUXvDPA6CUbNQn6upwtnjasQCCCux
	 3D9FzFgho1QVmmSbwKhfAvYdJcmM+AjdoPiXyg0fxxU1p7CsV8Dh8Gtn725KQMsYWN
	 oZ5JfgNPM/GWKXShB+a7CNsn7Usu5zaWz2JkmtBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Varun Gupta <varun.gupta@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0528/1005] drm/xe/guc: Demote uncorrectable local error log on CRI
Date: Wed, 25 Nov 2026 15:31:06 +0100
Message-ID: <20261125143834.115901884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Varun Gupta <varun.gupta@intel.com>

[ Upstream commit f831b84713b57cbd67f228a7f10147791e5ab13d ]

The UNCORRECTABLE_LOCAL_ERROR notification sent by the GuC indicates a
local, queue-level context termination rather than a global device or
driver failure. On CRI, due to a hardware limitation, the platform cannot
distinguish GT translation faults from true RAS conditions, meaning
standard workloads routinely trigger this error.

Printing this at ERROR level is too noisy and causes false-positive
dmesg-warn failures in CI. Demote the log level to debug for CRI.

v5:
  - Correct commmit message and comment (Tejas)
v4:
  - Change to _dbg instead of _info. (Matt)
v3:
  - Limit the demotion to CRI and add comment explaining the HW limitation
    (Rodrigo)
v2:
  - Also ratelimit the GUC_ID_UNKNOWN to match the CAT error handler.
    (Himal)

Fixes: 4e57574fa3a3 ("drm/xe/guc: Handle GuC local uncorrectable error notifications")
Reviewed-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Varun Gupta <varun.gupta@intel.com>
Link: https://patch.msgid.link/20261106034804.2005214-2-varun.gupta@intel.com
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
(cherry picked from commit e305536554790e06876dd4e4f854c97d1353aa79)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index 8124f9d7b44cb..dc4dba70612e4 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -3368,7 +3368,7 @@ int xe_guc_uncorrectable_error_handler(struct xe_guc *guc, u32 *msg, u32 len)
 	guc_id = msg[0];
 
 	if (guc_id == GUC_ID_UNKNOWN) {
-		xe_gt_err(gt, "GuC: Uncorrectable local error with unknown GuC id\n");
+		xe_gt_err_ratelimited(gt, "GuC: Uncorrectable local error with unknown GuC id\n");
 		return 0;
 	}
 
@@ -3376,9 +3376,19 @@ int xe_guc_uncorrectable_error_handler(struct xe_guc *guc, u32 *msg, u32 len)
 	if (unlikely(!q))
 		return -EPROTO;
 
-	xe_gt_err(gt,
-		  "GuC: Uncorrectable local error! guc_id=%d class=%s, logical_mask=0x%x",
-		  guc_id, xe_hw_engine_class_to_str(q->class), q->logical_mask);
+	/*
+	 * On CRI, the hardware cannot distinguish GT translation faults
+	 * from true RAS conditions. Demote to debug to avoid false
+	 * positive hardware error logs.
+	 */
+	if (gt_to_xe(gt)->info.platform == XE_CRESCENTISLAND)
+		xe_gt_dbg(gt,
+			  "GuC: Uncorrectable local error! guc_id=%d class=%s, logical_mask=0x%x",
+			  guc_id, xe_hw_engine_class_to_str(q->class), q->logical_mask);
+	else
+		xe_gt_err(gt,
+			  "GuC: Uncorrectable local error! guc_id=%d class=%s, logical_mask=0x%x",
+			  guc_id, xe_hw_engine_class_to_str(q->class), q->logical_mask);
 
 	trace_xe_guc_uncorrectable_error(q);
 
-- 
2.53.0



