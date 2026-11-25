Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618183;
	b=KCzO1mCXWqT3MbQ/szL3rwkIFXvj2Z4hAsFOXBBjXE0GPNlmRQYF02pGQdmUnBsdA0bA
	 AcPN8feMmPFm43tIV2/4I9zs0zP6XdXogRpjy9T1/RWSknUUbreWhhXzkHgUGhcTqW1qD
	 aEv5XIHM+RjWcGMu1C2Xk80hR4NhOsAopUnmE3xkIFcx92sOydqiFE8Y7hUxAVQlNYRha
	 P87VlOgcnzmDvQa07riYAbQH2AUrBhT54TAMcSUlb2W0Cvjyu8ijIYmOT/w0YXnsp5y8R
	 rvY68pRSxBLdrsY1XeHe/yfXP7FKVisY4jMwkWWJzUMmAwpS/p7WV4TXFlBYGGBsTYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XpOom2LMooUxPTH5JhUqjIZdk8S5dDqjItBtehsv/NA=;
	b=bO9+K8jpx8Qrn6MHXjXoFdj2E0hhu9I4QDzhuzQ3q9XPwh4dVODQCsSjUGmQESNk5iXd
	 ECFEf1hGIBZRIflqbigyvd11LUpTvk++oC+dmeGtSQtCYALiLFvcDOaZZXHqxpysLJ7X/
	 Y+z/fHTXhea9CKcmc7ByfBjbrW26kh+rGWnTgN8zeC+0cQtYNTj1ZaKClO5fiTtaGY85/
	 NeXqixJZZyCTU2JGtqUjpDH5nCswgOgW3c1/J5izZBu6CKmfUmdbiapcRRO8wkRW5Y9j0
	 3pPF9uy1U5FoqCeWMWbLBXEwP0vD1T4f0XjDSiEiFOxcUEH0MLdrBGXbCj9IeH+SMUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jkR7Lfl4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE652606A31E;
	Wed, 25 Nov 2026 14:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jkR7Lfl4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D5D1F000C6;
	Wed, 25 Nov 2026 14:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618183;
	bh=XpOom2LMooUxPTH5JhUqjIZdk8S5dDqjItBtehsv/NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jkR7Lfl4mfy4vTrt2fhdyJGnPPrmYzTd/wSA3kXBNCQ+hFBIfSEl2wRwovQ+b4qdd
	 zjjQLwnP5x3AFHGpxcpVLIjT88CD+fy7iMqsw1v9gfGq8oGwSyavGBye7VWlRcDYTJ
	 TxgeruGWlWobtfTk0UgXLPhNzP2YSq4kE08S8pUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0198/1005] Bluetooth: hci_sync: Update the CIS host feature when enabling LE
Date: Wed, 25 Nov 2026 15:25:36 +0100
Message-ID: <20261125143826.379149282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit e24bfbc5e20711dafa0cdc2b3325c69de1cff068 ]

The Connected Isochronous Stream (Host Support) feature bit is only set
during init, based on LE being enabled at that time. If LE is enabled
afterwards without the init being repeated, as happens when the
controller is still auto powered on after registration, the bit stays
cleared and controllers enforcing it reject LE Create CIS with Command
Disallowed.

Update the bit whenever LE Host Supported is written, so it follows the
LE state.

Fixes: 709788b154ca ("Bluetooth: hci_core: Fix using {cis,bis}_capable for current settings")
Assisted-by: OpenCode:claude-opus-5.5
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 0e93dc1b47f53..b0536742a48ee 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3511,9 +3511,13 @@ int hci_write_ssp_mode_sync(struct hci_dev *hdev, u8 mode)
 	return hci_write_sc_support_sync(hdev, 0x01);
 }
 
+static int hci_le_set_host_feature_sync(struct hci_dev *hdev, u16 bit,
+					u8 value);
+
 int hci_write_le_host_supported_sync(struct hci_dev *hdev, u8 le, u8 simul)
 {
 	struct hci_cp_write_le_host_supported cp;
+	int err;
 
 	if (!hci_dev_test_flag(hdev, HCI_LE_ENABLED) ||
 	    !lmp_bredr_capable(hdev))
@@ -3531,8 +3535,16 @@ int hci_write_le_host_supported_sync(struct hci_dev *hdev, u8 le, u8 simul)
 	cp.le = le;
 	cp.simul = simul;
 
-	return __hci_cmd_sync_status(hdev, HCI_OP_WRITE_LE_HOST_SUPPORTED,
-				     sizeof(cp), &cp, HCI_CMD_TIMEOUT);
+	err = __hci_cmd_sync_status(hdev, HCI_OP_WRITE_LE_HOST_SUPPORTED,
+				    sizeof(cp), &cp, HCI_CMD_TIMEOUT);
+	if (err || !cis_capable(hdev))
+		return err;
+
+	/* The CIS host feature is set during init based on LE being enabled,
+	 * which is not repeated when LE is enabled afterwards, e.g. while the
+	 * controller is still auto powered on, so update it here.
+	 */
+	return hci_le_set_host_feature_sync(hdev, 32, iso_enabled(hdev));
 }
 
 static int hci_powered_update_adv_sync(struct hci_dev *hdev)
-- 
2.53.0



