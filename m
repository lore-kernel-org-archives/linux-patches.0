Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694BD10A35;
	Mon,  4 Mar 2024 21:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588667; cv=none; b=brIDJZK8brydZ1QVQvA7SCGOduQ46Ag6cmXEMSaPXSxoF/iBQz/1gaub3DcnmtFbxDjKaR1ZWHLl9YYpwoRgTxvEO8cbhUnu/32f17S6T/NbmQRitOsd7YzrMShek8LHqD0W0AlQCHlvYcTbV3TBg/OqEFYC5gxNyJ5isrF4bDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588667; c=relaxed/simple;
	bh=nT01G+E9YAnmxbzjD10OTN3RVqn90KAgJnPQaOLh9Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQysWPsRPmTZfQGyLL6OTvdrCK13iVi6tUbJpPrV57fuUTk4fJfhkwNQSaxWuZHG9Zco888IUWu2Ol0jVg91iQtmpckpn1NrWuW7RWJL2a9+TGdfjKlMfTg/dLbnFYAvfEbYscUkqk0WeQETUJrnJNZ+LMyK5RnaGvUfwOV+ULY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TfKC7LlM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TfKC7LlM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2F3C43390;
	Mon,  4 Mar 2024 21:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588667;
	bh=nT01G+E9YAnmxbzjD10OTN3RVqn90KAgJnPQaOLh9Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TfKC7LlMk1K/lZH1kkrjt6tg25rci9EJEB/Q+s3eB06dIWAbv8WO+i3L4S5VmcmVK
	 EJ/uZoVYImnhf0ORUEbTjK/igIMDYG1Wyj8EF0efguqcPVUZS1HAyDgKcsTblXrWdh
	 gthgSKnTwC6dIfINAP3ym8/1kzOFMkA/ucswzgqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Min-Hua Chen <minhuadotchen@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/215] Bluetooth: btqca: use le32_to_cpu for ver.soc_id
Date: Mon,  4 Mar 2024 21:21:54 +0000
Message-ID: <20240304211558.606413574@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Min-Hua Chen <minhuadotchen@gmail.com>

[ Upstream commit 8153b738bc547878a017889d2b1cf8dd2de0e0c6 ]

Use le32_to_cpu for ver.soc_id to fix the following
sparse warning.

drivers/bluetooth/btqca.c:640:24: sparse: warning: restricted
__le32 degrades to integer

Signed-off-by: Min-Hua Chen <minhuadotchen@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 7dcd3e014aa7 ("Bluetooth: hci_qca: Set BDA quirk bit if fwnode exists in DT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index 4cb541096b934..d40a6041c48cd 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -637,7 +637,7 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 		snprintf(config.fwname, sizeof(config.fwname),
 			 "qca/%s", firmware_name);
 	else if (qca_is_wcn399x(soc_type)) {
-		if (ver.soc_id == QCA_WCN3991_SOC_ID) {
+		if (le32_to_cpu(ver.soc_id) == QCA_WCN3991_SOC_ID) {
 			snprintf(config.fwname, sizeof(config.fwname),
 				 "qca/crnv%02xu.bin", rom_ver);
 		} else {
-- 
2.43.0



