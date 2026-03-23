Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10B0823DD;
	Mon, 23 Mar 2026 14:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275399; cv=none; b=XC4FxF28F6wwfvv7ReSAvVWSeO5NC0wyQPaDj3GWI5+Q88d6XrQj0ZnNzT+Da8lJcrsKiKlLj1Gb5l9zShVDpssTk6ShcjCtQvagwDIrKkOxFMASfpVEwnLbWT3hCwl1WhHYWoOVyveooinmnJdRF20coo82maFdl5jXNwdFRaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275399; c=relaxed/simple;
	bh=aN+CuBX3N2ZTi1o1JiXEkcJlHLwDT6VNsKuhHn9PwwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8f+xenQbSDTJPKchhHolE3w0EI28vJ5FIGe1UgoZvpwYd9pmYz7/DA3bEh4plk8D9xVOUHKYkhztG5kR7l07qHrzPWpYn+A7Ch1fPyTQI4Ge8M6NMV2IT+Bfa6iI8ZLzG8ssqJ7UIoST7pRF7yTkdUUjbElEmpZtD+f3PTmmWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gp2LwgH1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gp2LwgH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCC5C4CEF7;
	Mon, 23 Mar 2026 14:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275398;
	bh=aN+CuBX3N2ZTi1o1JiXEkcJlHLwDT6VNsKuhHn9PwwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gp2LwgH1/gP+eOoVXgyPXfjCFnk3HZ3FRWjPOFbxWo0zCtPtOIb+nH8jkvnXaTOcW
	 uOhJ3fJZTg19QRRmSM6v1AYSPZczWoaiJDXbClROL90KB0ofDpY9Yx8/Ls7nVElegL
	 Lz5u7JuhydMzZmkXeJ/VvoVCLzp6SyPjbBxGOSmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/460] octeontx2-af: devlink: fix NIX RAS reporter to use RAS interrupt status
Date: Mon, 23 Mar 2026 14:41:20 +0100
Message-ID: <20260323134528.740740406@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 87f7dff3ec75b91def0024ebaaf732457f47a63b ]

The NIX RAS health report path uses nix_af_rvu_err when handling the
NIX_AF_RVU_RAS case, so the report prints the ERR interrupt status rather
than the RAS interrupt status.

Use nix_af_rvu_ras for the NIX_AF_RVU_RAS report.

Fixes: 5ed66306eab6 ("octeontx2-af: Add devlink health reporters for NIX")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20260310184824.1183651-2-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 79ab91de90e47..6f8914431de4f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -327,10 +327,10 @@ static int rvu_nix_report_show(struct devlink_fmsg *fmsg, void *ctx,
 		rvu_report_pair_end(fmsg);
 		break;
 	case NIX_AF_RVU_RAS:
-		intr_val = nix_event_context->nix_af_rvu_err;
+		intr_val = nix_event_context->nix_af_rvu_ras;
 		rvu_report_pair_start(fmsg, "NIX_AF_RAS");
 		devlink_fmsg_u64_pair_put(fmsg, "\tNIX RAS Interrupt Reg ",
-					  nix_event_context->nix_af_rvu_err);
+					  nix_event_context->nix_af_rvu_ras);
 		devlink_fmsg_string_put(fmsg, "\n\tPoison Data on:");
 		if (intr_val & BIT_ULL(34))
 			devlink_fmsg_string_put(fmsg, "\n\tNIX_AQ_INST_S");
-- 
2.51.0



