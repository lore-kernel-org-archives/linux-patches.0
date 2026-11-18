Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051714;
	b=pTT3Fro+rzdg2cQbRVHW8P83deMb8XooGrtWx1AWY/0TevDXMqM8Pt8eDQknzll22eVr
	 hZGBAb5yqexOcW9GTCzOIOXHKCGSppd2wyuBu7j9o0pPh9RuiOCGXM4ow24jvKAKbJBK4
	 Rfsx5xlca/FM9idvJ5kziiAueJKFsyjgD8jYHFJC7cYKL2UXaEr7SzbzXgZ2FNBE5i3Zl
	 /3A1zD1jtYGVVqaCUq6zCjSt3GBF3dpx9KQMXG33wE06z55rKue9m7FaCuQ2nPQweOvFW
	 6YjPsVQS+vj84GEEX7EgwHdXfO0UwMMpCF+Bz6/J0x+rPTyDIFBmSfPJVPuwaOH3AWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e7PZSRBG0QBqLpdW8pxmMQTvmR5GFQJBZW4h5q+Yc4s=;
	b=Ytb/rOy5IR/GAYRtrnfMaJKXPEMzOLEgLW6danj/ENwNQb5SSbgTooR+h0IcQjJa6jcg
	 +zYEqZyl8cc5tFshh1M5jFuY16yjkzpZ2FDVdezjr5idnQtt7b+F7lZU7Mz86Ae9LqJUx
	 hHt4FW/aFYsbtBsCs0ffXRN+UZIkczckvXkHaGDHYVbRIT12EwYGUcAZLGbQzcQwWDZIL
	 kSECxRDnbQFgjVaxcz2Mo/gAYrvRFV0HOFSDwR1xbvTHYQQKdIOCBb5bWZ1BxLK1T7/sl
	 l+qhneikjsDquqKKm2YU6STW3MMh7jlyZWGqtL8v78yg3pbrlE5NaAgo7XwBuVnZscw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2vXXFELY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453DC606A325;
	Thu, 19 Nov 2026 01:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2vXXFELY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C631F000C4;
	Thu, 19 Nov 2026 01:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051713;
	bh=e7PZSRBG0QBqLpdW8pxmMQTvmR5GFQJBZW4h5q+Yc4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2vXXFELYnRGtHaztbwHwRq6hP66tgAhXnWvIuwTOnsXPaKlpm4tjLR4Ekdu4jzCGG
	 dOSwC0VENuGA+eHeY5uzSHM+FCLlZviTzNaFr7i0SnjmyaWUZeaelh6KIlGH86+Fev
	 Uu/XGF1qdJ2U0+XenJZPEl/eBGArcxiXJ6p/S5zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.15 0304/2214] HID: wacom: Write shared touch initial status only once
Date: Wed, 18 Nov 2026 15:33:00 +0100
Message-ID: <20261118150022.339941228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Ping Cheng <ping.cheng@wacom.com>

commit cae3031c691dff0be61a26bc64e31a6939010d5c upstream.

For consistency with how the shared has_mute_touch_switch is handled
during registration, let's apply WRITE_ONCE to is_touch_on too.

Cc: stable@vger.kernel.org
Fixes: ba16e5ffbaa1 ("HID: wacom: Advertise SW_MUTE_DEVICE capability prior to registration")
Reviewed-by: Lee Jones <lee@kernel.org>
Signed-off-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -2327,7 +2327,7 @@ static void wacom_set_shared_values(stru
 		 * match historic default.
 		 */
 		if (wacom_wac->is_soft_touch_switch)
-			wacom_wac->shared->is_touch_on = true;
+			WRITE_ONCE(wacom_wac->shared->is_touch_on, true);
 	}
 
 	if (wacom_wac->shared->has_mute_touch_switch &&


