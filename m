Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618160;
	b=MimyAM0kJpWXaP3O2t7v43XFq0bRqaJ2m/EzR2Nn8Bc3PBf3RBnk/iUYsZrHwT+Bjc6o
	 Pal0scw/LRi5AYq4Rgf/Irb6GxS4dsWVc2kZdbv/zEoXydbetW4f4UuKyU7XSKKrF27ni
	 M9dHbMzUpuO6HExYFoRltBkp7i+PKDoS5OCNJIFo4hd1XwjQsymrAi8gl2QW+9cSuK/8N
	 lPmr1RxFWxigeRymzZpL7dPPR0eNPzIjLCHlEE6LjELZmAMUSIMFA0Oi8K8w0oy/ysMt/
	 E2ATf8mCiX/ykidZZbOcMNTt8PQHlzAuuEf5meA2SeqwZLB09R4xivkgL+gXrCzXGvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J7HHOWqFqIBKhsd5DVcu4PCgL1Vlzqjn0tIUZVzBcR0=;
	b=E+FChUvazjR/h3qgrW41mm+iOW05iVwI474AH8EhGRZTBO20J3zN7S+0Q6k+FXh6NAkS
	 D4P3R+OZNF4XDhXbjSElzG1eAkQN0Up79N5+FM659u+/WjHohVU7SPHX9T5GejM7XqGuE
	 dnQCsG6Jov+U3sTHhDyWi+BbD4Iju1dZqyj6cq4Y2WfUy+ZTcgRFsA7Lx5u485DT8cCHe
	 lvCS4x/Et4plGB4bMDITbiQZ0LcRTMTtT42GcPzRdmgyniBYPf396YZMPvN7QQ6e573V+
	 f+NNNojyjxsHL9dNIIw7CYyJ5NYmOIl1y2+z8gNjD3UmWcDA0g+RjArsD5dt/SQ8oig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VuZSSU+G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7519D606A326;
	Wed, 25 Nov 2026 14:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VuZSSU+G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCF01F000F4;
	Wed, 25 Nov 2026 14:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618160;
	bh=J7HHOWqFqIBKhsd5DVcu4PCgL1Vlzqjn0tIUZVzBcR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VuZSSU+GviuIL5A3TF0hwFIvDqgFUi9hZo2KadIFRrvqjz2AS1+Zwer8pa2KKDttd
	 /tavvNferEACP4ezNsayGnt68DzbGNQC1/o59RmHAYSvrgjzAvuoTuMKuYZ+UKbGKv
	 wYvl201UPdT5p5yhlFiWxga+E8SBscJLb1bLLgBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catherine L <catherine.l@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0192/1005] Bluetooth: btintel: fix buffer over-read in fw payload
Date: Wed, 25 Nov 2026 15:25:30 +0100
Message-ID: <20261125143826.237464489@linuxfoundation.org>
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

From: Catherine L <catherine.l@intel.com>

[ Upstream commit f92b7bca985205082c86140d0bd7c86c5be00efc ]

The firmware decoder cast fw_ptr + frag_len to struct
hci_command_hdr and read cmd->plen before confirming the
header and payload still fit in the remaining firmware
buffer.

Add explicit bounds checks before each dereference:
1. Reject if the command header is not fully contained
   in remain.
2. Reject if the full command including payload exceeds
   remain.
3. Log the offending fragment length and remaining size
   before returning -EINVAL.

Fixes: fbbe83c52bc0d ("Bluetooth: btintel: Create common function for firmware download")
Signed-off-by: Catherine L <catherine.l@intel.com>
Tested-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 4871a552d3aa0..85cbcfbea81a7 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -1150,7 +1150,29 @@ static int btintel_download_firmware_payload(struct hci_dev *hdev,
 	err = -EINVAL;
 
 	while (fw_ptr - fw->data < fw->size) {
-		struct hci_command_hdr *cmd = (void *)(fw_ptr + frag_len);
+		struct hci_command_hdr *cmd;
+		size_t remain = fw->size - (fw_ptr - fw->data);
+
+		/* Ensure the header fits before dereferencing */
+		if (frag_len + sizeof(*cmd) > remain) {
+			bt_dev_err(hdev,
+				   "Firmware buffer overrun at header (frag_len %u, need %zu, remain %zu)",
+				   frag_len, frag_len + sizeof(*cmd), remain);
+			err = -EINVAL;
+			goto done;
+		}
+
+		cmd = (void *)(fw_ptr + frag_len);
+
+		/* Ensure the full command (header + payload) fits before use */
+		if (frag_len + sizeof(*cmd) + cmd->plen > remain) {
+			bt_dev_err(hdev,
+				   "Firmware buffer overrun at payload (frag_len %u, plen %u, need %zu, remain %zu)",
+				   frag_len, cmd->plen,
+				   frag_len + sizeof(*cmd) + cmd->plen, remain);
+			err = -EINVAL;
+			goto done;
+		}
 
 		frag_len += sizeof(*cmd) + cmd->plen;
 
-- 
2.53.0



