Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E298486
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 16:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04A3C433D6;
	Thu, 27 Oct 2022 16:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666889912;
	bh=Fv6MRAwPocitOzoAV8jtA4fycgON8VLDjkKAGjL3swg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WRY7B/vc87VZZLyX3UTQneTSmI0o1+sigwU9KfkJCtv2KcKYCzyVJSDRVQirRGhb6
	 UG1QRHqaHoAAMAGijoyfaxZ2agBCr36Cwq6sqPJyN7rTY3zmyGLDdt5+0CMRSV3Ngc
	 yCf39MbETLypFh6Un95emcMGBuMe5NVbUNKqYGKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 45/94] net/smc: Fix an error code in smc_lgr_create()
Date: Thu, 27 Oct 2022 18:54:47 +0200
Message-Id: <20221027165058.960159056@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit bdee15e8c58b450ad736a2b62ef8c7a12548b704 ]

If smc_wr_alloc_lgr_mem() fails then return an error code.  Don't return
success.

Fixes: 8799e310fb3f ("net/smc: add v2 support to the work request layer")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index df89c2e08cbf..828dd3a4126a 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -896,7 +896,8 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 		}
 		memcpy(lgr->pnet_id, ibdev->pnetid[ibport - 1],
 		       SMC_MAX_PNETID_LEN);
-		if (smc_wr_alloc_lgr_mem(lgr))
+		rc = smc_wr_alloc_lgr_mem(lgr);
+		if (rc)
 			goto free_wq;
 		smc_llc_lgr_init(lgr, smc);
 
-- 
2.35.1



