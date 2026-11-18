Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016192;
	b=vY/cZX54WtXvCA/ihZOkLFfkGtprmf8P6TAhwby78J4++et0T63KazQNMekr0it9XNDq
	 DVJfijj9Kfckxh1nKu1D3t4LKdKpJeyXeTbvqr1yZlrg7xE8D8BEf+0JidKlAm/V606vI
	 DbcxJbTLfLZ5V61OZ6AWHAWQUtAAzrXquqXtu0ATxskk4Y4vPhBFwbKSnWAfcdPDrlM0o
	 4cHqol0/f6r1U73HRNTzp8jpOz6ayOSAqJA9IPkhzwsnKoaEuHU9KUVOQTOMVrEu6iIUn
	 mkLfI7LslQ2jkK1A3E3ncrWrtAemfq9Wj6hMM4yt6ZSouXrEHhdfxVbmF3yCgKIqgug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JAmmieT/S/3+pk3twH9szGKRuqTokVXZ1eFo84Gh5SU=;
	b=syxDpbvEH5+YQKEMY2u5WEA92qy8vKi9UGnLzNjMUEA/Myre8Rc8GV98dfB554tPjZ5f
	 9jtoAq0BwriZxygrf1z5ieVX0yltDspWIAumC1SJ5xWQHlvnEp4z31owJngZaFnb27Pp6
	 henhU9hh/zzI31o51voiq9KFVwlwuCHE9jGoqujoA09nSB/WntlQQVjBzOufLA9F192ZY
	 RgBtqVufYr7ZaIYLmn26Ox8/zyDlYB2/wJjvs1ZODYuwpMpGMylBC00P86aee9sFFKLkc
	 ++tOqnz25Pym+DJwNYfyqqLSaZsD9T2NbNG8pWhKcv8SnInMrhDrz95OYnR0xSCM7iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ydXbEu+W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890F1606A325;
	Wed, 18 Nov 2026 15:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ydXbEu+W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3D91F000C4;
	Wed, 18 Nov 2026 15:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016192;
	bh=JAmmieT/S/3+pk3twH9szGKRuqTokVXZ1eFo84Gh5SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ydXbEu+WKA6grYREeX79ann+3TpvoxqkTKxmahyQ7sYAGlYX6YzHZ4LGOYN8hG4Vf
	 hEq8FQweu8OOaj8Uj1BetqnMnPqkcWBMFhSnrlyAqkm1WX4T5KWnCWw1rIPt5skE6J
	 eOohU0ZS+xyeyn0x43KJk5bjqvB3RLg+GFTD57BQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhui Liu <junhui.liu@pigmoral.tech>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0443/2651] clk: sunxi-ng: div: Add feature support to M clock macro
Date: Wed, 18 Nov 2026 15:28:03 +0100
Message-ID: <20261118150303.766475797@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index a30a92780a051..6d3541a3b5191 100644
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



