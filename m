Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023785;
	b=jTUZJj55G7slHEcmgSOUwPFbbGk4QCbBN35r3f+XIheAoIDgzZ1FGbOI4n2K8RR9P7kj
	 xymOXIgcT72gymXfdctG4AMgDfVk9UgW1IyaR8xuqQgwUIoMwE6ieDDk1ykBOhmHiMJsH
	 bi3f2XE2pX89J/gAvnqc6s7GRdf4gJQPRNgu/equrXU8RxA3WyijOIy86QhVrT9/d0PTV
	 Twnbdffat3hrccrAXzPOvC9q+mcwpOM0JDeS9TkzNtWoKnDFW+LkLynmuPe+n2wazfffX
	 1Iwh4ebTk/rRnRALlxhVgxGcsY1YA7uwHOvyAkfuNnLhYApQ3nDlk9jxEK9a6KkXqvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dNje3zB3rvNToBaODFBETrdn24ImTetU5fFaJf6i2RY=;
	b=KaA3Qmfflh8XV2OpUKdHgdujY65OIVJYXneRTSJ1DAxT4dlFzQvWnYLmnYYRzfNv6wXS
	 xXJuM5Xb+neH9qwSfH+mldIwyVYlWF3+CGHDb1bkkMdDwrtbWnS65gv20phLa/4vHrHud
	 RGCct229QscIHon1NfcTXmQDuLNwhF+FheKD1HEND8H5qTHgCWM+b/ogcy3RtY0Zd7ZQD
	 7F4pOVlgCS7DNbOng/OplVRLfgwaBjLHWoEKblxbRqjv8gUhjtoSiNbqrPFiPWfkgDWEP
	 LRg2CLlT534sMdqVHyFu87HwfSv+1k1GEh1M6umtJCwnuTNIrhHeL9EzkWr0pcYqPCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d7yRyWiP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29594606A332;
	Wed, 18 Nov 2026 17:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d7yRyWiP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808CF1F000C7;
	Wed, 18 Nov 2026 17:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023785;
	bh=dNje3zB3rvNToBaODFBETrdn24ImTetU5fFaJf6i2RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d7yRyWiPYRYbdePspmRabYB2NNvHSEoZBNyS2dLTJLRZKrvR6TCcmGGZfDrfiKLEA
	 nJ5WkYc+lqjKki/Mz/+zCUEBCZBox0wJ3ieGRQHroQrDJ5SPLdN50jQCu2EwWfmtGF
	 HnKiKaaJvPblRK7X08YHaJzVmxACzgmWBjG4arEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0493/2151] clk: milbeaut: Return divider update timeouts
Date: Wed, 18 Nov 2026 15:37:08 +0100
Message-ID: <20261118150140.011476285@linuxfoundation.org>
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

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit 92d0998090d1716ee6b47174c10eb9415a12fca8 ]

m10v_clk_divider_set_rate() logs when the hardware does not clear its
write-valid request, but still returns success to the clock framework. It
also uses the sleeping poll helper while holding the divider spinlock.

Use the atomic poll helper under the lock and return its timeout so the
rate change is not reported as successful before the hardware accepts it.

The issue was found by our static-analysis tool and manually reviewed.

Fixes: 6a6ba5b55a72 ("clock: milbeaut: Add Milbeaut M10V clock controller")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-milbeaut.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk-milbeaut.c b/drivers/clk/clk-milbeaut.c
index bb94d02a76cf1..3b33ea6c889d6 100644
--- a/drivers/clk/clk-milbeaut.c
+++ b/drivers/clk/clk-milbeaut.c
@@ -414,8 +414,8 @@ static int m10v_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 				unsigned long parent_rate)
 {
 	struct m10v_clk_divider *divider = to_m10v_div(hw);
-	int value;
 	unsigned long flags = 0;
+	int value, ret = 0;
 	u32 val;
 	u32 write_en = BIT(divider->width - 1);
 
@@ -437,8 +437,10 @@ static int m10v_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 
 	if (divider->write_valid_reg) {
 		writel(M10V_DCHREQ, divider->write_valid_reg);
-		if (readl_poll_timeout(divider->write_valid_reg, val,
-			!val, M10V_UPOLL_RATE, M10V_UTIMEOUT))
+		ret = readl_poll_timeout_atomic(divider->write_valid_reg, val,
+						!val, M10V_UPOLL_RATE,
+						M10V_UTIMEOUT);
+		if (ret)
 			pr_err("%s:%s couldn't stabilize\n",
 				__func__, clk_hw_get_name(hw));
 	}
@@ -448,7 +450,7 @@ static int m10v_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 	else
 		__release(divider->lock);
 
-	return 0;
+	return ret;
 }
 
 static const struct clk_ops m10v_clk_divider_ops = {
-- 
2.53.0



