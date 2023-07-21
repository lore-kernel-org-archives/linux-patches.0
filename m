Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D08F20F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10310C433CA;
	Fri, 21 Jul 2023 19:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967597;
	bh=/5zhn9yjLCppYBDcb3O++hoELPeNgjf7g6qZhtPo3HY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SqBVUyd90626V+GKySGbZrcUs0I2FwwNcCCncLUq5bySuhYnPKHx8bPPiX0exeYPN
	 gEsabfzh+r7JfkT5KZTApwNM2y6qlkXCAcv7rb0b9ZLZJHz3lf+G9byH71RvOfomT8
	 +busLTMw4g4sv5AokpubqrNkBkyqI+OvREidY27s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 219/223] scsi: qla2xxx: Fix end of loop test
Date: Fri, 21 Jul 2023 18:07:52 +0200
Message-ID: <20230721160530.208078024@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
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

commit 339020091e246e708c1381acf74c5f8e3fe4d2b5 upstream.

This loop will exit successfully when "found" is false or in the failure
case it times out with "wait_iter" set to -1.  The test for timeouts is
impossible as is.

Fixes: b843adde8d49 ("scsi: qla2xxx: Fix mem access after free")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/cea5a62f-b873-4347-8f8e-c67527ced8d2@kili.mountain
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1399,7 +1399,7 @@ __qla2x00_eh_wait_for_pending_commands(s
 			break;
 	}
 
-	if (!wait_iter && found)
+	if (wait_iter == -1)
 		status = QLA_FUNCTION_FAILED;
 
 	return status;


