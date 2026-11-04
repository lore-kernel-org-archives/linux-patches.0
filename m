Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829492;
	b=LH8fHIGl4gfRvGQesd+Ekw48bc2xaqHGJ6YNzph1ykzHk7JBIHzO10UI8OdJYsiFJyCy
	 07SjSBJb7p/gTn7PaCTdK8ArTUU9PrnKHSme3uG/8aO5YoguxMKwG3fvQATeWdvQxAg/i
	 P3NN9/fYw/cghpbU1+SvJeQicqQ18uBX7p+e1PAAFnFmDJ9Dm4Tpbx7Zj10s3m4TKvLxl
	 C/Y1ra2eXB+2Y/cG0Rb5NvCToy+ss8ha0aVKaqyzOn0VkU0U6275DM1KvOdzNyavuk0gi
	 5Q5B+ij+9HVjFHai5OktGvDAZb68l1V3wul9dwYscAIM45Su4vwZw7dWJx4nHjzVjNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829492;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wP1hNzOqdQpJh83b7zPW8hkJlqXpIEg8egrTfffJlJA=;
	b=3fyzQcbKNRzI9I+vvyA63V/DUiN+js45V8H6gMLuJcq66WXd9i+/agiujapMh4R5yJha
	 xSCesCd53i2FRknegyo4scDN+J0n/qZIP1I9rjlnOJKd9TcPwRJLlh0hFebqX+3PQMts8
	 QW8ZYGB8Czp87HxeW9WDFP/ZutvCQxTZgfEaS6jApgcsBJeFYSQhIuPNfDXzYdOTzdYWq
	 MjHGYY75CzcOnK7GK41pMroJbQu3dAW3epFRldNxLTGaxrgz+Zw7cQ+7Dcf2rrKq0XPZW
	 Bnf+Z5cy/tzLGgbuDI3IAZYb+n6bDb10yZcB0g0hakDfGONhKy+rhFLy2N6mMPqZSSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T9EduflT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D80C60841B3;
	Wed,  4 Nov 2026 21:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T9EduflT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9741F000C1;
	Wed,  4 Nov 2026 21:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829492;
	bh=wP1hNzOqdQpJh83b7zPW8hkJlqXpIEg8egrTfffJlJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T9EduflTNXA71M+zc8Gz/Cy2qZWf2h45+MILHdsQ+jMMd3320fDOhsgE0YckTJq4c
	 8iqohEFmUh+NxiZFvSBs1vZyqRqt+wx5xesKVG+v+89bYOdN6FtW0FuscNJhR9S8Vi
	 TuGy1aSP70s9rnFdbvLf0412N0HaIIZH9NrHGVGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0159/1005] wifi: iwlwifi: mld: validate D3_END notif size
Date: Wed,  4 Nov 2026 15:58:12 -0500
Message-ID: <20261104211048.210150559@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 4e777dcdfe70d9b3ddf38cb49de9e30306889b18 ]

Check D3_END_NOTIFICATION payload length before reading notif->flags.
On short payloads, mark notif handling as failed.
Avoid out-of-bounds reads from malformed notifications.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714165826.db2df8b6b6bb.I6163bbdf433379bf1dbf9eb46fb9562892217bd7@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/d3.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/d3.c b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
index 0cb7bfcd6420e..73fd4c69357ca 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
@@ -1326,8 +1326,16 @@ static bool iwl_mld_handle_d3_notif(struct iwl_notif_wait_data *notif_wait,
 	}
 	case WIDE_ID(PROT_OFFLOAD_GROUP, D3_END_NOTIFICATION): {
 		struct iwl_d3_end_notif *notif = (void *)pkt->data;
+		u32 len = iwl_rx_packet_payload_len(pkt);
+
+		if (IWL_FW_CHECK(mld, len < sizeof(*notif),
+				 "Invalid D3_END notification (expected=%zu got=%u)\n",
+				 sizeof(*notif), len)) {
+			resume_data->notif_handling_err = true;
+		} else {
+			resume_data->d3_end_flags = le32_to_cpu(notif->flags);
+		}
 
-		resume_data->d3_end_flags = le32_to_cpu(notif->flags);
 		resume_data->notifs_received |= IWL_D3_NOTIF_D3_END_NOTIF;
 		break;
 	}
-- 
2.53.0



