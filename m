Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BDD17CA12;
	Mon, 10 Mar 2025 17:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626842; cv=none; b=aFpdl3cbMbK/o3rjaGNgjtFwU+ruKlrLT5sQEmjmKA3uLBLeZmGmgGfjptljc1a67fM6Qlo3UX5NbS2wPCY3Vg8hapc7UZ/FU2qvW9crSoF1X+BCPEJuOf49/JK8aApY+FIqU1D5gc2xL9sbc9mMTALj6lxGnXLrlTj7jHYZ7wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626842; c=relaxed/simple;
	bh=WCvdbi9jT4buUWKFmgz0vQ9gb8WUzgh9IQZEkCPa40E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNqvWnuJYwkC3wt4CsZSAkUw7BSBP4xohzmb4B3sISO1JAd/ceH0g7TxW5XdpEj+h/aW1n77P24E2mOBHz6qrE6LmusG8TO7LOMt+NwSbBw9xRcqQQXTn5D85T/ZeXB9UAUm7xxuk0aZKiQOu9wFv0rtfkrzwjpbugwozevljvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGzIaDrK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGzIaDrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A162EC4CEEB;
	Mon, 10 Mar 2025 17:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626842;
	bh=WCvdbi9jT4buUWKFmgz0vQ9gb8WUzgh9IQZEkCPa40E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGzIaDrKrrCCeN0lfzfNsg9JW9Xq2sB7kds6F5YmXFYPHbEpbxLVOiei8fAe0XeGN
	 saQeTJoHBwlUxIQltWJP1pFC432qNzCVZGspFZFAHl9/1I7l8ZfgbCrKKwglTiVQR3
	 xgl/UV3wyZ8IXKUHXKVlursZ0UlbmMhUVA2Uj5UM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 131/207] net: ipa: Enable checksum for IPA_ENDPOINT_AP_MODEM_{RX,TX} for v4.7
Date: Mon, 10 Mar 2025 18:05:24 +0100
Message-ID: <20250310170453.010376378@linuxfoundation.org>
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

[ Upstream commit 934e69669e32eb653234898424ae007bae2f636e ]

Enable the checksum option for these two endpoints in order to allow
mobile data to actually work. Without this, no packets seem to make it
through the IPA.

Fixes: b310de784bac ("net: ipa: add IPA v4.7 support")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Alex Elder <elder@riscstar.com>
Link: https://patch.msgid.link/20250227-ipa-v4-7-fixes-v1-3-a88dd8249d8a@fairphone.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/data/ipa_data-v4.7.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ipa/data/ipa_data-v4.7.c b/drivers/net/ipa/data/ipa_data-v4.7.c
index e63dcf8d45567..41f212209993f 100644
--- a/drivers/net/ipa/data/ipa_data-v4.7.c
+++ b/drivers/net/ipa/data/ipa_data-v4.7.c
@@ -104,6 +104,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 			.filter_support	= true,
 			.config = {
 				.resource_group	= IPA_RSRC_GROUP_SRC_UL_DL,
+				.checksum       = true,
 				.qmap		= true,
 				.status_enable	= true,
 				.tx = {
@@ -127,6 +128,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		.endpoint = {
 			.config = {
 				.resource_group	= IPA_RSRC_GROUP_DST_UL_DL,
+				.checksum       = true,
 				.qmap		= true,
 				.aggregation	= true,
 				.rx = {
-- 
2.39.5



