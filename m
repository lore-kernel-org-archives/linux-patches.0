Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C39E31717C;
	Mon, 13 Apr 2026 16:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099264; cv=none; b=UL+C6aMVuEWQRZtQEoDeBTki/U9HUOfsqaGWV7Om0BNEZfypoej5myTPWIvBjQWzIYjydBXF9lJRzVHbrYDmLqK0XGNCwdMRfH2+rRk2TxnrA9Fw31hz24Mf4aaRv/ze6mp+GsmFh/TP57R+o1iTbvSDA8+rcNvVJlqxjNLIc3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099264; c=relaxed/simple;
	bh=Mwhn/X44jHCGjDpE2hFbs8DovvZZd3L3L0E9eHKFMrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U76a1b4ouJRVZpCZw0rP2JwAjLe15m8fKhDvak3dz4FolOglZJYozanVBhwvVlOIHPoxEYDN3cESivjtvrMtYNVKYnBlYkQecGBnX1bMDX1dnWcC+4U+5E360EUlSM5XKeDfssLZIAY5pomXAxNwOKE1DBTvuiI1pJFWnDS2v78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hnhDjcOA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hnhDjcOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691ACC2BCAF;
	Mon, 13 Apr 2026 16:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099263;
	bh=Mwhn/X44jHCGjDpE2hFbs8DovvZZd3L3L0E9eHKFMrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnhDjcOAxjZt6SlSjsKODXkku4IukVuwsqr/BBdCWpRLaBlO99W2Unp7rNlPtSw65
	 75CAo/PwJmOc0e+xmdmu2eSpCLQ8NzM9A/pFLpTUKduahn4onQ+VT4W+eTU1NPhwdP
	 v/8kheabCG3AEzcTSSKskw7uBSv9ox8zXyloXKWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 273/491] netlink: hide validation union fields from kdoc
Date: Mon, 13 Apr 2026 17:58:38 +0200
Message-ID: <20260413155829.269147659@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 7354c9024f2835f6122ed9612e21ab379df050f9 ]

Mark the validation fields as private, users shouldn't set
them directly and they are too complicated to explain in
a more succinct way (there's already a long explanation
in the comment above).

The strict_start_type field is set directly and has a dedicated
comment so move that above the "private" section.

Link: https://lore.kernel.org/r/20221027212107.2639255-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8f15b5071b45 ("netfilter: ctnetlink: use netlink policy range checks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netlink.h | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 45370f84d6442..9d5d6aa690c56 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -317,19 +317,10 @@ struct nla_policy {
 	u8		validation_type;
 	u16		len;
 	union {
-		const u32 bitfield32_valid;
-		const u32 mask;
-		const char *reject_message;
-		const struct nla_policy *nested_policy;
-		struct netlink_range_validation *range;
-		struct netlink_range_validation_signed *range_signed;
-		struct {
-			s16 min, max;
-			u8 network_byte_order:1;
-		};
-		int (*validate)(const struct nlattr *attr,
-				struct netlink_ext_ack *extack);
-		/* This entry is special, and used for the attribute at index 0
+		/**
+		 * @strict_start_type: first attribute to validate strictly
+		 *
+		 * This entry is special, and used for the attribute at index 0
 		 * only, and specifies special data about the policy, namely it
 		 * specifies the "boundary type" where strict length validation
 		 * starts for any attribute types >= this value, also, strict
@@ -348,6 +339,20 @@ struct nla_policy {
 		 * was added to enforce strict validation from thereon.
 		 */
 		u16 strict_start_type;
+
+		/* private: use NLA_POLICY_*() to set */
+		const u32 bitfield32_valid;
+		const u32 mask;
+		const char *reject_message;
+		const struct nla_policy *nested_policy;
+		struct netlink_range_validation *range;
+		struct netlink_range_validation_signed *range_signed;
+		struct {
+			s16 min, max;
+			u8 network_byte_order:1;
+		};
+		int (*validate)(const struct nlattr *attr,
+				struct netlink_ext_ack *extack);
 	};
 };
 
-- 
2.51.0



