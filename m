Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027121;
	b=xaWQzSWt637sl8LkaeaqHppEc8xBGMAy4K6lTja7k5wIHfAl5FSmewiTeaJ4xJCUfNXP
	 I7hOfAVysG6ci3dXITDkBAno5iKIZ6fx29AORq1jdSuZRS4FZGT6Spo4sMdpWhC7jabvf
	 k6I2ZrxKXjWcm/7oEHuH75yNLqjNz7UaaZpkVsUtO3zAKGmFdAKsY7X4Ks7iGWq3Q8OeG
	 4cunx9EZTZX7yVxBE8P73wABX7e3foK6xV3Qa0fvkskBPuf3K98DHW3cvm7zrrjsEoMd4
	 wP9C9DLb+jAb7Bm2iyc1FePlr6Bkuu9Jgz/9pNb0qLej/I5vWcr9wXbvjDpPM3twdMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Apm19X21fYOJP6HMvvWZ5xJZkUvvHCzhwWqAzbd8Xg0=;
	b=hfK7OFHCwSDnhzhKNX7fpm6PjRWVto+crEAMjydutOhDIDoHNuPI02GW1+tQWt8peDeq
	 xHXB8KMrobrwYuqh71YKzb98MQwqjnAfbc4oiNBRabWBWFLRsCKcUKARkFKCdIsvpcMBw
	 J6MZDkMMBWi3Rda+GgKpddiBpUgkwP1Es4P7q7o4+VCkMke4AQcbzh5PdqHy2oaV6PJCX
	 Wy7UsVdzEofuwW0N0VwLFxqP737W2hvUWqyWiEShzJ1LWeOcc4dASSNQj2QN8ga7Loevt
	 mK3ci8htvoA8K/xVpGleDffQOxSa4fsqmms54XPC2HCF0Vj7hI6orHXAr3AyJU1g6Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0fHc+q4m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CBF606A31C;
	Wed, 18 Nov 2026 18:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0fHc+q4m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447481F000C4;
	Wed, 18 Nov 2026 18:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027120;
	bh=Apm19X21fYOJP6HMvvWZ5xJZkUvvHCzhwWqAzbd8Xg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0fHc+q4m4AkBPCNtDvri+g0oGg9dV9kBFalKfxAtSgBqNsm9bolFs+B1XguxDlqo3
	 Z0+G8nvzRcJSW895xw8eGEvdT0MQBWiao5KjYWI9ENFwIcWkZD6usVhakPWncXjBQM
	 cWIWtUJqQ+Dnb9Zkcsv4LXyY926d2XIPN1qi+K3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Azuddin <azuddinadam@gmail.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1676/2151] drm/appletbdrm: Fix incorrect error message on encoder attach failure
Date: Wed, 18 Nov 2026 15:56:51 +0100
Message-ID: <20261118150222.881480292@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Azuddin <azuddinadam@gmail.com>

[ Upstream commit fa6d4c16f7a0da6dce3eb36a3139bfe01d071f18 ]

drm_connector_attach_encoder() replaced an earlier call to
drm_simple_display_pipe_init() during review, but the error message
logged on failure was not updated to match and still refers to the
old call.

Fixes: 0670c2f56e45 ("drm/tiny: add driver for Apple Touch Bars in x86 Macs")
Signed-off-by: Adam Azuddin <azuddinadam@gmail.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://patch.msgid.link/20260926-fix-err-msg-appletbdrm-v1-1-bb578a7dbdda@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/appletbdrm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tiny/appletbdrm.c b/drivers/gpu/drm/tiny/appletbdrm.c
index 9ad1a9b895224..7516187d3145c 100644
--- a/drivers/gpu/drm/tiny/appletbdrm.c
+++ b/drivers/gpu/drm/tiny/appletbdrm.c
@@ -718,7 +718,7 @@ static int appletbdrm_setup_mode_config(struct appletbdrm_device *adev)
 	ret = drm_connector_attach_encoder(connector, encoder);
 
 	if (ret) {
-		drm_err(drm, "Failed to initialize simple display pipe\n");
+		drm_err(drm, "Failed to attach connector to encoder\n");
 		return ret;
 	}
 
-- 
2.53.0



