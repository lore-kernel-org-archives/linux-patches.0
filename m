Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020319;
	b=aSVF433XEw086z42v78dT+srDKa8Z565cW7TuFY/4nejzLiyzM5DZ4B2WUuFV0wSYuHY
	 B4k6NieQivFBqFmai0qDaSAgjFs6gGKWvi1Pe7QPtaGqpDTtJxPGLkOpoGAvDjUF2MjVp
	 lInpbIP6vzI0g4gT9IvObqFXVzMIunoMw+gCi1p/9Wo0SuY7YeBbkUXKx56A03OjVhgWL
	 UsMSNS6Yqvmv1x4d6WF2k9cL7cjrY+D3I8rhvAn5NJG/OIn7E6TQxRHICBv/9XwNEzBGD
	 jKWkJAYcZXxOPTnUPaxrXa96+mtfLQ4hDDd7QcaGQUW4dOX10OESPIPLZgvGWZgv0/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xoSPd/02Cuqr+sCfLQhRTpw6yMW42pWq118abdDlZGM=;
	b=CCGnaDjHUtaFVV/WdjKI+yfgkCeu2nLt9V/fW03LgR5XbcRaYC7ke99ZDWBBpn0l6+4A
	 Pe787AkuiHHyAQmoUXTtJ34Sk3Me8kNrplfx3+uJX3+oPbabLcupC2qIFfQ07CHOqXiBe
	 QD4rJJbnfFDu7k4xlHF0/3GNBw6wJ07cOwSJ6ZBCQhhjKCKy+pv64yjLkhrUNEvJYrmvK
	 uyjBve4FYZ79cMtNgRIMhahJmO5zTxdSZBffnkRam1Xwi5wArDFJX2BwWHAlH5Aiammoe
	 iwaXT8fSteyNUoMzfTDLkjRRCSp2nsxtHt4WjHZxSO3m16iG9UZuSzJBEBoavf8NJ/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kKf/9ZWm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0D6606A320;
	Wed, 18 Nov 2026 16:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kKf/9ZWm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134C61F000C4;
	Wed, 18 Nov 2026 16:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020319;
	bh=xoSPd/02Cuqr+sCfLQhRTpw6yMW42pWq118abdDlZGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kKf/9ZWmhBacL2gQQFpaCmVOrPz2LNgKgN4kQwOzG2xKV2yxqQRtiegoxx+IJd/9C
	 ZBDQGa6DQVz+HGqMzmF4N+O470jSMry8JGc1qCCpV2rLmkVQEHw3JplC1xcNUogV5B
	 hH75YJX1Z2Ro/AWx2W/ZORcpHmB4L21SuNn7gnOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Pepper <cochcoder@proton.me>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1908/2651] Bluetooth: hci_sync: scan unfiltered for host-resolved RPAs
Date: Wed, 18 Nov 2026 15:52:28 +0100
Message-ID: <20261118150355.490782391@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Kyle Pepper <cochcoder@proton.me>

[ Upstream commit 397464709a204da9b8dc3b01d6ea42539d951cd2 ]

Restore unfiltered scanning for pending IRK peers when the controller
cannot resolve private addresses. Keep accept-list filtering while
suspended and when forced by periodic advertising synchronization.

Fixes: e209e5ccc5ac ("Bluetooth: MGMT: Mark LL Privacy as stable")
Assisted-by: OpenCode:gpt-6.1-sol
Signed-off-by: Kyle Pepper <cochcoder@proton.me>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 789939fbaf1cf..4e5c47872c30b 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2618,7 +2618,7 @@ static int hci_le_set_privacy_mode_sync(struct hci_dev *hdev,
  */
 static int hci_le_add_accept_list_sync(struct hci_dev *hdev,
 				       struct conn_params *params,
-				       u8 *num_entries)
+				       u8 *num_entries, bool force_filter)
 {
 	struct hci_cp_le_add_to_accept_list cp;
 	int err;
@@ -2631,6 +2631,11 @@ static int hci_le_add_accept_list_sync(struct hci_dev *hdev,
 		return 0;
 	}
 
+	/* Host-resolved peers need unfiltered scanning while awake. */
+	if (!force_filter && !hdev->suspended && !ll_privacy_capable(hdev) &&
+	    hci_find_irk_by_addr(hdev, &params->addr, params->addr_type))
+		return -EINVAL;
+
 	/* Select filter policy to accept all advertising */
 	if (*num_entries >= hdev->le_accept_list_size)
 		return -ENOSPC;
@@ -2962,7 +2967,7 @@ static u8 hci_update_accept_list_sync(struct hci_dev *hdev)
 
 			num_entries = 1;
 			err = hci_le_add_accept_list_sync(hdev, &pa,
-							  &num_entries);
+							  &num_entries, true);
 			goto done;
 		} else {
 			rcu_read_unlock();
@@ -3026,7 +3031,7 @@ static u8 hci_update_accept_list_sync(struct hci_dev *hdev)
 
 	for (i = 0; i < n; ++i) {
 		err = hci_le_add_accept_list_sync(hdev, &params[i],
-						  &num_entries);
+								&num_entries, false);
 		if (err) {
 			kvfree(params);
 			goto done;
@@ -3048,7 +3053,7 @@ static u8 hci_update_accept_list_sync(struct hci_dev *hdev)
 
 	for (i = 0; i < n; ++i) {
 		err = hci_le_add_accept_list_sync(hdev, &params[i],
-						  &num_entries);
+								&num_entries, false);
 		if (err) {
 			kvfree(params);
 			goto done;
-- 
2.53.0



