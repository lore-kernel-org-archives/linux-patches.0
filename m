Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8DB3B27DF;
	Thu, 17 Sep 2026 16:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663878; cv=none; b=A8C+cLOi+cSCK8daXPMtc9+7KzlGc7l0WrK8Pxvg4yfi9QNytywQprNDldeo3oP3hdNrX1lkvEAsOw45JBsuIMi6Bpz5QazEqUh77rlUz+vCTPe8np6py4AYB7iKjt1qhB4v1u3G5GiHhMQpHm0EwTRwDuL/BzrBaiOQw99tqrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663878; c=relaxed/simple;
	bh=9D/AWGhbOlWgGQuJZNuTyMqTQRd7/tPo5Z1NNEs7IH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pReYA0H3ly8LtXrUKLyWHvNmNqvDhu+r5HmN3YbbsC/fPeFsMv+5FEWbvmXeQNxyXglTb8wjD2QaJUcL6F6MlVnKt83YldmvwehS555aJzZ1OikfqTmFUzXx6bRmZHKGoxaVNEw5Fw3X56jyBJmQvLI1/U0KSXQzs4FdF9/HtTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8Swh7Uc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8Swh7Uc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916E31F000FF;
	Thu, 17 Sep 2026 16:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663877;
	bh=Y5n9yBK6ZtaRdjpyyT3NfKoWRKBsTyHlrfm6FPs+YxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V8Swh7UcbUJJhPWEPWy9w+oX+I1QTLDSB34Mhe/7rQXqPCbZGg+pZU9PlQNiqOJDC
	 Z7eLcq3pG7FkmT/kdY2WbgmE5picwK2MsOftSJT7dmzCGbHbptwWMtQWqupAF2axG/
	 C7/FTU/AHxdEx2pd2f/WPLTXOxyV1I8BJwjIBfBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20de=20Bretagne?= <jerome.debretagne@gmail.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0185/1250] drm/panel-edp: Add LG LP129WT232166 panel
Date: Thu, 17 Sep 2026 15:59:40 +0100
Message-ID: <20260917151557.125639973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Jérôme de Bretagne <jerome.debretagne@gmail.com>

[ Upstream commit 31ac8899d1a9284fb50bd42c409f224788220e27 ]

Add an entry for the eDP LG LP129WT232166 panel used in
the Microsoft Surface Pro 9 5G.

edid-decode (hex):

00 ff ff ff ff ff ff 00 30 e4 b2 06 a1 25 10 00
00 1f 01 04 a5 1b 12 78 01 ef 70 a7 51 4c a8 26
0e 4f 53 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 fd 00 18 78 f1
f1 48 01 0a 20 20 20 20 20 20 00 00 00 fe 00 4c
47 44 5f 4d 50 31 2e 30 5f 0a 20 20 00 00 00 fe
00 4c 50 31 32 39 57 54 32 33 32 31 36 36 01 23

70 13 79 00 00 03 01 14 56 16 01 88 3f 0b 4f 00
07 80 1f 00 7f 07 55 00 47 00 07 00 03 01 14 56
16 01 08 3f 0b 4f 00 07 80 1f 00 7f 07 2b 08 47
00 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 2c 90

Signed-off-by: Jérôme de Bretagne <jerome.debretagne@gmail.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260520-surface-sp9-5g-for-next-v1-1-9df52552bf87@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-edp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index a8f327553e62e..9ad1769885b3c 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -2087,6 +2087,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('L', 'G', 'D', 0x0567, &delay_200_500_e200_d200, "Unknown"),
 	EDP_PANEL_ENTRY('L', 'G', 'D', 0x05af, &delay_200_500_e200_d200, "Unknown"),
 	EDP_PANEL_ENTRY('L', 'G', 'D', 0x05f1, &delay_200_500_e200_d200, "Unknown"),
+	EDP_PANEL_ENTRY('L', 'G', 'D', 0x06b2, &delay_200_500_e200_d200, "LP129WT232166"),
 	EDP_PANEL_ENTRY('L', 'G', 'D', 0x0778, &delay_200_500_e200_d200, "134WT1"),
 	EDP_PANEL_ENTRY('L', 'G', 'D', 0x07fe, &delay_200_500_e200_d200, "LP116WHA-SPB1"),
 
-- 
2.53.0



