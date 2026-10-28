Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210840;
	b=Nng1YVPC999Y/kHfItFuwlWNb7gkj1rA1rY0MKQlGi/vUjOowdU0kpZqbwTF4IEsE8L9
	 hHZYqtTF21Ualo/VpMOZRqIr/YgUPmsX0KALgtvWLO8PvLSNhcM4gwc27nuN7KEjJAn9F
	 xX8c3FHl3E6RvKosS3/8rF6ozTdjVPZDtN31NzaZf/sRCDdCvGEqjlQSBKwo9dt7GoVK7
	 7BMKD19iHcVgdKFfVvQlPm7yWkmbBYGtes3Ce67egY/TABOKmxi3dz8ark+XH8hPvUuJU
	 iZDlVA10MC9BmorPlsBt0oFLj/gsPXkRTzliYu/VrbY/m/JpuTex/tLJNPncC6yq5vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bCNy9grkfTJtzjsEWuMbIbYLtY9RHIefNgur6B3td3U=;
	b=GWRpIQF2SsJpWSdjo3DxI4IyQYcf5gUNzLrMtNgyFHlGvIRyWvDRpEM3XZlcXmPV1z67
	 1RsWy544ex8qE33SSycYugYvBoD7PLmzSa/OwRAQSvmQz/der7fcWSxl48qvT/jkI0Ei7
	 Vm2EiEslE2w6hERoVBEKYb/0kEy4fwgCbSOGpqGlOnh/EH2ixV5yy+CeT+rWsFyjotR2P
	 n76VMDPsJatG6HklYC6GqDwA/DRxPxjr7XzBT2YMdIXnIf+xQgdt93MACdC7ts8QWsct/
	 mclcITMzIyHwzQR5svLjkeHMnSMhv9LqyW2C+GozUnyo/BGW5I8M3FXgyKwGnVjI6Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uA9OmbpM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DE4606A31A;
	Wed, 28 Oct 2026 18:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uA9OmbpM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8831F01825;
	Wed, 28 Oct 2026 18:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210839;
	bh=bCNy9grkfTJtzjsEWuMbIbYLtY9RHIefNgur6B3td3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uA9OmbpMuQdyPaHwbF+5Yd33Kp44e7PYDJLhOvSnbC4ifxOlSBOeG4Ti4z/LCSWfk
	 /wqSBzZhDEMm+7OH6rfz7isOzRfPAQdm/7V6UB0gEIDHzfFkvdmODLLymxkwoWm0I+
	 PM2GyiND03ffYi6G2EvrDz0xrCwbZcjWJj0ETahU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 166/571] of/overlay: dont create "//" paths for fragments targeting the root
Date: Wed, 28 Oct 2026 17:55:13 +0100
Message-ID: <20261028170011.953873616@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

[ Upstream commit 21c89ff1fc86ffa517f3a9ca1ba5c48e9e37c1ba ]

dup_and_fixup_symbol_prop() rewrites a symbol value by replacing its
"/fragment/__overlay__" prefix with the fragment's target path. When
the fragment targets the root node the target path is "/" and the
result starts with "//", which __of_find_node_by_full_path() cannot
resolve: symbols pointing into such fragments silently stop
resolving.

Drop the target path when it is the root and the tail is non-empty. A
value naming the fragment root itself (empty tail) keeps the "/".

Fixes: d1651b03c2df ("of: overlay: add overlay symbols to live device tree")
Assisted-by: Claude:claude-fable-5 [Claude Code]
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Link: https://patch.msgid.link/20260831-nh-of-alias-overlay-v7-7-02754604805a@nexthop.ai
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/overlay.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
index 46fad2a85d3dc..28a340816a2b8 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -241,6 +241,9 @@ static struct property *dup_and_fixup_symbol_prop(
 	if (!target_path)
 		return NULL;
 	target_path_len = strlen(target_path);
+	/* a root target renders as "/"; drop it to avoid "//" results */
+	if (target_path_len == 1 && target_path[0] == '/' && path_tail_len)
+		target_path_len = 0;
 
 	new_prop = kzalloc(sizeof(*new_prop), GFP_KERNEL);
 	if (!new_prop)
-- 
2.53.0



