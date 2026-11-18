Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048193;
	b=moMCTbwR1FXEAcd8U6VyHAiAFShhbh9v7ZHNT75ym1GmCoszWD250iUUwjEmzPLTkaDE
	 C6vvtzlREOlqPp4fikOAc67WEIAH9iou78G8spZA0o4L29oUCChAuMJH9WyfGtCDy5WP2
	 4RAm+P+lJnyPtoTWmGs9T9wXVLEPVigmfHTH/C59/zvIvO2qricZNBXp/u9FICJAkZQqD
	 DKc5WhqxWK4UsXSV0RV3bPGT1dLCFVGXtsmjBfdaHe9iuk4m6u58bmyPmZ1EDZ447haP3
	 7RfLUiIz/hk90aLm4KzTK8eL+fRb54YIVdFSQNSZbKlgsmChLwz8Q+3i5K3navBXiaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=by3/eEpci/EfwM1CiupWj7wO2oYbUjUJJfP3kNIHewU=;
	b=aXZqrzMlaY7hf59Q2vvrUqc+TY4VBivPayd18/+3br1O7B5mcnY7Cjt9K7CF9kYUkhyL
	 og3j7+xWafQlLHj1Tm/e9tRNlLwJdn2fp0QVcra/QbNT4SfrLRfe/jKRYvn5NNDHWGUkl
	 uYhL+nE7qk1ZuyNFZiW7iP0FF8PLh76PrpsTbylYO9woRNqJYoMfUsuDWJPkgi0kWVo+e
	 C5NaNPhBj/3CHVkCfDXT6iQoStoKI9BiiyXUd770fAAwATFBYl5lH0Sm97ORIJ72566rO
	 D4rMiRg0PMLXTWZcIIN4H0J1nMO+yp4l7J6MQmcN6U1tJQySVOR/qUnPFpOw5xZcWMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KvcEdAZK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E13606A325;
	Thu, 19 Nov 2026 00:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KvcEdAZK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341F61F000C4;
	Thu, 19 Nov 2026 00:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048193;
	bh=by3/eEpci/EfwM1CiupWj7wO2oYbUjUJJfP3kNIHewU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KvcEdAZKn9cYtyoCXFa/3Aovqnh/4Y3Xvo32O5eFfBR/+1V/w/vSoKO4ArwqoTcxC
	 rcDnbt0fO4KbqIirR+yPB/HmeCoLmE9Fd3rAXwDbb4dHOr94h7C0jsR/s6GvXdoyYf
	 9p1Z5XBtEX1+5ifhRkqtkzydlwGkOQAFXQRBdNWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1909/2857] clk: rs9: Add clock index range check to rs9_of_clk_get()
Date: Wed, 18 Nov 2026 15:49:03 +0100
Message-ID: <20261118150309.954032798@linuxfoundation.org>
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
index bba0e7c667dc1..2cf0d014eacef 100644
--- a/drivers/clk/clk-renesas-pcie.c
+++ b/drivers/clk/clk-renesas-pcie.c
@@ -266,6 +266,11 @@ rs9_of_clk_get(struct of_phandle_args *clkspec, void *data)
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



