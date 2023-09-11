Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE23911705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E04C433C7;
	Mon, 11 Sep 2023 14:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443116;
	bh=kodaDjdgIMWKiwvXRcKvsYALa1HjbgtPg5unye4eWyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPo38UXXNUazSlli/lVO3ac17nr/vnWJyzytKBOkkps2wLKS+Ri8eOzQJL18hXjO5
	 NHWR4LABLymIln1JtNKHHAlzAHBEtYmScwZ5JfHJBW/qH5Z6X7cqT+JARCbL7HNFFk
	 mPb2rp4vDjpJfXnjdoswGedeFLC8NIc0jclwDmAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 263/737] pds_core: no reset command for VF
Date: Mon, 11 Sep 2023 15:42:02 +0200
Message-ID: <20230911134657.934269319@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

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
index 2a315f2da37d7..d06934edc265e 100644
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



