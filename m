Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618476;
	b=PDJqW2RUR/KXMC4Br2uY+f5rejLNybpt8xrd/+AzSCzf7aPSpKaFKKAOhSzoXgnr1Gmr
	 DZOwGBCerNF1jnJs8i0ChyOdg1GppSLpRwPc4l08ojHicjpN43hbUXcviTllWlhI/3CIw
	 m/amgQ+bsUdsKDgojxCNkUEjZujDpZzW8R6Ak/90nqAMaymhJYfFF8+DcnzDxlbhlVEHv
	 2ES2e89kbFxrNOw8PmNMP3CLBCSxUZDedRqT3dYErcvCx4fGyrCWelioQ9qjM3nLvm/OG
	 Kt7taL4D9Yxb5Z2UwzTkJd+QDkIkKJ2ClDDUKhziF5zCrO/0WRY/TbeKLFvD1loZHrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pv3mrw6Ed3nSyyjrIh7zHpNczLthL9jmPX9ZSW+Avjo=;
	b=4ypMrdDAZE/0GFOY66mNqqxxyCc1qeikd+mgquWA5CxBXHutqNxZXX3Tghaeec+wMyyL
	 1FWwZGvj1ktwEQZLMdc4GjbtnU8V75kJEbnbBCgg1LhmAlyyjqhHbEFTw8r3KpSXqOurV
	 N9vKMEq/cof317BADw8TSYTYMNFaS9eF7gYMM9DHvOBmuVXzHVjLZ3urGWVzkU9c7NhVw
	 DrXmQx/xG7EqmeYly/Y7tlxPgegli7TDAzlvhsu/Ui0Z6Ww23zuefbxYFvwvXyN3YxoDa
	 m8dvjMop7aj1RM/xOIkctUVKfl572LK392B0SGZy4K/vViC7Ja8RXuuwuw8tfSPYHqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="NGRuw/B5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F62606A321;
	Wed, 25 Nov 2026 14:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NGRuw/B5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C601F000EB;
	Wed, 25 Nov 2026 14:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618476;
	bh=Pv3mrw6Ed3nSyyjrIh7zHpNczLthL9jmPX9ZSW+Avjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NGRuw/B5DChn+GOfJ3oX6DKOIQiFY/CFk4TWi+E50Tuugx4SpXiiwFgstvjUgF7aK
	 surYzSD47s+pcp/YsvIWbiINGpt/O1Pd0KpGKUwvt2ZRmAvNP41By8ps+MqBIYD6mh
	 xKBqkF7mHBWlmjyQX8uOkHf34RQzlp4qkfmZx/dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0291/1005] Bluetooth: hci_conn: Fix SCO/eSCO Transport_Unit_Size for HCI data path
Date: Wed, 25 Nov 2026 15:27:09 +0100
Message-ID: <20261125143828.554045091@linuxfoundation.org>
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

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit 3efdadae3a252b14ca1f62b16e31a9aa7c5d30cf ]

Correct (Input|Output)_Transport_Unit_Size based on Core spec v6.3,
Vol 4, Part E, 7.1.45:

  "The Host shall set the Input_Transport_Unit_Size and
   Output_Transport_Unit_Size to be equal. For HCI Host transport
   the Host shall set them to 0."

Fixes: b2af264ad3af ("Bluetooth: Add support for HCI_Enhanced_Setup_Synchronous_Connection command")
Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index b007f623b2ecc..eebd73988bf66 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -327,8 +327,10 @@ static int hci_enhanced_setup_sync(struct hci_dev *hdev, void *data)
 		cp.out_pcm_sample_payload_msb_pos = 0;
 		cp.in_data_path = conn->codec.data_path;
 		cp.out_data_path = conn->codec.data_path;
-		cp.in_transport_unit_size = 1;
-		cp.out_transport_unit_size = 1;
+		if (conn->codec.data_path) {
+			cp.in_transport_unit_size = 1;
+			cp.out_transport_unit_size = 1;
+		}
 		break;
 
 	case BT_CODEC_TRANSPARENT:
@@ -353,8 +355,10 @@ static int hci_enhanced_setup_sync(struct hci_dev *hdev, void *data)
 		cp.out_pcm_sample_payload_msb_pos = 0;
 		cp.in_data_path = conn->codec.data_path;
 		cp.out_data_path = conn->codec.data_path;
-		cp.in_transport_unit_size = 1;
-		cp.out_transport_unit_size = 1;
+		if (conn->codec.data_path) {
+			cp.in_transport_unit_size = 1;
+			cp.out_transport_unit_size = 1;
+		}
 		break;
 
 	case BT_CODEC_CVSD:
@@ -384,8 +388,10 @@ static int hci_enhanced_setup_sync(struct hci_dev *hdev, void *data)
 		cp.out_pcm_sample_payload_msb_pos = 0;
 		cp.in_data_path = conn->codec.data_path;
 		cp.out_data_path = conn->codec.data_path;
-		cp.in_transport_unit_size = 16;
-		cp.out_transport_unit_size = 16;
+		if (conn->codec.data_path) {
+			cp.in_transport_unit_size = 16;
+			cp.out_transport_unit_size = 16;
+		}
 		break;
 	default:
 		goto unlock;
-- 
2.53.0



