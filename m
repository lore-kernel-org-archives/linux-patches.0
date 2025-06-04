Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A065C2EAE5;
	Wed,  4 Jun 2025 01:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748999148; cv=none; b=bb2K7OyDk5YyUbzQp/6I6bqbWM1B8ydtRzEnu5rXH8Tclw23GvsObpI6ev4wvCfXMvPFW8RHh50nSNYDLIZdW2usDm7hRyWic/0YAOVE5E//hE4m0p7bbTeqSzGyj8ilIgCRBcJCqUVOHaAHs+zOMs+ugQUlM+Jt3hqyWDSl0C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748999148; c=relaxed/simple;
	bh=wO7YHweoodzuolRHshXXQUQTm0GzwsUaV1RKs8/M2GE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JSZVywM6lQYrhqsCS45Gx6DnMX1BTmQ38NerrsiaEvP3vQTs3DVDI2nbl/Og9u0fmP7UGsVi7v6eUolLLpCWLbEa92KggIjzK9Y543FEkt1CGupCx8UI7H1ADjp8fgSGgXYsXOnN0Atu+spbZBec7OMb7+Q3UqOHIF4ewq10x0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BHkqHG3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BHkqHG3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E833C4CEEF;
	Wed,  4 Jun 2025 01:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748999148;
	bh=wO7YHweoodzuolRHshXXQUQTm0GzwsUaV1RKs8/M2GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHkqHG3R/8JczRkE2JQn1+c7qTlTcAzbK7nWzoziIUnJFuUFzReoxj+DzonlIvbqW
	 fvb+FTKRjUbJ6a1a2dF2kvJha3TlPY3Ig3uM01z/a1hfYYXik6GIRn7zMPT+/ys6SL
	 K2zENaDTy5h+EHzBySYaEuuZOZN6uSlh4iulNkUFeYo/THhzrgp+PeXU1FF32z7oLe
	 vH9iiyd2SF6vsphKKteLZJRPckMpYkL/uYP1ivVZrsJn4fhizhI2xlOeQK0yyMG7EW
	 F150+f5dP++rnuJMLE0VnDwwvzPxtvegPeyLl0+Czq2PLNHeVAiTGR7WWE91EX0QI7
	 0y4dyPwMJJxew==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eelco Chaudron <echaudro@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	aconole@redhat.com,
	netdev@vger.kernel.org,
	dev@openvswitch.org
Subject: [PATCH AUTOSEL 5.15 13/33] openvswitch: Stricter validation for the userspace action
Date: Tue,  3 Jun 2025 21:05:04 -0400
Message-Id: <20250604010524.6091-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604010524.6091-1-sashal@kernel.org>
References: <20250604010524.6091-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.184
Content-Transfer-Encoding: 8bit

From: Eelco Chaudron <echaudro@redhat.com>

[ Upstream commit 88906f55954131ed2d3974e044b7fb48129b86ae ]

This change enhances the robustness of validate_userspace() by ensuring
that all Netlink attributes are fully contained within the parent
attribute. The previous use of nla_parse_nested_deprecated() could
silently skip trailing or malformed attributes, as it stops parsing at
the first invalid entry.

By switching to nla_parse_deprecated_strict(), we make sure only fully
validated attributes are copied for later use.

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://patch.msgid.link/67eb414e2d250e8408bb8afeb982deca2ff2b10b.1747037304.git.echaudro@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. ##
Analysis **Commit Overview:** The commit changes `validate_userspace()`
function in `net/openvswitch/flow_netlink.c` by replacing
`nla_parse_nested_deprecated()` with `nla_parse_deprecated_strict()` to
ensure stricter validation of Netlink attributes for the userspace
action. **Specific Code Changes:** The key change is on lines 3052-3054:
```c // Before: error = nla_parse_nested_deprecated(a,
OVS_USERSPACE_ATTR_MAX, attr, userspace_policy, NULL); // After: error =
nla_parse_deprecated_strict(a, OVS_USERSPACE_ATTR_MAX, nla_data(attr),
nla_len(attr), userspace_policy, NULL); ``` **Why This Should Be
Backported:** 1. **Security Enhancement:** This commit addresses a
parsing vulnerability where malformed attributes could be silently
ignored. The original `nla_parse_nested_deprecated()` stops parsing at
the first invalid entry, potentially allowing trailing malformed data to
bypass validation. 2. **Robustness Fix:** The change ensures all netlink
attributes are fully contained within the parent attribute bounds,
preventing potential buffer over-reads or under-reads that could lead to
security issues. 3. **Pattern Consistency:** Looking at the git blame
output (lines 3085-3087), we can see that
`nla_parse_deprecated_strict()` was already introduced in 2019 by commit
8cb081746c031 and is used elsewhere in the same file for similar
validation (e.g., `validate_and_copy_check_pkt_len()` function). 4.
**Low Risk:** This is a small, contained change that only affects input
validation - it doesn't change functionality or introduce new features.
The change is defensive and follows existing patterns in the codebase.
5. **Similar Precedent:** This commit is very similar to the validated
"Similar Commit #2" which was marked for backporting (status: YES). That
commit also dealt with netlink attribute validation safety in
openvswitch (`validate_set()` function) and was considered suitable for
stable trees. 6. **Critical Subsystem:** Open vSwitch is a critical
networking component used in virtualization and container environments.
Input validation issues in this subsystem could potentially be exploited
for privilege escalation or denial of service. 7. **Clear Intent:** The
commit message explicitly states this "enhances robustness" and ensures
"only fully validated attributes are copied for later use," indicating
this is a defensive security improvement. **Risk Assessment:** - Very
low regression risk - No API changes - Only affects error handling paths
- Follows established validation patterns in the same codebase This
commit fits perfectly into the stable tree criteria: it's an important
security/robustness fix, has minimal risk of regression, is well-
contained, and addresses a clear validation vulnerability in a critical
kernel subsystem.

 net/openvswitch/flow_netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 7db0f8938c145..8e7238a4f5339 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -3004,7 +3004,8 @@ static int validate_userspace(const struct nlattr *attr)
 	struct nlattr *a[OVS_USERSPACE_ATTR_MAX + 1];
 	int error;
 
-	error = nla_parse_nested_deprecated(a, OVS_USERSPACE_ATTR_MAX, attr,
+	error = nla_parse_deprecated_strict(a, OVS_USERSPACE_ATTR_MAX,
+					    nla_data(attr), nla_len(attr),
 					    userspace_policy, NULL);
 	if (error)
 		return error;
-- 
2.39.5

