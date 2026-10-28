Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210749;
	b=zJ12G0wvd+ebBsyaZHt1HCrsQhhFps69kz99XWeAET7L1+oaBlnSwU1bKjX0Cxu7AdTO
	 C/Ha5vj/WJqRmPuY8Or8WPDIVgwqsePb/K0TA1tDsf+K5lYU7G/rHvqR4ulVfv+D4Ocbb
	 rPZFNPriMqawvFg/m7WyWsC57QCeda3uPa2+6VssbYmf5vZu69QnjFNM3lSAXr7Kgeftw
	 2aH0xAnQG/Qrwe1hmdZ5eXV832xL6TMMJrTxd50rY2pQc5+drdZP1GN6D06m8U8vqiN+W
	 xR1FkJNXzAkH10afTFxgZK+lR1YkLhakabAFU/SJIU5mJQnWRj6HL7q8Rz+rUYZttIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GklPPu7QGmGJ7pj/Dp5Imf0DPmnQev1KTJu4cTg+5SM=;
	b=dhoK5MQ4JWzo8VDftTzZYzMquMfw7PQOxxz88gysBxDFCSEifzGF0jhdW43wcIGXLrbu
	 iTvAVawHnkdKfWuGSLPWhQJf8NJWTFwWwfM1GlWfqSmTYtXxzqF420WRx1bBlW98Y+FVM
	 tHXnd3V2f6U6VYtWaWVlJx4sAR1gr1Co0y3qtOD6siPKuSW06XCcI4siz6tv7PGm+EocS
	 SDFyRBfIfZJQt/gCgIs8bq9vsGFAEKd3Wv/kTj5TyEhQa+JWt1ty4riXvPQlscZlve0Uu
	 4M/SSQQ7iKkgpw2hdMYqjl8IRMc6JzLF402BrYtBUOCZBMupD2RX5icaO4CMpiUeUJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BIKL1rob;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20276606A31A;
	Wed, 28 Oct 2026 18:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BIKL1rob
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708D11F01825;
	Wed, 28 Oct 2026 18:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210749;
	bh=GklPPu7QGmGJ7pj/Dp5Imf0DPmnQev1KTJu4cTg+5SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BIKL1robTXr8Z9ADR0mFraNS8qfn6sU7yPmWwJr9f5dboi7kuhHvfOOUgdKipv23M
	 Wec0oaaEEQfF+Mi6n1c1k3VopXgnklXyvOeublHqMrmEG4PoNTxs6PdIcRwxDplQvC
	 HFrV0gmuZTWmAz3qZGguplJtOvY3d+SIa315uP6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Nocera <hadess@hadess.net>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/571] HID: hid-alps: Use pm_ptr instead of #ifdef CONFIG_PM
Date: Wed, 28 Oct 2026 17:54:35 +0100
Message-ID: <20261028170011.056058838@linuxfoundation.org>
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

From: Bastien Nocera <hadess@hadess.net>

[ Upstream commit 5e130f58629a2819c9d053507ad368160d25eb65 ]

This increases build coverage and allows to drop an #ifdef.

Signed-off-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: aa9dde93e05a ("HID: alps: unregister DualPoint Stick input device on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-alps.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-alps.c b/drivers/hid/hid-alps.c
index 8aed5e17e5819..35df84426196c 100644
--- a/drivers/hid/hid-alps.c
+++ b/drivers/hid/hid-alps.c
@@ -845,10 +845,8 @@ static struct hid_driver alps_driver = {
 	.raw_event		= alps_raw_event,
 	.input_mapping		= alps_input_mapping,
 	.input_configured	= alps_input_configured,
-#ifdef CONFIG_PM
-	.resume			= alps_post_resume,
-	.reset_resume		= alps_post_reset,
-#endif
+	.resume			= pm_ptr(alps_post_resume),
+	.reset_resume		= pm_ptr(alps_post_reset),
 };
 
 module_hid_driver(alps_driver);
-- 
2.53.0



