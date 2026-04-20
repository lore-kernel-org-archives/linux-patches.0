Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0403A7838;
	Mon, 20 Apr 2026 13:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691871; cv=none; b=GTybu5gM7I/Txhs1s5QoMwjNG9MqfuOgTxy1PWZLjylCCSjEgPay2w+pHtEWjPUYh8NG1fJVZ96vBqzb9CvEukKusgIZseO9rW2VKED7j6VplKXTe7l+Vf5MN3t34BYVET9w8o+N8jID2pfxKHiWMEaCFwllRq75TcW1a+XaAXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691871; c=relaxed/simple;
	bh=WndapDrQTW1NPt1zLNN45ytCLcjeyhPdv7mnUOJLjQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=agY/cq+wQprjKB5QpBNAsElh9L+umMr+V6c8laE3xm4yyuuS8Up6R9uz/a8jtdCVYNr1Yfd1gpPKzFPdtp4AbNenH28i/FG9q8AKm0g2Msm30NGQaPsNitcjPlaom1Q0xsd4UXRGKo1oBK9Z4GZXErbNASUYOxjERoXJc7UKXGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o3vPibwK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o3vPibwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12357C19425;
	Mon, 20 Apr 2026 13:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691871;
	bh=WndapDrQTW1NPt1zLNN45ytCLcjeyhPdv7mnUOJLjQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o3vPibwKbJukBRKRnMELsjExQgK+Yp2oYTSMYJavReabOtMBoRuAuQidpnkzDtmpO
	 LDAUbsPIJZ+OV6CdkqZ5ozCyD8YQXpZL0moRo1DLMI8+7qExzUlTrK86eZBOHu0DbT
	 BDLn8i3Z7IxA8yTgh8J1Vx3yE0Bygqjkarnd6N0fbCWXgm8ee47kUSZq8Np3xBS2hb
	 PfScoF69hB6QDTZgnOCqdxto1e96IjG7mPy+/ZUiahNumxXLMSSqQHQe3r6ELTekNT
	 e5YS2iIZWqjWoNkPc54GU7ukMvmmRMijqkd/dfx4Sf5AqCt/B7Z55yFofh8C0jgqZm
	 trhSlfPCJNPWQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Potin Lai <potin.lai.pt@gmail.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>,
	joel@jms.id.au,
	linux-arm-kernel@lists.infradead.org,
	linux-aspeed@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] soc: aspeed: socinfo: Mask table entries for accurate SoC ID matching
Date: Mon, 20 Apr 2026 09:20:37 -0400
Message-ID: <20260420132314.1023554-243-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Potin Lai <potin.lai.pt@gmail.com>

[ Upstream commit 7ec1bd3d9be671d04325b9e06149b8813f6a4836 ]

The siliconid_to_name() function currently masks the input silicon ID
with 0xff00ffff, but compares it against unmasked table entries. This
causes matching to fail if the table entries contain non-zero values in
the bits covered by the mask (bits 16-23).

Update the logic to apply the 0xff00ffff mask to the table entries
during comparison. This ensures that only the relevant model and
revision bits are considered, providing a consistent match across
different manufacturing batches.

[arj: Add Fixes: tag, fix 'soninfo' typo, clarify function reference]

Fixes: e0218dca5787 ("soc: aspeed: Add soc info driver")
Signed-off-by: Potin Lai <potin.lai.pt@gmail.com>
Link: https://patch.msgid.link/20260122-soc_aspeed_name_fix-v1-1-33a847f2581c@gmail.com
Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 drivers/soc/aspeed/aspeed-socinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/aspeed/aspeed-socinfo.c b/drivers/soc/aspeed/aspeed-socinfo.c
index 67e9ac3d08ecc..a90b100f4d101 100644
--- a/drivers/soc/aspeed/aspeed-socinfo.c
+++ b/drivers/soc/aspeed/aspeed-socinfo.c
@@ -39,7 +39,7 @@ static const char *siliconid_to_name(u32 siliconid)
 	unsigned int i;
 
 	for (i = 0 ; i < ARRAY_SIZE(rev_table) ; ++i) {
-		if (rev_table[i].id == id)
+		if ((rev_table[i].id & 0xff00ffff) == id)
 			return rev_table[i].name;
 	}
 
-- 
2.53.0

