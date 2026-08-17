Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99AC15E5BB;
	Mon, 17 Aug 2026 14:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976413; cv=none; b=DjTA2uBxzsmTKzd06v02SnmYJVlyx16+Q4bbnZYqVxIYphNoKbR5DfizjsGmIzFRHQNcPP642vtt20NSP5JPfNffc2kIxERr/8w7A4syg1rtfGz6TEFkn5UJXag+aKnTsaxr5UBLg2EU03kMnLZOQc4+GqahRzqGNC65aYoImLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976413; c=relaxed/simple;
	bh=Y99TOmT89GS91HH+16Hd4zyMuKc7NzIO+hYCFDqaxSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5JzhxBD/At4oIXj+Tka/zoCbkd0oNm7q7Hxht/1Q7OhpMeWciE003ovWHaycw4gYPVOspcUYUbj1hcgLg1gvLbctIf3b08waii5zAo4Efu175pyDnDCZECj+ICJul7iQOxF6WMfxp295uBHs90SfvSsyVyWE8sZZEr25tdkRYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IOZUe7KX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IOZUe7KX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3081F00A3A;
	Mon, 17 Aug 2026 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976411;
	bh=Y2Uvd0q4demxgEmM+Gr0cT5Li7JqlZQP6VpXvIWB8U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IOZUe7KXTPBK5sYXcyXE91/LMrqWqFunnn/2EjTYX8zPDkmiVfB3uJV5Z0CZ7KkYF
	 uYpeScsP4aKBBB7raxZpZbCszt4jRpQS1OMiHrO/ykfCMX9uXGRFgYZn7jkA/tpGTL
	 6CJ4ziZ+uvq7sUIqt9XTtTPeKgPyOPO11OymBAI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Pravin B Shelar <pshelar@ovn.org>,
	dev@openvswitch.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 325/389] net: openvswitch: fix kernel-doc warnings in flow.c
Date: Mon, 17 Aug 2026 15:32:44 +0200
Message-ID: <20260817132551.594658523@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit d6e712aa7e6a3d5a9633f4bcbe2237f3edc292bd ]

Repair kernel-doc notation in a few places to make it conform to
the expected format.

Fixes the following kernel-doc warnings:

flow.c:296: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Parse vlan tag from vlan header.
flow.c:296: warning: missing initial short description on line:
 * Parse vlan tag from vlan header.
flow.c:537: warning: No description found for return value of 'key_extract_l3l4'
flow.c:769: warning: No description found for return value of 'key_extract'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: dev@openvswitch.org
Link: https://lore.kernel.org/r/20210808190834.23362-1-rdunlap@infradead.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: cf6f8b29befb ("net/openvswitch: check Ethernet header length in key_extract()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/flow.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index beacb1b46706e..862d376930d79 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -293,14 +293,14 @@ static bool icmp6hdr_ok(struct sk_buff *skb)
 }
 
 /**
- * Parse vlan tag from vlan header.
+ * parse_vlan_tag - Parse vlan tag from vlan header.
  * @skb: skb containing frame to parse
  * @key_vh: pointer to parsed vlan tag
  * @untag_vlan: should the vlan header be removed from the frame
  *
- * Returns ERROR on memory error.
- * Returns 0 if it encounters a non-vlan or incomplete packet.
- * Returns 1 after successfully parsing vlan tag.
+ * Return: ERROR on memory error.
+ * %0 if it encounters a non-vlan or incomplete packet.
+ * %1 after successfully parsing vlan tag.
  */
 static int parse_vlan_tag(struct sk_buff *skb, struct vlan_head *key_vh,
 			  bool untag_vlan)
@@ -533,6 +533,7 @@ static int parse_nsh(struct sk_buff *skb, struct sw_flow_key *key)
  *       L3 header
  * @key: output flow key
  *
+ * Return: %0 if successful, otherwise a negative errno value.
  */
 static int key_extract_l3l4(struct sk_buff *skb, struct sw_flow_key *key)
 {
@@ -749,8 +750,6 @@ static int key_extract_l3l4(struct sk_buff *skb, struct sw_flow_key *key)
  *
  * The caller must ensure that skb->len >= ETH_HLEN.
  *
- * Returns 0 if successful, otherwise a negative errno value.
- *
  * Initializes @skb header fields as follows:
  *
  *    - skb->mac_header: the L2 header.
@@ -765,6 +764,8 @@ static int key_extract_l3l4(struct sk_buff *skb, struct sw_flow_key *key)
  *
  *    - skb->protocol: the type of the data starting at skb->network_header.
  *      Equals to key->eth.type.
+ *
+ * Return: %0 if successful, otherwise a negative errno value.
  */
 static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
 {
-- 
2.53.0



