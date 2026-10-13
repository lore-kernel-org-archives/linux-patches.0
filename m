Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABDC24A06D;
	Tue, 13 Oct 2026 12:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895639; cv=none; b=DRQde3Ptkz9mp9+D0+IU37ZLMY69vVPEhMitM3i7ThOcapQwe5172BXNQXOh9qc+kv8TSpeMZZP6a3e3dBy8TQpziTV5k0kMG/4vd44AkmyynB5OFOUgQgHa+c1xFs4YxmAtJfltXaklIaO4Vtx0PfuYpTKzKN/Q4sPNFiMpTpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895639; c=relaxed/simple;
	bh=UU6FNDub3xZabOJTUCyFaVAgdwwFbVhjEZ+cYjStKxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7v4pknQg6DXaCLaO2Q1vJGpbs6KGaGhXXRe11tVjvUHv1IGUK9Z4tvtP7TT/b4Zvr1jO+AytmHkERMgtB64ErXNjdlY0NH3JKinQlcs7cWYSyMEUQ3oUavL7aaYQd4lJpKtj3OxTHLxoT4W5qY+L0I1HXbZRaw9W/0Md8AGbko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zs9Gm3v4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zs9Gm3v4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DDA1F000FF;
	Tue, 13 Oct 2026 12:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895637;
	bh=/w7DlRj//nQCxSF6mMoGopWAOrpq7v8HOEZ6foH+S0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zs9Gm3v4HAFz75hyx7rzf2XLCIVou8LpZAbRm9ZT85Mi8Uy8gAMLJFOy1cBokAo2q
	 146aGPPTurRwTsL6FRFKFggb3xZQpF5bCWqD5sXYlNXZF+qMVkm0ixDo1y0gz8DLTE
	 XqqKhWlBa0EOchKp5kliXGS6sUzOM+tCEetW/POQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Anton Danilov <littlesmilingcloud@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 342/497] tools: ynl-gen: support limits using definitions
Date: Tue, 13 Oct 2026 13:38:29 +0200
Message-ID: <20261013112916.021779306@linuxfoundation.org>
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

commit fa796178e5eb0078a9a6c36f60fd6494cfc3f81d upstream.

Support using defines / constants in integer checks.
Carolina will need this for rate API extensions.

Reported-by: Carolina Jubran <cjubran@nvidia.com>
Link: https://lore.kernel.org/1e886aaf-e1eb-4f1a-b7ef-f63b350a3320@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://patch.msgid.link/20250203215510.1288728-2-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Anton: the generator is tools/net/ynl/ynl-gen-c.py in 6.12.y. ]
Assisted-by: LLM
Signed-off-by: Anton Danilov <littlesmilingcloud@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/genetlink-c.yaml      | 5 +++--
 Documentation/netlink/genetlink-legacy.yaml | 5 +++--
 Documentation/netlink/genetlink.yaml        | 5 +++--
 tools/net/ynl/ynl-gen-c.py                  | 5 ++++-
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/Documentation/netlink/genetlink-c.yaml b/Documentation/netlink/genetlink-c.yaml
index 4f803eaac6d8b..12c60a6d88a7f 100644
--- a/Documentation/netlink/genetlink-c.yaml
+++ b/Documentation/netlink/genetlink-c.yaml
@@ -14,9 +14,10 @@ $defs:
     pattern: ^[0-9A-Za-z_-]+( - 1)?$
     minimum: 0
   len-or-limit:
-    # literal int or limit based on fixed-width type e.g. u8-min, u16-max, etc.
+    # literal int, const name, or limit based on fixed-width type
+    # e.g. u8-min, u16-max, etc.
     type: [ string, integer ]
-    pattern: ^[su](8|16|32|64)-(min|max)$
+    pattern: ^[0-9A-Za-z_-]+$
     minimum: 0
 
 # Schema for specs
diff --git a/Documentation/netlink/genetlink-legacy.yaml b/Documentation/netlink/genetlink-legacy.yaml
index 8db0e22fa72c7..d2ee1199bdf26 100644
--- a/Documentation/netlink/genetlink-legacy.yaml
+++ b/Documentation/netlink/genetlink-legacy.yaml
@@ -14,9 +14,10 @@ $defs:
     pattern: ^[0-9A-Za-z_-]+( - 1)?$
     minimum: 0
   len-or-limit:
-    # literal int or limit based on fixed-width type e.g. u8-min, u16-max, etc.
+    # literal int, const name, or limit based on fixed-width type
+    # e.g. u8-min, u16-max, etc.
     type: [ string, integer ]
-    pattern: ^[su](8|16|32|64)-(min|max)$
+    pattern: ^[0-9A-Za-z_-]+$
     minimum: 0
 
 # Schema for specs
diff --git a/Documentation/netlink/genetlink.yaml b/Documentation/netlink/genetlink.yaml
index b036227b46f1b..e43e50dba2e48 100644
--- a/Documentation/netlink/genetlink.yaml
+++ b/Documentation/netlink/genetlink.yaml
@@ -14,9 +14,10 @@ $defs:
     pattern: ^[0-9A-Za-z_-]+( - 1)?$
     minimum: 0
   len-or-limit:
-    # literal int or limit based on fixed-width type e.g. u8-min, u16-max, etc.
+    # literal int, const name, or limit based on fixed-width type
+    # e.g. u8-min, u16-max, etc.
     type: [ string, integer ]
-    pattern: ^[su](8|16|32|64)-(min|max)$
+    pattern: ^[0-9A-Za-z_-]+$
     minimum: 0
 
 # Schema for specs
diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 00c05791a6694..7e6b38ada78f4 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -83,7 +83,7 @@ class Type(SpecAttr):
         if isinstance(value, int):
             return value
         if value in self.family.consts:
-            raise Exception("Resolving family constants not implemented, yet")
+            return self.family.consts[value]["value"]
         return limit_to_number(value)
 
     def get_limit_str(self, limit, default=None, suffix=''):
@@ -93,6 +93,9 @@ class Type(SpecAttr):
         if isinstance(value, int):
             return str(value) + suffix
         if value in self.family.consts:
+            const = self.family.consts[value]
+            if const.get('header'):
+                return c_upper(value)
             return c_upper(f"{self.family['name']}-{value}")
         return c_upper(value)
 
-- 
2.53.0



