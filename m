Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054547;
	b=RugJ92OcxRSyWfThDzwiLTQ6eXD5WCwrRGyu4Qj3QroeiNuSPKVg9b3nCSk7hOF657H+
	 5wblqRctCz7PNl8t5n304fX+xrQ4y9A4HMVbcfwlInuCyDeqGKGdAvSJFA+R4xcUS4FXo
	 hZYiT3xdHmPKZ+j4PsmYTiz70g7SKmsLN2EVe/a1l1sI0PRDgOmHrEUceBBNEwgZBqkSP
	 lwgMd91U5v9JwHOfXh/qvb9+u4ZpSAphIMQOyyZW6vTZ2mPBPStTS4+0b7QnwmclTrzJb
	 PqAShC2mrjoVFRojX70wKFqY7cQmo5YQxuvPEWi09iTPVTxY1AmgZNHyqL0vodaJ9bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6A1Am5wnXRNw78O1b3hog+pxa+aT7Pbei5XfXpKF0qA=;
	b=dSfDhunh9lT2nqyG4p6sHGjK5mHvTwwuJCAk1Gbtk7usH1vCbHk68K6hfvurebxZVFCw
	 08R7i43QE2bDUJuzX9rR9s2ixVdx4WcHq9k2Z/ISrUCINATxeohdzR0lpSlSoeuryA8X8
	 JPWwUqaU6tTYg++OEsG9AGWl79x0uAGS10ysT6/KIiTHh4HiEZqexS9XI2P4p4udXJ1wP
	 oQIqdO/eQ8UodjHHY28aQAXoP3E/ssLKkP/8DbRGQ6xI7yyg4K/gLfIwhIXfD3y8ouArs
	 fD49gOZ1Mm4hLd34mUb7ShbDXBazotQxsk7jMX5ekDCb02zFp/kb7LuV4hzl3FYE8hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S9OWkMPs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29132606A32F;
	Thu, 19 Nov 2026 02:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S9OWkMPs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFD91F000C4;
	Thu, 19 Nov 2026 02:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054547;
	bh=6A1Am5wnXRNw78O1b3hog+pxa+aT7Pbei5XfXpKF0qA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S9OWkMPs06nR03k2WNre3gDAC72IWIXYsDFMObkX1jbb2bEh2ukg0hHpgl4PQtD4o
	 bCOqAxsvLvvnq3AhtwybbbqP7G5zwudtAMNpCz0kdjloO1zHYRBpRAwq908Ir6qVv/
	 xrQW5m4G5mq/Xaz537gxZveSSXZjMZw4OfnbAQrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Zi <2959243019@qq.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1313/2214] comedi: addi_apci_3xxx: fix subdevice count underallocation
Date: Wed, 18 Nov 2026 15:49:49 +0100
Message-ID: <20261118150104.016073531@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a90d59377e187..4f6898e8827ba 100644
--- a/drivers/comedi/drivers/addi_apci_3xxx.c
+++ b/drivers/comedi/drivers/addi_apci_3xxx.c
@@ -788,7 +788,7 @@ static int apci3xxx_auto_attach(struct comedi_device *dev,
 			dev->irq = pcidev->irq;
 	}
 
-	n_subdevices = (board->ai_n_chan ? 0 : 1) + board->has_ao +
+	n_subdevices = (board->ai_n_chan ? 1 : 0) + board->has_ao +
 		       board->has_dig_in + board->has_dig_out +
 		       board->has_ttl_io;
 	ret = comedi_alloc_subdevices(dev, n_subdevices);
-- 
2.53.0



