Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBB227F728;
	Tue, 27 May 2025 17:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367148; cv=none; b=kFPO680j7rtZgBsz/yn+KFj+0G990ClXeCKQMAeepqSIsT+9pVO2pioElf62P1ZZ+dKpsZ9S1lyVnDrgSAuUjudY+bskgGiZb7LfUHPijoQ+jd+/pIwZoP473txa6WjP9LxAS4ZDWbHk/Bypc3dRViDI9PTHo9LJ9r6hmREkwXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367148; c=relaxed/simple;
	bh=RVe29vfINF/Ysugi2SuCqxLfXV9sIDIIUyBCzDe+d7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f37KOrdnE1qpRI3ZpE8egLCFlZK9reuQT6jvJbaGw53bAhqKBwIWMIos3Fg1dwLsSr0ommQds8RJydU2IS+uwMHefWse9nQet9Be9JD+N/ZkrDE0f2xSUFvMRKLYs0CHgQkj9TCshSpD7hCvl5eQ5nE7/53xJNGTSZ4vxWgnOUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFwYHyre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFwYHyre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67ABEC4CEE9;
	Tue, 27 May 2025 17:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367147;
	bh=RVe29vfINF/Ysugi2SuCqxLfXV9sIDIIUyBCzDe+d7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cFwYHyre4LkZi42YMOsiJxiWIjy0yaTLe3/EAU75jSjEfGhr7Pk44JgijYAV9jEBP
	 LtJGLjxbSCVpHvbxW95u0xfWEbkX3g43saI1wmJZnXqNzeiCmNH5yV4LO9mhAZJqii
	 ZDbduEBr1rpNlgdUwn/A4jirewKScD6j2AhH/5zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Trager <lee@trager.us>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 294/783] eth: fbnic: Prepend TSENE FW fields with FBNIC_FW
Date: Tue, 27 May 2025 18:21:31 +0200
Message-ID: <20250527162525.055390485@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Trager <lee@trager.us>

[ Upstream commit 56bcc6ecff8fdc06258c637226986ed522027ca5 ]

All other firmware fields are prepended with FBNIC_FW. Update TSENE fields
to follow the same format.

Signed-off-by: Lee Trager <lee@trager.us>
Link: https://patch.msgid.link/20250228191935.3953712-2-lee@trager.us
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c | 16 ++++++++--------
 drivers/net/ethernet/meta/fbnic/fbnic_fw.h |  8 ++++----
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
index 9351a874689f8..cdd6c3a210944 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -747,9 +747,9 @@ int fbnic_fw_xmit_tsene_read_msg(struct fbnic_dev *fbd,
 }
 
 static const struct fbnic_tlv_index fbnic_tsene_read_resp_index[] = {
-	FBNIC_TLV_ATTR_S32(FBNIC_TSENE_THERM),
-	FBNIC_TLV_ATTR_S32(FBNIC_TSENE_VOLT),
-	FBNIC_TLV_ATTR_S32(FBNIC_TSENE_ERROR),
+	FBNIC_TLV_ATTR_S32(FBNIC_FW_TSENE_THERM),
+	FBNIC_TLV_ATTR_S32(FBNIC_FW_TSENE_VOLT),
+	FBNIC_TLV_ATTR_S32(FBNIC_FW_TSENE_ERROR),
 	FBNIC_TLV_ATTR_LAST
 };
 
@@ -766,21 +766,21 @@ static int fbnic_fw_parse_tsene_read_resp(void *opaque,
 	if (!cmpl_data)
 		return -EINVAL;
 
-	if (results[FBNIC_TSENE_ERROR]) {
-		err = fbnic_tlv_attr_get_unsigned(results[FBNIC_TSENE_ERROR]);
+	if (results[FBNIC_FW_TSENE_ERROR]) {
+		err = fbnic_tlv_attr_get_unsigned(results[FBNIC_FW_TSENE_ERROR]);
 		if (err)
 			goto exit_complete;
 	}
 
-	if (!results[FBNIC_TSENE_THERM] || !results[FBNIC_TSENE_VOLT]) {
+	if (!results[FBNIC_FW_TSENE_THERM] || !results[FBNIC_FW_TSENE_VOLT]) {
 		err = -EINVAL;
 		goto exit_complete;
 	}
 
 	cmpl_data->u.tsene.millidegrees =
-		fbnic_tlv_attr_get_signed(results[FBNIC_TSENE_THERM]);
+		fbnic_tlv_attr_get_signed(results[FBNIC_FW_TSENE_THERM]);
 	cmpl_data->u.tsene.millivolts =
-		fbnic_tlv_attr_get_signed(results[FBNIC_TSENE_VOLT]);
+		fbnic_tlv_attr_get_signed(results[FBNIC_FW_TSENE_VOLT]);
 
 exit_complete:
 	cmpl_data->result = err;
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw.h b/drivers/net/ethernet/meta/fbnic/fbnic_fw.h
index fe68333d51b18..a3618e7826c25 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.h
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.h
@@ -139,10 +139,10 @@ enum {
 };
 
 enum {
-	FBNIC_TSENE_THERM			= 0x0,
-	FBNIC_TSENE_VOLT			= 0x1,
-	FBNIC_TSENE_ERROR			= 0x2,
-	FBNIC_TSENE_MSG_MAX
+	FBNIC_FW_TSENE_THERM			= 0x0,
+	FBNIC_FW_TSENE_VOLT			= 0x1,
+	FBNIC_FW_TSENE_ERROR			= 0x2,
+	FBNIC_FW_TSENE_MSG_MAX
 };
 
 enum {
-- 
2.39.5



