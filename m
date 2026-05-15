Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF3C3E00A3;
	Fri, 15 May 2026 16:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861976; cv=none; b=g2OkLiaYM9nFLT9R/TIX9NoWBjFKys2ks2t7VmUOMaGff+chAjrnzYg07RxKr/CVSCCaAj8qYIDrYuc+gt5z0Lr7wKVSjF/J/GD0227XhA6hB6Z3iPiKxTsAqjrwdntZD5gKBYtCVhrOv9qWTWe9fddOWv2Iw3xrG7sFzj+ZTGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861976; c=relaxed/simple;
	bh=MOIyVBKdYZSxa5HUL36QE2NYSSfeEnWpCQDbk8Dovj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGEWxVRVd7p+DubBLtEYVBqmFLwtRYeor2CvOHCoTL69HqcnIQ7hVLsMFMj5JlOAIDijmRS3TvdEy3kib4Cau+0qg2i3pecDRrvu4g1pVFbxM8NyIacLf8lCBXO9/fNygHkON8CwfPWgJeICujiXjOuLeHmr3AubcsujD1UCnlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HepuZoZL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HepuZoZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E70C2BCB0;
	Fri, 15 May 2026 16:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861976;
	bh=MOIyVBKdYZSxa5HUL36QE2NYSSfeEnWpCQDbk8Dovj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HepuZoZL4fvGMZ2NfnZIsrAAzewt1JszsuePM0QUkeQeGNeInJ4QEci6kfolAMv3/
	 YZwYhznYxOxMWouHh4XXJzXMrcO2/HUoCYsF4Z9gjHf8QZfVJfgb8ozNWA7JoBJQ9y
	 ty+ZPr4nN7B8SloFdpwgC2snoIG6al5fFC9sg2j8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 058/188] media: qcom: camss: Fix csid IRQ offset for sa8775p
Date: Fri, 15 May 2026 17:47:55 +0200
Message-ID: <20260515154658.573034842@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>

commit dd1b373941079cc102cc18bc68884e18245f5912 upstream.

Fix BUF_DONE_IRQ_STATUS_RDI_OFFSET calculation for csid lite on
sa8775p platform. The offset should be 0 for csid lite on sa8775p,

Signed-off-by: Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Fixes: ed03e99de0fa ("media: qcom: camss: Add support for CSID 690")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/camss/camss-csid-gen3.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/media/platform/qcom/camss/camss-csid-gen3.c
+++ b/drivers/media/platform/qcom/camss/camss-csid-gen3.c
@@ -48,9 +48,9 @@
 #define IS_CSID_690(csid)	((csid->camss->res->version == CAMSS_8775P) \
 				 || (csid->camss->res->version == CAMSS_8300))
 #define CSID_BUF_DONE_IRQ_STATUS	0x8C
-#define BUF_DONE_IRQ_STATUS_RDI_OFFSET  (csid_is_lite(csid) ?\
-						1 : (IS_CSID_690(csid) ?\
-						13 : 14))
+#define BUF_DONE_IRQ_STATUS_RDI_OFFSET  (csid_is_lite(csid) ? \
+						((IS_CSID_690(csid) ? 0 : 1)) : \
+						((IS_CSID_690(csid) ? 13 : 14)))
 #define CSID_BUF_DONE_IRQ_MASK		0x90
 #define CSID_BUF_DONE_IRQ_CLEAR		0x94
 #define CSID_BUF_DONE_IRQ_SET		0x98


