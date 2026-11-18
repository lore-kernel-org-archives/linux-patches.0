Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023567;
	b=WNgx/zf7sGu91bctVVtoTwZ5WebxPgTY/sQIpVfQz28Qg47XigIbSg+SjZnHdxHaqcbu
	 OR9zI1DWCbPlsnnLL9OCBqRz27gv8HMHFUjm4OVwqf+yRhhY6w4UYi+UH73HqSbLo6wi9
	 JrC8V6hjmUEKsqvfUWn5nbeOaenJAnZgaoMFopU6CdlyOytTPGjAp4EkZIZMH66Wp4PLB
	 tuFHjsAEsrTSJJrI1VpW6Ge/ofEqrQpYfGyRHHKQhzbqQa7QxCccVU63kcxzuDlazsV8U
	 vG/82GIilfNnPJ903b8OQCE5cOz4XHZEvrstDAwWlFzb7U1jFzgmSQIoRJNmJCXELpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=najp781dGJCUpDGtmBMi50IknIfldDCaIqIRJEnKrYk=;
	b=abaxqXDqmht4qmCWL8U5VgYrMKBf1iGe0SOzk7QKnzltnDRYERshor4MpjRStV3KkM4x
	 kXqAhZnB5C4FtS26Y+vF9jm2+uSMiSaMAMqZB0HTpPrh/an+WNy6P5xZT93BfOdn4/rUu
	 NEXE0nPfKsRcCpb4tMlT4tDvORmC14lkWkg1izFrRTn03X5vaHl12rBnYW4WnVo0krbx9
	 u2GCGbq4F2QYg+tIZbOHtBeTDQ2/fwGb/W2b3lw2MVwzeq4JVldNaQ63Fqcqq21dD7dQg
	 SlUycr4sz6lCZDV1V0z0POr+/Mew2S3+vgqHboqhjQedqQ7t/MOGAJA/9MKIAwygqFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vSqvwU/A";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF71060A260A;
	Wed, 18 Nov 2026 17:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vSqvwU/A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23E01F000C6;
	Wed, 18 Nov 2026 17:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023567;
	bh=najp781dGJCUpDGtmBMi50IknIfldDCaIqIRJEnKrYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vSqvwU/A/7RQr/bXLcQOY41zYUthFPxOoAhsRmB6Dy/Ug/b9yXoaup7rghKEiO5K9
	 Yvn/OgQRJIiwNbi1kgrXLiOnaUBEG7bLqdvkERGqyEAK/MWbDsNZorR/Bofx3k6Ngt
	 MBiGw/h3cScXh4d5gh09R9iBZRMAcCoMqI/Q4ctI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0414/2151] clk: rs9: Add clock index range check to rs9_of_clk_get()
Date: Wed, 18 Nov 2026 15:35:49 +0100
Message-ID: <20261118150137.138957251@linuxfoundation.org>
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
index f94a9c4d0b670..6650e3440c749 100644
--- a/drivers/clk/clk-renesas-pcie.c
+++ b/drivers/clk/clk-renesas-pcie.c
@@ -277,6 +277,11 @@ rs9_of_clk_get(struct of_phandle_args *clkspec, void *data)
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



