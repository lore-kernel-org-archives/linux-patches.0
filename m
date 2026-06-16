Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7D8449ED2;
	Tue, 16 Jun 2026 15:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623199; cv=none; b=ggN6GLONm1Anbp4a3/rim/n5B63eNsiRodIxaPlTyLgRfVoaw0XHSzuRkzQGXfH1reGlfTfCElM8T9oqhAbkU/vLmRi46X5UGFg6Aj9FKqBpwQ8yy1QyGwuVbUexxZbkigPtFqBH/z4ex87yn8ocnWftnLK+P8QciIqD4lm0hnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623199; c=relaxed/simple;
	bh=8XdvS6P7xX50ODHPb30lcUtXFPUrKQBXAelFzl8q33Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pw6djJajRNMOrGMTt9ku+a92KcHCG842XjNmP/w6QzKQpqsj618NGUiNepbAG/s6XpGeEco2vgDSaqGej8EWpK2CZhbzbmnWKnqgwR4IPs+5UK3lvKOHOYhf200wfFhqH7pQn8JLBrMNFGGjJs4Yi3soUq4CRFuWPHZXXGWL93s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RK6J+KsI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RK6J+KsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882111F00A3A;
	Tue, 16 Jun 2026 15:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623198;
	bh=NVo6NCXZVjqV0JeO7FtFhyYz3edM5HXjhsK0vWIOtvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RK6J+KsIx9+m3u/ZcAMnisjAmBESRRzg/N4+fNHjMD2+vb+QiaRikY3jISVo9sn3n
	 qT60YyiSF+3wlY8sOZiGWkzwRpnxa0yUQNg1F9aH2xu8nFnIvyh4dtExy/tQ0ty/HK
	 f/KhZgHzF2x6MNT1EOjtn5EI6JoBoRVS3o8s7SOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 103/378] idpf: fix mailbox capability for set device clock time
Date: Tue, 16 Jun 2026 20:25:34 +0530
Message-ID: <20260616145115.785935558@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 85b0cbc1f38bc1e38956a9e6d7b04d309b435697 ]

The current code incorrectly uses VIRTCHNL2_CAP_PTP_SET_DEVICE_CLK_TIME
for both direct and mailbox capabilities, causing mailbox-only support
to be ignored and potentially reporting IDPF_PTP_NONE.

Fixes: d5dba8f7206da ("idpf: add PTP clock configuration")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260602225513.393338-4-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_ptp.c b/drivers/net/ethernet/intel/idpf/idpf_ptp.c
index 4a51d2727547d9..71fe8b2a8b4e42 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_ptp.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_ptp.c
@@ -51,7 +51,7 @@ void idpf_ptp_get_features_access(const struct idpf_adapter *adapter)
 
 	/* Set the device clock time */
 	direct = VIRTCHNL2_CAP_PTP_SET_DEVICE_CLK_TIME;
-	mailbox = VIRTCHNL2_CAP_PTP_SET_DEVICE_CLK_TIME;
+	mailbox = VIRTCHNL2_CAP_PTP_SET_DEVICE_CLK_TIME_MB;
 	ptp->set_dev_clk_time_access = idpf_ptp_get_access(adapter,
 							   direct,
 							   mailbox);
-- 
2.53.0



