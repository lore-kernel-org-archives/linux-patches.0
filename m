Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617852;
	b=KDknzs9EqyYWAEal2in+j/gNfnnOrZyu75fJ252+VVUcSNCpl8fqHNKA/FJsB2FpfRFm
	 MBIjsisk4kU+4yU9FZh8YfsRhHlLtaL+/Hg41Hquqwx8K2JcxvTFT0o7Pc1vHKSf7tai2
	 sKiP0QgQmvqar2mxu8XDPXdQqN8EmBowC58q65z3bXHEfJbC9gNwm+gcCPLExebyahZ3g
	 uIGO6H5yq35Yxp8g0SFdZmsILjyKUGNtJ9M+q5dBqwqPY6jG3+Y1hhBuzvYuN5kvb0qyu
	 O/k+QYEjTHgeQzfep0l0WXIZxwvRw4tg2G1YKplTohaLMgRHRh2jJktAMtNgd3iGv+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1N2/atWnwXHFxJGh3Ipwu6wmZM8gqa8JmaAhGZ5PkkI=;
	b=fP/ooB7QwvIqsBoesV81gzKtON6G6JWhB0bgNrcZLjtWCD5ZJ+RwcsRoIGRWlefqCPmL
	 Wgqach+9p33R/A23fKSz8jqGMPrIIsYvuMD2pBspOeJg678sGxYNRuyJb+x4IMXMZmEjk
	 PJ5ENWLNUoa060UI1h/UWj7Nh4PMk52Zpt3EMccccvBwpmIHWB+N8cin2imrv//c4EMzW
	 B6T7bv08SWjC6t1WxbgX7yL/zdOo83ujqmzd6fxyC7ftsjt/EGiw/MoMHpNWq5Kg+86Xt
	 zUhl6zCh5tgnWY9ewh34jeJyGuSECRUmLqhzIAzBBOxZ/zmmrCAh3ffkTn/q4kRA0WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eObc+jKL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A60606A31E;
	Wed, 25 Nov 2026 14:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eObc+jKL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B091F000C6;
	Wed, 25 Nov 2026 14:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617852;
	bh=1N2/atWnwXHFxJGh3Ipwu6wmZM8gqa8JmaAhGZ5PkkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eObc+jKLc9Wc3lUdjmQ0wi5Gt2/essMbEGm9Ic+BP7p2y3Q8/9nmE3oW3KKIIq90f
	 9p4HW8ZCjvkTijfxrICpDr/P/t/UhPJc5QharOIYdASWG0UyBFnwErrsEu498nFBnH
	 JRwdWJ6ePrtcYILqVivHUYNU5wGcJIPfHfGZqEik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tang Bin <tangbin@cmss.chinamobile.com>,
	Prasad Kumpatla <prasad.kumpatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0095/1005] ASoC: codecs: lpass-rx-macro: fix PM ref leak in swclk_gate_enable
Date: Wed, 25 Nov 2026 15:23:53 +0100
Message-ID: <20261125143823.969720571@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Tang Bin <tangbin@cmss.chinamobile.com>

[ Upstream commit e2df0223ba6dbdf028c45b4a018e6b15642a39af ]

swclk_gate_enable() calls pm_runtime_resume_and_get() (incrementing the PM
usage counter and, via of_pm_clk_add_clks, enabling mclk) before
rx_macro_mclk_enable(). On rx_macro_mclk_enable() failure it called
clk_disable_unprepare(rx->mclk) and returned, leaking the PM usage counter
and potentially unbalancing the clock that the PM clock domain also
manages. The sibling tx-macro/va-macro drivers call
pm_runtime_put_autosuspend() here; do the same.

Fixes: e38cbb75248a ("ASoC: codecs: lpass-rx-macro: Propagate regcache_sync() errors")
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Reviewed-by: Prasad Kumpatla <prasad.kumpatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20261028114501.2192-1-tangbin@cmss.chinamobile.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-rx-macro.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/lpass-rx-macro.c b/sound/soc/codecs/lpass-rx-macro.c
index 282a6aaa99865..1737d525ca86d 100644
--- a/sound/soc/codecs/lpass-rx-macro.c
+++ b/sound/soc/codecs/lpass-rx-macro.c
@@ -3681,7 +3681,7 @@ static int swclk_gate_enable(struct clk_hw *hw)
 
 	ret = rx_macro_mclk_enable(rx, true);
 	if (ret) {
-		clk_disable_unprepare(rx->mclk);
+		pm_runtime_put_autosuspend(rx->dev);
 		return ret;
 	}
 
-- 
2.53.0



