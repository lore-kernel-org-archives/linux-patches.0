Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D9611184
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3265DC433C9;
	Mon, 11 Sep 2023 14:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440867;
	bh=PYRC1ckyDJEUH5BbCdutNteGLbPo311yFNykH6SzXXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9tBHf4uuPrTpnLVynp0SDVJuZ/wU8uKVAJLNQ233Dyb+ptRZaVD4fsZAYTF+0Bqj
	 5RgIibGXCU35sWMfM36ZpVI0Gzzi39OIPYZXFokNhRS5UG9ZXSi4aBkUQMSUp9tfD4
	 wy3ZE3ojXYjBoZ/vogL9S5KuYt/ublJIHQ9niCcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 196/739] pds_core: no reset command for VF
Date: Mon, 11 Sep 2023 15:39:55 +0200
Message-ID: <20230911134656.663120898@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit 95e383226d6fcda6c217912f11edf8d74de9cc85 ]

The VF doesn't need to send a reset command, and in a PCI reset
scenario it might not have a valid IO space to write to anyway.

Fixes: 523847df1b37 ("pds_core: add devcmd device interfaces")
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20230824161754.34264-4-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 383e3311a52c2..36f9b932b9e2a 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -464,7 +464,8 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 {
 	int i;
 
-	pdsc_devcmd_reset(pdsc);
+	if (!pdsc->pdev->is_virtfn)
+		pdsc_devcmd_reset(pdsc);
 	pdsc_qcq_free(pdsc, &pdsc->notifyqcq);
 	pdsc_qcq_free(pdsc, &pdsc->adminqcq);
 
-- 
2.40.1



