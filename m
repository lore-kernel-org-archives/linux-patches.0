Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5ED34F616;
	Sat,  3 Feb 2024 04:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933845; cv=none; b=DLUKivjPf8yIFjsanaJTHOsgNOJWBRUb9u1z9YVECxIW5wyhlDWbkwiaiS2Flpf7c2cM7tdzzdzODi8HMGCYRCUbZEew+hBz6G3WVAeh+QykoQpYd2Fu1BJ8S+v2QUDFE13p9kaxJ10jjRXRHY8LXoeEUcqKLCFdHcErSGMoHkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933845; c=relaxed/simple;
	bh=zgHMt+MauDqhDg3bco8/n+QopH1oYfZx8NyX72ycwEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0xcAajb4hm7kBm01Q36nwrnnuLXkim/iAk/DeJ6Ojyaqz4XMN05s6zErOzJNoqjTr2eG4AjzdndSgAS6UIGLAPZf4NrOEjxh88gOfnKlDbO1+KM+zHfqVk1dbC3HBbTqe6+tLIyEVy4WXOTEcZBAsAjp6v0FSNqVdVG5V9tGjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=joN6j5/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="joN6j5/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F578C433F1;
	Sat,  3 Feb 2024 04:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933845;
	bh=zgHMt+MauDqhDg3bco8/n+QopH1oYfZx8NyX72ycwEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=joN6j5/5f9219I0SUvu0uCbNRTmYOYsIQGaiDOfLB52snb89hiUHn8HjkcbcrwxW3
	 25p6Hr9Cvj9JwRbLKUguFPXXU/+E1gA4a3gEDYmRF5O+dgd6RZwMBI57Sib6wd1Vjh
	 ioUm4Hkg/pNEUVOydrxsve+OQ3oOKa2cn34kg0Co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 148/353] Bluetooth: qca: Set both WIDEBAND_SPEECH and LE_STATES quirks for QCA2066
Date: Fri,  2 Feb 2024 20:04:26 -0800
Message-ID: <20240203035408.351800438@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 067e248e3599..35f74f209d1f 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2039,6 +2039,7 @@ static const struct qca_device_data qca_soc_data_wcn3998 __maybe_unused = {
 static const struct qca_device_data qca_soc_data_qca2066 __maybe_unused = {
 	.soc_type = QCA_QCA2066,
 	.num_vregs = 0,
+	.capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
 };
 
 static const struct qca_device_data qca_soc_data_qca6390 __maybe_unused = {
-- 
2.43.0



