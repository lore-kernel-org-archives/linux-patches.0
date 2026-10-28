Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208548;
	b=n6MY0lQEI2mEbsTbamfY9ZHy36t4KWaIMSMeEc+dYZJGLEStxRxAOPJX9OEcbrig1pRm
	 b2g01AEHglhtqW1qxijxZTYFtZobvAh4W9oBsEz/dcjJSLkphMi14X5ZW/gnun5vdvnGI
	 oyJRjpQvdwgIlFuj2gGz91Sr9AGbh3UmW0AcIroV+cuwZaz0rFj1TLONJ+c94B2jN8j8R
	 TP2iB7Rl8/Sf4t6NOk6FstFwvM/tz8z7PyWb4dP5VPOdy9iZ2GUyRCFPtTUJ+gjzoQMyu
	 97n0QKHzlNEKbAV/ThVCMpFdZZ7UDKbI9YQtIpv0JzyUvxHo/sOKdTkhoxwSH8Bk6sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5W+eTYVRLFRY3g/q2DpZ/r1fIU5rzp1mIkOnCnoBZL0=;
	b=lLGuQLZIQDpB22a5W5Z8envjm5e98a88TLze+Opw3/rc12wOwKYcjQfzFCIOCrRRuNPe
	 mzbssLPOjEXWET7mNRontlmUET1mlQArXdCAxGHzEIHKWhgsVmpGdxSU8KEuzg86uQ18X
	 dXZjV0J/pSZVns7Io3zt6vJtXCmvX013ZMWQ/eQzQnQ5OG47mahmU8c35jxEFaJLE1ZKi
	 WjSlaLZO9z2Jkx8byNU82gaVLg8aigUuWXU4tPXFjWW+dBf6BWa0VtN0ahwXtTt/rGttm
	 Kr2cnrl/4JzqhHRmbVPm7U3oEgQDnUche2oJRL5L15MvyKHaBgaqcyVPTLI3WfFC0Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CKB9O6FN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57253606A31F;
	Wed, 28 Oct 2026 17:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CKB9O6FN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C0C1F01825;
	Wed, 28 Oct 2026 17:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208547;
	bh=5W+eTYVRLFRY3g/q2DpZ/r1fIU5rzp1mIkOnCnoBZL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CKB9O6FNir8gNRYvlZdoZwED8BwCRm9Y0n88mYyJdsMeGiu5sjHr+6Xdt05ueBzJW
	 anSBZbbbOS2kJDx166s5nIJy1+DTRPndlHk+EugjPrNYNiZqBHWQ03+8N29dIEgcQ9
	 kp+BUVC9CAb7LwA5+XLJ+r/F4OGBPqqa4jDZqFSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 159/516] of/overlay: dont create "//" paths for fragments targeting the root
Date: Wed, 28 Oct 2026 17:55:11 +0100
Message-ID: <20261028170007.272483852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 67063a516070f..6eb6d0de9cca7 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -243,6 +243,9 @@ static struct property *dup_and_fixup_symbol_prop(
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



