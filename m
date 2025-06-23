Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D4F13A265;
	Mon, 23 Jun 2025 13:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684577; cv=none; b=mMq872UznZDt7mlp9iBVRU/dtYk45KvXqD4Eydr13Kkh/+ydWixGf9BZq/xEJQjI9kTJoiSyWGeM81JJQwLN6skUGbErNr8TV8YanyyLUZMExN5piQA5rvnYBCNQFty9SuImWXVAHdsuV3cAe8qqDLC2C2tkYuC+14op9FdUfDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684577; c=relaxed/simple;
	bh=OHiN75iAe2nZp0KpGGVTnWyCQiTFRgRPoKXJz9SX3ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0kbxk0rWDU2U0LfY+jaR0WhkeWl+a1r4rajn1hhTwpLC4VLS1pDr/CnQ1kM4Kuejtd5EdGC5BZ+pLjUVtp+z4UC1U+PFEcGTFAGh9e18xO7csR9r4yaisxxX0gDNL5NqI7l/cXS8W9PkA211rkPytalPwky6V9almVlnsw5IQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2poRDBPq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2poRDBPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F8AC4CEEA;
	Mon, 23 Jun 2025 13:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684575;
	bh=OHiN75iAe2nZp0KpGGVTnWyCQiTFRgRPoKXJz9SX3ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2poRDBPq9pu/93uIc2vQYG+2uPqsBX7B6K2r9bUqObUV4+anos6hBkUIdhmEMwO21
	 TdFNKSlUcGz0XujsZYmbnlESgXSKIrA8fiVAhraiD6r0s8fMMkmK0jX0AJcDjNtnho
	 Ep8J/lfS8Te7ufXEDOmBASbf6nTHduZjqlgmacEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Depeng Shao <quic_depengs@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 077/592] media: qcom: camss: csid: suppress CSID log spam
Date: Mon, 23 Jun 2025 15:00:35 +0200
Message-ID: <20250623130702.102859400@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit aef1d545989bc9e7f555af6b9f1be4963772192b upstream.

A recent commit refactored the printing of the CSID hardware version, but
(without it being mentioned) also changed the log level from debug to
info.

This results in repeated log spam during use, for example, on the Lenovo
ThinkPad X13s:

	qcom-camss ac5a000.camss: CSID:0 HW Version = 1.0.0
	qcom-camss ac5a000.camss: CSID:0 HW Version = 1.0.0
	qcom-camss ac5a000.camss: CSID:0 HW Version = 1.0.0
	qcom-camss ac5a000.camss: CSID:0 HW Version = 1.0.0
	qcom-camss ac5a000.camss: CSID:0 HW Version = 1.0.0

Suppress the version logging by demoting to debug level again.

Fixes: f759b8fd3086 ("media: qcom: camss: csid: Move common code into csid core")
Cc: stable@vger.kernel.org
Cc: Depeng Shao <quic_depengs@quicinc.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/camss/camss-csid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-csid.c b/drivers/media/platform/qcom/camss/camss-csid.c
index d08117f46f3b..5284b5857368 100644
--- a/drivers/media/platform/qcom/camss/camss-csid.c
+++ b/drivers/media/platform/qcom/camss/camss-csid.c
@@ -613,8 +613,8 @@ u32 csid_hw_version(struct csid_device *csid)
 	hw_gen = (hw_version >> HW_VERSION_GENERATION) & 0xF;
 	hw_rev = (hw_version >> HW_VERSION_REVISION) & 0xFFF;
 	hw_step = (hw_version >> HW_VERSION_STEPPING) & 0xFFFF;
-	dev_info(csid->camss->dev, "CSID:%d HW Version = %u.%u.%u\n",
-		 csid->id, hw_gen, hw_rev, hw_step);
+	dev_dbg(csid->camss->dev, "CSID:%d HW Version = %u.%u.%u\n",
+		csid->id, hw_gen, hw_rev, hw_step);
 
 	return hw_version;
 }
-- 
2.50.0



