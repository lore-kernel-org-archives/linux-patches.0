Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016463;
	b=xIbJamdXmoUIBCe4NnXna31kyTzQ3jZCtp2o31Eo3bShoh/K8jzB/UpTRA340OLx9W/Y
	 kEZN1O1XtwYPAwrha5JVRXSwdLzxbAVVn0hkX5vjYlAHckaCIDeJsLjr6v0GMnEp8W+/c
	 Jw+GH7tF2PBQ2fIhRu33Xt9VSnhckFPrz7SePmqo/ZW5sUCJ3pn3GEC/Gs/LfbkHszxAD
	 y2H+KoOAiHeAQxXak2i5e/IYRCVIfGha8oqaczw8RZ2PUEmK+K0U6h3o5pZbpZ53PpmES
	 9jyMoF/Be0Du4unX4hzX6Ozs68/+JA0wg9hh2Oy2LDCA+dNNjyWVbVHMJDYb2CA2Ecg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tsWVBAe5jkb3KXNx0CFmViov13f+JlJ1GHB3EV657es=;
	b=Y0Ht82mXh+LO0EgrgZBZne6uE2m5vYfZ1ccATBsrWveXgN1kjb1t7Hq0ooxyKz2BSsTc
	 ql1LOzj9bFOT3+zXJzQo7OcGUwWES3Aj/KDtBRzsqmo4KxeGbJ+xa/U1cYpu28Xm7Mlo6
	 42q4dBxRLk4Pns+0PA19zspfr06hasJox2j4FEb6B4Ej0HTrVwhvSJmYe03wxM6pbweki
	 Nj9EYb9/Wx7IikUvsB2FSCOriJ4vgNTliz5CM9eMPsRvCSnf9Y4SkAvl9nEtkh0N0g2uC
	 NIuuDyAwniMYsfiMlUWCvwNRl/doO4F4luJY54DwR8CrcjH7yXuPrf5frZgArpnRnGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X2DAQIGx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BA1606A31C;
	Wed, 18 Nov 2026 15:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X2DAQIGx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05341F000C4;
	Wed, 18 Nov 2026 15:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016463;
	bh=tsWVBAe5jkb3KXNx0CFmViov13f+JlJ1GHB3EV657es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X2DAQIGxk98IibD4cycZ+M8FfirmxxRB+0hnr9OX1iBkOnTGOcbkQMFtYxDq+Hj6g
	 /4RLmWenqmvf2NNQBm62UL+MaURXvgZ8dxL7n650Nphmb4ZW7uw8lSLb7gxtglboA1
	 e4p8z3rAvHWnqdYr4hJxvXXTGxRaYCeL8ej8vj1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0538/2651] clk: milbeaut: Return divider update timeouts
Date: Wed, 18 Nov 2026 15:29:38 +0100
Message-ID: <20261118150307.124535896@linuxfoundation.org>
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
index 4265bc442dfd2..b3bf569ef7471 100644
--- a/drivers/clk/clk-milbeaut.c
+++ b/drivers/clk/clk-milbeaut.c
@@ -410,8 +410,8 @@ static int m10v_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 				unsigned long parent_rate)
 {
 	struct m10v_clk_divider *divider = to_m10v_div(hw);
-	int value;
 	unsigned long flags = 0;
+	int value, ret = 0;
 	u32 val;
 	u32 write_en = BIT(divider->width - 1);
 
@@ -433,8 +433,10 @@ static int m10v_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 
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
@@ -444,7 +446,7 @@ static int m10v_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 	else
 		__release(divider->lock);
 
-	return 0;
+	return ret;
 }
 
 static const struct clk_ops m10v_clk_divider_ops = {
-- 
2.53.0



