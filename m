Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212587;
	b=wEvB9Bn6yjeauXN5etfVpeTGkuqHp3WH2Uj29ptmzjwJB1PYrS7GTfSOL/fgMUE6/TgO
	 SUPJgudNR5DhssIbNXDv2HMx3VCJ857zBL9toLJzohWYvGNxIO0TI4F2UTeReRQ5qWadK
	 kThQlT0q7RxawBDGKMvU1CeizrtxaGnDvI+gpz/zV5axutlMPVVuDwNushMF3asG1D50x
	 BClZcvqyXyeiKp8DFXjVhNny+O/gM3ipZYyAJPSYSAre8rTAf3Y3iyJfhiBYRTUuyq+6g
	 SjR0fIHD712IoQafeZh07Ef1iIjiD3StklHJXq0wN49iLdSGGSwEs06k8vKCTS6HOcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=SjruRc9dEuUkvcGpf4OggqhK6BKqAyq+bsPcVRx4uJE=;
	b=FDzLOKMdgi1wzIYm2ksuObrdewJo2aCTgpjYiEZ5EljTGWUFV9Bh3vfoB3Ly42NYYm/C
	 QbcYi5WxguAEcxDFSXAeT/Z+XM17iFOBzfkSX+GIMLIPOijikzEg54cyss/vV0W9hlbgg
	 yXzrPB72u3FTZPiaMeUarHJhuZd8yc9LKRDVNf6RpCiO5XzAkDR+s7w4bRvglA4HCPrgz
	 UfZiZE5iM4oGXE8G84dSg8bthhWGEiOvfdixjV5L5aAzhMHFwevLFn2e68nByoptlEIAv
	 Z5me/vPwPQzrhT9b7iGD10JrHZSpcwnpFqdHTilCsLtR8Z10OPIJW+5h0vjd8MPGMmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d8ag1PN+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BF4606A31A;
	Wed, 28 Oct 2026 18:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d8ag1PN+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3681F01825;
	Wed, 28 Oct 2026 18:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212586;
	bh=SjruRc9dEuUkvcGpf4OggqhK6BKqAyq+bsPcVRx4uJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d8ag1PN+FPT4/1zygKXHjSwf+FNNAV2d1+H7VZmdrXTZQAZKFbqil/QGW6x2PlSY1
	 98EYadN5K9EociO9MPOftB0TYn3JYxz4Fhe9d34PjrVhaIMTaB0EdUAazbVFcx5zHX
	 BlhHIJlatnE3CVk3tvsGU1eAlxN6G8aT1R9PS8Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0162/1887] HID: core: remove #ifdef CONFIG_PM from hid_driver
Date: Wed, 28 Oct 2026 17:37:38 +0100
Message-ID: <20261028170502.920946608@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 536a4750b905b..9fde4e8839c91 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -837,11 +837,11 @@ struct hid_driver {
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



