Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB9E199FAB;
	Tue, 13 Oct 2026 12:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895636; cv=none; b=Eq6CimDf2TCPTYuxof6RbVslsoETSCsn9A9x+iGSgHlxMPLfYMfNlVl/+r2eqc0TOzX4wBamjbarG9SDkrLdzTNiAkcgitzim+FF3Qqk+rGevOvfVN1gowKO0WUqpXP5g66mGGWSs0BD4uIft5E6wz9A2bI4W2/kE7N4rLl9lyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895636; c=relaxed/simple;
	bh=LeA1Y3qOnVT7XHmDm+Ia3fQSIb/+SQHjK/jZ5YzJr1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXAvDmi869xfUC7Xp9Z3/oUevl7dRaV2mvs3zP46bUhcXSRvlVuNHPtC4dFtD3g6GqsxmoH9j81jaVUdsASNMqcaKvCf2MFlwlJcI6XTgXfgvQk1K8a5b6W3UbXsqECOcYt22toSaRXPB4JsFt4UrjmR4TMflnmDwoOZotrsN0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/ThUx9Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/ThUx9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901E81F000FF;
	Tue, 13 Oct 2026 12:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895635;
	bh=RBAJ96N8hgcyYtHpFkWofbApkGyVEAVpXkNLIFEfxdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R/ThUx9YR8laSds0n/IMmL8p0lP8szz8b2O0mggwS25lFizIT17NIJXSPZKUHjQlR
	 z/YdbqiG39L7yN1Mt6fZMGzHA+bES2h7YHgEpSR+/q/sNf1DWlseBanObTfGz1BOCJ
	 /oHbZ1GnEqZW1nTD/x7b49pQBr3Q41S1dgkx/E8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Joe Damato <jdamato@fastly.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Anton Danilov <littlesmilingcloud@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 341/497] tools: ynl-gen: use names of constants in generated limits
Date: Tue, 13 Oct 2026 13:38:28 +0200
Message-ID: <20261013112915.997494158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

commit bcbbfaa2612d7d0e9c3eafade5f6e93c3672f34f upstream.

YNL specs can use string expressions for limits, like s32-min
or u16-max. We convert all of those into their numeric values
when generating the code, which isn't always helpful. Try to
retain the string representations in the output. Any sort of
calculations still need the integers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Joe Damato <jdamato@fastly.com>
Link: https://patch.msgid.link/20241010151248.2049755-1-kuba@kernel.org
[pabeni@redhat.com: regenerated netdev-genl-gen.c]
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Anton: 6.12.y has the older TypeBinary._attr_policy(), switch its
  get_limit() calls to get_limit_str() there. Drop the
  netdev_a_napi_defer_hard_irqs_range hunk from netdev-genl-gen.c,
  that range does not exist in 6.12.y. The file now matches what
  ynl-gen-c.py generates. ]
Assisted-by: LLM
Signed-off-by: Anton Danilov <littlesmilingcloud@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netdev-genl-gen.c |  4 ++--
 tools/net/ynl/ynl-gen-c.py | 36 +++++++++++++++++++++++-------------
 2 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/net/core/netdev-genl-gen.c b/net/core/netdev-genl-gen.c
index 8614988fc67b9..b54f5948555f2 100644
--- a/net/core/netdev-genl-gen.c
+++ b/net/core/netdev-genl-gen.c
@@ -14,12 +14,12 @@
 /* Integer value ranges */
 static const struct netlink_range_validation netdev_a_page_pool_id_range = {
 	.min	= 1ULL,
-	.max	= 4294967295ULL,
+	.max	= U32_MAX,
 };
 
 static const struct netlink_range_validation netdev_a_page_pool_ifindex_range = {
 	.min	= 1ULL,
-	.max	= 2147483647ULL,
+	.max	= S32_MAX,
 };
 
 /* Common nested types */
diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index c78f1c1bca75c..00c05791a6694 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -80,11 +80,21 @@ class Type(SpecAttr):
         value = self.checks.get(limit, default)
         if value is None:
             return value
-        elif value in self.family.consts:
+        if isinstance(value, int):
+            return value
+        if value in self.family.consts:
+            raise Exception("Resolving family constants not implemented, yet")
+        return limit_to_number(value)
+
+    def get_limit_str(self, limit, default=None, suffix=''):
+        value = self.checks.get(limit, default)
+        if value is None:
+            return ''
+        if isinstance(value, int):
+            return str(value) + suffix
+        if value in self.family.consts:
             return c_upper(f"{self.family['name']}-{value}")
-        if not isinstance(value, int):
-            value = limit_to_number(value)
-        return value
+        return c_upper(value)
 
     def resolve(self):
         if 'name-prefix' in self.attr:
@@ -358,11 +368,11 @@ class TypeScalar(Type):
         elif 'full-range' in self.checks:
             return f"NLA_POLICY_FULL_RANGE({policy}, &{c_lower(self.enum_name)}_range)"
         elif 'range' in self.checks:
-            return f"NLA_POLICY_RANGE({policy}, {self.get_limit('min')}, {self.get_limit('max')})"
+            return f"NLA_POLICY_RANGE({policy}, {self.get_limit_str('min')}, {self.get_limit_str('max')})"
         elif 'min' in self.checks:
-            return f"NLA_POLICY_MIN({policy}, {self.get_limit('min')})"
+            return f"NLA_POLICY_MIN({policy}, {self.get_limit_str('min')})"
         elif 'max' in self.checks:
-            return f"NLA_POLICY_MAX({policy}, {self.get_limit('max')})"
+            return f"NLA_POLICY_MAX({policy}, {self.get_limit_str('max')})"
         return super()._attr_policy(policy)
 
     def _attr_typol(self):
@@ -413,11 +423,11 @@ class TypeString(Type):
 
     def _attr_policy(self, policy):
         if 'exact-len' in self.checks:
-            mem = 'NLA_POLICY_EXACT_LEN(' + str(self.get_limit('exact-len')) + ')'
+            mem = 'NLA_POLICY_EXACT_LEN(' + self.get_limit_str('exact-len') + ')'
         else:
             mem = '{ .type = ' + policy
             if 'max-len' in self.checks:
-                mem += ', .len = ' + str(self.get_limit('max-len'))
+                mem += ', .len = ' + self.get_limit_str('max-len')
             mem += ', }'
         return mem
 
@@ -465,11 +475,11 @@ class TypeBinary(Type):
 
     def _attr_policy(self, policy):
         if 'exact-len' in self.checks:
-            mem = 'NLA_POLICY_EXACT_LEN(' + str(self.get_limit('exact-len')) + ')'
+            mem = 'NLA_POLICY_EXACT_LEN(' + self.get_limit_str('exact-len') + ')'
         else:
             mem = '{ '
             if len(self.checks) == 1 and 'min-len' in self.checks:
-                mem += '.len = ' + str(self.get_limit('min-len'))
+                mem += '.len = ' + self.get_limit_str('min-len')
             elif len(self.checks) == 0:
                 mem += '.type = NLA_BINARY'
             else:
@@ -2161,9 +2171,9 @@ def print_kernel_policy_ranges(family, cw):
             cw.block_start(line=f'static const struct netlink_range_validation{sign} {c_lower(attr.enum_name)}_range =')
             members = []
             if 'min' in attr.checks:
-                members.append(('min', str(attr.get_limit('min')) + suffix))
+                members.append(('min', attr.get_limit_str('min', suffix=suffix)))
             if 'max' in attr.checks:
-                members.append(('max', str(attr.get_limit('max')) + suffix))
+                members.append(('max', attr.get_limit_str('max', suffix=suffix)))
             cw.write_struct_init(members)
             cw.block_end(line=';')
             cw.nl()
-- 
2.53.0



