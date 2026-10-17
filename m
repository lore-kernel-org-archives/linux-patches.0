Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906B438424C;
	Sat, 17 Oct 2026 17:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258336; cv=none; b=GC0xtWGAHiEHdw0JSBL9Zgd8bchFlA8X79qkF26Ab3jPHbLRbPwtQEollTfxJSIQ1kM2VUT/ndfJsztc90OgYnQw9k7C9MHLfr9PKjzsbteuFIv9j6TdDWV8bmjyMojmOJCLOAWHzKf3WYkfRoBbt8g1GTK4TTQbLXUdviZu2uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258336; c=relaxed/simple;
	bh=xMFaCESWP9iRORJfxO1lAWkgpbAB0FGPPALmg8ruKxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGi5mPMO8YSgrkKIA+RguiLAn4EjmmvA9riT3KLGPT7FRwFg/HrHVwXtfO2MQs+UAj+0OHwbix+El/P9UD41KlOK0KKspKcwwA6WfOZVRbLUY/BGzUb+rEGKXCoFCRCUrdkfrx1jqnz7+l0uys5T75Z2WhGj+e2rU0dtsbpZz1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJRx3g9b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJRx3g9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A3B1F000C4;
	Sat, 17 Oct 2026 17:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258335;
	bh=ww6FUyng8jOW2BZiTZMGrExR1cAJNFP41d3uEaAvHe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hJRx3g9b8WLGcgqc1tNB9DAEHONJS5mLX8/DY0cZMnI3FQFD7jEki01uqikl/aKu2
	 fc4ZKYOP2dU3mT5HyuCJEDndrgW4f+tSRtTt6gqWH5MDr4rLFwULVIPDPGDTFD4S/G
	 NQ5o1s08CsfVGDrCZBpus64XGEeN8WHLztgwVyKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0851/1674] bpf: Mark bpf_refcount field as unique
Date: Sat, 17 Oct 2026 17:52:03 +0200
Message-ID: <20261017160452.969328194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 61e655391cb19c31f94ecd4354f624c81ce4cf75 ]

BPF_REFCOUNT is not marked as a unique field, while it should be. Fix
this oversight.

Fixes: d54730b50bae ("bpf: Introduce opaque bpf_refcount struct and add btf_record plumbing")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://patch.msgid.link/20260719153634.2908692-4-memxor@gmail.com
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 60018b87589de..0bf8f1fc648e8 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3424,7 +3424,15 @@ static int btf_get_field_type(const char *name, u32 field_mask, u32 *seen_mask,
 	field_mask_test_name(BPF_LIST_NODE, "bpf_list_node");
 	field_mask_test_name(BPF_RB_ROOT,   "bpf_rb_root");
 	field_mask_test_name(BPF_RB_NODE,   "bpf_rb_node");
-	field_mask_test_name(BPF_REFCOUNT,  "bpf_refcount");
+	if (field_mask & BPF_REFCOUNT) {
+		if (!strcmp(name, "bpf_refcount")) {
+			if (*seen_mask & BPF_REFCOUNT)
+				return -E2BIG;
+			*seen_mask |= BPF_REFCOUNT;
+			type = BPF_REFCOUNT;
+			goto end;
+		}
+	}
 
 	/* Only return BPF_KPTR when all other types with matchable names fail */
 	if (field_mask & BPF_KPTR) {
-- 
2.53.0



