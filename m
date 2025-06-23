Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E44B239E63;
	Mon, 23 Jun 2025 13:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685113; cv=none; b=Up38k5POUPcLcwxr9ATZ+yjSGr3kgUnozZJ4yFRIXsWrAbb8UUMq1A4/4eoi6TnhpBTSLFc4Fao64fgUUFVTm/6Rij8OGcfcVrV9II+H1Xc4jBFxey1qnsZQg46rCUpcwwczd28Uh3VDzdEF9IVMAl0CvtVMrrq2GHxLvdn+1CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685113; c=relaxed/simple;
	bh=bYe+f5qioUYQRiEcLbSGu0yOzXcWudECFwjPzQ12zng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDWe5fLf04zE0X5Tf/6TPvxxz9ZLwrCgNR+5B+XFfTOSKkUIvv+ElRoiGpJ6la4FxSgmpHr2DfpnFcKXLf2WeFci8EUI6KdeVqSQRZb6l/YqjEWQ7/RB9ERuuCzpEzdbqa5T64r5R8MEamKFMDjoM0qcsAIG2K5ER7trKcUankc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2BwMlKN3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2BwMlKN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E669BC4CEEA;
	Mon, 23 Jun 2025 13:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685113;
	bh=bYe+f5qioUYQRiEcLbSGu0yOzXcWudECFwjPzQ12zng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2BwMlKN3FjkH7USl8iDc7mcqkpPpQpROEuBiolrkMxVnUDZi4Wml+lE3RLEFcRaKk
	 WcOK0hfNwPCS4AhL6hrbYIa8e2R+67pyWpHF0YmcvmqJg6fD3KPAJKi5dssFyBIDdE
	 SC/RYiPraSl7fCb8eNH4gcC4h9ZwgHMNcgXw0x4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Thompson <funaho@jurai.org>,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/355] m68k: mac: Fix macintosh_config for Mac II
Date: Mon, 23 Jun 2025 15:03:48 +0200
Message-ID: <20250623130627.624408840@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 52ae3f5da7e5adbe3d1319573b55dac470abb83c ]

When booted on my Mac II, the kernel prints this:

    Detected Macintosh model: 6
    Apple Macintosh Unknown

The catch-all entry ("Unknown") is mac_data_table[0] which is only needed
in the unlikely event that the bootinfo model ID can't be matched.
When model ID is 6, the search should begin and end at mac_data_table[1].
Fix the off-by-one error that causes this problem.

Cc: Joshua Thompson <funaho@jurai.org>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/d0f30a551064ca4810b1c48d5a90954be80634a9.1745453246.git.fthain@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/mac/config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/mac/config.c b/arch/m68k/mac/config.c
index 2bea1799b8de7..856042fecd81f 100644
--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -800,7 +800,7 @@ static void __init mac_identify(void)
 	}
 
 	macintosh_config = mac_data_table;
-	for (m = macintosh_config; m->ident != -1; m++) {
+	for (m = &mac_data_table[1]; m->ident != -1; m++) {
 		if (m->ident == model) {
 			macintosh_config = m;
 			break;
-- 
2.39.5



