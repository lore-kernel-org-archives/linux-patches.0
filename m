Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90FA2EAB76;
	Tue, 22 Jul 2025 14:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193590; cv=none; b=cUQFLlERywj/H8xu4zYnByZ1ozjv9A+cIi+ku0dgmnkyaNGRWzKiLMncAJaFtGhH/55/auE+9CG9kmEsdW7XJicpNLntj8DEYNWVMIA0mtzrMeTAfSRa9aMi1e77yidcmw/ZrmCnP/0NqAWo/fjwAhgWRk9Kthhn7j5kiYrNknU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193590; c=relaxed/simple;
	bh=alpn4/vRbnYJ8lV03K58Kr6mwLPytuVpxm3H1NH8RRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u921IWMUDsFyy06DDd50fuq/qEeJziByrbxlA39Q7vBfb0UEWPUtY7yQRyAVrnJkFPCho/x4Pt6spcHoYYwmeOabt0BTmUSPGejor0x9Dlh8vN9Woo9v2rMku4/bwPCJjuumNPeZtSFJW1JT05ftF73wUVc+gLpivO3ie/l9MEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDFKZi3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDFKZi3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348BDC4CEEB;
	Tue, 22 Jul 2025 14:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193590;
	bh=alpn4/vRbnYJ8lV03K58Kr6mwLPytuVpxm3H1NH8RRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yDFKZi3k67rYKHjAsUYmxTW5BLF1Kqr90J782WX6ZCbU29oSZBNOs/E/uQw035/3f
	 SI53iFLzGsg4aaCUP59VORwbJjV+BfEfQ/PEiIBGCKYx5lYrZh0CBjUv96phrVCH1A
	 Wr7vqLnww8vrxDd2iZIlxSyMeC13tiniggFJC5wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 137/187] Bluetooth: hci_core: fix typos in macros
Date: Tue, 22 Jul 2025 15:45:07 +0200
Message-ID: <20250722134350.840510238@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Eggers <ceggers@arri.de>

[ Upstream commit dfef8d87a031ac1a46dde3de804e0fcf3c3a6afd ]

The provided macro parameter is named 'dev' (rather than 'hdev', which
may be a variable on the stack where the macro is used).

Fixes: a9a830a676a9 ("Bluetooth: hci_event: Fix sending HCI_OP_READ_ENC_KEY_SIZE")
Fixes: 6126ffabba6b ("Bluetooth: Introduce HCI_CONN_FLAG_DEVICE_PRIVACY device flag")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 1cf60ed7ac89b..08cc5db8240ed 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1934,11 +1934,11 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
 #define ll_privacy_capable(dev) ((dev)->le_features[0] & HCI_LE_LL_PRIVACY)
 
 #define privacy_mode_capable(dev) (ll_privacy_capable(dev) && \
-				   (hdev->commands[39] & 0x04))
+				   ((dev)->commands[39] & 0x04))
 
 #define read_key_size_capable(dev) \
 	((dev)->commands[20] & 0x10 && \
-	 !test_bit(HCI_QUIRK_BROKEN_READ_ENC_KEY_SIZE, &hdev->quirks))
+	 !test_bit(HCI_QUIRK_BROKEN_READ_ENC_KEY_SIZE, &(dev)->quirks))
 
 #define read_voice_setting_capable(dev) \
 	((dev)->commands[9] & 0x04 && \
-- 
2.39.5



