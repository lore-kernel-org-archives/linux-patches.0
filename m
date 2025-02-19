Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173AC1E503C;
	Wed, 19 Feb 2025 08:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954706; cv=none; b=dwStS++I5kFh0DmCNfoi8YpHlOMsEMnuQwxDAlW7zLYOq3fFVBV1PUSQXIyfH9F34jjfxjAYVru6C2RFOR+W872xxVQrKFggfYtdXRLV0st+LFOpL9NCmVn/4H4YvnkxWO9V7pRCF56TV41jAUMLKZ/lTcLPOCf6X+0N0qBzy4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954706; c=relaxed/simple;
	bh=BxJ88TRvBrSXUEaaBLQYkOi/1TeRjMQQKmFdZ58dzNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkS6u8x7Vfam4hLteD2KR3SczuckjthvDeLr3qapyJIm1rDOc6jKC2tXSRKG4jZOm2Cyuau5b6BsF09s5Bf3iLsfdOh8KVfURQ0ZyhlFczhe2bQyqJ7jBTl+0PSVkdva8HIiBlUQjCL0Hn4PVtC3MfMzgjyKVJimDvYIKUWAV3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fx3UrbH9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fx3UrbH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A395C4CEE6;
	Wed, 19 Feb 2025 08:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954706;
	bh=BxJ88TRvBrSXUEaaBLQYkOi/1TeRjMQQKmFdZ58dzNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fx3UrbH90Gtn5hCxpy/ruq19zRidK+vDnCkzyveMzSk4u1ae6T7QDomOU9QtHmKI8
	 lI2FOd4UMBI1FRZRR3o7xRa9DKmjG8rzroaMTcGOm/r2BeWGCyjrqhEHFP8+j7c1FN
	 rFCpLYaQFZD+IGQuOx3gO2rIvf+ws1vOGhDlBYR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/230] pinctrl: pinconf-generic: Print unsigned value if a format is registered
Date: Wed, 19 Feb 2025 09:25:29 +0100
Message-ID: <20250219082602.181423939@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 0af4c120f5e7a1ea70aff7da2dfb65b6148a3e84 ]

Commit 3ba11e684d16 ("pinctrl: pinconf-generic: print hex value")
unconditionally switched to printing hex values in
pinconf_generic_dump_one(). However, if a dump format is registered for the
dumped pin, the hex value is printed as well. This hex value does not
necessarily correspond 1:1 with the hardware register value (as noted by
commit 3ba11e684d16 ("pinctrl: pinconf-generic: print hex value")). As a
result, user-facing output may include information like:
output drive strength (0x100 uA).

To address this, check if a dump format is registered for the dumped
property, and print the unsigned value instead when applicable.

Fixes: 3ba11e684d16 ("pinctrl: pinconf-generic: print hex value")
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://lore.kernel.org/20250205101058.2034860-1-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinconf-generic.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 0b13d7f17b325..42547f64453e8 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -89,12 +89,12 @@ static void pinconf_generic_dump_one(struct pinctrl_dev *pctldev,
 		seq_puts(s, items[i].display);
 		/* Print unit if available */
 		if (items[i].has_arg) {
-			seq_printf(s, " (0x%x",
-				   pinconf_to_config_argument(config));
+			u32 val = pinconf_to_config_argument(config);
+
 			if (items[i].format)
-				seq_printf(s, " %s)", items[i].format);
+				seq_printf(s, " (%u %s)", val, items[i].format);
 			else
-				seq_puts(s, ")");
+				seq_printf(s, " (0x%x)", val);
 		}
 	}
 }
-- 
2.39.5



