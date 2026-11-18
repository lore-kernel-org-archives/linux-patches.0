Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056311;
	b=QnObFpqe70+Fax6E1J8y6gN6bC0qfohH/GkOuE244yFp9QqxuZQoSyCxkJ/OLPQgVpif
	 8Oy+x/N+m1z86SMEiUYwh6cT9oiTiI/LLjWQ2ZBWwkB3J2AkfLs9/LT/bwvdT+lh65m5d
	 NBajnjR29z5LFJFLrAdtnhP4cKxwgeS7CjQF8fogO8AYPdOCRTSZGBPKRx2dUdeGYi/FG
	 ZJqcd0z6twlfm/BMlqnyD5OQ475K5eH1V06yYjtZUDCRnJz8LjssifaMZYfJJNfF/cSR6
	 78lc01kRXYdEr8RpkQlVY8o2uFSy5G8g9sr9PScc5f1tLL+0kXqBpk0dzCX1nAKpVtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r7TGE3dbDKZqls3pS3GU35b/14G3f7/Akwlaq4HHWiY=;
	b=ggfEei5nDb0Wha12IMRFGKiDJjn+OfQICvn84pT3HY9VYrbvPZTei44S1TUob1VrnSNi
	 LPzwrT+hxM64aUkfqsrSzAYkCOGVCCvYWllC6yFnywQb2SA0JM848eT9DI4Z5Qmy7nLeK
	 sPoLuV/Jc1ugRuLoPdJYKptg02TW1Mg2OK1kX6pYCyCgKyZ/kvQM6pj0UnAz0e68TJO0V
	 8TUjIGuHLKVPwtwD+P6V2pMJlN93uDDdR4w+PGQs67jCpxOonvJ5Lr6+fYu3Cmk6x5TCf
	 K19ysPUhPT3M3NGd8eDgbFEZeBjFWuXvYFeZ0vHu/IFBIM2/mRCCxd6EVC0BJUjlthw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LwlqzcuV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93E5606A32A;
	Thu, 19 Nov 2026 02:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LwlqzcuV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3581F000C4;
	Thu, 19 Nov 2026 02:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056310;
	bh=r7TGE3dbDKZqls3pS3GU35b/14G3f7/Akwlaq4HHWiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LwlqzcuVmZmZlAJ14qLP2U2bUVx4QYBZS6g8XTM8FWDjlri5pB5vQmWdr4nZj/rnV
	 kYtmZ1MCG+0HNjroM7u4lgqIoaUA9lKBbrjatg2kowmp+HP+tzszJQEWPeW5nL1GsR
	 MYWQUOE7PdxhW1DfhjhOMNM+Fsulz0fhEwKOPpps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1940/2214] Bluetooth: btintel: propagate version TLV parsing errors
Date: Wed, 18 Nov 2026 16:00:16 +0100
Message-ID: <20261118150128.632789145@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4d0766cbb41ae..87a2cdedb1e7a 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -620,6 +620,7 @@ static int btintel_read_version_tlv(struct hci_dev *hdev,
 {
 	struct sk_buff *skb;
 	const u8 param[1] = { 0xFF };
+	int err;
 
 	if (!version)
 		return -EINVAL;
@@ -638,10 +639,10 @@ static int btintel_read_version_tlv(struct hci_dev *hdev,
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



