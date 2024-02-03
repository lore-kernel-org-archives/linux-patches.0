Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3987101C1;
	Sat,  3 Feb 2024 04:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933402; cv=none; b=k7Acin6IGa9hyGjnSipRLt8lXoLpF1HUHzFzSAt64qe0DlpmANIDcLaR8DHCd3ZzpVXS2/XaWs2MM6VgJS8YJN33UbXgDTZ2iC8HUwO7w41hCjy+QUY0nZTosPoMzKCbttddXfJXRdaIjs4531m1/rSoyblMUYF3v3EJb0U5W00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933402; c=relaxed/simple;
	bh=pOju6AVEX1xVlg9NLmYgHsou91AOIDB1WQJXkl4S1Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cl2QlTqgCCSMxPrGMoapgl2/OKdQ09lMqzyEEfQzBIGyAxV0M2Yz9tti72SZyHxBJctiFGHbY1khcbVXy9gOLnaExMohDwg+YomvyMuki6guk84jDjLScP82p127FK58d3FRoepJIvn5ugD5+7iMmccM2mu7D5FguWbBC1UjC6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6tsevEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6tsevEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A89AC433C7;
	Sat,  3 Feb 2024 04:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933402;
	bh=pOju6AVEX1xVlg9NLmYgHsou91AOIDB1WQJXkl4S1Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I6tsevEnCSDM7E3oOQ9nglKGeFdpy3wxMd0L+cCsPJnxFZWugpWjThvdxZIvexdg4
	 sz1B8fDhVcUFX85ZFJbAz0o2vu7p4Sfkne3PMyCl2RnfnU/mtpXbjWbENvsuEWavZD
	 /rVTUbdVT0f7nykXVohBJ+OV8a4MIRiPNZ9fFx+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 096/219] Bluetooth: qca: Set both WIDEBAND_SPEECH and LE_STATES quirks for QCA2066
Date: Fri,  2 Feb 2024 20:04:29 -0800
Message-ID: <20240203035330.730705992@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit 5d192b697c7417254cdd9edc3d5e9e0364eb9045 ]

Set both WIDEBAND_SPEECH_SUPPORTED and VALID_LE_STATES quirks
for QCA2066.

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 45dffd2cbc71..76ceb8a0183d 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1861,6 +1861,7 @@ static const struct qca_device_data qca_soc_data_wcn3998 = {
 static const struct qca_device_data qca_soc_data_qca6390 = {
 	.soc_type = QCA_QCA6390,
 	.num_vregs = 0,
+	.capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
 };
 
 static const struct qca_device_data qca_soc_data_wcn6750 = {
-- 
2.43.0



