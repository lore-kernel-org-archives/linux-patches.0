Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DE53A6414;
	Wed, 21 Jan 2026 18:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020169; cv=none; b=TU45fFBW9Mx8A/RJdKFrgf7VVwJuOtUBLzambLMN0sorsXgOIzXzoFr7NTUls7DyJ/3thLZzEb+uHKeXm1u1QSIwbDPQNABaOFN2+jXmnBJpNOarIjOoAbPWf0HHF18j07Dg0qZOeSoFtIiSOnsRVSIKXXvjPeUxXq2u4DGERi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020169; c=relaxed/simple;
	bh=N4zwqpZe/1YSMqs1x83Mm7eSYNBQPHO+pniiZKYIuho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a1hvtS4rvDnv4d6aGoljAK/PCri/J/RV2miGFJiWwYqkNu9sCvrLRa4Y/C2/dl8YIcs6UbrGcgst64ILa5idp6qWh2rTT6KkJ1C09uvfhwQ3qHIYux3y/PzuJuzsWKv9KNlnz+2DK1GIYnP+X/JJ+oyfG31a4riZr/gHmlwkfbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nEmQ57OX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nEmQ57OX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96D6C4CEF1;
	Wed, 21 Jan 2026 18:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020169;
	bh=N4zwqpZe/1YSMqs1x83Mm7eSYNBQPHO+pniiZKYIuho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nEmQ57OXWX5w6UZElZmYecXz8wl2IX9NqxWYvZMB+kw0oS/P8YA7PpFXwaOszh4Q6
	 LO6DjwjDPG9R42dNN7FIlF54s4Nt0iBvyrsrqKvq3YQ0mI1I4dfvXFWCCkfUIj8L3X
	 Fcw0br6cXW7xGGcQKEo5psyq9iC1KxPmlywF6S5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tingmao Wang <m@maowtm.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 080/198] landlock: Fix wrong type usage
Date: Wed, 21 Jan 2026 19:15:08 +0100
Message-ID: <20260121181421.439449178@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tingmao Wang <m@maowtm.org>

[ Upstream commit 29fbfa46e4287c596bdc77e2c599e3a1bbf8bb67 ]

I think, based on my best understanding, that this type is likely a typo
(even though in the end both are u16)

Signed-off-by: Tingmao Wang <m@maowtm.org>
Fixes: 2fc80c69df82 ("landlock: Log file-related denials")
Reviewed-by: Günther Noack <gnoack@google.com>
Link: https://lore.kernel.org/r/7339ad7b47f998affd84ca629a334a71f913616d.1765040503.git.m@maowtm.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/landlock/audit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/landlock/audit.c b/security/landlock/audit.c
index c52d079cdb77b..e899995f1fd59 100644
--- a/security/landlock/audit.c
+++ b/security/landlock/audit.c
@@ -191,7 +191,7 @@ static size_t get_denied_layer(const struct landlock_ruleset *const domain,
 	long youngest_layer = -1;
 
 	for_each_set_bit(access_bit, &access_req, layer_masks_size) {
-		const access_mask_t mask = (*layer_masks)[access_bit];
+		const layer_mask_t mask = (*layer_masks)[access_bit];
 		long layer;
 
 		if (!mask)
-- 
2.51.0



