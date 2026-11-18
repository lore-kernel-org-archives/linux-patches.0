Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023601;
	b=wTVBjwVeL9HI415Vf6cz7NqfXdSm+T5aANVc6wOCzuH4k18co29oDdfIeTOod4ab1kEL
	 /LKHKkx3V3H4ANKW9OeHe4ueRl0q27i+is3b5Km6HzH9Rjil4hlP4/ShjBrNP4lMCD8oM
	 XfwyZL6srecEUbQtkZQGnxznjbgEyZEt756T8FgcnIoVoO15dGW6+1iY61M1Th3VRYFi4
	 f2EG8pyqFjrtsiGIQJ5NwJFgfIcpCOQXS8H62NyNU9JAZDwG3rlLkefP+fSOgqf0lleIV
	 YPQziGz93y+IUO0MZa8+XxesAuYcaXPx58U0H0/ilefWkr3wzwR/A48x+LxkjxWswcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023601;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OKU+QpMaSw5dfcTaTlYqigmjYm/sOAz4PlYZGlBrv+U=;
	b=3tKdd0bBjlhKjvT8E/BCrX6vIsK5vVoGYoplgRnUhu7NVKzC7J7eIks/5HPP52rezNdA
	 aq3los3vp6WoB/PSzyuH0OnzMvqvd64LyzQgvwFUdyb9/79mnz+NcqLvs5r7WJCikEHnV
	 UOTn+4Sfnq0JRgWF+MYks4zh22vkI+SMKFYsOuP+dk5tISBMYQ1QLErE3zwp9B4ktDMSB
	 +/T4PHlyepR39RQ3TKsM7a7cIKIbqB9dtGIYk/SeO48rC5KT+GVQkdtwPJvijlbewbd2F
	 GUnhp/wPb7NR8O+5g1OCl1zKXF1Zaj+0uMgRKINig6vKUwaVx609F70oLXSsEDT3raQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oqLwb7kE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F57606A31C;
	Wed, 18 Nov 2026 17:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oqLwb7kE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8191F000C4;
	Wed, 18 Nov 2026 17:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023600;
	bh=OKU+QpMaSw5dfcTaTlYqigmjYm/sOAz4PlYZGlBrv+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oqLwb7kEHVcxzyoemqLtgNf/AED9lpijCS/pEeqFKMJKSi6zfywRbM5a/SsfmvhxA
	 I0zzp8KIVIQm6R9/14ROoONjIj76IT9of7JwjtAJrX/2+RlEMKUxolugIafGKFTyOA
	 sVVPa5EGLiDKFUgZVwZNkH9tJGyLhP538uP3rJJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhui Liu <junhui.liu@pigmoral.tech>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0425/2151] clk: sunxi-ng: div: Add feature support to M clock macro
Date: Wed, 18 Nov 2026 15:36:00 +0100
Message-ID: <20261118150137.536890169@linuxfoundation.org>
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

From: Junhui Liu <junhui.liu@pigmoral.tech>

[ Upstream commit f43bed1fb1ddf7b350ceb7c371c624795a7820e8 ]

Add a variant of SUNXI_CCU_M_DATA_WITH_MUX_GATE() that accepts CCU
feature flags, such as CCU_FEATURE_UPDATE_BIT.

Signed-off-by: Junhui Liu <junhui.liu@pigmoral.tech>
Link: https://patch.msgid.link/20260906-sunxi-clk-no-p-v1-1-cbde21c9fe69@pigmoral.tech
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Stable-dep-of: 59dced16a82d ("clk: sunxi-ng: sun55i-a523-ccu: Use M-only clocks for MBUS, IOMMU and DRAM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu_div.h | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu_div.h b/drivers/clk/sunxi-ng/ccu_div.h
index be00b3277e976..46370c0b57f00 100644
--- a/drivers/clk/sunxi-ng/ccu_div.h
+++ b/drivers/clk/sunxi-ng/ccu_div.h
@@ -212,16 +212,17 @@ struct ccu_div {
 	SUNXI_CCU_M_WITH_GATE(_struct, _name, _parent, _reg,		\
 			      _mshift, _mwidth, 0, _flags)
 
-#define SUNXI_CCU_M_DATA_WITH_MUX_GATE(_struct, _name, _parents, _reg,	\
-				       _mshift, _mwidth,		\
-				       _muxshift, _muxwidth,		\
-				       _gate, _flags)			\
+#define SUNXI_CCU_M_DATA_WITH_MUX_GATE_FEAT(_struct, _name, _parents, _reg, \
+					    _mshift, _mwidth,		\
+					    _muxshift, _muxwidth,	\
+					    _gate, _flags, _features)	\
 	struct ccu_div _struct = {					\
 		.enable	= _gate,					\
 		.div	= _SUNXI_CCU_DIV(_mshift, _mwidth),		\
 		.mux	= _SUNXI_CCU_MUX(_muxshift, _muxwidth),		\
 		.common	= {						\
 			.reg		= _reg,				\
+			.features	= _features,			\
 			.hw.init	= CLK_HW_INIT_PARENTS_DATA(_name, \
 								   _parents, \
 								   &ccu_div_ops, \
@@ -229,6 +230,15 @@ struct ccu_div {
 		},							\
 	}
 
+#define SUNXI_CCU_M_DATA_WITH_MUX_GATE(_struct, _name, _parents, _reg,	\
+				       _mshift, _mwidth,		\
+				       _muxshift, _muxwidth,		\
+				       _gate, _flags)			\
+	SUNXI_CCU_M_DATA_WITH_MUX_GATE_FEAT(_struct, _name, _parents, _reg, \
+					    _mshift, _mwidth,		\
+					    _muxshift, _muxwidth,	\
+					    _gate, _flags, 0)
+
 #define SUNXI_CCU_M_DATA_WITH_MUX(_struct, _name, _parents, _reg,	\
 				  _mshift, _mwidth,			\
 				  _muxshift, _muxwidth,			\
-- 
2.53.0



