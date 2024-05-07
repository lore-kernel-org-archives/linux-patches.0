Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F8816D4F4;
	Tue,  7 May 2024 21:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715116095; cv=none; b=nnghtsuIXjzi22DkVVaL6l62COIAZqKJiTd3l5UqCfxRaiq4PPPQXS6z9OffZK9oSnoLykM9IufeCaciSHBIbd7cDeTQJVo4HTpWQyPUYDLZGMMGPV01ZjH1O02q2Knf4eI5FB6DY1PPBXIry7gHusoTldg6nxA+FAk//lbAeDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715116095; c=relaxed/simple;
	bh=WMVf2oXI6SZDlxicVvLWUrdlJrbGyN0El+cc/ed111U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0e6IfsQOZfcLF8pKepf5nFqlpiePgq5Lqu3OTROr5mn3Yz9elluzYec46o6dENKLfvGvVSn5v5QZAf2ZHtWKZ1LafUf6G04CzGEBMeXF9MKCZMmg07xxcUvkSuiTGLjjp8VxOFWMGccF7hSFXsM2l8kiDP9DiOZemCvTTKDuZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QGtSAZ1C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QGtSAZ1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DE3C3277B;
	Tue,  7 May 2024 21:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715116094;
	bh=WMVf2oXI6SZDlxicVvLWUrdlJrbGyN0El+cc/ed111U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGtSAZ1CvMLrZsm5XzuVOAtqzN3wJfpw4e27VCWOM7JvDcd45QO8sukoQyJZ1wDaw
	 dtoppLFP4YWTQWBfDLYaxVulUsEdNz8WsvTuyYy7qLau+YPinr93TRxTTY2cKvySTG
	 yCUqD9e0F+fhx8p/GAn9I07t6/H2YVfWTtF4zLm7aG/bVzLbMPL7ZvWE41Q70zSjOX
	 EEXT04ElDbw7ihUCgo6YOQ7DOWaal+Gzv79ja4QNa21EQlSghS3CC8sTTsmvM2LWCg
	 yXZyXEEqGrmuKLM+gQHWmB1b+1XcQ/OaWWP7iBOPEKWewLIpnTAO3Mtc6BXa0lApbl
	 CojyC9Pxn8obA==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Abel Vesa <abel.vesa@linaro.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 08/12] spmi: pmic-arb: Fix some compile warnings about members not being described
Date: Tue,  7 May 2024 14:07:45 -0700
Message-ID: <20240507210809.3479953-9-sboyd@kernel.org>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240507210809.3479953-1-sboyd@kernel.org>
References: <20240507210809.3479953-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Abel Vesa <abel.vesa@linaro.org>

Fix the following compile warnings:

 warning: Function parameter or struct member 'core' not described in 'spmi_pmic_arb'
 warning: Function parameter or struct member 'core_size' not described in 'spmi_pmic_arb'
 warning: Function parameter or struct member 'mapping_table_valid' not described in 'spmi_pmic_arb'
 warning: Function parameter or struct member 'pmic_arb' not described in 'pmic_arb_read_data'
 warning: Function parameter or struct member 'pmic_arb' not described in 'pmic_arb_write_data'

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20240417-spmi-multi-master-support-v10-3-5bc6d322e266@linaro.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/spmi-pmic-arb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
index 937c15324513..12c0efd744c2 100644
--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -132,6 +132,8 @@ struct apid_data {
  * @wr_base:		on v1 "core", on v2 "chnls"    register base off DT.
  * @intr:		address of the SPMI interrupt control registers.
  * @cnfg:		address of the PMIC Arbiter configuration registers.
+ * @core:		core register base for v2 and above only (see above)
+ * @core_size:		core register base size
  * @lock:		lock to synchronize accesses.
  * @channel:		execution environment channel to use for accesses.
  * @irq:		PMIC ARB interrupt.
@@ -144,6 +146,7 @@ struct apid_data {
  * @apid_count:		on v5 and v7: number of APIDs associated with the
  *			particular SPMI bus instance
  * @mapping_table:	in-memory copy of PPID -> APID mapping table.
+ * @mapping_table_valid:bitmap containing valid-only periphs
  * @domain:		irq domain object for PMIC IRQ domain
  * @spmic:		SPMI controller object
  * @ver_ops:		version dependent operations.
@@ -232,6 +235,7 @@ static inline void pmic_arb_set_rd_cmd(struct spmi_pmic_arb *pmic_arb,
 
 /**
  * pmic_arb_read_data: reads pmic-arb's register and copy 1..4 bytes to buf
+ * @pmic_arb:	the SPMI PMIC arbiter
  * @bc:		byte count -1. range: 0..3
  * @reg:	register's address
  * @buf:	output parameter, length must be bc + 1
@@ -246,6 +250,7 @@ pmic_arb_read_data(struct spmi_pmic_arb *pmic_arb, u8 *buf, u32 reg, u8 bc)
 
 /**
  * pmic_arb_write_data: write 1..4 bytes from buf to pmic-arb's register
+ * @pmic_arb:	the SPMI PMIC arbiter
  * @bc:		byte-count -1. range: 0..3.
  * @reg:	register's address.
  * @buf:	buffer to write. length must be bc + 1.
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

