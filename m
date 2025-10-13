Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352483064B7;
	Mon, 13 Oct 2025 14:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367310; cv=none; b=CQ/tPfFI+F2E1Ufe3vaistO8nsyDZpMuQPXPC8sc25USS+uUdaUagvsdJdVTR5OQeZMyVzpIGvDUdGMQ3rJBHhBA5KFj1KFg713D9f8sK2Bkb3K/Gwag5Gx8zDd8P1R34JIH7J5U2mE/UN7Z25doUEwDJjHmKCt0ODYAHfcAXm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367310; c=relaxed/simple;
	bh=pGEIrBnRN0oS0R+IaxT95hVDiDLvc4eISxI6UrdTCE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0xDW2NqclDp8u6hp5AkqZxQnUceRp2QykU2LTA+zAMlI+qYZgSSD7YQ/50Sqyt1ZCxDDCIHOkcJI4VTVOltowxaQ23c2QNDUmgpDzMTe4EpQUhPOB9p4HlkOn2ZojiyDZ2+NP0AcOOefUDrLSt/Cx3vxlTok0I+8fQ0qNBWCLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h79B19sE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h79B19sE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB1BC4CEE7;
	Mon, 13 Oct 2025 14:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367309;
	bh=pGEIrBnRN0oS0R+IaxT95hVDiDLvc4eISxI6UrdTCE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h79B19sEaDzrHzNqQZr5yOFViplKRZKQ7xFh92P014wZoN5yIOjeGzyH1aN7uxszl
	 fEc5OwnfheLkXekeFzmnX4QGuEjVtvojzRpkfvCKpphMEVA2WPR+BciMs7+BGg6yZx
	 xFblElE48sBpNyQ3qa7ca0LjpBuQ4S96TTx5OzUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/196] drm/msm/dpu: fix incorrect type for ret
Date: Mon, 13 Oct 2025 16:44:54 +0200
Message-ID: <20251013144319.073400098@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit 88ec0e01a880e3326794e149efae39e3aa4dbbec ]

Change 'ret' from unsigned long to int, as storing negative error codes
in an unsigned long makes it never equal to -ETIMEDOUT, causing logical
errors.

Fixes: d7d0e73f7de3 ("drm/msm/dpu: introduce the dpu_encoder_phys_* for writeback")
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/671100/
Link: https://lore.kernel.org/r/20250826092047.224341-1-rongqianfeng@vivo.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
index 05a09d86e1838..fd5f9d04f81e6 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
@@ -452,7 +452,7 @@ static void _dpu_encoder_phys_wb_handle_wbdone_timeout(
 static int dpu_encoder_phys_wb_wait_for_commit_done(
 		struct dpu_encoder_phys *phys_enc)
 {
-	unsigned long ret;
+	int ret;
 	struct dpu_encoder_wait_info wait_info;
 	struct dpu_encoder_phys_wb *wb_enc = to_dpu_encoder_phys_wb(phys_enc);
 
-- 
2.51.0



