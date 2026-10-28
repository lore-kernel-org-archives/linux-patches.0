Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212618;
	b=U37FNRDoXUGZt3auNuEWTtYyglupE2ByrK2LTUJ8UgJUMznzjI/dks023hlJ0DZuxM/a
	 OCB9iDbeJ2QvrYdFl+5P5bswY6G51KRW5NadP2Rn1kAAFr4gop1dprKWahTxc5AStqc8i
	 iMHoBEWd+KOsU91F1SJ7DJY7ZiMRS0KxZ8rvOuUmQ1lnUdqubez3VO19+ywD+PnXRESo0
	 f1zMGSsEeacKYlSZOiYP6YBgGQMTbCKRhoKhanf1UAX8K+iDOtQJgA7zobEpraSBfDU20
	 pwqol4TQU3WRpYapfSo/JQ0C83I24BHNesnW/HUE7IWADsn0fp7w/7XzKAKNHXb3MDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kwryuhbd1ANA4XK3q7lYeES2UGu6Oa9p3dIB5hfTVyA=;
	b=4iii6sy/7QzWfr+YLWOKcTCiY4PCrKfktTi1IXBxcQ/jq+Q9JSUThIlFC0A1wEgGU8YW
	 Xoyf85F1zzca77hLJ7oMETGT+YozTKkYapUmNzgU4KCtRw2esnsC91UQt+6xz0YK7I1U5
	 0OlUNQHNoiidaM5fcn119+e8iv6kSGXN0JZxMwOmXTAqOYnV4HgzBShpWsPIQ35jOBFfs
	 fJKym87XQ8tTaZlCwEwRm/KSkI1RGNZ628PWVLPd+2yrKdKWZFAC+ZvFOq8Gc2g9gEtiw
	 slqWD6GT3E7LYI6dG0Gpy6ozR3Sv4mtI3gVsuaOfjqUS6rMvNtWoUisqoBdiKY8RC1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B3CmhdbF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127B4606A31A;
	Wed, 28 Oct 2026 18:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B3CmhdbF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5AD1F01825;
	Wed, 28 Oct 2026 18:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212617;
	bh=Kwryuhbd1ANA4XK3q7lYeES2UGu6Oa9p3dIB5hfTVyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B3CmhdbFu8JQ7tXsdszDSlj8vrpa96Zp+u9HA9V8MAHQzq30A24YV2t9wQ7VzMuPY
	 9BHikbVT6lH/IHjNIUQQK1IYhrpxVx4BtRtgv72gPUiXdcoAYIEMiqu74DmJdgob1l
	 Ia1/mLtb+qi9Jq1+Gck0VYRDXl/5Y8EL90ODfC4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0218/1887] of/overlay: dont create "//" paths for fragments targeting the root
Date: Wed, 28 Oct 2026 17:38:34 +0100
Message-ID: <20261028170504.193165360@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

[ Upstream commit 21c89ff1fc86ffa517f3a9ca1ba5c48e9e37c1ba ]

dup_and_fixup_symbol_prop() rewrites a symbol value by replacing its
"/fragment/__overlay__" prefix with the fragment's target path. When
the fragment targets the root node the target path is "/" and the
result starts with "//", which __of_find_node_by_full_path() cannot
resolve: symbols pointing into such fragments silently stop
resolving.

Drop the target path when it is the root and the tail is non-empty. A
value naming the fragment root itself (empty tail) keeps the "/".

Fixes: d1651b03c2df ("of: overlay: add overlay symbols to live device tree")
Assisted-by: Claude:claude-fable-5 [Claude Code]
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Link: https://patch.msgid.link/20260831-nh-of-alias-overlay-v7-7-02754604805a@nexthop.ai
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/overlay.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
index ebd712dcf34fc..7d8205b7e5631 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -241,6 +241,9 @@ static struct property *dup_and_fixup_symbol_prop(
 	if (!target_path)
 		return NULL;
 	target_path_len = strlen(target_path);
+	/* a root target renders as "/"; drop it to avoid "//" results */
+	if (target_path_len == 1 && target_path[0] == '/' && path_tail_len)
+		target_path_len = 0;
 
 	new_prop = kzalloc(sizeof(*new_prop), GFP_KERNEL);
 	if (!new_prop)
-- 
2.53.0



