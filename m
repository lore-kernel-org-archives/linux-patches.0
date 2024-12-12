Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8CD2210DE;
	Thu, 12 Dec 2024 17:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025860; cv=none; b=Q+GtLRB0cUpsyxv98hc8BRpanp5H8v7dEA6ShBKY8o1I7YQ2w3BJ6kljzrqwBW4srbznrRqLNrJ0b32emjeM4sG3jRd9MdNYmznLHP2xAo6WxDe2xkSimxKJPbZ9cJQs1aFmmphoRsxkkk8CtzDipjUgnpTh1e2RbBB5GQTMNtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025860; c=relaxed/simple;
	bh=y08me7rYqSAlulE/wUUXqAEqQ5QV7WM5RjC3VFvrKS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBV0A5GAYfUYAL8rncXbQnzX+Wyok3OBci2JT7Ri6LSsDpysg7F6AEK8AKAxHQT7cYaWsYhtuzJX9vrmPD8rBwW9mXmPw7zlig5slG7gHnN3KnVajrCepHUC62FTCszsoXp6ebsKqCob2hGsLBm7k6Y3cN4KLriuekiC250IO/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnIzQuph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnIzQuph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC5AC4CECE;
	Thu, 12 Dec 2024 17:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025859;
	bh=y08me7rYqSAlulE/wUUXqAEqQ5QV7WM5RjC3VFvrKS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jnIzQuphDx1F7Z2DP+Wi+XnDNezTI2BgjSPOCVC0oFvxNHFN5F4yxfTi74W4KKG+c
	 mmeAPPA2smEObcoAvxkko5+Y8i0gRlu1QgpVX5ufb/EkBinucZ7VyR+q6B0m1VslF+
	 vd/f80wdJycJje5pcagSsCPuX8wr0YwVhUljgil8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 281/321] wifi: ath5k: add PCI ID for Arcadyan devices
Date: Thu, 12 Dec 2024 16:03:19 +0100
Message-ID: <20241212144241.081193060@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit f3ced9bb90b0a287a1fa6184d16b0f104a78fa90 ]

Arcadyan made routers with this PCI ID containing an AR2417.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20240930180716.139894-3-rosenp@gmail.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath5k/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath5k/pci.c b/drivers/net/wireless/ath/ath5k/pci.c
index b7f62c472b879..e58da21b28ef5 100644
--- a/drivers/net/wireless/ath/ath5k/pci.c
+++ b/drivers/net/wireless/ath/ath5k/pci.c
@@ -47,6 +47,7 @@ static const struct pci_device_id ath5k_pci_id_table[] = {
 	{ PCI_VDEVICE(ATHEROS, 0x001c) }, /* PCI-E cards */
 	{ PCI_VDEVICE(ATHEROS, 0x001d) }, /* 2417 Nala */
 	{ PCI_VDEVICE(ATHEROS, 0xff16) }, /* Gigaset SX76[23] AR241[34]A */
+	{ PCI_VDEVICE(ATHEROS, 0xff1a) }, /* Arcadyan ARV45XX AR2417 */
 	{ PCI_VDEVICE(ATHEROS, 0xff1b) }, /* AR5BXB63 */
 	{ 0 }
 };
-- 
2.43.0



