Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212817;
	b=H/GumABBRDyt5p1QC/91iFe5ZAv8FepoZ9EEy9/8lEnUhY0or/KhkeGKs5tl5WYhGMFG
	 2WnYxXGDJJTvOIUBsTTvMnEPGCdSmoRpgqioWUcn5YeOVgpCpDMtq7Wg3vKeEUycKM81Y
	 Q/rneb1LkSHu+58opDNbGmdJoc3w5l3Ro+odvFr03S+VFajhfdonGzfRtoE9tn7I8UBpW
	 knw8HSC1e9esBRg49l1nTiGq7UpSoxPywKTa/IeWS6vBGINWQGoFqcbJeLm/ScsTGKmAC
	 YQ5ioBfv27jtMtXNIRhDVdOjYeOYlxsVXz2T+6XjDZm1N6J2nbUwLIPnItuqoalvBdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t67Spv4pO8a80NhBdMvT8FROKSkcMk97MlOzhXdZRUY=;
	b=JiK8o0XEscOZp+TsXH6qyTuuCvXz8EkPoeXFJvHjHjBElr7u4VfcXaEeGjoXWDPFWMEJ
	 6i9wU0juWWDnlPneEiW/763GhTdYASnG3oeyRLOeqD6j3H06bopocWeSv4oYMwEfLnRJC
	 gkYcxZtdR+8MXAC7DEpsPfLXO1siQ5usY1hQ/Dzqr2E4xwB7yGtrVr6JZyGn+Zn1rVKGK
	 uX2QwynqpWZg2FyOQprqIcgrpdekMstQYo6Ip5KRmYpMSH3Dn9O59kZ1T0RGxZDkWXEiH
	 CIgc3VmiqwLdpx5KceO1NsBU8mazxDgjQVTd2GIGRu445M9kKHG5YKiwTTjsF9K6iTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XnMPC/AA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7078B606A31E;
	Wed, 28 Oct 2026 18:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XnMPC/AA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43331F01829;
	Wed, 28 Oct 2026 18:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212817;
	bh=t67Spv4pO8a80NhBdMvT8FROKSkcMk97MlOzhXdZRUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XnMPC/AASzAab0TxigCN0L6i/wqBU66cpL7D4QR+jMcA8WFmaLevhs6IgYGF17N8G
	 Am4Wp8KsdnMfLSSp9JESdZxra212DSRd8HYx9aLAF9drvFiB3P2l/tE7hRTuN06ygH
	 Mp3isFuPh5OeQb0mqJopapQva2IuRJl98dtlGAAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Benson Leung <bleung@chromium.org>,
	Jameson Thies <jthies@google.com>
Subject: [PATCH 6.1 0286/1887] usb: typec: ucsi: displayport: Current CAM OOB index fixup
Date: Wed, 28 Oct 2026 17:39:42 +0100
Message-ID: <20261028170505.737639274@linuxfoundation.org>
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

From: Jameson Thies <jthies@google.com>

commit ea31c6498c61307dc0d8ce338a7f268cb8cbdd57 upstream.

Update ucsi_displayport_enter() to return invalid error when the PPM
reports an current alternate mode greater than or equal to
UCSI_MAX_ALTMODES. While here, remove 0xff current cam assignment on
failed GET_CURRENT_CAM response.

Fixes: 04cec690b1fd ("usb: typec: ucsi: displayport: Fix OOB altmode array index")
Cc: stable <stable@kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Signed-off-by: Jameson Thies <jthies@google.com>
Link: https://patch.msgid.link/20260917032008.1701888-1-jthies@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/displayport.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/usb/typec/ucsi/displayport.c
+++ b/drivers/usb/typec/ucsi/displayport.c
@@ -71,11 +71,14 @@ static int ucsi_displayport_enter(struct
 	if (ret < 0) {
 		if (ucsi->version > 0x0100)
 			goto err_unlock;
-		cur = 0xff;
 	}
 
-	if (cur < UCSI_MAX_ALTMODES) {
-		ret = dp->con->port_altmode[cur] == alt ? 0 : -EBUSY;
+	if (cur != 0xff) {
+		if (cur < UCSI_MAX_ALTMODES)
+			ret = dp->con->port_altmode[cur] == alt ? 0 : -EBUSY;
+		else
+			ret = -EINVAL;
+
 		goto err_unlock;
 	}
 


