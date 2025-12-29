Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3F9248F72;
	Mon, 29 Dec 2025 16:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024974; cv=none; b=aNqvjJIksw8AbntWwGCCBrlWwVFQ4z6YogsPLQKdyf5j8kjLMxMCpEMXOVGI3Vyw7DR6tzLhBZJYuvTZyOz7YWG1D/Y5X5xCc3Z6GfDH0ulGE28tUmj5VzCAJLxgQi2HxIpF5U5OlmgnrFbuGeyobaH6kwywF5F1TBtPcDOR9qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024974; c=relaxed/simple;
	bh=hW1kHor00bGNonW4s/vyGu0KvJI75DKyR9dnCmUtb1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ep/mXp32zYl2Ks6Na2GL8BYMA7RfeBTC/AR/67+WFSwBAwxiYN2jswlIXQ8xYlTvAea9gLlJMI03JTw6dHAA48+MGS9OZP7IW7uGwfxn7mDMh/NQMHcPMw0GJwQddl/CuLKihjjA4KvEgZzkTHXNAWqv1CG7Z7ASWM+7u7W5vzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/5/VAvZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/5/VAvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763A0C4CEF7;
	Mon, 29 Dec 2025 16:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024973;
	bh=hW1kHor00bGNonW4s/vyGu0KvJI75DKyR9dnCmUtb1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/5/VAvZFzGgIWJMFKmJWsq5fnQFogktl0imTfUK7KKctioTyFTF+TMxIIcjp2bCG
	 TU+Nen/M2BXN2103FvVB0/Sl49xBIZZQ1ffDefqNK4al+2A/GpAKiqBw6OOaJe5O9w
	 +rU5sbnrbZp4l2CjzKP3rVM3l45jxeRekk63HnAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Zhang <quic_shuaz@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 049/430] Bluetooth: btusb: add new custom firmwares
Date: Mon, 29 Dec 2025 17:07:31 +0100
Message-ID: <20251229160726.171259337@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Shuai Zhang <quic_shuaz@quicinc.com>

[ Upstream commit a8b38d19857d42a1f2e90c9d9b0f74de2500acd7 ]

The new platform uses the QCA2066 chip along with a new board ID, which
requires a dedicated firmware file to ensure proper initialization.
Without this entry, the driver cannot locate and load the correct
firmware, resulting in Bluetooth bring-up failure.

This patch adds a new entry to the firmware table for QCA2066 so that
the driver can correctly identify the board ID and load the appropriate
firmware from 'qca/QCA2066/' in the linux-firmware repository.

Signed-off-by: Shuai Zhang <quic_shuaz@quicinc.com>
Acked-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index cc03c8c38b16f..22f1932fe9126 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3267,6 +3267,7 @@ static const struct qca_device_info qca_devices_table[] = {
 
 static const struct qca_custom_firmware qca_custom_btfws[] = {
 	{ 0x00130201, 0x030A, "QCA2066" },
+	{ 0x00130201, 0x030B, "QCA2066" },
 	{ },
 };
 
-- 
2.51.0



