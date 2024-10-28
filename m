Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8AB15B10D;
	Mon, 28 Oct 2024 06:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097179; cv=none; b=Tac1pj5hI9vJb0JqcgabOrFlOHxV9Cq9cuDGdWWbt3pm6KozJjdcaeBH2+ViIs83TMMRfUnsi7GTqxFCKJ0JLiFzg2ahvli/w6V9ClzF11oColiEhJIE/Otv+lSj2vDAaX/sDcrS8PlCNycCtaJkgWznBJWe4OxdAL33Lsr68Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097179; c=relaxed/simple;
	bh=7cIlnnWdEVScycTS26yt/eg6rCeG2d7/qh1u3BaWLWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BrvvbVWZt5jHKSRgvXTIOs5FwKWGTAb1gEH1FXlHXRN6P+DgL28TWwwKzb+TKH2ddj6nks3Ku9xX3QEZ0++EhA2ILLPflHG3HGdqG/QyTBnh3C5rALUnq/UR6wlbRuYVRItQGRGkiSEokUEdZFpIVpgBtOyEcTvFQ3p94M+Q5go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZfxCh1J6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZfxCh1J6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BC8C4CECD;
	Mon, 28 Oct 2024 06:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097178;
	bh=7cIlnnWdEVScycTS26yt/eg6rCeG2d7/qh1u3BaWLWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZfxCh1J6mbhkmXcHxdKXuv/5yQNKNbJMzZ6kNumJHkSudOJWvnBW+9iFDK2XSjUi1
	 iiJcl0w5r5bRMhKHri4qDdSOSnos3kc51NAW9f6UPBRsMd2A623a7Js5Drql604Pcm
	 M/lD56olmdpf50BeHIQ1e0E60E92/bar0cjMvRwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Zubkov <green@qrator.net>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/137] RDMA/irdma: Fix misspelling of "accept*"
Date: Mon, 28 Oct 2024 07:24:15 +0100
Message-ID: <20241028062259.232578119@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Zubkov <green@qrator.net>

[ Upstream commit 8cddfa535c931b8d8110c73bfed7354a94cbf891 ]

There is "accept*" misspelled as "accpet*" in the comments.  Fix the
spelling.

Fixes: 146b9756f14c ("RDMA/irdma: Add connection manager")
Link: https://patch.msgid.link/r/20241008161913.19965-1-green@qrator.net
Signed-off-by: Alexander Zubkov <green@qrator.net>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma/cm.c
index 8817864154af1..691b9ed7f759d 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -3584,7 +3584,7 @@ void irdma_free_lsmm_rsrc(struct irdma_qp *iwqp)
 /**
  * irdma_accept - registered call for connection to be accepted
  * @cm_id: cm information for passive connection
- * @conn_param: accpet parameters
+ * @conn_param: accept parameters
  */
 int irdma_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 {
-- 
2.43.0



