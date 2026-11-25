Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619579;
	b=k4PXGeaml9eNoURUNFdhD8W2uhNxFZANwy7FPv7IHumdpiBMtuvZz2iXRtbbA3FeIsrA
	 JJD24+oYM7OuJD4VIeTvndlPwIMVOOP5Zw3msOS1G3GQ63o78DFVr/JUE5tmx6RyrRiGn
	 sQPU8lpwTfjp4fkh2zJOVJiPjPOoUuOeVvz+G5RNOIYsYRD13W88rARGKGtI3FdVZ8hLi
	 a8R3peovzvQFh2RVx9cwexlfmtPkmZa4R07/Y5pBH1tkktS5hR9bHwl6ViZFQW8lel72/
	 ud1A0VCSpp4outUOpIJDvA1S6qOyJUzCxQUvwv8RP0W2jzm4ybgV+PnF35KNwvENeBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xxgg46EVrL9sWyd7CUcWemT+6MaGne+dASaCQDbs8UA=;
	b=fr9UfwLMsqOR9iY6FVVgCSmZlDtEi9+h8oElxO5KV3E+L7/yQIXoraNzzzMRLRbes3ks
	 TL85+EkhFvo7Y5FZ/FbTT+8xu6ypuYYj7SbqyvE7sXOMU13WkVZsatLSBhUKLeNQaRpB1
	 GFLoavD/g3IwD5fz7usZcNYXtb3mtbBtdbKKxAnylgjv/VV0yL/Sfy42bY7TyRvXyI9X6
	 2uH83h3tQvYV1byM08szbxjO6UqJRkakHDkalSV4SIZThCWy3qzk6Dm6f4GKF1Pjp1VwE
	 xXXOpWhAOs41Q+IP/9TlRRB6myzLiRtsFE5kjQDGMRIDpzc9CMVmOv3PThraa2Rw1vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYgCoyva;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA632606A323;
	Wed, 25 Nov 2026 15:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYgCoyva
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472D71F000C6;
	Wed, 25 Nov 2026 15:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619578;
	bh=Xxgg46EVrL9sWyd7CUcWemT+6MaGne+dASaCQDbs8UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YYgCoyvaxmWuhErdGKO9tbWJmXjFcmUJztNqKYjgiAFv5A0xe2nqVf9ExMwy1Sq8o
	 Bf6i2xXK7TuLoUgBPEQc/PJGVFf3scxPDQdxSHNFIKgzxOTSdtXVmfgH6xXNjya0IU
	 LclcNG3d+HwfOMwEBEPoZ3aizS0grDLqVIWdiwGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduardo Mucelli Rezende Oliveira <edumucelli@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.3 0640/1005] tools/bootconfig: Close only opened braces in compact output
Date: Wed, 25 Nov 2026 15:32:58 +0100
Message-ID: <20261125143836.744904701@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Eduardo Mucelli Rezende Oliveira <edumucelli@gmail.com>

commit 26fa92f351d4993428268afebf6c60c987477af5 upstream.

A key may have both a value and subkeys. When it has only one subkey,
xbc_show_compact_tree() can print that subkey using dotted notation
without opening a brace. During backtracking, however, it treats the
value node followed by a subkey as evidence that a brace was opened.

For example, a.b=v, a.b.c=w and a.z=q are printed with the brace for a
closed before z. Reading that output back changes a.z into the root key
z, silently changing the configuration.

Check the key children when deciding whether to close a brace. Skip the
value child, and account for a sole subkey that itself has both a value
and subkeys, since that combination is not compacted. This follows the
conditions used to open braces without keeping a depth-indexed array.
Extend the mixed-value/subkey sample to cover the lost sibling.

Link: https://lore.kernel.org/all/6ad67e4cda05238cd173c99e820a85de2c13f5fc.1794337724.git.edumucelli@gmail.com/

Fixes: e5efaeb8a8f5 ("bootconfig: Support mixing a value and subkeys under a key")
Cc: stable@vger.kernel.org
Signed-off-by: Eduardo Mucelli Rezende Oliveira <edumucelli@gmail.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/bootconfig/main.c                           |   29 ++++++++++++++++------
 tools/bootconfig/samples/exp-good-mixed-kv1.bconf |    5 +++
 tools/bootconfig/samples/good-mixed-kv1.bconf     |    5 +++
 3 files changed, 32 insertions(+), 7 deletions(-)

--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -39,6 +39,23 @@ static int xbc_show_value(struct xbc_nod
 	return i;
 }
 
+/* Match the conditions under which the compact formatter opens braces. */
+static bool xbc_node_needs_braces(struct xbc_node *node)
+{
+	struct xbc_node *child = xbc_node_get_child(node);
+
+	if (child && xbc_node_is_value(child))
+		child = xbc_node_get_next(child);
+	if (!child)
+		return false;
+	if (child->next)
+		return true;
+
+	/* A single subkey with both a value and subkeys is not compacted. */
+	child = xbc_node_get_child(child);
+	return child && xbc_node_is_value(child) && child->next;
+}
+
 static void xbc_show_compact_tree(void)
 {
 	struct xbc_node *node, *cnode = NULL, *vnode;
@@ -99,14 +116,12 @@ static void xbc_show_compact_tree(void)
 			node = xbc_node_get_parent(node);
 			if (!node)
 				return;
-			if (!xbc_node_get_child(node)->next)
+			if (!depth || !xbc_node_needs_braces(node))
 				continue;
-			if (depth) {
-				depth--;
-				for (i = 0; i < depth; i++)
-					printf("\t");
-				printf("}\n");
-			}
+			depth--;
+			for (i = 0; i < depth; i++)
+				printf("\t");
+			printf("}\n");
 		}
 		node = xbc_node_get_next(node);
 	}
--- a/tools/bootconfig/samples/exp-good-mixed-kv1.bconf
+++ b/tools/bootconfig/samples/exp-good-mixed-kv1.bconf
@@ -1,2 +1,7 @@
 key = "value";
 key.subkey = "another-value";
+a {
+	b = "v";
+	b.c = "w";
+	z = "q";
+}
--- a/tools/bootconfig/samples/good-mixed-kv1.bconf
+++ b/tools/bootconfig/samples/good-mixed-kv1.bconf
@@ -1,3 +1,8 @@
 # value -> subkey pattern
 key = value
 key.subkey = another-value
+
+# A valued parent with one subkey must not close its enclosing brace.
+a.b = v
+a.b.c = w
+a.z = q


