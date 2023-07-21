Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17E620F88
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FF5C433C8;
	Fri, 21 Jul 2023 19:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966609;
	bh=hI582G+i0LWX88tQw2kmHnNmCTrXP8B7NGbnUFyQgZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MyLzRK2B8J6E0rja+IoCF7SwykcXiixnDuuUsCYZ4WLkDKqLQzp0Y92W7142EYVPm
	 wyovoZ3qrvoJebeWs+0TzCOfYwwzOA63JW4+7ltjLdM/4MtQATm3F6tSK6BTZ++Y6l
	 0uwy11WzCpOEcb9WcN3AGMQs8FRerR4ymofQG34g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 404/532] scsi: qla2xxx: Fix error code in qla2x00_start_sp()
Date: Fri, 21 Jul 2023 18:05:08 +0200
Message-ID: <20230721160636.378051072@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit e579b007eff3ff8d29d59d16214cd85fb9e573f7 ]

This should be negative -EAGAIN instead of positive.  The callers treat
non-zero error codes the same so it doesn't really impact runtime beyond
some trivial differences to debug output.

Fixes: 80676d054e5a ("scsi: qla2xxx: Fix session cleanup hang")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/49866d28-4cfe-47b0-842b-78f110e61aab@moroto.mountain
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 4f48f098ea5a6..605e94f973189 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -3898,7 +3898,7 @@ qla2x00_start_sp(srb_t *sp)
 
 	pkt = __qla2x00_alloc_iocbs(sp->qpair, sp);
 	if (!pkt) {
-		rval = EAGAIN;
+		rval = -EAGAIN;
 		ql_log(ql_log_warn, vha, 0x700c,
 		    "qla2x00_alloc_iocbs failed.\n");
 		goto done;
-- 
2.39.2



