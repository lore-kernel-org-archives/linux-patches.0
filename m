Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049863;
	b=RRrR2F/ii6reXfOfK1FoCJt4n8Nf0mMsUbfxlDq6a79gWSkfYfFcgzv9N2PFVh49HrBW
	 AfNL4mF0rqGzbLPmq9uME/fiDmgKC/0Zxm0SvfNFuz18XZ4YbLLhXSEo6Jaqiwo2qIcLr
	 9mSPM1puHcGPEx89scxLA5v+EQ5kf5AwAA3jZF/0Lvzrdo8ClQ7MDTbyRV0+PFM0QBd8q
	 cRAmZCyODycLwvjJeKWWsudfEh14ELMXbzgZWbdC0Huqo9o2o6rR9rkBTQLinpkrEgVuI
	 F40H1zFPe3i1vbT8XPx9b0F7U1LWxmTaJ1EIYNrZ5mDoyvc8Kpxr9Swt3Xxi612VS4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049863;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gFT+KTxz/Kd95fttoqZaDmc1ZuOmx8Zwqo4UatHb/dg=;
	b=p7LJ8jHq0gnAFr4LEno7TClaoUJqONOfk3hgikSrtV8GjuW5Cco7wXHq4JFR2a/J0NDD
	 fer27NecT2i9kjTNUL7CEhgTGK6K3i6UwhspAQgGkc26sNySlypIogXsRwVDqHB8q2jfm
	 9292JKOwdOs/2NQIJTZgFPY2opKVm8wTrJkAS0ZoLFinkIp095kmyW4gdqGoScD+7JO4Z
	 Wkiu1YpLIGYX/VkUI0N9gQKNjxrC+tGs3c3iUjQ2Ph8jAIKyXDk3r83xtkTxMOsVOtJqZ
	 A+71fy5VNbEHnboIv1Hxs6iiDPvSgJ6PKV6EB5bHWpv4TJLWFYo1CMZ5Gg1zc0JkB3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tlk9ViF2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E069606A330;
	Thu, 19 Nov 2026 00:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tlk9ViF2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6331F000C4;
	Thu, 19 Nov 2026 00:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049863;
	bh=gFT+KTxz/Kd95fttoqZaDmc1ZuOmx8Zwqo4UatHb/dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tlk9ViF2SmdCqXuzIYhomjumTji3DXxmSNiU4FWLYVrQ0txUn8wcYx8eME6dP1+Pw
	 kzRnkOWZKPFDN8bBgu2t3OIh+2A5nvKbx7Kae058DyKXIdA0A42xtjk20J70Gziw57
	 P+ZcGqthXaWfGbLUelPH+uN2v3BSFpwYW9VOP8Q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2504/2857] Bluetooth: btintel: Zero version data before parsing TLVs
Date: Wed, 18 Nov 2026 15:58:58 +0100
Message-ID: <20261118150331.714533167@linuxfoundation.org>
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

From: Kiran K <kiran.k@intel.com>

[ Upstream commit cf87709d7ff83b4de5d42b61e4a9806fe374cb9d ]

Firmware may omit optional TLVs, leaving their corresponding fields
unset in the caller-supplied struct intel_version_tlv. Since the
structure is typically stack-allocated and not cleared beforehand,
fields for which no TLV is received retain uninitialized stack
memory. This stale data can be logged via btintel_version_info_tlv()
and copied back to the caller, leaking kernel stack contents.

Clear the structure in btintel_read_version_tlv() before parsing so
that fields with no corresponding TLV are deterministically zero
instead of containing garbage.

Fixes: 57375beef71a ("Bluetooth: btintel: Add infrastructure to read controller information")
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 7501a946aed7c..3adfe01166c5e 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -645,6 +645,7 @@ static int btintel_read_version_tlv(struct hci_dev *hdev,
 		return -EIO;
 	}
 
+	memset(version, 0, sizeof(*version));
 	err = btintel_parse_version_tlv(hdev, version, skb);
 
 	kfree_skb(skb);
-- 
2.53.0



