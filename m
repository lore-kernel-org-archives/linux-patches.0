Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F09155A25;
	Tue,  9 Jul 2024 11:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524260; cv=none; b=Z6u5AFEhGcgZP72dGNGpRg7vI9lwYl43X6TWDiBDF35XN9z1N9snLVxquH8Z/AmasPFMityWKd1/uud+voln3nj1tUIlSmDr5pm70gctyAyY7eVWWkXXrGLhHxnIyzzdfUru12kXKJcAnDdEhVRdqldtmfyzQrKgIodzwynXcdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524260; c=relaxed/simple;
	bh=zJpVP8E5L3jCLhdy6tYzdskHgP8Ls4RugBVvPkC/XUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1BINS2Uf/G1NZCH3F4ea74D8jLvEtWL1Lynph4uc1Fx2GBkoCkCZ4v2bCuPUIIEh/ZeYrdoxlKdpdLJTO65QHAxAXkXwkqKLHXwq8Y147wlZQ8Ad34HX8NYEX05kZTl4DJfMDxDFAhNV+Lfygg/xD/J0DrbWHmcz8IQqGlFqgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CAkZ09P9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CAkZ09P9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C590C3277B;
	Tue,  9 Jul 2024 11:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524260;
	bh=zJpVP8E5L3jCLhdy6tYzdskHgP8Ls4RugBVvPkC/XUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CAkZ09P90GrdFhpZXloRKWPj9RfZFJSn8LJhdo9AMhIpr3XPm4jz3nPDrFeqsmamV
	 seTO5D5hog+Jyg3n8ZPhgHH3YzgMzXcB04zEEzPuYP/QkeK9a23oddI+3JIO9Y0geh
	 KadJIxE+Uek8GzvIRsYLXwWCLVoE4BJiuDl5/fEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijian Zhang <zijianzhang@bytedance.com>,
	Xiaochun Lu <xiaochun.lu@bytedance.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 124/197] selftests: make order checking verbose in msg_zerocopy selftest
Date: Tue,  9 Jul 2024 13:09:38 +0200
Message-ID: <20240709110713.751709747@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijian Zhang <zijianzhang@bytedance.com>

[ Upstream commit 7d6d8f0c8b700c9493f2839abccb6d29028b4219 ]

We find that when lock debugging is on, notifications may not come in
order. Thus, we have order checking outputs managed by cfg_verbose, to
avoid too many outputs in this case.

Fixes: 07b65c5b31ce ("test: add msg_zerocopy test")
Signed-off-by: Zijian Zhang <zijianzhang@bytedance.com>
Signed-off-by: Xiaochun Lu <xiaochun.lu@bytedance.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20240701225349.3395580-3-zijianzhang@bytedance.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/msg_zerocopy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/msg_zerocopy.c b/tools/testing/selftests/net/msg_zerocopy.c
index 926556febc83c..7ea5fb28c93db 100644
--- a/tools/testing/selftests/net/msg_zerocopy.c
+++ b/tools/testing/selftests/net/msg_zerocopy.c
@@ -438,7 +438,7 @@ static bool do_recv_completion(int fd, int domain)
 	/* Detect notification gaps. These should not happen often, if at all.
 	 * Gaps can occur due to drops, reordering and retransmissions.
 	 */
-	if (lo != next_completion)
+	if (cfg_verbose && lo != next_completion)
 		fprintf(stderr, "gap: %u..%u does not append to %u\n",
 			lo, hi, next_completion);
 	next_completion = hi + 1;
-- 
2.43.0



