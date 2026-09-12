Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF1F37204A;
	Sat, 12 Sep 2026 07:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197201; cv=none; b=VfHvuQE9S48Or3XxYY/ldwSTbgXZ7XnW+6ismiyW3JxcqVP0Xuc394GCT17nUOJYyN7y2V8JZWE4zYBSdjX+knCOKNREz1sSWSC3zrcw3O6Q+MmMK7Scf4lMRixe/LhAe4h1q4i/Z+JLDLCM1X8Sqrw0mq6fN9Fm6aDcM0nQt4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197201; c=relaxed/simple;
	bh=IOhgCjyy6JUC1lMWbin+wsoLrFAf5wzXDrFDPpbTD94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=esyGvdj5KB7KIW23UCDjBRkd1msQV+Vag7riQGpCz8MEoIow7u1QlrfKuuLPZiTS9m3vot55/RXcjkgh+oOHivra1s5vfFNhaDAVkG7So3bjkvnczZWq8vdW9ZbWaMjfmmF0l5JupXo5THh19a4L7RUnSSGPYwZ56iehExzjeG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Ib5s0RC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Ib5s0RC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81EB31F000FF;
	Sat, 12 Sep 2026 07:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197200;
	bh=HiqnC/+nkHLfqL/NUFy0P6dBduXGvAOwjM9i7hbxUg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Ib5s0RCejY90LJpq0nCjtbGQ3Q7hGgdCgOU6WZktpEXMERsyVCsKByVCk4sBc5GT
	 9X9JXfLpvyYX02MKTnr26EizQhhVmwamNfr+wnLsktO4wQYpU3+wuT01fSrgiqUHJz
	 fM2PlUjmytN1pYmdm6dIUxrqm5rSMqUI/53ItJaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0122/1815] media: keymaps: Remove obsolete RC_MAP_RC5_TV keymap define
Date: Sat, 12 Sep 2026 08:31:12 +0200
Message-ID: <20260912065651.879476786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



