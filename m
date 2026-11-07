Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061913;
	b=2OWgfKlS22WU8DMbEMwKNq7qbdCGqJvfGN6vnqu+gAZUYyiAKK307yxQli2Q28WomRS1
	 1z3eXxg/A7KGKqGRfTXCS/AxErNBrVDmQe7GzEwE8qzD+JMCsIYo5l5SN1MpFvOMBdNsW
	 e6QCqoGmCAU1/3wxG8j6CvXi82BsIBII5hW4EUZAQS+ByuheCp+TgAtn4eJgcBcDpKXtt
	 YDfoBHdMspxwjPMULXF+w2qb7n/Lg0LEa4a46PfrgQaDexn+sI0CH4EjAMigXNK9oWOZE
	 Y++B0Alti+XR4PcypWZp66lpA+rBqDJXLGMledjzMNRl9vw2D9RKS62M/FRr2IcwYpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u4aY4oQQwf96sx7+uTEZPKP7S8O1av3F0Qv+Dw9t0sk=;
	b=ktSivVUSKcAVAqNcbGMk5zanfjrDn2qUelXk/HEQxVukgoIvA2Vz9O/3V7BAgg+2J6FU
	 KfTEYBVvAjj0fouF9kRAeNBgF0ThVqxi69UmOYPqv1F2185FNo400xmx0N0IaUZ4re8Rm
	 F+0EvVESv/I/ndyQc3f3imWujU0Di2EiqdFg/qqcpMUJKfr2tJHnwaBqljWt5iG2Q3h1J
	 5zSJlLJtbEj9ixGZoAOjNCPTvzD6QRfLlnwXVTWHvmy3GFMCpFCljTTqCET3xUWVAkhsu
	 QiwNnu/rN4vzNouwXXnnDSQtAhI6tdNu+aqhQ5a6O5/tCF8CHkmkQC1aDzYqnSxj0VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=elXHKETu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29C2606A330;
	Sat,  7 Nov 2026 14:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=elXHKETu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D5E1F0089F;
	Sat,  7 Nov 2026 14:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061912;
	bh=u4aY4oQQwf96sx7+uTEZPKP7S8O1av3F0Qv+Dw9t0sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=elXHKETuYtm6GNjXXoM2xjOXOzJvDLgGcHoVTI4MQHduN+dRbzYZSddSDqeOM0VDE
	 VxqVbisGKs/vFOi0Z/LwPKpZqtzIOOo2r5wxY4YpMofGbaEI+rKy3X7jqnaEzmmuMa
	 Wrpfwqk1IKj2A67dCLNeTuNw3ONV2yhnHf0mf1c4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Michael Walle <mwalle@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0921/1536] mtd: spi-nor: sfdp: check the length of the xSPI Profile 1.0 table
Date: Sat,  7 Nov 2026 08:48:57 -0500
Message-ID: <20261107135023.512767210@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 20b791568d5f0..e6e86ebadb341 100644
--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -1171,6 +1171,7 @@ static int spi_nor_parse_4bait(struct spi_nor *nor,
 #define PROFILE1_DWORD5_DUMMY_166MHZ		GENMASK(31, 27)
 #define PROFILE1_DWORD5_DUMMY_133MHZ		GENMASK(21, 17)
 #define PROFILE1_DWORD5_DUMMY_100MHZ		GENMASK(11, 7)
+#define SFDP_PROFILE1_DWORD_MIN			5
 
 /**
  * spi_nor_parse_profile1() - parse the xSPI Profile 1.0 table
@@ -1188,6 +1189,9 @@ static int spi_nor_parse_profile1(struct spi_nor *nor,
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



