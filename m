Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026756;
	b=p22i4W9cayYHDr081X4XsUxbTkCX7SlKYbmjPV4dtoIUijVzgFw9xEYVXcemT6RAeU8l
	 tQPOgT/HoluBR6d+PXey07qyYDlXiCHIJN/0DNiesS2z0C5wMYKI7kcWTR4zKhraE/4ZQ
	 lsXISIg9R+RpOnMjPDLCiXnm/YMiK5iNls1zC7t0pum2AFjNF7aOp7RkgOF5eWzEL0y1e
	 ld4tMi7V65Pz5kcpXYWGFCsB/xrOtRwKEMTyURUhans3uPAN7nb7jxYmILzA+AcD6jPiV
	 k2x+kJozsMkrkeX9KwXtfHBbVBa8L7DastPd+JbJ7b2maHzYayRiqmGLF4s0uQ7rAkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026756;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zcQ/J93QMKAec2yUyWqpg5DclQ3OS9CxJYUt6MjyyoA=;
	b=B9C4XZlTu2ZyLpwrfDXhwljUQXsmxw+wZVPzWHoyAm0xPqbK0Q43k7W06wlCtg09Uz9y
	 fRhA7qShBYEyFF4f9Yro2zqUeGNqFqZeprqEgAIIW5WjXCX6TnmVnzgRsXVpP3qGenJ9F
	 CXRaasdQz1QycfaqMakVFJNYyElqss2p9iPo15ymueQ40WgYrvGHgFXDvMgWTW8QYnG6F
	 XBZOK2DEg+9LiEL+gSxSf6UTuTEKQziFHL1OSOIZCYrb1j4Au4LDWzrDomUC3rlEeFsmu
	 1L7VviP8spSy5WOp7W1VSCVVmdSMu6bPMomq+4exGWpgDzIAB1GAlgOcBHp8I3fOFSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fUzSq7Ki;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8553606A31C;
	Wed, 18 Nov 2026 18:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fUzSq7Ki
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DD11F000C4;
	Wed, 18 Nov 2026 18:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026756;
	bh=zcQ/J93QMKAec2yUyWqpg5DclQ3OS9CxJYUt6MjyyoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fUzSq7KiiGlmmhwuhM9T9RmUd7xKhLx6i1Hvi3Pe5OORxgxSy5/LkR04ea4N6uFBx
	 fySvZlU7tjEOYI9TFIs5B6H62h/qqPkD3EmIKhgLWWd1y9rK0yAQ7cDsb/ipdKw9op
	 WR8K9ZIjRpoFKQ63tiHSRlXh0Ols/eF4DwlyfnOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1547/2151] Bluetooth: btintel: propagate version TLV parsing errors
Date: Wed, 18 Nov 2026 15:54:42 +0100
Message-ID: <20261118150218.254319577@linuxfoundation.org>
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

From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>

[ Upstream commit 3a74624b5deae7f5e2b98e638687fbf9594a9781 ]

btintel_read_version_tlv() ignores the parser return value, so setup
continues with partially initialized version data after a malformed TLV
causes parsing to stop.

Return the parser error to the caller so an invalid response fails setup
instead of being treated as successful. Keep this behavioral change
separate from the bounds checks so it can be reverted independently if
an existing controller sends malformed data.

Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Reviewed-by: Ali Ahmet Memis <ali@iusegentoo.com>
Tested-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: cf87709d7ff8 ("Bluetooth: btintel: Zero version data before parsing TLVs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index cdcd3b20f1b4c..704feeee3233f 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -713,6 +713,7 @@ static int btintel_read_version_tlv(struct hci_dev *hdev,
 {
 	struct sk_buff *skb;
 	const u8 param[1] = { 0xFF };
+	int err;
 
 	if (!version)
 		return -EINVAL;
@@ -731,10 +732,10 @@ static int btintel_read_version_tlv(struct hci_dev *hdev,
 		return -EIO;
 	}
 
-	btintel_parse_version_tlv(hdev, version, skb);
+	err = btintel_parse_version_tlv(hdev, version, skb);
 
 	kfree_skb(skb);
-	return 0;
+	return err;
 }
 
 /* ------- REGMAP IBT SUPPORT ------- */
-- 
2.53.0



