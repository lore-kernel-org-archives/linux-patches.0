Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039804;
	b=CO+EFtP7sV8t1KmXb2CSxg8cinda+ulUPT5Sv9skNM/Zb8zi1gebPfzkzULcq7A+zPLs
	 /6EE8W7iXpzqq7sQkFwqgLbCVNKCPlFsanB8OePQr9WRI1nsq00fsvR5bv5r0Gn+qAD3P
	 Q7y1aq9qGFtncuMu8qjJxgEIGmr6PYXa2A6cXeHgDKKTMj7+rdV/Hhh0vhjo+xxxS6280
	 iNvRkYXMrR7XEQ0yzSm8o95LfbIkGRO7k3K4t4MVommgAnyQ4zRrJn69dpVgo1gCY9Cgk
	 b1q8sSp2Ose7FbUcMhDMBiDZN0ScWe7c5CydhCLRvgHIOeXAdWU8gKDDTX8SGRK94rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039804;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sSHTkUADfTOropSU1Nf9nlPNdsOqjtgW3Jcvz9Xb3YA=;
	b=NKylo2sNxnCpsUvezO3I75vCNr8/4TNlLH6kPaggerJIYEAiGqpiBLonk0reS0AOl77p
	 FpM8L16ey5HauH0BAcLfNoHvlAAO0YKDO0ObLKNW2LWMeezpEFcx93QyBRVFIrYkHpdI1
	 hPgVgqqjkJIcSwMfrRMXSnJPxFJCsIpn9FxB5MwXIihu+xQ/7Dr09KP5c0zEZPPSrlhrF
	 3w/kH0MKxBsbC94bcOfZZx+4p0ppOV31ClWHX/fHnsUamf4iC2KCaen54xM+5kt/pIQ/x
	 gnCZifh+6NI2pgc+qZ7D2eEz4GWGSb9ig6VQvgCpdlB+pGhp9P5Nru8HsuG4LXY30LQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="b/YCe45e";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8D3606A320;
	Wed, 18 Nov 2026 22:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b/YCe45e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747581F000C4;
	Wed, 18 Nov 2026 22:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039804;
	bh=sSHTkUADfTOropSU1Nf9nlPNdsOqjtgW3Jcvz9Xb3YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b/YCe45eOWd4Ap+sLtp2xVT3/2zYb9EjByzxC3yOfFxXu0twwLxSZDhKrOJ05lsui
	 X1z51mmJzdtFBV1pKUgO1lEhx3IauBpET1b62kwS0wK59TehApLlOdfQWIrimzC9zv
	 SW1IQxHmcVYQ0eJcZXCuDIq+sK5pCoMfQt6IiGU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2190/3318] clk: rs9: Add clock index range check to rs9_of_clk_get()
Date: Wed, 18 Nov 2026 15:46:52 +0100
Message-ID: <20261118150427.653016731@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit a2ef401bdfd19aa41d0e3e1b630a12fbc01ac184 ]

rs9_of_clk_get() does not validate the clock index in the passed
DT clock specifier.  If DT specifies an incorrect and out-of-range
index, this will access memory beyond the end of the clk_dif[] array.

Fix by this adding a range check to rs9_of_clk_get().

Fixes: 892e0ddea1aa6f70 ("clk: rs9: Add Renesas 9-series PCIe clock generator driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-renesas-pcie.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/clk/clk-renesas-pcie.c b/drivers/clk/clk-renesas-pcie.c
index b00c38469cfad..f4ebe6d14bbc9 100644
--- a/drivers/clk/clk-renesas-pcie.c
+++ b/drivers/clk/clk-renesas-pcie.c
@@ -283,6 +283,11 @@ rs9_of_clk_get(struct of_phandle_args *clkspec, void *data)
 	struct rs9_driver_data *rs9 = data;
 	unsigned int idx = clkspec->args[0];
 
+	if (idx >= rs9->chip_info->num_clks) {
+		pr_err("%s: Invalid clock index %u\n", __func__, idx);
+		return ERR_PTR(-EINVAL);
+	}
+
 	return rs9->clk_dif[idx];
 }
 
-- 
2.53.0



