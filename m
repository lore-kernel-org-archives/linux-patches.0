Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210729;
	b=P4PHOXAhFY1cWpgpoSQXNPpgBcpMdWKBGUDTOtarlozUu/99w/hzJlU80+RWCQFylsNI
	 sc1zJv7Ef+7ZrasnMuCOPiJFDpkthY+8oOYW4bN8InglorfGN0DRRZFu1Van0h6B1b0jo
	 9ATHk5VhC/tUj0gXYEWTP30xg27hIM1XpwiM4yKPsb/66IXb50OLqMKCwmdwveNPbScSz
	 PFTIMckfC6rVJ4OzWBl7U64PXs68AVmBBhokqCFVbs8+x9m+ZoMsggi+zfhSMis9Q7lLW
	 FmwF9kVWUaJhFo8M1vudgpyfVKyLhjwWa2ZBJTpocD6BcT3oxHADrKAqYyklYhSJrCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210729;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=nCq8+VXczT2scvwCDPMYcor8nBf9hT557VVyH2/IuFc=;
	b=KGMmK3fJ5FywFu0ULU1of9YGdV3a75pbE4Qn1A12R3dYCsGCAY60DTbyCKBtu34dHAbk
	 PHNlr7r4IzkucuFnrv1G/gAMHIbrlarVL+HB0bNBqwdpHpNj6zxKcJsd7rMdJpBRKYqu6
	 iHwx1PTeMsupMKtzJTQYuyMCYOBTqM3e0bI82qaPq0MzhrJoceCVgQR78QaVhwPg4cYta
	 HdOU/iFcrGlRVcWGU2vt7pBZSrX8Qm1iNs/E64tXxRd3Cy99/Xn2Xy2fW5AlbQv1BfFuS
	 BZcp2d9xJ8V0D1GZNOCRDkYfQGSSwof2WcgROV296umlFSD7ORd2R0GUCZb0DTSneVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qJEUgeo/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C43A606A31A;
	Wed, 28 Oct 2026 18:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qJEUgeo/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5ECD1F01829;
	Wed, 28 Oct 2026 18:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210729;
	bh=nCq8+VXczT2scvwCDPMYcor8nBf9hT557VVyH2/IuFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qJEUgeo/ZD8Zg6g2ikFjz7vQy9K8PstJIu3MOKPlcxEFSltSktcgVhHYuL3UxRbf0
	 9/PKtWlu6kRMPjRn1CI4jba1W2zhAtnNDi8wVj6spz6BZATFyCT7DpyhFuRXapSaJ7
	 nDdATIa+Y5/VOsCj+1G7BPDfwyzBCJOLuzteDxZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 126/571] HID: core: remove #ifdef CONFIG_PM from hid_driver
Date: Wed, 28 Oct 2026 17:54:33 +0100
Message-ID: <20261028170011.009259338@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit df8b030d82dd1224881acb4e778fa06c4824f72b ]

Allow HID drivers to pass ->suspend, ->resume and ->reset_resume via
pm_ptr().
Through the usage of pm_ptr() the CONFIG_PM-dependent code will always be
compiled, protecting against bitrot.
The linker will then garbage-collect the unused function avoiding any overhead.

The only overhead in the final kernel image and at runtime are a few
extra bytes in 'struct hid_driver'.

The same approach is chosen by 'struct usb_driver' and other subsystems.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20231012-hid-pm_ptr-v1-1-0a71531ca93b@weissschuh.net
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hid.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/hid.h b/include/linux/hid.h
index ab088e77742ce..3d941d51ccb63 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -815,11 +815,11 @@ struct hid_driver {
 	void (*feature_mapping)(struct hid_device *hdev,
 			struct hid_field *field,
 			struct hid_usage *usage);
-#ifdef CONFIG_PM
+
 	int (*suspend)(struct hid_device *hdev, pm_message_t message);
 	int (*resume)(struct hid_device *hdev);
 	int (*reset_resume)(struct hid_device *hdev);
-#endif
+
 /* private: */
 	struct device_driver driver;
 };
-- 
2.53.0



