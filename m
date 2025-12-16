Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D4D342506;
	Tue, 16 Dec 2025 11:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885459; cv=none; b=G9zqac+2j3pJRCjBHsgon85A7uUrzb8X7tfUW3CInlF33ZTeimNILYQImCJuqsk+h96tzHu7Oj4FbbyOLnZA4GWqmxODWCpkqoqXqi5CnkGP9VEl66a7aHZS+FWpcj7TXfrnxKjIQbZij3JALP155AanAzvu7kNdUGc3kunsYqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885459; c=relaxed/simple;
	bh=Cpr8i17Idk2I+h7zFjJveCjQbcDSdh1V8xgWlIwFmVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOFfrUTjg6HlYiChoTWZcxj05qEPshETVj9Zju6dbMGUuJDQX8BUJXv63rKFZPN/rFGgtIhuGmAqaW5qN4vjOzzCleKs6F5DQf7ZBiM6qXr6d2A3vJIny7vdf+C1g5n0mwApxRXC/xUpnslXVTvC6f0fLE19k2KfaV2lSjoXA+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9DeGlUK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9DeGlUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F92C4CEF1;
	Tue, 16 Dec 2025 11:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885459;
	bh=Cpr8i17Idk2I+h7zFjJveCjQbcDSdh1V8xgWlIwFmVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9DeGlUKNgPpLV0E9W5pKD+xJJNKZESB8srsQ8ts0WJ3ojelb80JKvmfEcCQnowql
	 2jd4JE95LjDO/+9wuNanmC4XkTDNQYPKl8kQWOG8xVpI8DK9TRXkJ/j3Mu3BmsZBUp
	 MKrM9BsLfeaVVOhSSXct8KKJNPCpzyK2klWf5yAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Matt Coster <matt.coster@imgtec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 146/507] drm/imagination: Fix reference to devm_platform_get_and_ioremap_resource()
Date: Tue, 16 Dec 2025 12:09:47 +0100
Message-ID: <20251216111350.817101334@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit f1aa93005d0d6fb3293ca9c3eb08d1d1557117bf ]

The call to devm_platform_ioremap_resource() was replaced by a call to
devm_platform_get_and_ioremap_resource(), but the comment referring to
the function's possible returned error codes was not updated.

Fixes: 927f3e0253c11276 ("drm/imagination: Implement MIPS firmware processor and MMU support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Matt Coster <matt.coster@imgtec.com>
Link: https://patch.msgid.link/2266514318480d17f52c7e5e67578dae6827914e.1761745586.git.geert+renesas@glider.be
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imagination/pvr_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/imagination/pvr_device.c b/drivers/gpu/drm/imagination/pvr_device.c
index 8b9ba4983c4cb..f9271efbd74aa 100644
--- a/drivers/gpu/drm/imagination/pvr_device.c
+++ b/drivers/gpu/drm/imagination/pvr_device.c
@@ -47,7 +47,7 @@
  *
  * Return:
  *  * 0 on success, or
- *  * Any error returned by devm_platform_ioremap_resource().
+ *  * Any error returned by devm_platform_get_and_ioremap_resource().
  */
 static int
 pvr_device_reg_init(struct pvr_device *pvr_dev)
-- 
2.51.0



