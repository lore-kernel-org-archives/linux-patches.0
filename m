Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060545;
	b=MxQgwNI8mIjRvua1y+RhM/7imOQWYW86gzOIILhV98qIvS9KB/mw2GOss2QCuw06+OXB
	 awAgg2bd03CWngWGCjzuO18YzTcWYNlbYWTl4zqWrP7yIm707djR1gvGp/P5EuYgR1f53
	 6MR+RAAmuSQW/j3zdcIyaUeuifL3wRK+jbyR4kwlCqVXzQovmwsXtHbNjt0Oa7sW9eZi4
	 qCjyqvhqi4DH/+RUekkbd+xplJTHp6kvRJ9k03fJLMmkvcqLsV6Y7yvAG+1Ms26E7kCe+
	 Nu9R8XBic8cVyPB6R4/38l6+ZiblqcRqsB9DArt+Y2KWGvHPX8IYICC79Cp5hJUN3wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7yZr3EN2ariBZDXFFiVLPZtdxge9OPAEyBIDAgw5bag=;
	b=ixj5uC6YE5/KEyzBnOIc40i8MwOrXRKHpglAzjYlDcqaSZxwoziBrGED11sE9YJusKy5
	 KrDq2EtiPXluLuGSKN4oy6xG9CInAeK36klfWQDKcc1mvSEVehEtLv40RNoZkHIABhXqy
	 nUUeYsQfdz+fVc+3yfWiQ/XzrhUfVX60Sg+2TnqXzoGYxDv267s1aQkPJ5gv9UrmYa9Qt
	 wQgKdFBai0uEywLgrkn9Mx5pzwYyj+OBPtkfVvcDb2MMO+SFY3lKInKVzdq61aF92rNd/
	 tIiHjDj+eEPXkIJnzoPHZKCPU9BT1N+5aNHxRf2yL0xjeGYIX3hYfaRWT7ortxIrnag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EVMZhAMO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6618A606A320;
	Thu, 19 Nov 2026 03:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EVMZhAMO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D401F000C4;
	Thu, 19 Nov 2026 03:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060545;
	bh=7yZr3EN2ariBZDXFFiVLPZtdxge9OPAEyBIDAgw5bag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EVMZhAMOuNNm0Lkf05LMCLw8ji613qgffSc9r8f8+FRhXiZxtWAQVl4ufXnjKd/kw
	 0eXJL54hHAAx+NfaBv8P/yl0SaVh26LE5GVrPp1KAITv7rICiNA0QJBHa6kbWrs5p7
	 lls67bVc32vTDNuIkDmMDg2mJa7sqC3vOV6IFHGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1235/1848] firewire: core: remove unused link field in fw_packet structure
Date: Wed, 18 Nov 2026 15:54:33 +0100
Message-ID: <20261118150011.568179876@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index aec8f30ab200d..6395605e91fd0 100644
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -309,7 +309,6 @@ struct fw_packet {
 	 */
 	fw_packet_callback_t callback;
 	int ack;
-	struct list_head link;
 	void *driver_data;
 };
 
-- 
2.53.0



