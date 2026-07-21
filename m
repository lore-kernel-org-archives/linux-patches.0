Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4249146D098;
	Tue, 21 Jul 2026 19:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662036; cv=none; b=BIrx67HjoP1kx76uu/ktVaDgS8idHlEYAdh8HLAdukyA/MBEvJg4gRYu2v6zPDm+VRSNlHD79qEMWYASBXLhVwwtTtJxT72vweAK7u58mwzPWjq7I6UUF4N0NqlXsG6xhcu79ZxrN3w7pIflKpP7SUcx/4Pfq8E5/8TYxCviL2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662036; c=relaxed/simple;
	bh=ENfXIYVGQNrdoqZ5T/wV3yk1iOh6VRDEi5Kt2grQEco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcwSnq0mlvMaD+aefix8wP4pvUyOAVCqobxWch/JlsNJfxxNIyYEIaHbn/NGbzMGOl7PG8l0j7Thzc6HKUNfJ5gWs8Oz2s8UFVbA51gcZ74PQzdPWKJzCRgNqou1ahaLk3pcEQMUvq0l1pqM1ZdPLKDbufjDTwNRqY4OdvWAcR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fmc0LmRL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fmc0LmRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697141F000E9;
	Tue, 21 Jul 2026 19:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662034;
	bh=SpslLoFFTFFJL13ovr3nsGotF/M5AwofbALXBs9N/hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fmc0LmRL9xbeWck+ueH9JVNFEhSbTaqzkbGkGhqax+bXC/AfRVkQozKMhoDewcUr+
	 Y1niznFItInqZvFp8z7o2UsUKXpQaK23p4jaSk4jioUFaTZg1QWJnJ/6mc5SXe6qvy
	 mpqJNXai21PpBq+qdKYM7rsO+EjLvuffuGR+G/9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Leonardo Scorcia <l.scorcia@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0275/1276] pinctrl: mediatek: mt8516: Fix Schmitt trigger register offset of pins 34-39
Date: Tue, 21 Jul 2026 17:11:58 +0200
Message-ID: <20260721152452.233424635@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Leonardo Scorcia <l.scorcia@gmail.com>

[ Upstream commit 1c3044cab23a056ea28da47da1cdd667a39df0b8 ]

The correct Schmitt trigger register offset for pins 34-39 is 0xA00.

Signed-off-by: Luca Leonardo Scorcia <l.scorcia@gmail.com>
Fixes: 264667112ef0 ("pinctrl: mediatek: Add MT8516 Pinctrl driver")
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mt8516.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mt8516.c b/drivers/pinctrl/mediatek/pinctrl-mt8516.c
index abda75d4354e28..68d6638e7f4b18 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt8516.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt8516.c
@@ -244,7 +244,7 @@ static const struct mtk_pin_ies_smt_set mt8516_smt_set[] = {
 	MTK_PIN_IES_SMT_SPEC(24, 25, 0xA00, 12),
 	MTK_PIN_IES_SMT_SPEC(26, 30, 0xA00, 0),
 	MTK_PIN_IES_SMT_SPEC(31, 33, 0xA00, 1),
-	MTK_PIN_IES_SMT_SPEC(34, 39, 0xA900, 2),
+	MTK_PIN_IES_SMT_SPEC(34, 39, 0xA00, 2),
 	MTK_PIN_IES_SMT_SPEC(40, 40, 0xA10, 11),
 	MTK_PIN_IES_SMT_SPEC(41, 43, 0xA00, 10),
 	MTK_PIN_IES_SMT_SPEC(44, 47, 0xA00, 11),
-- 
2.53.0



