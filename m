Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5B12641FC;
	Wed,  8 Apr 2026 18:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673927; cv=none; b=Bx+g8RZyi+dUaAfaWg6MAa6Ka2HkakiAgWRceJSk/rrgnwuLOovZL4gtsKtvu4RpTLQavFUdh4Eof/mSRDjFZ+X+Nld8FbkSqg5osHRqjcUpQmwBHLTnECx5voSTQPjJVWCN7XObIM9r4DEjdIuWliQMTpx+0bCRG29I3FXnWP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673927; c=relaxed/simple;
	bh=QLRSuXijIoHL1h6X8c80ZnzOH5rkG0WqLkY5Oh959Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sla9/bC8rabZ158t+2WbSR+deT/CsO4u8oRUhlRBkatbJiODMy6rxilIiXe2ymLqMigQrK6nHIWF9dt5w0OjQTDrFXQaByfoqmdmYD0tsNXd4SaVPbQIWZlhyPQBsegtrVXLS0EW3Yf5cOa/q/gzLle7eGMRCM6Upb2MUadclYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3ANwFTX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3ANwFTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A186CC19421;
	Wed,  8 Apr 2026 18:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673927;
	bh=QLRSuXijIoHL1h6X8c80ZnzOH5rkG0WqLkY5Oh959Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3ANwFTX+O61+l89kfNCdN52t4ukoog0CBrbCv5xNRyzggm+oe4imPjfQC6DLgtTq
	 HJj6cbNBu0qQlTCg01NVBL3co6cyaDcd/kPOGPc+VCyxZtlqnlzKyPCsSJm6nXxUT3
	 NRVzAuP3n9CJwHMql0Kt313GCpgxZMcZH9iJI3uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Shiji Yang <yangshiji66@outlook.com>,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 110/242] mips: ralink: update CPU clock index
Date: Wed,  8 Apr 2026 20:02:30 +0200
Message-ID: <20260408175931.205121293@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Shiji Yang <yangshiji66@outlook.com>

[ Upstream commit 43985a62bab9d35e5e9af41118ce2f44c01b97d2 ]

Update CPU clock index to match the clock driver changes.

Fixes: d34db686a3d7 ("clk: ralink: mtmips: fix clocks probe order in oldest ralink SoCs")
Signed-off-by: Mieczyslaw Nalewaj <namiltd@yahoo.com>
Signed-off-by: Shiji Yang <yangshiji66@outlook.com>
Reviewed-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/ralink/clk.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/mips/ralink/clk.c b/arch/mips/ralink/clk.c
index 9db73fcac522e..5c1eb46ef5d07 100644
--- a/arch/mips/ralink/clk.c
+++ b/arch/mips/ralink/clk.c
@@ -21,16 +21,16 @@ static const char *clk_cpu(int *idx)
 {
 	switch (ralink_soc) {
 	case RT2880_SOC:
-		*idx = 0;
+		*idx = 1;
 		return "ralink,rt2880-sysc";
 	case RT3883_SOC:
-		*idx = 0;
+		*idx = 1;
 		return "ralink,rt3883-sysc";
 	case RT305X_SOC_RT3050:
-		*idx = 0;
+		*idx = 1;
 		return "ralink,rt3050-sysc";
 	case RT305X_SOC_RT3052:
-		*idx = 0;
+		*idx = 1;
 		return "ralink,rt3052-sysc";
 	case RT305X_SOC_RT3350:
 		*idx = 1;
-- 
2.53.0



