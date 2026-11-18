Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016278;
	b=auQXYllIUxeNItvqup8uAPES2Vs1sNZJDdGSxZEq3p8+ossOWeabd7lD66gwtKes5Gmo
	 STDV48iYKmdUCwb9BEScda/DPbB0j+sxg5A7uFHPwFFpBTmIkGqimQIxCFkdpNB0rI9Wp
	 wHCCZtiZdBbwWfyEBuSfgCNZ4nzsJPYXLICmtFYUtINTHKYytqyVEKToWdA3fOLE2gPYZ
	 UaLqOcYFuAWFDds84W2JmT2oLp29Qz1d5iS5kicQ/rhoZCKC9xhzB1nN69qpcSflPnTDo
	 4cQa55ccPhGR10yZgTww2dJoiritj9f23cDWXyhgrRKFfrJC7F4aGXAwKll+nWl6cBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016278;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7LoHxm0pvytWROy1OdBX5OrvY4A4GDPR5EVvV7oLhMU=;
	b=1dOp9HNvT9dGim9KVyGoGut8zRp521WUYjr8djkJn2nfMmR4ecdzPrQRF4n2532Ku4zb
	 A+ORvHRbaCtOPynpjb5mQG9XGtQQwDaU1yZfKQmNi/PJhKxsfcaIk8EA6ZPh+H83NSCoF
	 XW3OBZx1nSXTNbO2k7oLiqboqCGZnBM9WdHUqHlGHxq9C+4xSbDcKe8Y8mZTr2oLxWdRO
	 sKZOS2/nxSw+Akjf3miqfztfnd/LWk/p3Usq/dmjxMGLmmTR+M6PhGG8hbd5f5RmUKHHt
	 w3g1MtUmkkzBOqK8Sh/QhbH9pDEi9Ai+99G7I7qgfnjjUGomzAs0tVkGZTeD413ILLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B+ZRUgbB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AEA160A262E;
	Wed, 18 Nov 2026 15:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B+ZRUgbB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72731F000C4;
	Wed, 18 Nov 2026 15:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016278;
	bh=7LoHxm0pvytWROy1OdBX5OrvY4A4GDPR5EVvV7oLhMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B+ZRUgbBZdBHBFQlz4fxr1Iv9Rkcy6fMlzhZMEp/M5XpqNZIIdzC9QvrDNDyaeGM4
	 I4gK375NMUSzoLUSII6ORyzzWNHMBXFfMPI/J+abo4VtH/XTc6kDxNBiGQkMX6wxgo
	 vkF7K466cVjXv5fNmekU9Ot1msZ3Wxe654eZWJV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0431/2651] clk: rs9: Add clock index range check to rs9_of_clk_get()
Date: Wed, 18 Nov 2026 15:27:51 +0100
Message-ID: <20261118150303.341283624@linuxfoundation.org>
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
index 564550c803896..f3376c29007aa 100644
--- a/drivers/clk/clk-renesas-pcie.c
+++ b/drivers/clk/clk-renesas-pcie.c
@@ -276,6 +276,11 @@ rs9_of_clk_get(struct of_phandle_args *clkspec, void *data)
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



