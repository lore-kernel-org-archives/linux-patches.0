Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D2A158219;
	Tue,  9 Jul 2024 11:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523801; cv=none; b=em0jpd69BE/bzf9IldUtU0Ztkz9XPOZW+T4Bxy1VUImPlTiucROJzuGusDaDLfwZjfmbne4ze8/sGY5CFMg//M+S201MLWC1EdngGNeYmqP23zsYFe0iD6HjqwZ4GlDyWsg9NRDBtsjyYRj+q+wwMl0ewQPKBFlLQ3MzPXn6v6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523801; c=relaxed/simple;
	bh=aBc9XbJL1xdNHQxFmpPNDzhzguDPGEdLaUdQDNkLUU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YO+q+dNFoOK6juvd9S0TftuzQNRUsPMOKE3U7mtCv+NO9vwy+kKq/+syFZ229H1AgpzNunhemJqpc93+uEPtQCpczegiXsK9rrpqJVctPOde0BmewL7LuqpDx9BGhCmIVlHCEyM2zgMKEFkyECW3SgvzyLDl0c3N5I4Qe8E0E0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PP6PpZwI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PP6PpZwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E10AC3277B;
	Tue,  9 Jul 2024 11:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523801;
	bh=aBc9XbJL1xdNHQxFmpPNDzhzguDPGEdLaUdQDNkLUU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PP6PpZwIFVaEkmewrqLs0ZNOkJSLg+KC8ryncjQ7r2FANRpmpouErPfQBMTwY3TEW
	 PY706PRFRrmHuVgpUMSrhXENnt6mkRFXoWiWav/h3LVDE2n/GFPoyarnn6YLc4sgst
	 TQ08X3ohzEaYzQsXFR5btrw1bkTCRKn4mK0XPxys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijian Zhang <zijianzhang@bytedance.com>,
	Xiaochun Lu <xiaochun.lu@bytedance.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/139] selftests: make order checking verbose in msg_zerocopy selftest
Date: Tue,  9 Jul 2024 13:09:43 +0200
Message-ID: <20240709110701.383616689@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



