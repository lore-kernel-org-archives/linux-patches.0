Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774632;
	b=3NoG7PZYV1o3P/y+MDd9vktnoWxvm94F9O1xWhvpQOt8fpAHH3Es5JVD9sJ3+hcGObll
	 4N+biWC2hYM2nW+4u9imyps1nLpI8ke6crb1eb6K5CS+ytJoHAlfo5ukAD2FS4cqqOgLe
	 4GwLmoqkD6lDXOZPa4w2Umex0T+xPYCusIvXyADeuHLAOSAsrSycSJBdsm60HvJPZ6Gr6
	 hQ/v78Ji9WqRNaGAzvcEAdIU0fjRAE5Xaw95fzbmrnxg2dV0LxzG48dwg9dRDuqSsQz7p
	 O6ygc145rq7SO6bSS5TNdNE8h8wv8eSAPnPiT/1SO10RoxwpEmaER2SAuCBpY+veq9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AVkdv9hGOs9FdXt+70zEYoYAAg9q/BCM4LBhXJOS2Bw=;
	b=TWgqj2Qh0EJdUMIX9pCeWfjx3iSACJ3Wl+Xrn+P7FjyzI44TekqO2TZwiLuoVBSfCgKf
	 As1vpaUp7SIHe56+tGdsaptcjPDQQWYvijNtHOFoNI/bbNraTn6sJh4y+E0iQdZDZVXhD
	 Xw+RvrkdgrunpPIDkMq7/B4FA2LT1Y2BjUmv2vt1x5IEx5CTARrUwZyqI659/6pR6RzoY
	 RH7wuLRLHrhm0IQhb4U4xMTx7POnE7iWJmykassl2R+/Tpz3w0DRf1OEhov15L3Jzhenc
	 tz7Hq6HvIc6CIa8CNAxClx0L0IeNonjPTne+2/1dm3tYO+ppwsZRrhRuW/tBLPkfziA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uY1Z0T9x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBDA606A31D;
	Fri, 23 Oct 2026 16:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uY1Z0T9x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6501F01825;
	Fri, 23 Oct 2026 16:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774632;
	bh=AVkdv9hGOs9FdXt+70zEYoYAAg9q/BCM4LBhXJOS2Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uY1Z0T9xNJy1ELHiJTQsoOzl82tl2sLsmnOZjduP3s+N6tcYj63jV7HlXYFap/C3X
	 LxDOZR950Kl1aDLTGmd4fK4zoVWI91ozNpmI/W0ZScZErsy1zV9fhcvFpnXishQrsv
	 rKH+2bO2w0tB8/LR5RxRGTaj2yaA4biURBZ5osF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.2 106/242] bootconfig: give the footer size static_assert a message
Date: Fri, 23 Oct 2026 18:39:08 +0200
Message-ID: <20261023163716.288865596@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sashal@kernel.org>

commit a1ddc2721467fb68241372db77657fd0dcf6cda5 upstream.

static_assert() without a message is a C23 feature, so clang warns:

  main.c:498:56: warning: '_Static_assert' with no message is a C23 extension [-Wc23-extensions]

Add a message.

Link: http://lkml.kernel.org/r/20261011223358.2327625-13-sashal@kernel.org

Fixes: 6ed5e20466c79 ("bootconfig: Fix unaligned access when building footer")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/bootconfig/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -495,7 +495,8 @@ static int apply_xbc(const char *path, c
 	footer.size = htole32(size);
 	footer.csum = htole32(csum);
 	memcpy(footer.magic, BOOTCONFIG_MAGIC, BOOTCONFIG_MAGIC_LEN);
-	static_assert(sizeof(footer) == BOOTCONFIG_FOOTER_SIZE);
+	static_assert(sizeof(footer) == BOOTCONFIG_FOOTER_SIZE,
+		      "bootconfig footer size mismatch");
 	memcpy(data + size, &footer, BOOTCONFIG_FOOTER_SIZE);
 
 	total_size = size + BOOTCONFIG_FOOTER_SIZE;


