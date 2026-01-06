Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B47C365A0D;
	Tue,  6 Jan 2026 17:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722053; cv=none; b=Gq+fbs3efdVOw4mvHNF2ZsLvoEGSi7auCdsa7Gjw4fMpXd2J1NjYP93MbcUP07hEBE5OMz4JKSFZDdM65BLtWARwaC+ufhU17TIFl2M9p15edJNFTreSqCnU1Tyw2Omebk0sThY+F7YGhzcUK3Mi4K60vCrRoCj5UKzpa4SBKbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722053; c=relaxed/simple;
	bh=3A/OHz5TI1sC7quC7MBe2VbgLhRO4hzvkEOuidRAAZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGgqbmSb+q9UIKb/it13wpf/fGpKi0Avq8qUw9qqQKnGVb9/YCft15MqrB6xZgkZKVnQQVwiAUD058aaOzCGtwfdvlrznAn/whY6sP8QvzhvCa/YpMRC/Ljb2PgNmqW3tOXJOflJSPX5Wl/uHdPvVUw2bb0IZ4CPd0cTUlVDLi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFgbnJqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFgbnJqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE548C116C6;
	Tue,  6 Jan 2026 17:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722053;
	bh=3A/OHz5TI1sC7quC7MBe2VbgLhRO4hzvkEOuidRAAZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZFgbnJqVneI9riyfvgtkd9DOJpoVEmpbIh7ePTHnkFDisy29sSONByyYnVNJQWh9c
	 Pymypj777Ke9ef1Wf5kYvhxy5edxkakUHauM2+hv3RaKVtp7yeRfLUnOTmqEbRNceL
	 QFi8eaECqkZ/tJk/GdVJNU/Zb8N+koRv491CQu6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [PATCH 6.18 151/312] mtd: spi-nor: winbond: Add support for W25Q02NWxxIM chips
Date: Tue,  6 Jan 2026 18:03:45 +0100
Message-ID: <20260106170553.302792927@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 71c239348d9fbdb1f0d6f36013f1697cc06c3e9c upstream.

These chips must be described as none of the block protection
information are discoverable. This chip supports 4 bits plus the
top/bottom addressing capability to identify the protected blocks.

Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/winbond.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/mtd/spi-nor/winbond.c
+++ b/drivers/mtd/spi-nor/winbond.c
@@ -351,6 +351,10 @@ static const struct flash_info winbond_n
 		/* W25Q01NWxxIM */
 		.id = SNOR_ID(0xef, 0x80, 0x21),
 		.flags = SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB | SPI_NOR_TB_SR_BIT6 | SPI_NOR_4BIT_BP,
+	}, {
+		/* W25Q02NWxxIM */
+		.id = SNOR_ID(0xef, 0x80, 0x22),
+		.flags = SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB | SPI_NOR_TB_SR_BIT6 | SPI_NOR_4BIT_BP,
 	},
 };
 


