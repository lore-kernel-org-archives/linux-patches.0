Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042855;
	b=N4LUgKJH3wsmM5NrOVFF1ox7Aw/H24wT7Vb2mcElb2dnOI26CN+Zc01zoQF3enbwbwPe
	 FylUl28ahNdg5wD2b6u8W7IqtwlpLVWBsErfz/51mGAUtaPFt1yDOlVQPurTFtiFlBJ+J
	 HWWTaOR1zfCKN9nSxkGo0CZlqyMMbiSbio0jYc+OE3B8u6ANSB60xjheHS+aez8LAhWqS
	 8I7DMkzaM3VWjHAIPXlP3BXhAjeL9cNOuhxc7DKuqi5cYqnxWLAs6zDx4WGghWKt+bVBM
	 NrflBh6Y8kQemY8G0aZi8UcLo9BEPZwGXR9CFmXpA9F5Nq8M4lYq1Tc52NHsaHJ8zNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ii+wVtzZCoMhpFb5zLVqruND+5ZYcL/pRrcUPoXmtg8=;
	b=VsM+nem+JPVeIQ/P+NxZLm3u43GlrRPrqnzzUgaa8GXr0F9Wbqr+2l2//liD5ni9y4/M
	 pwQWEAMJN4WdN0gkiDbKpNN/LMLT844jMXaLtY0NeeVQ1fYw6idywLO5NS4lDdIExghkW
	 Imfo1QiKJiZO3fPjJdTQ/oUlRg/IbOYTpMBkuHRzPMh1F9TQ62m8AlTDPnU1EXdu7CteD
	 eh/FW+4S7v+TF211TNmjwG1+xByRZMGy4Q1hJM5OWCo52u+oqQSZgmjJ565RXAO075X+M
	 tYg86Q4+I3L6BB4mPCUDAG+H9aNSo5ug9km9PhgrexJ2SpvaWhdE2J7bR8emt9bbuYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KFJDT8MX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71388606A320;
	Wed, 18 Nov 2026 23:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KFJDT8MX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855D41F000C4;
	Wed, 18 Nov 2026 23:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042855;
	bh=ii+wVtzZCoMhpFb5zLVqruND+5ZYcL/pRrcUPoXmtg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KFJDT8MXA2ACpGTfybxPwhx8j323I1pv/iwIpY+mCOtQ4mHeWZVElv1w+y5SDeBvC
	 dIVcwQ1KXMLA46qv+PSZOEn2BNKSnwkyGQyyA5dnThnCqobFzUiLf9XSxzjnHPVQsL
	 yK5kxK3GRPPiVFKNsD6cncT40T6s9fcKfqFBr96Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 3318/3318] Input: matrix_keypad - propagate error code from matrix_keypad_build_keymap()
Date: Wed, 18 Nov 2026 16:05:40 +0100
Message-ID: <20261118150459.104600747@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 4d8221c0d7e72bea5ee1a6bf8ae423a1faca66fa upstream.

When switching to managed resources in matrix_keypad_probe(), the error
return path after matrix_keypad_build_keymap() was replaced with a
hardcoded -ENOMEM instead of propagating the real error code.

Return the original error so the actual failure reason is preserved.

Fixes: 7d0f351da460 ("Input: matrix_keypad - switch to using managed resources")
Reported-by: sashiko-bot@kernel.org
Assisted-by: LLM
Link: https://patch.msgid.link/ascss_vYXDPXIxmn@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/matrix_keypad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -455,7 +455,7 @@ static int matrix_keypad_probe(struct pl
 					 NULL, input_dev);
 	if (err) {
 		dev_err(&pdev->dev, "failed to build keymap\n");
-		return -ENOMEM;
+		return err;
 	}
 
 	if (!pdata->no_autorepeat)


