Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C970925BEE8;
	Thu, 27 Nov 2025 14:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255026; cv=none; b=pxujvMo15MJCzdS91b1q58C6S/GCHc2pzDHOpevaDSb+IR8SbjnwBX0shriNz34/RKV7nLOvc9bvh+hV2aywA2UerhPhlqjV8B7IVt3O3McIvj2wTolf8cjdcy7YYl9x2VcImwj60dFOjhyQPWfbNqXO/eoukGg2UuRsQiSlHXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255026; c=relaxed/simple;
	bh=Wke53vn3U5yfYhFHMXOYRPEozYi4Er+yuBvUNaJ0yDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kSetD8YcSKeMZifqY9kpxsJVZ7qGtfyLZmih/kYusUOOhmq+Zjg9Yxo6Ms8hb3P4UOvU/sPE+RTRnbS72D3ViaNHe6shBBdIK7oirqFG1HSNV2Ev7cATKebObXsDEvaQeIcdRjl5s8lkc4mKjpD98VfDjwvOYZqBpJ1+mdQh1QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iS4pqBxh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iS4pqBxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9B8C4CEF8;
	Thu, 27 Nov 2025 14:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255026;
	bh=Wke53vn3U5yfYhFHMXOYRPEozYi4Er+yuBvUNaJ0yDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iS4pqBxhNI3whiGpnC2o18+bBTUPLjdB8DZZQ6EtnBsKjmwsWP53CyQJCXzB+ZoWM
	 eg8AFJ1LbUNxEoNSqR79Px/DSpjAcROeOwfPHxZjfhujZsT5gjSNqScJrcjz5j639f
	 SHpZwaQhB3BJMrP3OKSJajWMFA7xSVTmpakObtYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 69/86] ALSA: usb-audio: fix uac2 clock source at terminal parser
Date: Thu, 27 Nov 2025 15:46:25 +0100
Message-ID: <20251127144030.353402803@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: René Rebe <rene@exactco.de>

[ Upstream commit d26e9f669cc0a6a85cf17180c09a6686db9f4002 ]

Since 8b3a087f7f65 ("ALSA: usb-audio: Unify virtual type units type to
UAC3 values") usb-audio is using UAC3_CLOCK_SOURCE instead of
bDescriptorSubtype, later refactored with e0ccdef9265 ("ALSA: usb-audio:
Clean up check_input_term()") into parse_term_uac2_clock_source().

This breaks the clock source selection for at least my
1397:0003 BEHRINGER International GmbH FCA610 Pro.

Fix by using UAC2_CLOCK_SOURCE in parse_term_uac2_clock_source().

Fixes: 8b3a087f7f65 ("ALSA: usb-audio: Unify virtual type units type to UAC3 values")
Signed-off-by: René Rebe <rene@exactco.de>
Link: https://patch.msgid.link/20251125.154149.1121389544970412061.rene@exactco.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 787cdeddbdf44..e19d962fab870 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -930,7 +930,7 @@ static int parse_term_uac2_clock_source(struct mixer_build *state,
 {
 	struct uac_clock_source_descriptor *d = p1;
 
-	term->type = UAC3_CLOCK_SOURCE << 16; /* virtual type */
+	term->type = UAC2_CLOCK_SOURCE << 16; /* virtual type */
 	term->id = id;
 	term->name = d->iClockSource;
 	return 0;
-- 
2.51.0



