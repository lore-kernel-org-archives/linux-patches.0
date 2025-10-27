Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E6A32D45C;
	Mon, 27 Oct 2025 19:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592860; cv=none; b=bjgR5ICcbRgnSoZxPx6pI30hksdf00NflFPWF6bJ3/jcKn00A1Kl9mr1Dk5ynlEUpU8O7N0I6YYyMLjKR4Wz+3r90imjg0umaMr1SZ/rHZwe7iqsdzxqWBY3APhO+Yy/RxjTe59yZeWV2afShZ8Wf45mPfoJDgtnrnL3sYruCm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592860; c=relaxed/simple;
	bh=s00QPazGtlnxOLEQaVPTQPev2OpK+paZmnbCYgBHoyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WD3hcoRVHDIW/SowKrjgKv2TEdwZAY4ltxvYP2dGns3Y6sSivv/g0q9eC5dTeHQrPzius1btn1PqCdzwGCtAya0ifktRyV6kMjCp48S9i7Kpr2FM6FCxRiTTG4nOlHeBngRJEA3UFd1RM/QSzTJ1B6uCUKEs+82iu4UkcTUjgMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DXOHafHh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DXOHafHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE720C4CEF1;
	Mon, 27 Oct 2025 19:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592860;
	bh=s00QPazGtlnxOLEQaVPTQPev2OpK+paZmnbCYgBHoyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DXOHafHhpX3ZIBiLHQH2nsF8SSORLOAI0F3NHj+Gg1awoiuWwRz8fq3ooQ2jrY28Q
	 zGVx/C+u8FUQDFy5UET4ARUX05GRP00KnZw2Ng1n/XYl0Y0gmCcm/oT4sqm3cS75k8
	 6VN3NXxZBy4nUylvqoyJ1f24igG2mMnhMMa9q9Xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/117] ptp: ocp: Fix typo using index 1 instead of i in SMA initialization loop
Date: Mon, 27 Oct 2025 19:36:06 +0100
Message-ID: <20251027183455.067165190@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit a767957e7a83f9e742be196aa52a48de8ac5a7e4 ]

In ptp_ocp_sma_fb_init(), the code mistakenly used bp->sma[1]
instead of bp->sma[i] inside a for-loop, which caused only SMA[1]
to have its DIRECTION_CAN_CHANGE capability cleared. This led to
inconsistent capability flags across SMA pins.

Fixes: 09eeb3aecc6c ("ptp_ocp: implement DPLL ops")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20251021182456.9729-1-jiashengjiangcool@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_ocp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index efbd80db778d6..bd9919c01e502 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -2546,7 +2546,7 @@ ptp_ocp_sma_fb_init(struct ptp_ocp *bp)
 		for (i = 0; i < OCP_SMA_NUM; i++) {
 			bp->sma[i].fixed_fcn = true;
 			bp->sma[i].fixed_dir = true;
-			bp->sma[1].dpll_prop.capabilities &=
+			bp->sma[i].dpll_prop.capabilities &=
 				~DPLL_PIN_CAPABILITIES_DIRECTION_CAN_CHANGE;
 		}
 		return;
-- 
2.51.0



