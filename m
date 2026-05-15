Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B364BCACA;
	Fri, 15 May 2026 16:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862511; cv=none; b=bzI2gi2R7lPeHOhdm8HOXicpeJoZD3qqTINNY1eraoRhVDt1SodWAesnsYt3MgfrAmiw8SSTb1IyQq+g1tq24V97KzHI3B5MQ8IrLwbp/AGe7gm1yOULG4peHNC4KMmq+19Gev14mW6ZzJ3eTPwJc1M/ABh1uHrnMf97IiAho8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862511; c=relaxed/simple;
	bh=yB2P4og3bowYBgDIYfVbDfFM6fdTEbErbQwq6axeks0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQnhorUcXO2w6TkTaUCuMkikAiEy2yhdRP5Uhw/r/TnMlbeiGHQFQw3mX0y4MZNPKRzRMOowXAfxT2Myp/aPH6lKrCU993SNscF80tDrLq5vEoxVRPCeCRvemcIZcvnovAAGyHupKbylCcXyYGKjUmnA2SlvmyzZOJ6Ma8sPozo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ND79NdKw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ND79NdKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E450C2BCB3;
	Fri, 15 May 2026 16:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862510;
	bh=yB2P4og3bowYBgDIYfVbDfFM6fdTEbErbQwq6axeks0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ND79NdKwDlMX5sGScvraWVXDiZQqTLc9NeL8YAtJLa/+5MbnAfTmJYorSu7z2uSJB
	 VeYFHRfUv3nItZcJGPCSkmAkgg81QS1DkFaHv/Gkz8fB5/z2E8dTCXQG6U48EFbVFl
	 qb3SK0AIRmcJdyspT0+PyjRncI/aVJkuJLnz961w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 075/201] media: qcom: camss: Fix csid IRQ offset for sa8775p
Date: Fri, 15 May 2026 17:48:13 +0200
Message-ID: <20260515154700.159403585@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


