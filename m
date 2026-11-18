Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035547;
	b=HUJCb/i6+rNiPVemCly/12Fr0E3N01yGqIGwnQkXfWVYr1WHKch9n0U/1zJsE9dX/6VX
	 M202NJ0L+MIVJ9B2gThI8ju8Vmx+WaS4vq628WQhcZusvEMxiOGdAhn6dUv4SCrRPAIKf
	 hOFiCN4OGLiXQOY70eUxFQoiwZewLXfUqNwbn70SA6UCa9ZYmaL+W6dFYLBqdssfE7IsO
	 z+U1MUsshUBfMC5j29/8nRTR/lDSLKz5a8fU7JTCY75mv8lu4J5busBdrUIGE+0d5Ynr/
	 DAqCS0NfPZXPon8aoDiDqgpNds5tT1xZa3u16tk4dajiKaUQ1VM2lMRdULpNfX8qS2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wl15ed4P1Hpu6tUCscof6jZDo82/mfarIQDCA8SuPLI=;
	b=JFFyeRXpQv8tlUf0b5U4hsm3R56Oh/Umhmd8CeTPQ1va2uxzoq0gLJP1FugZDj/YWQ3x
	 7g2f3i3kXFeIfUtV2JuDQ3OywXU4RHC4x6RVPsqJDrAYRohzS/0OFlSNZe3zJeGoB8Nxe
	 iH2jWXhs9rWX0okOCkVfalyzHlbspTDAIYzf5U/Ra/lw2Z0K5Y7+nu4YldPrQHsC2cewR
	 Z83bCr630Mudw6I3kukfNzkLaBu4BdezVOq3fuZDZdReGWgqKGBcFHaTekiI6UctVUGkO
	 QRncGZq0EBs5AcyoSlV8JWxcnfH/DdismkgwZdA2/DZciaRmxeD2m6BMKgP3qM2ZgNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iRyabHZt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08A2606A31C;
	Wed, 18 Nov 2026 20:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iRyabHZt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D48E1F000C4;
	Wed, 18 Nov 2026 20:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035546;
	bh=Wl15ed4P1Hpu6tUCscof6jZDo82/mfarIQDCA8SuPLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iRyabHZtbfB9PchavK+s5BINmFrNAbW3BbanpjxG789Q4SGVYVM4lNpF16kGP/u6P
	 eg761H9+eN+IHhQFDwE1+rouABm/Gl0G6u+hTazo/x+0qXWEWKyWBBFxh5+3BoqI8t
	 1Lfp5RP+rn7ClkDDqd8+nsDnLifmTUmACIyJVrcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.6 0741/3318] HID: roccat: savu: reject short special reports
Date: Wed, 18 Nov 2026 15:22:43 +0100
Message-ID: <20261118150340.826044171@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

commit 76c51fdc825a0486f8d88ff896d39acec8f377b4 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to a helper which inspects data[0] and, for a
special report, reads the complete struct savu_mouse_report_special.  A
truncated report can therefore cause an out-of-bounds read.

Require enough data for the special report before calling the helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: 6a2a6390cf09 ("HID: roccat: add support for Roccat Savu")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-savu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-savu.c
+++ b/drivers/hid/hid-roccat-savu.c
@@ -182,6 +182,9 @@ static int savu_raw_event(struct hid_dev
 	if (savu == NULL)
 		return 0;
 
+	if (size < sizeof(struct savu_mouse_report_special))
+		return 0;
+
 	if (savu->roccat_claimed)
 		savu_report_to_chrdev(savu, data);
 


