Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023504;
	b=zLAoGMhK9tmxWHg3iUtFAqU78KCNRU49NleGoQB/Mi8s0xhGKw9yjMCz3pnSSraSAvYk
	 4ra3edc2N5d+eeqU9QHXF9MfUKtGbFHKYszd7asL/Vnkxkr7Sd2exwSmpsU56oRGpkhsb
	 koYsoId9qnHW0HrCzdSUncvna5aiCw/b6flo7D5SE9rue7Hnok83G6j0Bjsnd8gVIIwJ6
	 bSTiIx73s5eE3fPPfLjHo5dYbauAAt4ZfOdk35k/LHw+rBVifl98XtbN7GQOBe1ylH2ca
	 yCiSEw0n1WNVDEj5K+Dke2/NsUCEp9UWoaWT+kLsEbjX9C1Db7F0MLkFe6+Xxe98WDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023504;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=le0GdVjprmROTk/JzbpkkaUGHB+Khp9qNY+Km0O9dAA=;
	b=LDW0gDsay0n9t39eZiWYrWIY8StSQFlRJI5NZdlxcbVRSBpe8PGy0g7JesHNIPtHJcYK
	 7J8jrYDxLkhGYGSXGuaoKGK0m9g2j5Yo3SCRdZj0q7dLmJ2mmdkD/+ekGo6w8cOO8M1BG
	 WNQhhXWza7AvqWp74TlfetzkHXKb5FRNCfWr3JvRNguREW4ueY6FLGVd1n4G2sjypGbbn
	 0GiIZc+zQouIUkLl+LKSy1QD9OGKCrhg9QahaA+p8jtpvy2XwywYWApCJt7Trwp5shPmG
	 lYciCSrm3TcCL/teVKtS32mKwNtS3IYekUMZT8Leb7eBLjgU7wnd2Wszll2xgPbySEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DLTUZ97O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4951E60A260B;
	Wed, 18 Nov 2026 17:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DLTUZ97O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3401F000C8;
	Wed, 18 Nov 2026 17:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023504;
	bh=le0GdVjprmROTk/JzbpkkaUGHB+Khp9qNY+Km0O9dAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DLTUZ97Oi8kxdOFI+MnJwTqsRqWZ6b8C05uGfxp+nwaWNuHeWvZWY08qtkwcbtJOl
	 yLuTQzwKDRK4woEh1uzDTz6ZTGYwV9ac7lEF3QWqouzd8pG1esbTzAvR1gnom43DMr
	 QsnUUobDOXlO2wDYCpEwx25n/e1QiiSXLrDc4BOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0394/2151] firewire: core: remove unused link field in fw_packet structure
Date: Wed, 18 Nov 2026 15:35:29 +0100
Message-ID: <20261118150136.415530966@linuxfoundation.org>
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

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit 00d4d31e4fdfe51312f0184f8d162b8d4de172dc ]

The link field in fw_packet structure has never been used since it was
added.

Fixes: 3038e353cfaf ("firewire: Add core firewire stack.")
Link: https://lore.kernel.org/r/20260911141602.3288806-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/firewire.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/firewire.h b/include/linux/firewire.h
index 6d208769d4562..4743023b1f9ff 100644
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -321,7 +321,6 @@ struct fw_packet {
 	 */
 	fw_packet_callback_t callback;
 	int ack;
-	struct list_head link;
 	void *driver_data;
 };
 
-- 
2.53.0



