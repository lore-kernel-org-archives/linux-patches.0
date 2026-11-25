Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619440;
	b=iW8ddIN6VplrE67AaTF5a/qvpSrP7IVN1wZppRlqJGJRmvGxynvkHqWG0auwfs3kVvtC
	 wrkH7vbhgjXEKfjqL7+GrdoSkKKYksgBw0Di4z/i0IVKBLimgc72mFAuZvOqERNhdszRT
	 CV5SF8qKoVQyZ5GpWRPXG5b/lB7EuFDd1JkIdylL66RKh2QKi3hqYug6pE4xkzAyD2An5
	 bDZQrVTgOWjONPuotvOl5CTk/6ZdJnu6Dq1NCWcHDU8JPoLZbWLbI9TgXMsT2VEUPLOiR
	 L8+45+jdCDFrHUiLtKEnlJJEs458bvDez9tRrH7iBQdmXP++/oy5y2vHkF5gPCtGx2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619440;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DD1nZb1yPIXn1PTXcPnrY+5k4fdANDJiYCc+JPOVqLs=;
	b=zmDWlv2E+wboffaXbWf2pNv/glqJOa+fCI14sjTzS8H+X47YQYjRby6JafwMEeXyYV0r
	 DSXVLTxDUsK55V7XNoni+MiZGIYr8IAFftt55VNekeQ1IonuHNu7z0A/bFCFnM/nQ/A1I
	 utoLt+G8jZDqRZtfnrIDd7wpxc2H4FIf7Knyam/UwM0ovepy4eWbJDCo1o1Wqcp801HYp
	 zeQgWBdnfQkH9KIbDZLGtFHQY8VJ8IOLZm3kWi2hjpbHpI85NA9aHpFjlGwovMJPz79DU
	 6r1Ycxu05s2G4eK2PxpzU96LUI7Oz/WbxwXh7Cgkluq/kfCpwFI1u80SY1apKCevEhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SBGao9e0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B78606A682;
	Wed, 25 Nov 2026 15:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SBGao9e0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D841F000CA;
	Wed, 25 Nov 2026 15:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619439;
	bh=DD1nZb1yPIXn1PTXcPnrY+5k4fdANDJiYCc+JPOVqLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SBGao9e0RIjq+cA0Syjh+LzbGFFdEOC3XB9jVm9DIL+PwfF0ls1iqm84+52DPvviq
	 HJAlf9Bgvu4jDLS21k8O2rUVCmUUulQ0pMeOyQ01DmmaPY2wvQmdFjND8n3ymZh8fH
	 wXWABfMEDzjkn8Y1fuineSyj/CLDeTOHBXpynsdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 7.3 0595/1005] mm/mmzone: read the zoneref slot once in zonelist_zone()
Date: Wed, 25 Nov 2026 15:32:13 +0100
Message-ID: <20261125143835.681328604@linuxfoundation.org>
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

From: Gregory Price (Meta) <gourry@gourry.net>

commit 9c52ebe9c89d41c56fcb5d94efe9e539414175a9 upstream.

Memory hotplug rebuilds zonelists in place while allocations walk them,
so a zoneref slot can change between two loads of it.

zonelist_zone() loads the slot with a plain access.  The compiler may
load it again later instead of keeping the zone it already read, so a
caller can check one zone and then use another, or the NULL terminator.

Use READ_ONCE().  Callers that take a zone from a slot and keep using
it, such as get_page_from_freelist() with ac->preferred_zoneref, need
that single load.

Fixes: 11cd8638c37f ("mm, page_alloc: remove stop_machine from build_all_zonelists")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Link: https://patch.msgid.link/20261101021340.2251928-6-gourry@gourry.net
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mmzone.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1815,7 +1815,8 @@ extern struct zone *next_zone(struct zon
 
 static inline struct zone *zonelist_zone(struct zoneref *zoneref)
 {
-	return zoneref->zone;
+	/* Memory hotplug rewrites zonelists in place. */
+	return READ_ONCE(zoneref->zone);
 }
 
 static inline int zonelist_zone_idx(const struct zoneref *zoneref)


