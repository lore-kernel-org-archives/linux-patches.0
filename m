Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052138;
	b=eVOTlupcKz5P6ZKX2/SdZEufNbP3kUN2kV0EGnh0Q21TiL34xoA5qhXmWu9zMnne1mgr
	 HGBh9DkGilbl+ozEZs9yY9yN2XOr2A3g0H6Rzq6ga0bWzMH1mkbRc7DY9fORFjFalxNod
	 JbxvjQXHsoZtQ3c0LDGK5cVN8iV7QORzn92Wga/JxpjzP//AVxnms1gX8w9+yDDVKxlTN
	 qGIsFrXl1IxtNnUUSZlNVITaprStn+ecBuWA5dBGbymortAepDdfNOjZCw1qULhO7yXl/
	 iyT3BzfEZNtWubJdWk8KuaVf2vawINn8u26La/aLYj4zbyOwlJqmdKKCZEraEIykhUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=emcXGEoVq8nnAOwTSk61Zq2HCIusv1ETi/GHRDsXpq8=;
	b=j+weVpLGCZkwAD4zgsSlEJvTW2/2SrL5jQemc7TsTlN5mc8mrrsFW+amfRtvNQd/Kxpl
	 VQg6WzBCvCdP+K1K8sOzbJvICRZeus+dtnkNqkHkq6dj0BExTl+OxoAjWMxg9Sxxggy4Y
	 H3XVekg4NS5UiccRyZb1agHQzJDDx6n0dTTpuIrhh3pCvvTRrJQQ+sHYYdKujvUfvzFPV
	 bihDRCdr8yBg0hqxhPcPkVKYajBxdM1YqqhXF4QQ4vGFyQyzu7PaWwxdIY3hg8X18Ik2+
	 4qmWAZQ4nLLwTKR0WKqtPotUFo6aR5uCZeX1kWdM0rVcwt7i89lY/iIgMPY4DkFK9bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xH/cL7Rg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1193F606A31C;
	Thu, 19 Nov 2026 01:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xH/cL7Rg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3634A1F000C4;
	Thu, 19 Nov 2026 01:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052137;
	bh=emcXGEoVq8nnAOwTSk61Zq2HCIusv1ETi/GHRDsXpq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xH/cL7Rgodw9zD91XS4C0uwFsXzQwQ4Wb2pKu6O/eZ/sDyEG+8kinJd05qMg9wg+e
	 6JQJH9o+Dx+/cTdBdFSxGFsex9oOJB9LgYQgm7jwSuxgo6KQV//kMXe9Gs3wIXL+IY
	 tRb7d0oO9JUZvKn4w6gwSZZf5DfSbnpGLLJZVhNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Michael Walle <mwalle@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0455/2214] mtd: spi-nor: sfdp: check the length of the xSPI Profile 1.0 table
Date: Wed, 18 Nov 2026 15:35:31 +0100
Message-ID: <20261118150029.383794231@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit b9f34a95a81021fa1f3c9cb8cfd458e66824cad6 ]

The spi_nor_parse_profile1() sizes its buffer from the table length the
flash reports in the SFDP parameter header. But it then reads DWORD1,
DWORD4 and DWORD5 without ever checking the table is that long.

So if a flash reports a length of one, the buffer is only four bytes
while DWORD4 and DWORD5 sit at byte offsets 12 and 16. With a length of
zero kmalloc() returns ZERO_SIZE_PTR rather than an error, so the NULL
check doesn't catch it and the first read dereferences it. And the value
doesn't just get thrown away. It ends up as the dummy cycle count for
8D-8D-8D fast reads.

To fix this, reject a table that's too short for the highest DWORD the
parser reads, the way spi_nor_parse_4bait() already does. The table is
optional, so this isn't fatal. The spi_nor_parse_sfdp() warns and
carries on.

Fixes: fb27f198971a ("mtd: spi-nor: sfdp: parse xSPI Profile 1.0 table")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/sfdp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mtd/spi-nor/sfdp.c b/drivers/mtd/spi-nor/sfdp.c
index c787fdacf0a11..d11914f236f13 100644
--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -1114,6 +1114,7 @@ static int spi_nor_parse_4bait(struct spi_nor *nor,
 #define PROFILE1_DWORD5_DUMMY_166MHZ		GENMASK(31, 27)
 #define PROFILE1_DWORD5_DUMMY_133MHZ		GENMASK(21, 17)
 #define PROFILE1_DWORD5_DUMMY_100MHZ		GENMASK(11, 7)
+#define SFDP_PROFILE1_DWORD_MIN			5
 
 /**
  * spi_nor_parse_profile1() - parse the xSPI Profile 1.0 table
@@ -1131,6 +1132,9 @@ static int spi_nor_parse_profile1(struct spi_nor *nor,
 	int ret;
 	u8 dummy, opcode;
 
+	if (profile1_header->length < SFDP_PROFILE1_DWORD_MIN)
+		return -EINVAL;
+
 	len = profile1_header->length * sizeof(*dwords);
 	dwords = kmalloc(len, GFP_KERNEL);
 	if (!dwords)
-- 
2.53.0



