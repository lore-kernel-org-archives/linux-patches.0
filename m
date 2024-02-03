Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B18E2DF87;
	Sat,  3 Feb 2024 04:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933583; cv=none; b=YrBcJfKLvyQso/FXq5UMKRUxNILZKAmPoqRvh5DtTWKQ1824Ka/hdjWbxJq1fnWL7V75MpvII68VQZbPv6xahsEv6Z5EeEU06K8TViRycwjTtgzRiD3UH5jYG2H2vjxHRqQDI6Wa2NUzXs42R1lXVeTdctpDn6Hmk+DPQ3VA1+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933583; c=relaxed/simple;
	bh=2ywu7LzzdX/3YoUEAi3FPBCNdf6EqnBSBAU779Alom8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zk1evXiQkP7l3PtdX/LNHEulOOw1Dg4gy6LWaEULdQ9QxiRl6gdN+yTNsQzKOxkWvM+KalJxOhuyDL03aoVoy0NgcpCsOecq/0sv9u2ZyADdF+7eGEP4BhzWadqpZcxZUF7RnW1O3bi5nmmctXNX9bTNFeqr/fp5WLMp/h78rhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XkNQOUUx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XkNQOUUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17267C43390;
	Sat,  3 Feb 2024 04:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933583;
	bh=2ywu7LzzdX/3YoUEAi3FPBCNdf6EqnBSBAU779Alom8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XkNQOUUxaFf0kY2ehgyaCJCJzjzrlB9fHDOAjPZHKggnKdw773FAjKVxowZi0BonA
	 dTC9mG8mee/ZLXctq1Fpy6sTrJ3S5cuIjyRUHFNc5foCRtqY3VCn2Y6brck5JQszx2
	 WpxrZv2mc82lEsZ6jTmZxC2zg9+Xg5Vik9B7F3B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 145/322] Bluetooth: qca: Set both WIDEBAND_SPEECH and LE_STATES quirks for QCA2066
Date: Fri,  2 Feb 2024 20:04:02 -0800
Message-ID: <20240203035403.857534401@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4b57e15f9c7a..ad940027e4b5 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2035,6 +2035,7 @@ static const struct qca_device_data qca_soc_data_wcn3998 __maybe_unused = {
 static const struct qca_device_data qca_soc_data_qca6390 __maybe_unused = {
 	.soc_type = QCA_QCA6390,
 	.num_vregs = 0,
+	.capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
 };
 
 static const struct qca_device_data qca_soc_data_wcn6750 __maybe_unused = {
-- 
2.43.0



