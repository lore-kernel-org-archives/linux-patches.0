Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46762321B8;
	Mon, 11 Dec 2023 18:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fhSocoge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF67FC433C7;
	Mon, 11 Dec 2023 18:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320921;
	bh=73t4Ujm8r75Lb4qpCPzmZXB5JE1yLMTdv4s2QZvobsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fhSocogeBDNVPdVegrfQaZJIWNyzU4axb0u5aWlrmdJ2TVKrTuvP6DpqX6P9gpFg9
	 3dY5CaoeOM+7rTkSE7dxtYIYJRf0Jwtdz/n6t787MPODI/73C7rXAzAq73zwX8wxHe
	 6dNKhf05FQ+6lulECeIfGSutagwLLAxTfimzXhHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/141] net: add missing kdoc for struct genl_multicast_group::flags
Date: Mon, 11 Dec 2023 19:21:44 +0100
Message-ID: <20231211182028.464276936@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 5c221f0af68cfa9edcffd26ba6dbbc4b7ddb1700 ]

Multicast group flags were added in commit 4d54cc32112d ("mptcp: avoid
lock_fast usage in accept path"), but it missed adding the kdoc.

Mention which flags go into that field, and do the same for
op structs.

Link: https://lore.kernel.org/r/20220809232012.403730-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e03781879a0d ("drop_monitor: Require 'CAP_SYS_ADMIN' when joining "events" group")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/genetlink.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index 7cb3fa8310edd..56a50e1c51b97 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -11,6 +11,7 @@
 /**
  * struct genl_multicast_group - generic netlink multicast group
  * @name: name of the multicast group, names are per-family
+ * @flags: GENL_* flags (%GENL_ADMIN_PERM or %GENL_UNS_ADMIN_PERM)
  */
 struct genl_multicast_group {
 	char			name[GENL_NAMSIZ];
@@ -116,7 +117,7 @@ enum genl_validate_flags {
  * struct genl_small_ops - generic netlink operations (small version)
  * @cmd: command identifier
  * @internal_flags: flags used by the family
- * @flags: flags
+ * @flags: GENL_* flags (%GENL_ADMIN_PERM or %GENL_UNS_ADMIN_PERM)
  * @validate: validation flags from enum genl_validate_flags
  * @doit: standard command callback
  * @dumpit: callback for dumpers
@@ -137,7 +138,7 @@ struct genl_small_ops {
  * struct genl_ops - generic netlink operations
  * @cmd: command identifier
  * @internal_flags: flags used by the family
- * @flags: flags
+ * @flags: GENL_* flags (%GENL_ADMIN_PERM or %GENL_UNS_ADMIN_PERM)
  * @maxattr: maximum number of attributes supported
  * @policy: netlink policy (takes precedence over family policy)
  * @validate: validation flags from enum genl_validate_flags
-- 
2.42.0



