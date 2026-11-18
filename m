Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032055;
	b=InFSSDecpxpQoTuEJvObAZKzdBMn3V8NfF8uPLfKkq7pcbkTV4QORL5Nz5yV6PQQ+c1F
	 9y5w1PI9ebX4U1CKSXtyoCXyh7QUtJ8Wbgdr6X3b/sqzzGqcYiSo3Khxuu6WUHSLjDW8O
	 +emGJERGNHDaoHwT2oR0lpX47f6S4si9Dyxfz3V5pFdESQPcdnQ0Jb2ni6W11aFK/qlfR
	 O+eqEVP7d05yjgsQCNmPEN9oJpQQmsxEvcwTgnBeEdPFmsQQXf27aDADtKkq91qlDpFYB
	 H/ip0trN07JSPXxjHI67BVkGzp7j2Mi9ZkpzKJmB/WOe7HSanFnEReP4C4Gmps2Dnww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YEUErghi2sfLTl/ZgdXqVy9lPISd6JK/wScb7Pr0qPo=;
	b=qPDrwUBy3Cu5PEcRPsNiiwWtMns+bUzZYGiPQgw5jFjKW8rIRyvNhNX6NZx2Y43RaTAl
	 EPm3tLQcMXD3po5vrrLtOvDTHtrgE9VSTOGdLcjgKisTWOowaQHbGMHwSLCUc/QrMjgk1
	 oQd901mFnq5AZvsx5KrbD6IFQ6SAEMoFmO3lhtYLYR0V9hOT5pqhiZTNh+VOJceaw7K20
	 phq+c/ho9h8A4v1Q6AGmdtrCm62L9Qe8D+IjxFuipQZ7r7pyDE7Se4Gf2uSgwiFAAcn/q
	 GqWFjVLuiAl2/K9F3sNhisQbTlzgzDYbZxfDm9TCrgQGtBKAdOyZ9wen+qzWUbwGPHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dLa207Gh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E77F606A31C;
	Wed, 18 Nov 2026 20:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dLa207Gh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C0C1F000C4;
	Wed, 18 Nov 2026 20:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032055;
	bh=YEUErghi2sfLTl/ZgdXqVy9lPISd6JK/wScb7Pr0qPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dLa207GhUuf1f+mXoI2Fu45GHgR67OgzTEIAaP9dLRJqh43mfSDsEFP+7q0ZupEuI
	 xCs6GhOKOTP4sxhoM4KSqfFnPWWfqowpuDRFgOUENGrWP+eLmVesQAQWrtXvexRMO7
	 cc035X6+LkHtgYURlsV0MJgVjnWBd1u356/bGQEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1239/1756] Bluetooth: btintel: propagate version TLV parsing errors
Date: Wed, 18 Nov 2026 15:56:06 +0100
Message-ID: <20261118150059.082834625@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5a0b30006d2b6..b2aff2bb09114 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -705,6 +705,7 @@ static int btintel_read_version_tlv(struct hci_dev *hdev,
 {
 	struct sk_buff *skb;
 	const u8 param[1] = { 0xFF };
+	int err;
 
 	if (!version)
 		return -EINVAL;
@@ -723,10 +724,10 @@ static int btintel_read_version_tlv(struct hci_dev *hdev,
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



