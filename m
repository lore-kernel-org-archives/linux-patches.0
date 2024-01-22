Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60F3664A6;
	Tue, 23 Jan 2024 01:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975104; cv=none; b=H5Jzs7SXMo4/uJCWzJ+Ed1O6nLdQjSlgL9Wf3UdiOrNY/vt8zCp8IqQr/uVO4JG/+xlCEbRbPNJMqClXoaAmDW7GSE+iCXnerSbs2/VDaELR3MGS8xAgxMbAXV4YJSJHOWVyZR3RZCIw6/6MdTsWqauqWiBqBIIY4gjsFEa13ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975104; c=relaxed/simple;
	bh=jISu3IgRwxZAaQ1Myaoiig81fdU0Y643L8e6CpgWezk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pupEha5WK4v/cWEcfrjrphbEgKOeFG5FT92nIjmDhoc2B6XG8L0Twwt1NCtMQUms1mPwfj6ROfdo0IpbY4NG274TZiwA1ef5otkwyyFP/Pb1vfNdJwkomZp56SFjiLp/tifDFPHf/zLOX5JWOOi4VIHLjMGD+aQEwN36F0qd6WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3ZR4yx+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3ZR4yx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3842EC433F1;
	Tue, 23 Jan 2024 01:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975103;
	bh=jISu3IgRwxZAaQ1Myaoiig81fdU0Y643L8e6CpgWezk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3ZR4yx+OpNpjgG/1iskFfeJyU8+ia5tpygi3g9jgoucoDf3wGBG7C44U9KGghDzy
	 G1RCo0VK5zoUt1zX2/YdhuXtaGR2XLyM5QBTK4SSFdqY+EgONQcWjk2LSPhkBkwMEx
	 AJWVbdG5mDrkiVYhZZS7sO12+bGIC2S/btxaZUGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 239/583] drm/bridge: Fix typo in post_disable() description
Date: Mon, 22 Jan 2024 15:54:50 -0800
Message-ID: <20240122235819.303199256@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

[ Upstream commit 288b039db225676e0c520c981a1b5a2562d893a3 ]

s/singals/signals/

Fixes: 199e4e967af4 ("drm: Extract drm_bridge.h")
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231124094253.658064-1-dario.binacchi@amarulasolutions.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/drm_bridge.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/drm/drm_bridge.h b/include/drm/drm_bridge.h
index c339fc85fd07..103ff57fc83c 100644
--- a/include/drm/drm_bridge.h
+++ b/include/drm/drm_bridge.h
@@ -192,7 +192,7 @@ struct drm_bridge_funcs {
 	 * or &drm_encoder_helper_funcs.dpms hook.
 	 *
 	 * The bridge must assume that the display pipe (i.e. clocks and timing
-	 * singals) feeding it is no longer running when this callback is
+	 * signals) feeding it is no longer running when this callback is
 	 * called.
 	 *
 	 * The @post_disable callback is optional.
-- 
2.43.0



