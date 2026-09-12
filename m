Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C70D472777;
	Sat, 12 Sep 2026 12:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214547; cv=none; b=cdY95/RLIavSBMxdRq2XV9VWMMra4eZeKKIzAlnVh2N4xVWW5Z0GHIyetwFs8cK8ZKUfD6CWP4M/h1TodefmRN9PhNLHokFfzw8GnaBdBn/jKVbORcoBtHewgCyjF+ulPJyweEuUpzsaXU3GV5BPagTPiQJuPUkmSkHKwU+e1ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214547; c=relaxed/simple;
	bh=Adg8t3MlnBKplgiuBOkpFvtuVROjK5GKWWvDw3JH4YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AeKX1jKJJCXSHqQlBt3GOxQIAJVbfVdbsqZNklPuz1Dy8UAXrdkoiYRMGAsP9QKeIzRwfJINBFKSlZHT9QON11RIpF1Gd65WHYnA24oRjRb/0NUzPvGY3camJ6NOiXNhHvdjm8kynhnG73A173TKjwj/9xrmv/LPVdJTNj3S1ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRIVGrVE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRIVGrVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A192A1F000FF;
	Sat, 12 Sep 2026 12:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214545;
	bh=Q19R7lwQ5+aVE8VwsDEyL7G89eAK72qPJ8fkjtHlOZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sRIVGrVEdCUdhPI1E/4Bh4fav0uIcjbtWlH5J323I4C84jCtRd2Np9BhU+h1XVJwh
	 tJMGcqd7pyNI3jbX/8FvZHKOkP0t2KaUjY+4y2mYMbAQAMAqf2qWthRwW6NQiXy9ue
	 W7G6wSY2JMU5q5aPIsUBcGXBSRKXmHHGJFyQe0EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0349/1376] media: keymaps: Remove obsolete RC_MAP_RC5_TV keymap define
Date: Sat, 12 Sep 2026 08:46:15 +0200
Message-ID: <20260912065615.329277067@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4867eb2f931e0..8c74175bf296a 100644
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



