Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE572266580;
	Tue,  8 Apr 2025 12:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115016; cv=none; b=Ihh1abS1QxMZ198CHaHzY+wgmlpcOhs2S1MC0IVxpyAd7GOPuT9MYWOCEBDNIqSljb1SVS3/1k0HmmLAVAs2tiA7fTZ7a8QK+S/XmJr0rtdW9njGtzImX5KVQgCz4SGqP18tno3jdg2JCJoqNSprEGwA1MljHAmVR2CoF6ChDMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115016; c=relaxed/simple;
	bh=lNeYKws1MaqxdNVr4e529zjhsdTqVxTEUWl/SAYwcjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hd59355LEZ+LRJ571eNrh2UI4FVPT/TMU3ofbi6d7M8E50Yu9cFXHpK2DRJwh1p7JawFuwirUqFBTCN2VJU8wKkSMgoa/g6+YA68PYH7+sAq4riDBEBpqBgYMkNfpnFIFhYzXK7GoQDXPbfOBE2QyiC66wHkH2+Rdh1vtIzxj5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UfjPjafT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UfjPjafT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E247C4CEE7;
	Tue,  8 Apr 2025 12:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115015;
	bh=lNeYKws1MaqxdNVr4e529zjhsdTqVxTEUWl/SAYwcjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UfjPjafTnafLngczYmTJkJwA2FWCCn5k13psPXcOlh5EofZ2T0vQdeQpLdxa6ld14
	 Xgsh8IHKVcLRC6cSBevSQRgabGC60sriU8bOR+rXhqUzBachfrpL9M5RBiNNor/6Ix
	 K+kSGQdh6ZWG+8lxJ1SK8JPohSaq/aqDOP4XmPlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 318/499] net: dsa: rtl8366rb: dont prompt users for LED control
Date: Tue,  8 Apr 2025 12:48:50 +0200
Message-ID: <20250408104859.152931291@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit c34424eb3be4c01db831428c0d7d483701ae820f ]

Make NET_DSA_REALTEK_RTL8366RB_LEDS a hidden symbol.
It seems very unlikely user would want to intentionally
disable it.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://patch.msgid.link/20250228004534.3428681-1-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/realtek/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/Kconfig
index 10687722d14c0..d6eb6713e5f6b 100644
--- a/drivers/net/dsa/realtek/Kconfig
+++ b/drivers/net/dsa/realtek/Kconfig
@@ -44,7 +44,7 @@ config NET_DSA_REALTEK_RTL8366RB
 	  Select to enable support for Realtek RTL8366RB.
 
 config NET_DSA_REALTEK_RTL8366RB_LEDS
-	bool "Support RTL8366RB LED control"
+	bool
 	depends on (LEDS_CLASS=y || LEDS_CLASS=NET_DSA_REALTEK_RTL8366RB)
 	depends on NET_DSA_REALTEK_RTL8366RB
 	default NET_DSA_REALTEK_RTL8366RB
-- 
2.39.5



