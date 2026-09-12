Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6B341A92A;
	Sat, 12 Sep 2026 16:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228954; cv=none; b=EiQC2yRLPq6S3H03BJdYcq+xYN2kTJdK7ymmbWP4MSPrF3Nm5bvglPOyYtM/MpodTohg5jkPrp0q/I9b/c4+iRw+Wl9bUNj6unOfA7V7B1O0xy4GgcTrIaLNqpralhZrZEeQutBL8qzq74odDSmTyivwQkERRuOs81HWXeWIrHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228954; c=relaxed/simple;
	bh=WbknV5QVOFC2Zv9z5cU1Gk9c1ur8jIXy0X5Fis7ySzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmv1LMJIHiLJ+5sV4/MtHVpn/3Uqn67AKq4hdsjUotUV0toKr0wLmWePaULzmPIr8J351JfMvhORrR7JuV/TQ+wXvQExtIjCtzE70sdFfKRN3QFVBy+ZjRcMOiGx9cUkvx7iBxMBHHASolnngQcGzLMiWvYM2AL3yDALIIBZcLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wn+zYuRT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wn+zYuRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E431F000FF;
	Sat, 12 Sep 2026 16:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228953;
	bh=5MGHtjv/QkhdsTDIXNoGIdEoTaLEMaRUU63LRqXtYTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wn+zYuRTj7H6SraJ0EW2usyVICJnvY92nY43BdAg9wiACaf8HrjpuGU1D41rw/NYU
	 vbm+nFf2p1dlIVUIzqHFzQeSTVpjC+PbR24qS++WPBhlgmCLm4hBGlBGx1UyMc0whS
	 auXAEg+CjqwNtR4PQ3o4ndi3PD5OMirX3C8Uf3Rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0491/1191] media: keymaps: Remove obsolete RC_MAP_RC5_TV keymap define
Date: Sat, 12 Sep 2026 08:53:39 +0200
Message-ID: <20260912065559.257586623@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 793b54342dffe..1eb9a93330036 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -306,7 +306,6 @@ struct rc_map *rc_map_get(const char *name);
 #define RC_MAP_PROTEUS_2309              "rc-proteus-2309"
 #define RC_MAP_PURPLETV                  "rc-purpletv"
 #define RC_MAP_PV951                     "rc-pv951"
-#define RC_MAP_RC5_TV                    "rc-rc5-tv"
 #define RC_MAP_RC6_MCE                   "rc-rc6-mce"
 #define RC_MAP_REAL_AUDIO_220_32_KEYS    "rc-real-audio-220-32-keys"
 #define RC_MAP_REDDO                     "rc-reddo"
-- 
2.53.0



