Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060759;
	b=qR92FHiPeaw/iKR6hyu2NeLEXApFvEgNQFBk05Nd7vh0aag03ZE7F6Ex4yonwaVHc8SJ
	 ccVHuk801x7GKCkRpMDgZwhYSOFhNCeSMB9ZqpjAIfrSRsi6Gv5T3InsVL982zP6ZBfgp
	 6utiKNLL3dsSYzBvQ7Kwa5tJ9A0RGQPO4my+Frh1DpNUkSxQAZ2XKut7cQ5OHfYg3SZtW
	 FHzbMAHQHfSRYxLHPD7fr/FZc/4RXNLpXbfudnsXkZ8UDWA6jDgl39N2siI6IuE4SOeqs
	 RWQj9ceWJA3kL6synK+hyQxeSFz71Hyrz7Q3krNySvXKopYxGS9BqinGFubFrqMk4pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060759;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qaclzZdy909aKQv0zFHx0gVFCimoc57Rb4yUtaEsAvk=;
	b=3dnlET+siab9WCUL+WkNffVXO2IJaBw2ukMR2DxNHPQsygdkoqq1lDShs7u3FWvKFIpv
	 3uMorTVyVVsVAdqpokgist9c3A5/jdXNsLLBtmhCcH4eN/KP7E2N7P4OZ6IkTTIdc0SjL
	 Sz6uMcNO5qAQzjZGy2UcNe6mhCkZ4FhW50+DOxEjhp/eQp9/v9J/Yhcy6UBZvR3DswOPq
	 oP48lTxE5gB+rwUKYtQuzwKbIZx3X+H39p7K/gsdQFw7NMPNEGp0yh4u2hTkK8zBdHXtJ
	 BRGGO2uCq+epaV+nsCkh6fbj4U+KCjYpbC3hx1LKHQqs87ULRAWOxwY5WrY+5Svaveg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KHo6wZ+n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D10606A326;
	Sat,  7 Nov 2026 14:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KHo6wZ+n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620031F0089F;
	Sat,  7 Nov 2026 14:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060758;
	bh=qaclzZdy909aKQv0zFHx0gVFCimoc57Rb4yUtaEsAvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KHo6wZ+nnNsDkWxRF0LKdcD2yEzyH15mTNtLPuXVpdsHKEPu6XMIpAvpf9DmUU4N3
	 6AXwMngZK+/MzKF6SidHQkTvmBvpgAxQT8kLGLFSKt8CcMcOd7km7ZA9EhULIrqLHj
	 REljiXGtA+XAmdoMN8Bjg5bWBzMbaBdec/v/0/Vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0164/1536] driver core: attribute_container: Unwind device_add() on attr failure
Date: Sat,  7 Nov 2026 08:36:20 -0500
Message-ID: <20261107135002.275083045@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 8cfe7ad274bb42c4653b645267410d4a3a23db98 ]

attribute_container_add_class_device() first calls device_add() and then
creates the container attributes. If attribute_container_add_attrs() fails,
the helper returns the error with the class device still registered.

Callers use an error from this helper as a failed add and do not call
device_del() on that path. Undo the successful device_add() before
returning the attribute creation error.

Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Link: https://patch.msgid.link/20260608172717.88657-1-dbgh9129@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/attribute_container.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index b6f941a6ab693..b1d6eb6ab46b5 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -427,7 +427,12 @@ attribute_container_add_class_device(struct device *classdev)
 
 	if (error)
 		return error;
-	return attribute_container_add_attrs(classdev);
+
+	error = attribute_container_add_attrs(classdev);
+	if (error)
+		device_del(classdev);
+
+	return error;
 }
 
 /**
-- 
2.53.0



