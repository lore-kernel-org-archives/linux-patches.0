Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212464;
	b=1zGyPFCweQONCT1XjqBUSK4aipXz7QYq0q0XvlR1VdC1b2DsMR5iTHXTkpE3Y6v7g9nD
	 14UULAd8htoq11JL0DNiok7Q3sJRC7817tl5Mh+gB+Mg2jDeaGfl4kxJL2ZcHENNuw5bN
	 j7xSnHe4658JO+JmvgQUQRi/zGMciqQD1yWIZ37ktt480szMtg0CXPMKh+5aKoiDiSjT/
	 fAkl73d53cmBtiqlBeD5vW+aBwBwbWNm/qS1yimTz/miQupgoCf8YljNjzJhEAN62hjAi
	 toMaGkTx0prWI5mN9RtMjcaammoXS9vu9N9sHDXuBh8lDdo6s3snMAhp3DBBa91fJbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yC7thpLrlq5EOetbfR+y3hgUCCck996FvMDIyMxKwYE=;
	b=5MGj5GmYCWzIV6FiJOi7pXnnNsA/PzBPD2HMhIh1NE78bVZ9L2jBjcC9+DXN86U7B1WZ
	 N6qsxNJrsFztnVRuin3LdpxaiHKhr6rjpdiVwp0I16x7pCXYqpLNMKgtHUHSw/Z5qVWK7
	 xYgI7Psg7NLrsTWhV6b8PEPA7Um8sOc0XYnKAZ2pj/lpNfGIg9HJuhW/gnGWs7a+hbUk9
	 447fRJDzWCyQrB+RN2aX+0hBY16EZsUyW3/uPgpOk1rNrQayY18A0bvt97hY1EM/QHYeg
	 wo26ZAIuFkXfPacOebPxW4TDlc/Ae8N8dFEiqMJ+cKbW8jm12oL9Lqqn3tMrpIV3rtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z7NHvnaW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4A1606A31A;
	Wed, 28 Oct 2026 18:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z7NHvnaW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4681F01825;
	Wed, 28 Oct 2026 18:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212464;
	bh=yC7thpLrlq5EOetbfR+y3hgUCCck996FvMDIyMxKwYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z7NHvnaWp/ncisEu7nuKTKrSGWhwGdXV3cN1iB1JsCZ2LeAb74Mg7w6YczDcwrN4x
	 dp4vi7WRdxjQ2gZF3O2i2vhumflK1IdIIcl+nV5gbRG9C2nPmoZSWbE0Vi4cw23xPG
	 TVPgtyp2/7TWZ8IdvKMI7tGVX4Y74ij6zwvqgqW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Nocera <hadess@hadess.net>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0164/1887] HID: hid-alps: Use pm_ptr instead of #ifdef CONFIG_PM
Date: Wed, 28 Oct 2026 17:37:40 +0100
Message-ID: <20261028170502.966153360@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



