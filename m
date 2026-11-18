Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026768;
	b=IT7gTDO7e8QUCmzJKEJtK52QvNj9V4qrDBHQJxFwnMJJxmk/KsPATF+pZG0V+/LKPv4V
	 ctUHIwR1LcnO9PBFW82/nvcwtSwQpL7hBqurDlrWvEqYp6/OQCJs0XdKZ0YC0DmAX5M+S
	 66Ctqb03e/Jml7f90cxmTsMcXxQ1ZKUrsNmmdo32Hgt7flnpdIjgrxImZ+L6M5SS2qdiJ
	 jw8MXouFpxdAHEqVR4RonTwCmhQ0ikJkGgELjInOH0q4yjVwYmagsOT9+S3ylyJksl3B8
	 CxRoupZpTM2jCb0wSnyzG0FoPi48M4+oqQGC/fFabq50RlHOtviL4tLRJ2Zp+9C0T5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026768;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FHIvQ9miKGTPZxdnq0KYk9q6+jCjtw2woykB6rCsD0I=;
	b=ATFdi+/pR5UP+fHIREeBJdsjCKC5FtwRG740O+WqBz4PbUVyHrmEqqLzm0OzQwrSXO28
	 vVQl7LR3Zrsd1727dAsYsSZYyA1hkvcy5mtfSTaOMvuNbrOH/KatGqoXMWQox7urf+cLF
	 bS+/+rzQQF5o1wIWCl+4SZYBp9uZB2THnQBHgDjK/+mN+3ikzCDuCVvMopAa2Nf/RN/8r
	 M4mk8Ciy7A2iw2A59ReQTIkHCvzTLrPHAWPUQBO54u+gEe74Ry49NDNJNmtpkQ87gXwZF
	 ifeBM1bn8q4SnjCDNGQxfY8gcV44VCPZ3CVJua0NNuC3KVEZ6AlTxIF9IZQtMKCYNSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x55QAV8q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A4A606A31C;
	Wed, 18 Nov 2026 18:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x55QAV8q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4046D1F000C4;
	Wed, 18 Nov 2026 18:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026767;
	bh=FHIvQ9miKGTPZxdnq0KYk9q6+jCjtw2woykB6rCsD0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x55QAV8qdGX2IsGBP5ePY+jQqNk7k+HYTo3wqdUSm3b9heALjHDrVpYeQBRIJWY8T
	 bynosIsUNgoNMJ35XnUlyHTjF8se5+osta0GGxSFT8+oSNJF1vkxIn+s7y1hza7SFD
	 K4a6+9pKLcvFXKGrv0M8maaQsHkWBKA450KqZMtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Pepper <cochcoder@proton.me>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1550/2151] Bluetooth: hci_sync: scan unfiltered for host-resolved RPAs
Date: Wed, 18 Nov 2026 15:54:45 +0100
Message-ID: <20261118150218.370519385@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index a5a6708b93cbd..6967da50aef05 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2639,7 +2639,7 @@ static int hci_le_set_privacy_mode_sync(struct hci_dev *hdev,
  */
 static int hci_le_add_accept_list_sync(struct hci_dev *hdev,
 				       struct conn_params *params,
-				       u8 *num_entries)
+				       u8 *num_entries, bool force_filter)
 {
 	struct hci_cp_le_add_to_accept_list cp;
 	int err;
@@ -2652,6 +2652,11 @@ static int hci_le_add_accept_list_sync(struct hci_dev *hdev,
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
@@ -2983,7 +2988,7 @@ static u8 hci_update_accept_list_sync(struct hci_dev *hdev)
 
 			num_entries = 1;
 			err = hci_le_add_accept_list_sync(hdev, &pa,
-							  &num_entries);
+							  &num_entries, true);
 			goto done;
 		} else {
 			rcu_read_unlock();
@@ -3047,7 +3052,7 @@ static u8 hci_update_accept_list_sync(struct hci_dev *hdev)
 
 	for (i = 0; i < n; ++i) {
 		err = hci_le_add_accept_list_sync(hdev, &params[i],
-						  &num_entries);
+								&num_entries, false);
 		if (err) {
 			kvfree(params);
 			goto done;
@@ -3069,7 +3074,7 @@ static u8 hci_update_accept_list_sync(struct hci_dev *hdev)
 
 	for (i = 0; i < n; ++i) {
 		err = hci_le_add_accept_list_sync(hdev, &params[i],
-						  &num_entries);
+								&num_entries, false);
 		if (err) {
 			kvfree(params);
 			goto done;
-- 
2.53.0



