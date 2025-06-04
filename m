Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059B6155333;
	Wed,  4 Jun 2025 01:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998827; cv=none; b=Zf7E0jRUJIp5VAolvccbcOhBIlxiVTxCM7/Nj8530K4kVVzzUBnVzzFIVDGf13y/9CH3ePbrqywCb/M57Nk/L5ZOcLJQsnpULYrYSPUpLi/+3a1yDNWfB8g9niS4bZrytm8l2VhGs4MIyjQPLV2w56Q9u7JPiCqdrXsvvvsKKeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998827; c=relaxed/simple;
	bh=ZhfJNSUfVWX/YyUEgTXuyctIRpN1qjS1PmgApLjFutU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mk2ZASTy9aq3G1blOSeyfAcCAcU3/EHn1rcdDJs/2OnVgkHZHbtlpJdrKi/1YJPw6NawAZdxXK85fK5vrM+Ubn5srlG+YCxB3GeckgwQaAGJCCTd3aYC8KY2V5Bt7Tw17Wnvbl4DiiA/YbSnL1rscVibRuF07QUXWHv6GZj/+WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dwUgG5W3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dwUgG5W3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CAEC4CEF2;
	Wed,  4 Jun 2025 01:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998826;
	bh=ZhfJNSUfVWX/YyUEgTXuyctIRpN1qjS1PmgApLjFutU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dwUgG5W3ATLqQjdb0iOOGlsaPv1meMoHcdSX1t5APa81GmIaB+IeZrTI2y5iOyHPm
	 ROVddLpmy7EuhnlRbxY8nNaY3ILMUVf2XPAWPb01uDUD3pees1eMzp45ujDTUO+78t
	 1S6p5gUcCtzVWmek0j7XzfTSsQ5grQbyeFKblZySU8mGUfiOlbACmVIlOjW+SL1dak
	 HEtz7Ta3pdi4/mGcqGyGnn7TrWveXwupaXxUGxRHVMKMmYWSiv/x4VsVSZce5zyod1
	 QntgOMWG3pxF/fIcQ8KnFKC9a3z8p7D3VQTZkZcit4Ov3tqWrA4LgAlXPEVi0u2qKJ
	 OrASfSP3yJHRg==
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
Subject: [PATCH AUTOSEL 6.12 36/93] openvswitch: Stricter validation for the userspace action
Date: Tue,  3 Jun 2025 20:58:22 -0400
Message-Id: <20250604005919.4191884-36-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005919.4191884-1-sashal@kernel.org>
References: <20250604005919.4191884-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
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
index 305daf57a4f9d..865d5e5a0784f 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -3049,7 +3049,8 @@ static int validate_userspace(const struct nlattr *attr)
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

