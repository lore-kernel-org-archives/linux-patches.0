Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED2443847E;
	Mon, 31 Aug 2026 13:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184576; cv=none; b=ZzUHgMJvefLsMWVHKsFA1quQ3I3JZj5NOQbKu4E+JjA5YuwwgH5rAR7SqwrfjLdD0bmj4/Mjw56aNMe75V/ltRBV1QS0cXj1DW/EG3QaC+ouwhdF8mGScq+dbwgUFPbshfceAYcovb0rt7mRGsnhejg/D1n4VRZMmOZfJmBTgZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184576; c=relaxed/simple;
	bh=inGDke+YobRpOG4YqC57/i9iZg1xhwzSm6g9ErkVAgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8SugYid0YCAsrNZsmngcKj28FOBWOQMw5zMBfRdGAsRntzXaRcZp0rmLX6ZbJ4R3eLg/Zzb+uucVHeDsGy6V+7J1SP8WMJwmhlA9dLOd06uKt0J3qGo0c7bBIO451QuH1Qc1gdbaWUJY9JPMUC7Y2xMxD4lmfC85Cfw1VpuzIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=szgMtSni; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="szgMtSni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379571F000E9;
	Mon, 31 Aug 2026 13:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184575;
	bh=UKDc1Z2VJucbqC6OEkOhScebxJVNDL2Dc1ADoiUNnKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=szgMtSni7LQ2AXgIbE0Edug3zv2JfBES6c6c/cW/tfT75tq4ylvMVqCVC8RnEYPJO
	 JGXuNh43kBG6xAh2HloIDiB4DjA6newtZimEOk8anPFcrvt/Ox2GpAUr1/as+/shyQ
	 toIGNe4UR8LIaOiqsJXuXiWgUI0BCGKBiMI4bFmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 54/91] Bluetooth: hci_sync: Use bt_dev_err() to log error message in hci_update_event_filter_sync()
Date: Mon, 31 Aug 2026 15:34:42 +0200
Message-ID: <20260831133402.549529164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6231,7 +6231,7 @@ static int hci_update_event_filter_sync(
 						 &b->bdaddr,
 						 HCI_CONN_SETUP_AUTO_ON);
 		if (err)
-			bt_dev_dbg(hdev, "Failed to set event filter for %pMR",
+			bt_dev_err(hdev, "Failed to set event filter for %pMR",
 				   &b->bdaddr);
 		else
 			scan = SCAN_PAGE;


