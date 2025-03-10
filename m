Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5524122D4C3;
	Mon, 10 Mar 2025 17:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626839; cv=none; b=YrihS1I5OtKFOqes+vuOMaCovDsbAHel5hTYZArxgE3IJ4yQ34vcRZZtcIZFzROzb+XcHvIc/6TEjm0reFGcFyNYRj7VLiTmSjKD03f4aUzMLgcv7jqcmenIOgo9RiOyVrKZbua69aYcev3Z5xYOE+F+nH9Bzkph+USLNz5SsC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626839; c=relaxed/simple;
	bh=2GaO+Q0tr39ZAhsqyVG66bXQDWZ5QFaJbRBbsv5PYyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFHOHGKrku0ZOV6dJOUoQSULehmdfwkAxRFb2YzBVpA4GSFJuiUek7QgBGnQ1BGk5dP64u8GEwPa2Bss11RPuTFzkXzV7d5UkqqxdCVb+95tjyqMt2TUdZezgkZlCKGq9pNmKuMMbDeMrViD5dezOHs7loHdnk5wXP0nIK8yjZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hb9su+5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hb9su+5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D108DC4CEE5;
	Mon, 10 Mar 2025 17:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626839;
	bh=2GaO+Q0tr39ZAhsqyVG66bXQDWZ5QFaJbRBbsv5PYyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hb9su+5lKmqnrcc9UTu8nYOUzn9ucHVvYQtNbHbg/TtWeI1YayZSbADAUdLs9bEnY
	 AslvIvS8a8prLpbD+K6ma7CdX0b0J2JWOBNlNxpEcBlQPpom3owXaLhEKaB5xWikFi
	 IAN3FT2a6UDSmNe7BZ/dNHzrb0FLasRadfpuIAHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 130/207] net: ipa: Fix QSB data for v4.7
Date: Mon, 10 Mar 2025 18:05:23 +0100
Message-ID: <20250310170452.971426833@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 6a2843aaf551d87beb92d774f7d5b8ae007fe774 ]

As per downstream reference, max_writes should be 12 and max_reads
should be 13.

Fixes: b310de784bac ("net: ipa: add IPA v4.7 support")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Alex Elder <elder@riscstar.com>
Link: https://patch.msgid.link/20250227-ipa-v4-7-fixes-v1-2-a88dd8249d8a@fairphone.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/data/ipa_data-v4.7.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/data/ipa_data-v4.7.c b/drivers/net/ipa/data/ipa_data-v4.7.c
index 7e315779e6648..e63dcf8d45567 100644
--- a/drivers/net/ipa/data/ipa_data-v4.7.c
+++ b/drivers/net/ipa/data/ipa_data-v4.7.c
@@ -38,8 +38,8 @@ enum ipa_rsrc_group_id {
 /* QSB configuration data for an SoC having IPA v4.7 */
 static const struct ipa_qsb_data ipa_qsb_data[] = {
 	[IPA_QSB_MASTER_DDR] = {
-		.max_writes		= 8,
-		.max_reads		= 0,	/* no limit (hardware max) */
+		.max_writes		= 12,
+		.max_reads		= 13,
 		.max_reads_beats	= 120,
 	},
 };
-- 
2.39.5



