Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617679;
	b=tGll2S75YHvDBr9VWDkRT9SduXQDwBW2OOeVN/XNMb2GELiFqNSogrgVvrC6CKTYSvxy
	 tD5df1cJkegT7vRZRPYm2HoTbQLg6g6mYXXYIIhtia0z5dEbV7aCmNRQPO4K3WznFiiPb
	 26XCDucHRFRuV+djyxjrd1TsQNzlT8IGtGFh3gtePBz/KkIYWQobqhlBIVvlcRwbApJHL
	 d1exxiQOCy2Eh0NHRPVNaR7IfK8nu2lBTwyhZeL0Vl6XwqeRu5vQz4gR9M5BITQgXLGhE
	 kILiAvNpGycOaFMfoMKpqntQze4CRvDlh/XB1aZyZW8GouW1VVoYuOIlaT42X8Dxc6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617679;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uyrQN7SGLSkTXHkvkC89pL6exju/ACkbNJSxsmBX6oQ=;
	b=DW9LUQ2RR6CQvsvnvEadb1IT3Rd9on8WCES7K+uIqTIsmsiLaGPVU32zRYbPULhnTnxQ
	 +35+/73skLrt5ok2RVm8YUUTGrq+pcunDNy7ANOTGj15+XBbHXJ0yI3MWNQv49JuDPRs4
	 eFiTI8LH1nV6oCGFCy8RmypROi/NsQ9jOYjw0drdOus1zJHUyIwIhtTnSd7/1zrHixTpJ
	 UwW751gXAHeuKicelBIkDTQWX24Z4dFF+U9KBzVuHpkhtNT9WYUuYfGp47sY3QuOzaYyL
	 EOiIX+fLYsa5nCXRp4aUKc1KJ1cfpOstf3aoMylQFy5R7A7tr47HL9tRbOhXciQKfUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U0jIlEt0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336B5606A31E;
	Wed, 25 Nov 2026 14:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U0jIlEt0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74F71F000D2;
	Wed, 25 Nov 2026 14:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617678;
	bh=uyrQN7SGLSkTXHkvkC89pL6exju/ACkbNJSxsmBX6oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U0jIlEt05+x5lv36uiqoRZx6qJPLKHVnQ+te573owZqshaKcxs4VNtl+4vEyd2MGr
	 SNJTNupNvt9UjLk1IOYO8WpS9nkXTlP8gmlYwNoHBNcVUnk/ZzmfPUJlD07Sko/9Lf
	 VrIkMg5wmO1n+xFiWZIU4JT3rKaGkVPh2V4pyL44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0040/1005] drm/panic: Accept a trailing newline in panic_screen
Date: Wed, 25 Nov 2026 15:22:58 +0100
Message-ID: <20261125143822.678491240@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit 3706caf4da279686b9b95a253eb1d39b1fa12192 ]

Setting the panic screen through sysfs with echo fails with EINVAL,
because the value ends in a newline. Ignore it when matching.

Fixes: e85e9ccf3f84 ("drm/panic: Report invalid or unsupported panic modes")
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Link: https://patch.msgid.link/20261016052722.60051-2-lucid_duck@justthetip.ca
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panic.c b/drivers/gpu/drm/drm_panic.c
index fef47625c5268..1dca0b05e9240 100644
--- a/drivers/gpu/drm/drm_panic.c
+++ b/drivers/gpu/drm/drm_panic.c
@@ -842,7 +842,7 @@ static int drm_panic_type_set(const char *val, const struct kernel_param *kp)
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(drm_panic_type_map); i++) {
-		if (!strcmp(val, drm_panic_type_map[i])) {
+		if (sysfs_streq(val, drm_panic_type_map[i])) {
 			drm_panic_type = i;
 			return 0;
 		}
-- 
2.53.0



