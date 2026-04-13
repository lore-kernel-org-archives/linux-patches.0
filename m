Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E8E27BF6C;
	Mon, 13 Apr 2026 16:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097961; cv=none; b=bevvJD6i00yNN1NONnH/SJgrmf4N3RGLiF9Wo+1MmtGi8QqQPYLJQP6AmgafbvseorQrf7Z1spqJoEtbSlCoAuPe6mUSY6Wk4iN4IRx8JTBKnDbOKmZMCRpbBOZ7QNhheOVt36mGhS5aHfG9Id880zqX2avQAA7qvvCMiiWOinQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097961; c=relaxed/simple;
	bh=wkngRYyQtuIo2Dtt4dpU3n01bXi6SPSE7Y18dNJ5t28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQdIZrUI/q0aIFJ+9NXtvV5r5nhGBUE5BMk029wVaSNot6sPeBNQxy89TekcWaUHbJhIgil/chRzwHF+Iw7J6JvieSbwKaFdMbkdPYMATuu8Ehxa1QpRyGydDl0CHjoYjxsDBg5P1grteUiOVgtFUT5YNYyEu/ZUsfkCNvPAve8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSVs9o7P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSVs9o7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79674C2BCAF;
	Mon, 13 Apr 2026 16:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097960;
	bh=wkngRYyQtuIo2Dtt4dpU3n01bXi6SPSE7Y18dNJ5t28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSVs9o7PvFAMBHccd8klVb3cFt4eFyMjsJW0DVwtwmNjO0jVA3rKjeZffDJxe7fdh
	 Sz2dTGqiXWtPwutovzGXjWfA8PKIlM5a4KUxAuL/xuETEYqUTwlFudLXTdcEjE03ju
	 6E1h/Ag9hVwgFWOQo5U4Dmr6I77Z98qWPmiSidHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 340/570] netlink: hide validation union fields from kdoc
Date: Mon, 13 Apr 2026 17:57:51 +0200
Message-ID: <20260413155843.228800284@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6eb4593983319..8c67db47556e2 100644
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



