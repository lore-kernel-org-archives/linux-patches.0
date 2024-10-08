Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF871DFD1;
	Tue,  8 Oct 2024 13:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392739; cv=none; b=azC+r2dGv/01pO+g+KOw6uR0SbvZMgJyn1ewKjwIF9pPDyMnhfdriKuWPfiYmfy4yDtVD7UqLHy/bHb3wSskjlMirjW0DtwRl0dKt36F3N8ZJPJy8SbvPJgwPPZIoMyDb/6uCf92jxim1KiClL6fFP2f+AZQ9Eu90elZxtRRGBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392739; c=relaxed/simple;
	bh=QGCNvcpl7uDXQF/ZECf3gRf3uGbeBwI6hr8Vb5XLNSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EV8ootNsG6+7altAHmXkDd/P43K9lrgdau4qkkdXfJevKtef9+SjbdCpeSX15g9bl8rntVQusV97Gds2u1eOHe5JOVvLCHC2wyV9Fo5C+D8H6QGAGqmrctPkJu01zzvl9QZFmLrFX/gTypM5v/8nl0Y80SbjAh3KScmJnYvPdag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2UfB+mS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2UfB+mS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE18C4CEC7;
	Tue,  8 Oct 2024 13:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392738;
	bh=QGCNvcpl7uDXQF/ZECf3gRf3uGbeBwI6hr8Vb5XLNSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B2UfB+mSvc4V5o4Y9LkaOYaPowrBhp5qR/XoFjuLZh8soA5wqs3OIKbBTAp0vkdoz
	 1mK6RnIRolWKEVG7lV51yyVEstTD4SQyjg66EtJSOlC9fOVNkOk8rCQES9rViul+Xg
	 kv/5v7hp3U4AQKvPs4PtLNNIbLAXFZRYvuiX3w3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.11 504/558] net: pcs: xpcs: fix the wrong register that was written back
Date: Tue,  8 Oct 2024 14:08:54 +0200
Message-ID: <20241008115722.064772397@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

commit 93ef6ee5c20e9330477930ec6347672c9e0cf5a6 upstream.

The value is read from the register TXGBE_RX_GEN_CTL3, and it should be
written back to TXGBE_RX_GEN_CTL3 when it changes some fields.

Cc: stable@vger.kernel.org
Fixes: f629acc6f210 ("net: pcs: xpcs: support to switch mode for Wangxun NICs")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reported-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20240924022857.865422-1-jiawenwu@trustnetic.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/pcs/pcs-xpcs-wx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/pcs/pcs-xpcs-wx.c
+++ b/drivers/net/pcs/pcs-xpcs-wx.c
@@ -109,7 +109,7 @@ static void txgbe_pma_config_1g(struct d
 	txgbe_write_pma(xpcs, TXGBE_DFE_TAP_CTL0, 0);
 	val = txgbe_read_pma(xpcs, TXGBE_RX_GEN_CTL3);
 	val = u16_replace_bits(val, 0x4, TXGBE_RX_GEN_CTL3_LOS_TRSHLD0);
-	txgbe_write_pma(xpcs, TXGBE_RX_EQ_ATTN_CTL, val);
+	txgbe_write_pma(xpcs, TXGBE_RX_GEN_CTL3, val);
 
 	txgbe_write_pma(xpcs, TXGBE_MPLLA_CTL0, 0x20);
 	txgbe_write_pma(xpcs, TXGBE_MPLLA_CTL3, 0x46);


