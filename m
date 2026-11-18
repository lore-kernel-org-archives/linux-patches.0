Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045392;
	b=Vx5VNi2MlGpvus8sshJLHDiGPwDeFkhXJJvL1mNAMk555kM+BS/gXGbMgnQDQYq/Pk50
	 VnqHukjrsDd6bDdyIDxkV2m1YOCpcFqnyEEnZx1nribU2lvuXUoqcZTMDnAj61lY8no9k
	 MpVg3SCPjqtZV79u103m3hGrYSchQ3rem/15wFUNekbvlxHlBVg4fa2LEAjJPqLXknXQz
	 8sAL6JpWNuRiGUXa8INUAGM4BqmzilZfb3aSe+aPJFoxZAuv1A0TrPXN1DbvYRaHWezNj
	 NuodBXSz9sADc9dwMleC96bQBoeS13WkbFDolEcMUk7oJAqR2iMNxZsso9bMIz5KXxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JRcIPP3Ry8ryfak0iGdTTe/jh48mA3rAWotHzCDQDtI=;
	b=bcW+ye3EqA/mc6x6N0L5f3qYyhRo81zzM1YwXxrnz02KlDlvUWDVSnFUV9k/DPtPU/Mx
	 cgr9KZdrhvB4lMwPB+5cRea9jTa6qOTTHEhIuU0cMVr9BozU59PTz7bghGrVS65UaeGq7
	 C6J+454D+GHx6SAwj29Z3RFrXp7vC4LkUM5Q6efH7VKnmv2EsqFoW0gnl5Y1CkfxYEoQj
	 36tl+7GcH72S/VcsgF83bxMyy6wa7oW3bV6uS9QS80wS2SnqKkhqq5LoQndtw871GJwfm
	 8+w1i2jAc1+ka9z1YI+xu8Ipvf64p/HV3HohN3qtq2/y+okN5xdP3f/oD6BAdHNy3Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N+fhbcy7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42B7606A332;
	Wed, 18 Nov 2026 23:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N+fhbcy7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2261F000C4;
	Wed, 18 Nov 2026 23:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045392;
	bh=JRcIPP3Ry8ryfak0iGdTTe/jh48mA3rAWotHzCDQDtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+fhbcy7HmKSc0nbaCK4yIiE7F46RsepPOS0OJsvAkN9H17ldkBz4gXiJ3Gb1OPA2
	 VwQgFVamVBCXexMj9ngckqij2h7mVc6JQjV3GbdTbt/Se4DMYse20mXgs5Fv6NDLiz
	 W8XZHI/3g9HbEMS076UaLt3egE5RgrDyA+j/4noE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0908/2857] clk: imx: Fix clock reference leak in imx_obtain_fixed_clock_hw()
Date: Wed, 18 Nov 2026 15:32:22 +0100
Message-ID: <20261118150234.267011789@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 52d4d1b26a5bc64de95099d0a3dd8b90dba1f3a3 ]

imx_obtain_fixed_clock_hw() obtains the clock through
imx_obtain_fixed_clock_from_dt(), which creates a consumer reference
via of_clk_get_from_provider(). The reference is discarded right after
__clk_get_hw() returns the hardware pointer, leaking it.

Keep the imx_clk_fixed() fallback unchanged and drop the DT-obtained
consumer reference with clk_put() once the hardware pointer has been
extracted.

Fixes: a4a4069f4523 ("clk: imx: Add imx_obtain_fixed_clock clk_hw based variant")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260915055631.1730231-1-vulab@iscas.ac.cn
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/imx/clk.c b/drivers/clk/imx/clk.c
index 4aa86bf8a8b93..71b38e30653b2 100644
--- a/drivers/clk/imx/clk.c
+++ b/drivers/clk/imx/clk.c
@@ -103,11 +103,16 @@ struct clk_hw *imx_obtain_fixed_clock_hw(
 			const char *name, unsigned long rate)
 {
 	struct clk *clk;
+	struct clk_hw *hw;
 
 	clk = imx_obtain_fixed_clock_from_dt(name);
 	if (IS_ERR(clk))
-		clk = imx_clk_fixed(name, rate);
-	return __clk_get_hw(clk);
+		return __clk_get_hw(imx_clk_fixed(name, rate));
+
+	hw = __clk_get_hw(clk);
+	clk_put(clk);
+
+	return hw;
 }
 
 struct clk_hw * imx_obtain_fixed_clk_hw(struct device_node *np,
-- 
2.53.0



