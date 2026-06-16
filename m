Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA3A15B998;
	Tue, 16 Jun 2026 15:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625169; cv=none; b=SiHSlzOJzsD6bOFWUwvbtIU3LqBIxsdCXt+efsMc5t11o05rmwtZuO7ECQ3nzxJ2/wBSuIpFdGbucuECwrrkVvWYE1nL+POTe+zD7qSIvwZewnMgLTbNOopYG447o+o+a1wo1o3NVqdIvfknJmjN42riZxQCmUlXSuHr1wOWwKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625169; c=relaxed/simple;
	bh=ltckXXLvliO5152M4XoyGYdfV2GsbBbdQFAINiWbdEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uidxhPPzNpSpT7SZJU49ug2ApZbuYF8Lc7DEaNwZK5GQa5fmujzTIt7M+SIvnK8jNTqXUxvZ2/XPrdd7E4Hv5VzOCUavjy4bA+YfdsYgYj7djR7skDaWiuamNk7xe69BUVtdxWUcsvHVy0FFQGjthSNOBXWuPcDvCA78Vgpv8qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hQMDAbYT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hQMDAbYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13BB1F000E9;
	Tue, 16 Jun 2026 15:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625168;
	bh=rNNTe+VKKM4wtc4l2k9IfOGml/PM3jHS+mA4D7Wh7iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hQMDAbYT20H4CUKqqPNLIWAayyJShw6rTo4nS095yUzJa5MgpGn4NlkKj7riaVZ7V
	 /7P5V7ZicLDAcrakTMmtAaZEjdBMX08tyE1rN6Rz6VjAcp8NrN+7jZVKG0XRM4nQwB
	 /yaQkxcWzv4JFL/xPcPVU9Rde2KzOBWRSLd6u5r0=
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
Subject: [PATCH 6.18 091/325] idpf: fix mailbox capability for set device clock time
Date: Tue, 16 Jun 2026 20:28:07 +0530
Message-ID: <20260616145102.234882074@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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
index 31c5593550e1af..1063c1a96ee5c1 100644
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



