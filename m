Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F1E2264DD;
	Tue, 17 Jun 2025 16:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179011; cv=none; b=VS86Mufe8nIvE+/mCR6sKlYPFCQYOA7OiuYAcGcPHlWhWfeBgYQFzVBsw93VXg3asWIVlqe2mduaCHt5pwfv+bGWvBUNygFl1UultBESzD+zh7XReLAWUxuARbM78e22Jj8dy94S0/SsnAbFmU6lt4R6vZ690SACQbAExjzCXvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179011; c=relaxed/simple;
	bh=ZxwWB3jf9O4mpWkFacwMnj82MvLl091Q8za3NancVV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHa56Oz4wKP4DJJ9s/1zPRq6gzs+rUR31QHSUDloaGNzfFIjDShnF2RMnLf1f0FGpfXc878WGJlhW0GsTzBkCSh+eC5Pb2cpqT9mgXavMp3J1ucYLiYaDwyhYYKlRnpX+2Ig5cY+VQkMO1iEXAsn3dDDiLz8h0vL4lX6WCSxc6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ydl4UWkj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ydl4UWkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDD3C4CEF0;
	Tue, 17 Jun 2025 16:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179010;
	bh=ZxwWB3jf9O4mpWkFacwMnj82MvLl091Q8za3NancVV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ydl4UWkjwutV6j3/75Yg+Xy0r3FFcrwVOyGy3k3JJHZgrEUxKSECiXEDDJFOJnllh
	 xbXFuf9Tu5MJeHcLInelZ4kl8fdjDo4LJ6LE+yWoQ530RjlUO17qlZBYdMRBqxoux0
	 AyJygvU9+u9CXUL1rfo2xBMh6x/qQ/evP6FAi9Gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 621/780] selftests: drv-net: tso: fix the GRE device name
Date: Tue, 17 Jun 2025 17:25:29 +0200
Message-ID: <20250617152516.764891379@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit c68804c934e3197e34560744854c57cf88dff8e7 ]

The device type for IPv4 GRE is "gre" not "ipgre",
unlike for IPv6 which uses "ip6gre".

Not sure how I missed this when writing the test, perhaps
because all HW I have access to is on an IPv6-only network.

Fixes: 0d0f4174f6c8 ("selftests: drv-net: add a simple TSO test")
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250604012031.891242-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/hw/tso.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/hw/tso.py b/tools/testing/selftests/drivers/net/hw/tso.py
index e1ecb92f79d9b..eec647e7ec19c 100755
--- a/tools/testing/selftests/drivers/net/hw/tso.py
+++ b/tools/testing/selftests/drivers/net/hw/tso.py
@@ -216,7 +216,7 @@ def main() -> None:
             ("",            "6", "tx-tcp6-segmentation",          None),
             ("vxlan",        "", "tx-udp_tnl-segmentation",       ("vxlan",  True,  "id 100 dstport 4789 noudpcsum")),
             ("vxlan_csum",   "", "tx-udp_tnl-csum-segmentation",  ("vxlan",  False, "id 100 dstport 4789 udpcsum")),
-            ("gre",         "4", "tx-gre-segmentation",           ("ipgre",  False,  "")),
+            ("gre",         "4", "tx-gre-segmentation",           ("gre",    False,  "")),
             ("gre",         "6", "tx-gre-segmentation",           ("ip6gre", False,  "")),
         )
 
-- 
2.39.5



