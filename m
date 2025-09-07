Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8D11DF246;
	Sun,  7 Sep 2025 20:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277306; cv=none; b=t37NYvBxG/zExkyML/TRsT3SQHjDtJzMUta7CoCn23GkYUhcVdx8Hsu6jIZ0dapV0fKdskI6KEEtnjLZWA5YgEe1oFS3L1KS0evBJ9xAziXpUS2gPil7luPUbkZdX+XCgtSHbcK4kOOcHZnToghFa+mEY/g1SUIB99nGW0+SwWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277306; c=relaxed/simple;
	bh=heEaoSkwn5GQMvvP6zPpt0fQ6H9p83TKCY3rvhBJpQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AEdS9Bf6vrSfapxBXWA0kiDuBBuwDW9CJUgIPAniBM0VbFhEOwxJaCtkapbhXrSFVV4M2Z4Ss6B8kWogIMwhQGlmNlMLvLv9vdxYtlxXGtDAZ7s+Zs+nhyF/va8TBqH/pBWQd7nptcTUAIgGX/FpPcMeisD8CIF+gmyo9eFXIoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z2t0mgXc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z2t0mgXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E71C4CEF0;
	Sun,  7 Sep 2025 20:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277306;
	bh=heEaoSkwn5GQMvvP6zPpt0fQ6H9p83TKCY3rvhBJpQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z2t0mgXcrBCUzEFQu2XyhIt/06Su7+5ZY/NCdj+5A3Kcb1kvEiTHliZP3K64daM9d
	 a5jlT2f27CQCVZBVnzMd6HEF3NiNhRYxbCLMDyrgVLYv98C/OZznEO48YMb53hJmpj
	 AE5kZqvmhFz1ZYHszw5vGxe1tFYUxMAvbjh6cdP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 150/175] pcmcia: omap: Add missing check for platform_get_resource
Date: Sun,  7 Sep 2025 21:59:05 +0200
Message-ID: <20250907195618.404532410@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit ecef14f70ec9344a10c817248d2ac6cddee5921e ]

Add missing check for platform_get_resource() and return error if it fails
to catch the error.

Fixes: d87d44f7ab35 ("ARM: omap1: move CF chipselect setup to board file")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pcmcia/omap_cf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pcmcia/omap_cf.c b/drivers/pcmcia/omap_cf.c
index 80137c7afe0d9..5b639c942f17a 100644
--- a/drivers/pcmcia/omap_cf.c
+++ b/drivers/pcmcia/omap_cf.c
@@ -215,6 +215,8 @@ static int __init omap_cf_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
 
 	cf = kzalloc(sizeof *cf, GFP_KERNEL);
 	if (!cf)
-- 
2.51.0



