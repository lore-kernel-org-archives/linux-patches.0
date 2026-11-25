Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618019;
	b=3npaXFWqvv1ebDd7DybZVi+mQJKU7LSNpkjEfb03DCXdvz3JNlNzNOmBBTo96xIzemME
	 UBtMi2539DwFh+oJYbVKotw6XtMjlUhDpYNqQZNJ0akFLq22ZxwAp/+iC5xlJLop2c13u
	 P5TIST8PIpfNnn+yDTT8K+S5DboyRkl5jGvguyVGsCXRDaqVCmXxClWdkkeR5g20dqsub
	 HT+bS51Ar1NZWlDsd2VZgUuXPrs8OruVqDBtah7uqhjrfpTjYLDtvum34iYlXCThmUsfN
	 Bk4uy5J6T+dM1sLlHU8BO7Alyk2RaCrDtCFfrzin9xnspNbm6qUc8Q+wmifXKH5FWKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tlGaNogMIevLhAXbzIKuZfhNI/f89I3Py2kMJ2Qy350=;
	b=YudD/8nF9+O+yQEaT7796XgryE7+t7AoC34m55LZRo3fs7/e33Tbn9/O84VArVP4vyly
	 Pa60wCyHX/d5Cgvh4JR14Je1VEt8LZB2ZCYcDv/u9gdbGIP6piCGiOmi1mvdwt/oldlhi
	 zQ3fEThf8NgqnlSGjkg48vvKxUGCGXwQNxhJpoeNPciuepLRVXDsZdoBYXFx+2ZvR607B
	 Woqm0jLAuGLMzuj0yzSyqlWGV5yPXi9gWmvIrAsKU2+FHjRp0gBEVH3uEdyaD7vseCgUI
	 o5ZXbIIwUnRM3jah+03DpsB8Dk9dW++YXrZzvTQFiHmhgfq/6XKo8woGRJ/NA7xutTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w0IHTSjN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2958A606A321;
	Wed, 25 Nov 2026 14:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w0IHTSjN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426A11F000C6;
	Wed, 25 Nov 2026 14:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618018;
	bh=tlGaNogMIevLhAXbzIKuZfhNI/f89I3Py2kMJ2Qy350=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w0IHTSjNACn8enYEZg9SdElxdk3KaWMPV7VoX9juXnOmVGDuvIcQc0FkAOaivKVnP
	 n2ONWaKDogeY50YV1sntz5Vs8AzIjfNwoU5mwMTpc6SXs9GEWdLVsYn5Vced3b5Qel
	 KzxUUECrduDLDkZMnu85DTvKMDBLcsgjqfM6h218=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0146/1005] drm/panel: visionox-r66451: Wait longer after the panel reset
Date: Wed, 25 Nov 2026 15:24:44 +0100
Message-ID: <20261125143825.157478507@linuxfoundation.org>
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

From: Vladimir Zapolskiy <vz@kernel.org>

[ Upstream commit b4b2778d5e175b166e4a27e5df5d61da468ad004 ]

The initialization sequence is sent 10ms after the panel reset is
deasserted, however on the SM8350-HDK display card the panel does not
answer a DCS read at that time, as a result the panel initialization
commands are lost, and the panel does not exit sleep mode and the display
stays black. With the first command sent about 15ms after the reset
the panel comes up reliably, so wait 20ms after deasserting the reset.

Fixes: a6dfab2738fc ("drm/panel: Add driver for Visionox r66451 panel")
Signed-off-by: Vladimir Zapolskiy <vz@kernel.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20261101212458.2431191-3-vz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-visionox-r66451.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-visionox-r66451.c b/drivers/gpu/drm/panel/panel-visionox-r66451.c
index 0ce5c670dbb9b..d2cbc60af1179 100644
--- a/drivers/gpu/drm/panel/panel-visionox-r66451.c
+++ b/drivers/gpu/drm/panel/panel-visionox-r66451.c
@@ -36,7 +36,7 @@ static void visionox_r66451_reset(struct visionox_r66451 *ctx)
 	gpiod_set_value_cansleep(ctx->reset_gpio, 1);
 	usleep_range(10000, 10100);
 	gpiod_set_value_cansleep(ctx->reset_gpio, 0);
-	usleep_range(10000, 10100);
+	usleep_range(20000, 21000);
 }
 
 static int visionox_r66451_on(struct visionox_r66451 *ctx)
-- 
2.53.0



