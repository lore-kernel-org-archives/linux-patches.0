Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825884B2704;
	Mon, 31 Aug 2026 13:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184288; cv=none; b=f4AnmHLxQjirSarwqZ8EByHAoaPvgc8Axf+nuNQ8vr35haDTrANyQSJ+pjsYFXBzp92vTueY+QlNjEhC0YXoxevPQFi40kYJ9AYGMVpudjq3HtrPc4NovgssLixHm9vqrq2CCtgkiM2jIQ0oOcj6wio85Zyk3a83wsOfVyUvrgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184288; c=relaxed/simple;
	bh=JLsPd0rACAJrAV6SGzdHSm7A+dF13Njkr+y3O8Pb/7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htxSACVJDQyAOXljiC8ElvA4hoR7+MlSJ9ahMbnwP0I+sxvhCO5d9+DNdGqbWTZTDxT5YlkHcMUGAF/JlSJDWFgG55SsUECv77WjklwJCWO/rbZfSPPiRZ321cbF6mOfgKsYMcIHRBHPeLaJgK2fsRaf2m8qGDC5D5xwLK9OOjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dP8aW9GY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dP8aW9GY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47FB1F00ACA;
	Mon, 31 Aug 2026 13:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184286;
	bh=l8kXWQgZmnqvTLDARYFtx4To2KBlQGvTqMvVeAKs3vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dP8aW9GY4gyIo1zr2Yl+doBJafni1N1QJUvL1f7ihktyIoSH+MGDiOT4+NKycimyt
	 EcI8xvWlzCbJN6q4ptVK3EdYqPpKs/ttVFWg6vDQvFdylF1Ji6TqA553uWq81oc0lB
	 ALhly3k2q8Nyqf3JtelN65C0dJdKcGBIAGn0IWyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 53/99] Bluetooth: hci_sync: Use bt_dev_err() to log error message in hci_update_event_filter_sync()
Date: Mon, 31 Aug 2026 15:34:22 +0200
Message-ID: <20260831133402.688841227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit da0186f19a7433d3d5607b0f61e9a3de17d1f721 ]

Use bt_dev_err() instead of bt_dev_dbg() to log error message in
hci_update_event_filter_sync().

Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: f57b399c4fa1 ("Bluetooth: hci_sync: Fix accept list UAF during suspend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6239,7 +6239,7 @@ static int hci_update_event_filter_sync(
 						 &b->bdaddr,
 						 HCI_CONN_SETUP_AUTO_ON);
 		if (err)
-			bt_dev_dbg(hdev, "Failed to set event filter for %pMR",
+			bt_dev_err(hdev, "Failed to set event filter for %pMR",
 				   &b->bdaddr);
 		else
 			scan = SCAN_PAGE;


