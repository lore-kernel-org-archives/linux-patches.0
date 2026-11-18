Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029134;
	b=bp3Ek9dQDWaal8xfWfYDNoo7rh3Gtzd/rFeCzfU5zIygoUqQduVkqLt2CWUYF6/VUpGW
	 P/kX3tF9T2dsGvAa+D8VXPj49N72cidHAsNWXxqwNWuf633h8rcNqftKd/PvF6E/wGUul
	 YVw/MXMgt/njGRxCs5W+8PK0udeu2H8NoeQEfyJHjCQd2alFzfWCZ3zPMQ+gWa/xc0rcL
	 SzDVJBnQkJyjUEnjGM6K6xYOtuegBAN7k4WuK6+u9SFpPtQefFMoqcMcoQddk3N+SJp/C
	 hOFTtnNE/MN76R9SU6R4Ze1te+y2jX5ggrhsk+WzsH2U8a/eLNLJBU95L8/gjMmZRpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=og/mWIC11jyk4nYB93d5sjFRvje4as10JCBYYK9oZbU=;
	b=tYSlu87UCbCdXR0Ipmg/YZBRg10w4cxK8LA1kUrVGAmgUXMD8/ljEX3JCAFZC5jYy41P
	 zbVBkm5nG4ahjC8kAHJEnfewuLH2VBKz4iE6n3fD6x6gejFc02Z4U/Ca0YY/R0vb3b09W
	 d0jMucWuuIXM0rFyI8aEsVw2sWkbTJvY89Dnih9LiUxcO12LMBv7dlT0rvJ5EPJMdol4L
	 aLkD2x5UDYpBs344fXitoqBIH4BsZsT4AeLPWNXhQ88Kv4mSPTG1rGq3/lMpu5BZ3/dET
	 QKqKtpwTEPkTBPupT383Xd6eSjkmOKc076uRzYwVO3U2Wjl1ZVt6tg+hzDIigcgkMjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HNg47Db9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674C9606A32F;
	Wed, 18 Nov 2026 19:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HNg47Db9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C055C1F000C4;
	Wed, 18 Nov 2026 19:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029134;
	bh=og/mWIC11jyk4nYB93d5sjFRvje4as10JCBYYK9oZbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HNg47Db9MRluTsvULC8Momi0D7uwzORg2fq0CVvRQR2gEnABPkZXhTEKDtVgqrWcH
	 jXoi8SOrrytHqCyvQ8rJ6BpsO9i69UrfAbJfCuL5CW+JTfMNPgCb8+MYCtGoSrWEWq
	 BgWZHyKAMgNQOX3e3tSkjS0/mjU85zcWaK+gM2xA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <sboyd@kernel.org>,
	"Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>,
	Brian Masney <bmasney@redhat.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0215/1756] clk: Use the generic OF phandle parsing in only one place
Date: Wed, 18 Nov 2026 15:39:02 +0100
Message-ID: <20261118150016.888634548@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>

[ Upstream commit 57d728b4ab15a8af890013bb0f302e7733f7c1c6 ]

Ideally, there should be one single entry in the OF world. This way, the
DT parsing logic is always identical. At this stage, we call
of_parse_phandle_with_args() in:
- of_parse_clkspec()
- of_clk_get_parent_name()
which kinds of defeats the above statement. Furthermore, when this call
is done from of_clk_get_parent_name(), we fail to parse the
'clock-ranges' property.

Make sure DT world is entered only once by calling of_parse_clkspec()
from of_clk_get_parent_name(). Doing so implies that we do not try the
"clock-ranges" path if we already found a "clocks" property.

Suggested-by: Stephen Boyd <sboyd@kernel.org>
Fixes: 4472287a3b2f5 ("clk: Introduce of_clk_get_hw_from_clkspec()")
Signed-off-by: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 1bab1ca73a74c..4a10d5c664572 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -5237,6 +5237,8 @@ static int of_parse_clkspec(const struct device_node *np, int index,
 		 * has a "clock-ranges" property, then we can try one of its
 		 * clocks.
 		 */
+		if (of_property_present(np, "clocks"))
+			break;
 		np = np->parent;
 		if (np && !of_property_present(np, "clock-ranges"))
 			break;
@@ -5381,8 +5383,7 @@ const char *of_clk_get_parent_name(const struct device_node *np, int index)
 	int count;
 	struct clk *clk;
 
-	rc = of_parse_phandle_with_args(np, "clocks", "#clock-cells", index,
-					&clkspec);
+	rc = of_parse_clkspec(np, index, NULL, &clkspec);
 	if (rc)
 		return NULL;
 
-- 
2.53.0



