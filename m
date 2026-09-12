Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435F4384CE2;
	Sat, 12 Sep 2026 09:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206341; cv=none; b=CrGosMcwzSyPAWoe3pkViHMTuyMdZDfPvh3MCLUIaGWvhEH8lFAjmJGbftg4mZVT2jbcCIvItdN5BK7p9vtPnlWczDD/H1GSYRlZtF9HFBemIwRAlVRl/Ne7MAOLNfmOZQVxk1ZaLOGh6XKzeGIk3s2fYAjMWpwtp60kOYBpE0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206341; c=relaxed/simple;
	bh=3i9YEbtBae1MeRG5xMil2xAT8N/k+nfpeoikGFz3Yf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDcVNvxjfK4umiLBw6lBBakbf9ByzmsddjRFVctfDrYHV/lo4SVWPVtkCl9Zx/VgSkN62cKvrFNT9vUA6OqpCkfPIxeyo6hzHjrxrZvffdtQcGTMpLT8AUNUFKRg1easI/W4Y0UmX0DXMtHpeiUw756JlPuxW2lsbqyR3y6ex2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NgJW1s6V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NgJW1s6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161761F000FF;
	Sat, 12 Sep 2026 09:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206340;
	bh=CxfDGxmLg3RyOtGwdivq0kNUM5/6yzCL2Dp1HKS2bN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NgJW1s6VptMuniYOEcaC/kmalsWw0PCpPD0wFra2iZU6l10Z0sTQHcAEFpPKrl0Id
	 MJPUHe7bFvLo8+J5PyklUOGEuKxPWEvGYN2AQ//r3jDc/7OJ5Jq07xALwtnJGAVUVW
	 +vzfoOsfbI3jfUIMxphojp7gUsCRmBQUV78gC9ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0145/1518] media: keymaps: Remove obsolete RC_MAP_RC5_TV keymap define
Date: Sat, 12 Sep 2026 08:38:34 +0200
Message-ID: <20260912065626.774997395@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 5370facb7b4461166a4610d456fefeb92ef50a82 ]

Since commit 206241069ecf ("[media] rc/keymaps: Remove the obsolete
rc-rc5-tv keymap"), the rc-rc5-tv keymap is no longer in the tree.

Fixes: 206241069ecf ("[media] rc/keymaps: Remove the obsolete rc-rc5-tv keymap")
Signed-off-by: Sean Young <sean@mess.org>
Acked-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/media/rc-map.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index d90e4611b0664..950d702aee3bb 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -309,7 +309,6 @@ struct rc_map *rc_map_get(const char *name);
 #define RC_MAP_PROTEUS_2309              "rc-proteus-2309"
 #define RC_MAP_PURPLETV                  "rc-purpletv"
 #define RC_MAP_PV951                     "rc-pv951"
-#define RC_MAP_RC5_TV                    "rc-rc5-tv"
 #define RC_MAP_RC6_MCE                   "rc-rc6-mce"
 #define RC_MAP_REAL_AUDIO_220_32_KEYS    "rc-real-audio-220-32-keys"
 #define RC_MAP_REDDO                     "rc-reddo"
-- 
2.53.0



