Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD03A1DE89C;
	Mon, 10 Mar 2025 17:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628075; cv=none; b=Oj3znol0y8U+8pxeaKtvD+2B9hTBXrvGmlgbg6zNNBlC7B2B7ZlXq5XmhKeSeEPLtUGGHMjlqOC7fNPxjYww+6OsgrsmtLAkC/HnQ8xQhMac9jDILGrCug3T1XhLfNJOyjT29QwD7wEklfze9VFSyCV+yZxeTcaLiV7uB1BrvEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628075; c=relaxed/simple;
	bh=M+tc8hCqG+rubFaBDnPRUCgXafa2Wt3z2PIPiMIr3xQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCHG8x7avDCsiPJFmJDd/Qe5G8/mXkYu7aqbxZvVg+1Lhw6BZ1EA2YyS6qmsNzVl1jVrA9Hc2BPfdPrpk6yWSpz2d/lEW42E8pMAm1v8nCSTAWCUbBa5ANu8olStA642S6UY+BcEDTpNbmu7ZmG8hjIDbzVzQF+zQnFb52FG+JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BacxbGIV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BacxbGIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65073C4CEE5;
	Mon, 10 Mar 2025 17:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628074;
	bh=M+tc8hCqG+rubFaBDnPRUCgXafa2Wt3z2PIPiMIr3xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BacxbGIVI239dQkEpvYBhgyLsn088FVmiM9YThdhbNEjmdjZsAcDEvcbFhOE3oo/0
	 wWNeU4NNZi9ru4DiDnsK2R9D3ujfahA9QWS9ynEiI6tPSqusL32EMJo1l613fyHzYj
	 lCT4GLGn2sRFS8abuj5rGkw+1ikSdUvuaNXc9o0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/145] net: ipa: Fix QSB data for v4.7
Date: Mon, 10 Mar 2025 18:06:13 +0100
Message-ID: <20250310170437.943735271@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f8e64b9025820..4ff666e98878e 100644
--- a/drivers/net/ipa/data/ipa_data-v4.7.c
+++ b/drivers/net/ipa/data/ipa_data-v4.7.c
@@ -37,8 +37,8 @@ enum ipa_rsrc_group_id {
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



