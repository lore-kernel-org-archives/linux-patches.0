Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A5C179A3;
	Fri, 24 Apr 2026 13:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037754; cv=none; b=WvjfRf3sLA6b9gBxGcCtO6BzHfiDE4vAWBcMxnk3dyhs4CJnlJyBOuMB0o4rxn/6LazNvbsl7HoGRJq+F+sbBEMWlkJfo/mDgHd+Y/x0cn+lq04A1Qi8riqdq/Z3zhkFnCqoHCoFNRFu0JPRLXlswCfsj15xm0Ib79KaL7JAnxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037754; c=relaxed/simple;
	bh=BFO4rO7FJGxVrNlyv2OxH3uFI7SYjTHcouasZ18o008=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVWU3nsQQq62xdVWH7tj6XTAqNwDA3lhWxMuBdfE8bXczvgHqAFZyKp2I7LwM+uyM3SP4SOMU/eI7eW3kM+Ggj4JZ9Z3feW5b/S4P88Xfa7KFV7brmSCddvuzYS7cLVduNrzJxCaBcWTlWYAXSQv8TDATQMaQ/o5ucpU7mH4198=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BFuVMcd8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BFuVMcd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30B5C19425;
	Fri, 24 Apr 2026 13:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037754;
	bh=BFO4rO7FJGxVrNlyv2OxH3uFI7SYjTHcouasZ18o008=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BFuVMcd80RzwsnEU2qO1Pd9a6a/h2yqq4s+hLhpjjppUrA7kmmPZW8S2cLPi+P8L5
	 GyXQ4fU2o3/5/o0hfn3MXYcaxH+SdI6IZk8H2mniIYspOwEJj5QTds81kMY1g6CQAA
	 g5DRVJZwonbghLaTxklQB/KjujrxpJaFJ1Aplu2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Koskovich <akoskovich@pm.me>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/166] net: ipa: fix GENERIC_CMD register field masks for IPA v5.0+
Date: Fri, 24 Apr 2026 15:29:31 +0200
Message-ID: <20260424132544.740433345@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

From: Alexander Koskovich <akoskovich@pm.me>

[ Upstream commit 9709b56d908acc120fe8b4ae250b3c9d749ea832 ]

Fix the field masks to match the hardware layout documented in
downstream GSI (GSI_V3_0_EE_n_GSI_EE_GENERIC_CMD_*).

Notably this fixes a WARN I was seeing when I tried to send "stop"
to the MPSS remoteproc while IPA was up.

Fixes: faf0678ec8a0 ("net: ipa: add IPA v5.0 GSI register definitions")
Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260403-milos-ipa-v1-1-01e9e4e03d3e@fairphone.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/reg/gsi_reg-v5.0.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/reg/gsi_reg-v5.0.c b/drivers/net/ipa/reg/gsi_reg-v5.0.c
index 145eb0bd096d6..eac3913297c27 100644
--- a/drivers/net/ipa/reg/gsi_reg-v5.0.c
+++ b/drivers/net/ipa/reg/gsi_reg-v5.0.c
@@ -154,9 +154,10 @@ REG_FIELDS(EV_CH_CMD, ev_ch_cmd, 0x00025010 + 0x12000 * GSI_EE_AP);
 
 static const u32 reg_generic_cmd_fmask[] = {
 	[GENERIC_OPCODE]				= GENMASK(4, 0),
-	[GENERIC_CHID]					= GENMASK(9, 5),
-	[GENERIC_EE]					= GENMASK(13, 10),
-						/* Bits 14-31 reserved */
+	[GENERIC_CHID]					= GENMASK(12, 5),
+	[GENERIC_EE]					= GENMASK(16, 13),
+						/* Bits 17-23 reserved */
+	[GENERIC_PARAMS]				= GENMASK(31, 24),
 };
 
 REG_FIELDS(GENERIC_CMD, generic_cmd, 0x00025018 + 0x12000 * GSI_EE_AP);
-- 
2.53.0



