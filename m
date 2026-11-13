Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590079;
	b=xvs2vvKh1BnAp/9gcB+wWWZilItTQCbeaw/wCpA6h86+Qa7Bh1bsoviectYQWauKVbEl
	 3GF9R20N3Etnxw5U6uauTNHbKVc7GPN5DO+CMFh33lEKVV+hM2I54UTPS7Lrh2ixs+jxz
	 Zi9QJenBKoCh3YqoN7eXGYOOLy233e3g8l80yuX0XEZFbUv0SfMy/4jGfj2nPVJRBvd9G
	 tNxPjeavvwc0NcKd1CNDMSyMNuBdf2JLZw+/FSTetJ4IRD9PdRmuaS+kix7B7T0cbcmbq
	 TB3DCwDcJHkBGqfE50FDhKBImC32fco29TIkV2HL9RhkZYF9ovOSeK8IyMHd8CLAi6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590079;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fc/h3tNXJSgD/3yff1IA/0ZCXiH+eZmW3tSli964Jtc=;
	b=lQDxBAEFVc5wsMKGL3+9wkiQDBSB42A89fcSTfWOlv35cEk1KKGWjf2qaUjFZoqtQWSh
	 3O8VuS5OZpmclNYiYcPgOxM8/2rAwYtEDcEBPMBQqPV18m/rwb6tmz7RUlyvkJFn4iqsV
	 nUKZpUZNfJlwZihAT2vHtbvMfWJkhl8ncFwBTMCBImZKwwzaQjjQmVf4i4xXBlBtQo4lx
	 KhyTwq8OV1SHqFSv5M4j3mzKEq9VZUJgp+6joO63yqCVoOSyb/nra/4MKE8PZ1dvA8c8G
	 xsee1FKZQX8eTaJU7ynzSULwcn035VGPUmNd9C2OLbK7OgFUD/huyHOe0VqB6eA1oyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QeYbvMLm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A581606C09E;
	Fri, 13 Nov 2026 17:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QeYbvMLm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C261F000C9;
	Fri, 13 Nov 2026 17:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590079;
	bh=fc/h3tNXJSgD/3yff1IA/0ZCXiH+eZmW3tSli964Jtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QeYbvMLmAyjjjpAbNJpPFdtEs8GuSZemzvhKX5TjWFbkl8NHUyaLBpV1UhSdwqfWE
	 8adrA4PaSTQ4yEpYyfkCoASqUwKGwjB6mBisIdDXzsSmHDBbRJw7xYgFifM94n5rMp
	 K6oCDJjWAZ3mjVsyMqFxe8tYZZWnWHprZxZ+zm1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Rosen Penev <rosenp@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 091/686] mtd: rawnand: ndfc: fix gcc uninitialized var
Date: Fri, 13 Nov 2026 10:43:44 -0500
Message-ID: <20261113153823.953998255@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit cceca8cb776b03e83985578f84bd730c30d57f70 ]

Now that this can be built with COMPILE_TEST, an unassigned variable was
found. Set to 0 to fix the W=1 error under GCC.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606141301.iyVdFgl7-lkp@intel.com/
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/ndfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/ndfc.c b/drivers/mtd/nand/raw/ndfc.c
index 9a38da68976c8..e1628d021a8b6 100644
--- a/drivers/mtd/nand/raw/ndfc.c
+++ b/drivers/mtd/nand/raw/ndfc.c
@@ -188,7 +188,7 @@ static int ndfc_probe(struct platform_device *ofdev)
 	const __be32 *reg;
 	u32 ccr;
 	u32 cs;
-	int err, len;
+	int err, len = 0;
 
 	/* Read the reg property to get the chip select */
 	reg = of_get_property(ofdev->dev.of_node, "reg", &len);
-- 
2.53.0



