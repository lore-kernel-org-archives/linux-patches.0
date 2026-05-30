Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD7D32B11D;
	Sat, 30 May 2026 17:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160566; cv=none; b=HySom90f1s3jRmtOVRgmMrxjq7pSW+JqmyzIg3mL5dAyN5DIVEaXak/pFXQx9LfHeyf7t52VLEDd62ZCH/GSGlSEoDS04O747+DJbogUgTxEpWbEzRri1JHnw2Uy96Wqe6J6Ud0KMGhl/x4g7xRrPT9y8xh27E1qdgYdw3CBPEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160566; c=relaxed/simple;
	bh=IsjciT669728mxkxB5y+2h4rJwsXVB0TLKDlZz5Djms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2MEE66ND2ZdA9ao9exolhLQOtHSu4C7f7eCyM6BGULsX8vOuE3ttVyI9kIugRB3DQ3UtGmSU4EFL4Q1fUqjyXzog8ghrICpJuY+j9yJfjPnWT3k3sH6Jdr9pzjkRMxj9a86OjrjM11QwTko3Mg3mxxxhBgTy/x5QfCQcm4MkVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQ3jiLmv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQ3jiLmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132271F00893;
	Sat, 30 May 2026 17:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160565;
	bh=Oj5N1N7A67FxJ1/fI5rcmFExgb1PujRxse7PymWaQWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gQ3jiLmvzrCXvQxw+NYV27v1/BLC9ZYqTzKusZ/2Rs0FzRHB25KkKIDKbACITjl8V
	 MSihZxLkVtAAzOxMs9tGpUZUSWYXN0UecvjnpJzl6crr/lptI7np3O5/WGY1SOzFOi
	 2LDdgJtUn9E/hCR88M6lTec13xiXRhwfPbIk+RRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Salisbury <joseph.salisbury@oracle.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 343/969] ASoC: fsl_easrc: fix comment typo
Date: Sat, 30 May 2026 17:57:47 +0200
Message-ID: <20260530160309.838305982@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Salisbury <joseph.salisbury@oracle.com>

commit 804dce6c73fdfa44184ee4e8b09abad7f5da408f upstream.

The file contains a spelling error in a source comment (funciton).

Typos in comments reduce readability and make text searches less reliable
for developers and maintainers.

Replace 'funciton' with 'function' in the affected comment. This is a
comment-only cleanup and does not change behavior.

Fixes: 955ac624058f ("ASoC: fsl_easrc: Add EASRC ASoC CPU DAI drivers")
Cc: stable@vger.kernel.org
Signed-off-by: Joseph Salisbury <joseph.salisbury@oracle.com>
Link: https://patch.msgid.link/20260316180545.144032-1-joseph.salisbury@oracle.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_easrc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -1286,7 +1286,7 @@ static int fsl_easrc_request_context(int
 /*
  * Release the context
  *
- * This funciton is mainly doing the revert thing in request context
+ * This function is mainly doing the revert thing in request context
  */
 static void fsl_easrc_release_context(struct fsl_asrc_pair *ctx)
 {


