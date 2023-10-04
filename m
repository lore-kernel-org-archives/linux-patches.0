Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC05421360
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJaTTJMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCD0C433C7;
	Wed,  4 Oct 2023 18:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444374;
	bh=tSqybAFkyAMBncEXFniNdOmclOJPYxM+mHdwHwNavSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJaTTJMwI9RaHLimfRInAmIqSViUePAX/SVW2K6mHk9Z4edRpKsh+FCpRU9O+1Sh6
	 znpP21+z7HiRmFDpbkgekudO9qUjS17yGSyEcuLjDg6zyq2WxGrr+9CyebybRycTB7
	 yMDw0wbwqyBJFGewp+0asOa5LKPHiU5A9cWSK1Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 228/321] net: hsr: Add __packed to struct hsr_sup_tlv.
Date: Wed,  4 Oct 2023 19:56:13 +0200
Message-ID: <20231004175239.781379738@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit fbd825fcd7dd4c11d4c48c3d0adc248a4a0ce90b ]

Struct hsr_sup_tlv describes HW layout and therefore it needs a __packed
attribute to ensure the compiler does not add any padding.
Due to the size and __packed attribute of the structs that use
hsr_sup_tlv it has no functional impact.

Add __packed to struct hsr_sup_tlv.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_main.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index 6851e33df7d14..18e01791ad799 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -83,7 +83,7 @@ struct hsr_vlan_ethhdr {
 struct hsr_sup_tlv {
 	u8		HSR_TLV_type;
 	u8		HSR_TLV_length;
-};
+} __packed;
 
 /* HSR/PRP Supervision Frame data types.
  * Field names as defined in the IEC:2010 standard for HSR.
-- 
2.40.1



