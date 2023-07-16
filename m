Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289F98F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0323C433C7;
	Sun, 16 Jul 2023 20:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689541067;
	bh=sh4PXW6Kr5AyDSqId6FLNtnbTfJmyStQpAWxwk6vm+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SncEjLA6uVqHqghue0GE7LplsPX439EGFv3q1K6azqcbuO4rhxQBRE1bJAQMZdLhe
	 meaDAMqSkPg/M18Ahyhs8HnYdiPTBiOXCj88H1tG8DqeV8rgJa5GMBWkEMop0LqL2+
	 IWkxGIKW/DYypxcgjCx3xbAmWTNLXSeOPClmF7PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 580/591] mtd: parsers: refer to ARCH_BCMBCA instead of ARCH_BCM4908
Date: Sun, 16 Jul 2023 21:51:59 +0200
Message-ID: <20230716194938.863751271@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

commit 085679b15b5af65f9610f619afde41da0f966194 upstream.

Commit dd5c672d7ca9 ("arm64: bcmbca: Merge ARCH_BCM4908 to ARCH_BCMBCA")
removes config ARCH_BCM4908 as config ARCH_BCMBCA has the same intent.

Probably due to concurrent development, commit 002181f5b150 ("mtd: parsers:
add Broadcom's U-Boot parser") introduces 'Broadcom's U-Boot partition
parser' that depends on ARCH_BCM4908, but this use was not visible during
the config refactoring from the commit above. Hence, these two changes
create a reference to a non-existing config symbol.

Adjust the MTD_BRCM_U_BOOT definition to refer to ARCH_BCMBCA instead of
ARCH_BCM4908 to remove the reference to the non-existing config symbol
ARCH_BCM4908.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20221116124932.4748-1-lukas.bulwahn@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/parsers/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/parsers/Kconfig
+++ b/drivers/mtd/parsers/Kconfig
@@ -22,7 +22,7 @@ config MTD_BCM63XX_PARTS
 
 config MTD_BRCM_U_BOOT
 	tristate "Broadcom's U-Boot partition parser"
-	depends on ARCH_BCM4908 || COMPILE_TEST
+	depends on ARCH_BCMBCA || COMPILE_TEST
 	help
 	  Broadcom uses a custom way of storing U-Boot environment variables.
 	  They are placed inside U-Boot partition itself at unspecified offset.


