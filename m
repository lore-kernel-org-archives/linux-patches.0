Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69CE3612F2;
	Tue, 16 Dec 2025 12:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887354; cv=none; b=O2Hp2LTHeB2ITg9e/5CQBu2atc5+EjMa8fCZaEWe5sIcY/o8OwxSlUGNES8g8vF4TmgbJJiw1CU26g9jtl+K+lGfBcjT3PEFvF6cc4MgoCXqcLsthyEvxYHVniacTlcxuPSPP2WlvrDRIqaE227ey60DcxqjeQMpg9RbPNwpa1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887354; c=relaxed/simple;
	bh=WKvMVEYS5Vy/osMSFFgCc9FdU5qLAPZthLXwsxEARJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0RC5WA1i1pTLfqAu6f2RRXHArXX6p9O2bEqY44q5CJ9G+k77TwqOOktDVZtoIKCitf9DeRTGbH+JQv4FNGTOay0S3C7B7jQqi+kATSCcSlHMk04ztd3+6qJsAnYMCdhIetnKsusc2Rvlqd8DQ9oLZy/Gdo7x1Mybdv6bO/Yy1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bfrW9tng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bfrW9tng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5235C4CEF1;
	Tue, 16 Dec 2025 12:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887354;
	bh=WKvMVEYS5Vy/osMSFFgCc9FdU5qLAPZthLXwsxEARJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bfrW9tngjiPSFWTkv94BEkj6KrQ6WwF1+XJ7XTUl1XnsOWaihj3FAYkSFibH2XvDo
	 WV5fzFsHBHCJuX25GzR+CC4UTcUE/MxIGsnxqv/HJUWOR615OpAOC0bDqDJbPyydGn
	 CdDPW0S4q6Df6tw+u3kqAhyRBBj/OYJsg1+ciVvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Matt Coster <matt.coster@imgtec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 171/614] drm/imagination: Fix reference to devm_platform_get_and_ioremap_resource()
Date: Tue, 16 Dec 2025 12:08:58 +0100
Message-ID: <20251216111407.545611909@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index 294b6019b4155..78d6b8a0a4506 100644
--- a/drivers/gpu/drm/imagination/pvr_device.c
+++ b/drivers/gpu/drm/imagination/pvr_device.c
@@ -48,7 +48,7 @@
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



