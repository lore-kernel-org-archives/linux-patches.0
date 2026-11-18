Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039089;
	b=j2GevxNhxc6R4tjbApC1a2s9lKTMSAnkMappSlxpTptJ4bI1hDOowfsmeO1qdkRrt0XG
	 gNPhl2/22laLS0qA3ySRrw9Nch3a/hCor3rQjvY3IG0HHnHJo3DEVu8f0XCoa0RJTmox7
	 jL0RD9ujuWmh7lnaXgXBzslskgtDBzwuk+QlZq+aEhBtnPW6vSCOiCZUSCdlg0HHE2VJp
	 v+L2BzNdHSyosLwwxtwjxHZpRr7H0TeGlosE1K2VVh8QUuEj0AQ38YnfLSMI80xIHdnSP
	 7zSXpAYUviCp/1ILuzktbMb2+HAKtsJWuaPhD4J0TBs+KCIYSaYbD6ISTA7VbdwSxeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=kuiATmUqzmEoFFz76aJT+Xg5Qa39ZE/U5lbfqexU5KU=;
	b=AHowBUDH4px5o9RAstZW9IYNtyiZ1CAWEivHMII5uOrHWwX7HlrWlCSMn+N+2lVG6iZc
	 rMGkqfvraDDavtrhAXa9OO9I418sh0X/SmvVQaZWdQbVLo9ZDYd9A9UbAsiDnA5ziH+3F
	 R2N05awb7Yn+Q2xGT/7bwK/HuQnYq3geqg07QB+PivNerJpBQakSwkq/kLkh2kJifvMVF
	 17pQppbQnzCrLz9SBo7uwDR1sVW/Iab0/smEucEkDoQN01gcCUaqAYNYfipHoK4M6U4Dd
	 cyRQmi9B2oabgkoKXv2c0V+1nI0YAbqWyO2C6um+YRGuzQnU9dGXc1XauXQs4h9sgmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FF0qgrq6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434E3606A33A;
	Wed, 18 Nov 2026 21:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FF0qgrq6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9281F1F000D2;
	Wed, 18 Nov 2026 21:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039089;
	bh=kuiATmUqzmEoFFz76aJT+Xg5Qa39ZE/U5lbfqexU5KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FF0qgrq6qvjUYeGack4ERHZzWny6FjtbjMHpzw4Q69ngzUSprSxqSrHU76d9Eazfn
	 TqsNhrUIutoCKeD4WJphC8iT7qKXU7gba2jzR3gcIaP+/ZffLwHfN8/YmaesJRRbKG
	 j5eBBfoZNySQ3Y2XavxBb8zRFYSz2Rplx7l+1xZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Zi <2959243019@qq.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1976/3318] comedi: addi_apci_3xxx: fix subdevice count underallocation
Date: Wed, 18 Nov 2026 15:43:18 +0100
Message-ID: <20261118150421.362024296@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Zi <2959243019@qq.com>

[ Upstream commit 3de5aa458dede472a253266d02902bd95af8e849 ]

In apci3xxx_auto_attach(), the number of subdevices is computed with

    n_subdevices = (board->ai_n_chan ? 0 : 1) + board->has_ao + ...

The ternary is inverted: when the board has analog input channels
(ai_n_chan != 0), it counts 0 instead of 1, so the AI subdevice that is
actually created is not accounted for. As a result
comedi_alloc_subdevices() allocates one entry too few, and the later
subdevice initialization (notably the TTL Digital I/O subdevice, which
is populated last) writes past the end of the allocated array, causing a
slab out-of-bounds write.

Flip the ternary to count 1 when ai_n_chan is non-zero and 0 otherwise,
matching the subdevice creation order in the function.

Signed-off-by: Yang Zi <2959243019@qq.com>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20261014101803.11036-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: 656e39fedcf0 ("staging: comedi: addi_apci_3xxx: only allocate needed subdevices")
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/addi_apci_3xxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/addi_apci_3xxx.c b/drivers/comedi/drivers/addi_apci_3xxx.c
index bc72273e6a291..7355ec454cb40 100644
--- a/drivers/comedi/drivers/addi_apci_3xxx.c
+++ b/drivers/comedi/drivers/addi_apci_3xxx.c
@@ -787,7 +787,7 @@ static int apci3xxx_auto_attach(struct comedi_device *dev,
 			dev->irq = pcidev->irq;
 	}
 
-	n_subdevices = (board->ai_n_chan ? 0 : 1) + board->has_ao +
+	n_subdevices = (board->ai_n_chan ? 1 : 0) + board->has_ao +
 		       board->has_dig_in + board->has_dig_out +
 		       board->has_ttl_io;
 	ret = comedi_alloc_subdevices(dev, n_subdevices);
-- 
2.53.0



