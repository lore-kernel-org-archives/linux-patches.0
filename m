Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016609;
	b=JgmeFXGpdqJdfX6dHILHAO4ihXihNxXr7mJmrfrl/NGbVcsE1inTOx5ZiuwNm5iWeUv/
	 0wje7pfvjcmbAl+2SZ8+5GVXXFre9rhk3hWm+NCIyamlEasf7mmeBsbJVSTokffSMqOii
	 Xcu8xg0caGI5BT/q4ijm/0SQ/QXuKVHGlA/WiH6YK8C7auOppjiRJNDSD6k0Sg38EqkMs
	 iZmDTX+PTRUVWUui72kDodO6ePdmLndxhJfVew/8ogQyvlINezoD/KnXqltHYBLSDmvQn
	 kPbnVWyK8nvQDfzN4DtLnga52pArClbE0ni+VPWe5atZBGvRFxHBBN2aqptem2qZ67g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lMSOrXzB86BcBEafpQuUM/yvYtjDH9xTTVe1u0LbGFs=;
	b=QQb/ZBNF+31XFYUcBLzPqUn/JeIbDdy/EOsAQU0B6cVprtwH4tHuBseac0TPd1tn8glQ
	 BcLySeopOFycfOjkF3FV8ERdlEEQ1Weqb3mMJjwr91Ttw/EoRdf8bejlRrpUw3zfD407L
	 riCuGExLejFT+O3mvG9rDSyuH0/qv3++VSh5k9pEAvt31bLjHLrRDG7s7cSuzQibGDWQ/
	 fQ0nR0iWaPERmvaEPmuW8ZyIlRfx9xkIU7XepHWwMzDaYQNJor7uM7c4j7CfeDEylLyIp
	 iOqwPfwKtsznDAbZfaxdOw0z4ipiXSg7PSAsY9FeDaWa97i3H8blwdkkmIJXkdTGQfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T0qw88p2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66EE9606A31C;
	Wed, 18 Nov 2026 15:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T0qw88p2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81811F000C4;
	Wed, 18 Nov 2026 15:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016609;
	bh=lMSOrXzB86BcBEafpQuUM/yvYtjDH9xTTVe1u0LbGFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T0qw88p2wfUM19UaLFhOylSXN1qR6m2EyUDxMs5rYXmKaObPq7zBv/3hQWL9LFGtV
	 nB4Xj4USgGo6WY862p8iz+iBCNX0duCUdPFM7Mg84stxwthMBPNoB+4z7lD6xG7psa
	 GsIDEFORPuKcvcWdvaI084qE/KAx9FXe/QFke8mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0562/2651] netlink: specs: devlink: describe the netns id in the parent-dev nest
Date: Wed, 18 Nov 2026 15:30:02 +0100
Message-ID: <20261118150307.973996203@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 150079380e4b13c7ed0e738913937e375259172c ]

devlink_nl_rate_parent_fill() emits DEVLINK_ATTR_PARENT_DEV via
devlink_nl_put_nested_handle(), which adds DEVLINK_ATTR_NETNS_ID
whenever the parent rate node lives on a devlink instance in another
netns. Now that we defined dl-nested-devlink subset, which unlike
dl-parent-dev includes netns-id, let's switch to it. The rate APIs
input genuinely does not accept the netns-id, so we need to subset
them to stick with dl-parent-dev.

Fixes: b5f90fd4580ce7 ("devlink: Add parent dev to devlink API")
Link: https://patch.msgid.link/20260915161341.1053476-8-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/devlink.yaml | 41 ++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/Documentation/netlink/specs/devlink.yaml b/Documentation/netlink/specs/devlink.yaml
index c4dfc814873f5..31667f43b8488 100644
--- a/Documentation/netlink/specs/devlink.yaml
+++ b/Documentation/netlink/specs/devlink.yaml
@@ -899,7 +899,7 @@ attribute-sets:
       -
         name: parent-dev
         type: nest
-        nested-attributes: dl-parent-dev
+        nested-attributes: dl-nested-devlink
         doc: |
           Identifies the devlink instance which owns the parent rate node.
           Used with rate-set and rate-new to parent a rate object to a node on
@@ -1331,6 +1331,10 @@ attribute-sets:
   -
     name: dl-parent-dev
     subset-of: devlink
+    doc: |
+      Devlink handle accepted as the parent-dev input; the netns id the
+      kernel reports back is not accepted, the parent is always resolved
+      in the caller's netns.
     attributes:
       -
         name: bus-name
@@ -1339,6 +1343,37 @@ attribute-sets:
       -
         name: index
 
+  -
+    name: dl-rate-set
+    subset-of: devlink
+    doc: Attributes accepted by the rate-set and rate-new requests.
+    attributes:
+      -
+        name: bus-name
+      -
+        name: dev-name
+      -
+        name: index
+      -
+        name: port-index
+      -
+        name: rate-node-name
+      -
+        name: rate-tx-share
+      -
+        name: rate-tx-max
+      -
+        name: rate-tx-priority
+      -
+        name: rate-tx-weight
+      -
+        name: rate-parent-node-name
+      -
+        name: rate-tc-bws
+      -
+        name: parent-dev
+        nested-attributes: dl-parent-dev
+
   -
     name: dl-nested-devlink
     subset-of: devlink
@@ -2320,7 +2355,7 @@ operations:
     -
       name: rate-set
       doc: Set rate instances.
-      attribute-set: devlink
+      attribute-set: dl-rate-set
       dont-validate: [strict]
       flags: [admin-perm]
       do:
@@ -2343,7 +2378,7 @@ operations:
     -
       name: rate-new
       doc: Create rate instances.
-      attribute-set: devlink
+      attribute-set: dl-rate-set
       dont-validate: [strict]
       flags: [admin-perm]
       do:
-- 
2.53.0



