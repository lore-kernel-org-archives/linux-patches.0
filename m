Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043561;
	b=Nd+i0XJHNCoJxFWQ4tDXiumJa/NxeZPP9dB9Ava7Kv0Oy0bPIhlcdta4ke6NIvHaxQOq
	 KFUYWzXmlAQW2tGCDlXG1ys/TgQdyhCz1F0J2M42ZqJg/iX2n5+4G06DQdnJMEm/ieNvR
	 Kz8jiNjo9EI7WD6NgRzS2eRhjiVOeC8Z22px8kPiyQ7Cp5PaZobGy0unQelATL5r9LnzX
	 42ZPizLV9BnLedyTfkC6W8bVwRADuEisY71mjpxNp8+sbHGacvW+L65t5xFl5r17wF9fe
	 39zJ91RMY+56Sm/cac5ks6v3rvPdVRlTFEFKi50RLAiukuf8kkp3pJuhE8EyCBMNIgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d4jj9oYVPWeiAdWyroS852XIc88dYzzP08Gz3FeC8c0=;
	b=UiK/zxyAaAezx2WOLQ23r1NE9P9ekFUhgMII1t11LxxRPEUAbdn8QA+cZlaBNcZBG5ms
	 qufUVZoIcU3nniHof1HUhIt0g9QXXbxN5KQglZCpemw79/d9kVi0w66RzGVx0Fc1NvfJX
	 Sdcc9wUckhQY2b+mIZ2Srk3jAH22IpGZrZW+x6hfb3vTnh95W/NxfMtkJL2KJAyPNOEBs
	 i1hAjrcfXwujRNCPniXxeiMBYLjvTLHgfJJBBIvEwM8olIQyHRCC4zRsbJtMyrBHfW13Y
	 SC4FC7AYFdnQjJRSX9BpCdF4eIuEg8iTRmubuYGofbPl7Dl9EiAnrgfxChgLWbILwHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vg0VsNc5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09380606A333;
	Wed, 18 Nov 2026 23:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vg0VsNc5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228C71F000C8;
	Wed, 18 Nov 2026 23:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043560;
	bh=d4jj9oYVPWeiAdWyroS852XIc88dYzzP08Gz3FeC8c0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vg0VsNc5fBx42Dfe5LdzanhJeW1Sm061EMN8S1PcEWhNeSICOct/zQlVFjdfmOlYH
	 I2Ue9AGw/2CpoJVZwxfbfGnZOwOpHln338/hkZqCV+ZpnFIaEK16ogZ/zQo+Dl7Spz
	 h/yuMrnLsQIGCN654oGsNAQuP/CgUowoSi9af41Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0254/2857] ksmbd: reject blocking compound lock requests
Date: Wed, 18 Nov 2026 15:21:28 +0100
Message-ID: <20261118150210.582673946@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 16a7f7c2ecf3c893b65f0fb78fa7a7171ae0ba9e ]

Clients set SMB2_LOCKFLAG_FAIL_IMMEDIATELY when a LOCK request contains
multiple lock elements, and servers reject requests that omit it.
Accepting such a request can leave earlier elements locked while a later
element waits asynchronously, enabling prolonged partial lock ownership
and avoidable deadlocks.

Return STATUS_INVALID_PARAMETER before processing any element when a
multi-element lock request contains a blocking lock. Unlock arrays remain
unaffected.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 4290e29d3632c..6402a378ef6c3 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7228,6 +7228,13 @@ int smb2_lock(struct ksmbd_work *work)
 	}
 
 	list_for_each_entry_safe(smb_lock, tmp, &lock_list, llist) {
+		if (lock_count > 1 &&
+		    !(le32_to_cpu(lock_ele[0].Flags) & SMB2_LOCKFLAG_UNLOCK) &&
+		    !(smb_lock->flags & SMB2_LOCKFLAG_FAIL_IMMEDIATELY)) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		if (smb_lock->cmd < 0) {
 			err = -EINVAL;
 			goto out;
-- 
2.53.0



