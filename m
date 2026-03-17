Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF84536C0B9;
	Tue, 17 Mar 2026 16:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765853; cv=none; b=HjSo+vwHIj484UCl1f2F9UmhasFZc+FsobebdN6RQuyxNlLTfO4Esvw0vG8RTE3GzzcJwTg+pcQhCA3ZoNbXxj/ygVo1TeNJNWkBg9TRFChiZ11ykyiqbpZyLGCsDu9/mPvgWOvDgOrxezcxHndwE6PXxgLTa2VEr96j8/k7O1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765853; c=relaxed/simple;
	bh=8wcz3Jo78JjnLPh1ih8DMQgLQ+QlqW2ePZ+HbKiD32A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiciPzdQDUrqIzjuVEODkEJaEBUAmnLXKBJ3RvkAx+/AwXw46SJP9nwdrGOYu+RcZ0M/uzzel0Wd7yplbKzIao1FssPJbFkeVVJsau5yyGiXPPX0DjtJ/3Rqc3SKgBrDF3Z0Uh0PYH5+gi76c+Yt1cGANIXzD+Act9q/GaC3E74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nWj5BwAi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nWj5BwAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40FBC4CEF7;
	Tue, 17 Mar 2026 16:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765853;
	bh=8wcz3Jo78JjnLPh1ih8DMQgLQ+QlqW2ePZ+HbKiD32A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nWj5BwAiLWDOVXoDXShinweycThD8zOSRB4D6MEg90QhcuBQb5TcHjQtxvdmSjV/F
	 4NpSVJ4xIWiXBne/iD4XQBdTFOzFzGgXs0Y8V5r9+8RepszTbbfT2hdGJe7vpzlFRx
	 CA/PvlBrCsxMQE648Sqi6F/uzw7/W1VS2Sw2H0yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 110/378] octeontx2-af: devlink: fix NIX RAS reporter to use RAS interrupt status
Date: Tue, 17 Mar 2026 17:31:07 +0100
Message-ID: <20260317163011.062817572@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index fa6ca4f41b59a..2a715872e9edf 100644
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



