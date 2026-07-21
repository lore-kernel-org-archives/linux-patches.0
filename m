Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C9E46D54C;
	Tue, 21 Jul 2026 15:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649058; cv=none; b=ZWxlQSL3JJ+ow7UQy7Gda2Fx9hXXkrAyFK/bNGXi1Jy8nMbpeSEOspC/spbfMzIn5jOA1UStMB+Iyvq+hsyLyFGfXdjZB0i7WjPP/cXc2keA+g+u9ul/Lj2e8MWJiQbdyPHjXp+hRHTHC/m6hoCMNXMz55FVI+Lu5iGqoaiz/1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649058; c=relaxed/simple;
	bh=cqMZ6+88XyvT7QSbqGKWL4IvB78b7sQqBYBKA0CIh/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uM0EDyhwvO1OWovfcGCz8t6HNcA/1c5LcXpp0/Xcd3x6h1Tg+nNCYNfm56kFq9X/h39Q4eZGD+J37c5edFcH90rsBZE/6T/T2g3uH6BKxl37fTAbLo/9l1c1MZZRxCdP80idWhijZeaXrEsDy4M/dPg3cM7TYXs4lgMhA84QwsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QQ+xBOPN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQ+xBOPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C431F000E9;
	Tue, 21 Jul 2026 15:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649057;
	bh=EBQqbxBd72E3CrRNzAW7mfKH18yBY4d+yfw6PaDF1KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QQ+xBOPN1sySR2rtPuBMAWby2uJSqKO69yE/cLa7YWIjQMxgmIjPyFiGmmHkp19fG
	 KRkOUHBh+/8yurUVuo26aYqyEUjrnXy40zQ31ovlGdaqtVLIqkEh7hPiD4hMFDulnv
	 aZh3jynBqrDFklMh6E/8bCOlMiCm5adSXD/ckeYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chanwoo Lee <cw9316.lee@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0434/2077] scsi: ufs: Fix wrong value printed in unexpected UPIU response case
Date: Tue, 21 Jul 2026 17:01:47 +0200
Message-ID: <20260721152602.987744669@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chanwoo Lee <cw9316.lee@samsung.com>

[ Upstream commit 2483ae0a56231a915c706411421c6c002a2bf83e ]

In ufshcd_transfer_rsp_status(), the default case of the inner switch
statement prints the UPIU response code when an unexpected response is
received. However, the code was printing 'result' variable which is
always 0 at that point, making the error message useless for debugging.

Fix this by printing the actual UPIU response code returned by
ufshcd_get_req_rsp().

Fixes: 08108d31129a ("scsi: ufs: Improve type safety")
Signed-off-by: Chanwoo Lee <cw9316.lee@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260527092134.275887-1-cw9316.lee@samsung.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c3f08957d179ac..385e1a8eec1620 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5634,7 +5634,7 @@ static inline int ufshcd_transfer_rsp_status(struct ufs_hba *hba,
 		default:
 			dev_err(hba->dev,
 				"Unexpected request response code = %x\n",
-				result);
+				ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr));
 			result = DID_ERROR << 16;
 			break;
 		}
-- 
2.53.0



