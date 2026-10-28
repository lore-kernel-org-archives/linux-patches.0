Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208665;
	b=XP1r8oZg7DfcI8MyrnRqYCRqvBVsrS26hRWSYD37iH+MCM0S7QdzPjCD0qp5mdjslM/X
	 WfXff/ZF18jOIPhG51Ve3ITx+fiD/lrNeA6JDAkZG98zMTMuwD3o6wo8170RA2ytqTFN5
	 vrYvOTWTREdJi9T/tDOeL2fBcieOCThQ+ACzfc97zFLeI1f/qKp+xNqBdO6ImSVx0HRUR
	 U6LBOpomZpO7HAoWlgrS9b/85F3HKrT4zcBHpaG2PXvzdLLqWlFz5OrJuq3UHIUKOxvzE
	 bWjlUspnN5E06gHX4vXh49kaOLCFtayVf3pscBgFOoVGLz1WHh8mWfKWkHrA7tF/nmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=57Wyvd8KQywKurBlMudLXA/bYAGcQ0x1+dSadsvCJIM=;
	b=h2U02OrhPTm4xGVS9MP6ELEX270exAGdCD+EVcSce1Un9F44b7YRUdJIQ3qB+5kKoa7O
	 4jTum2hxjF2Vp1gO927NI3jOzJmKQG0XYvSo8UQMqmT+IpDh0PRuU1bnYOyU9PmAebnDu
	 MDl02kksTSZnk7qlp8twmT07GKiFKuHaxujnkYBQQnRDWf66vUKhaa0KOIH1CQRCePsGI
	 h8hzSVY8BWmomHCEsMghvSEaXJ8nmc3OQ7rplaMsBgnE/MAjo7rhHg02yAyZcrvNyzdch
	 nG8IpNQfBvND3jaiJbA7soAdxdkQOj62ajxjgE8B3XxWjD6f7vqGyYcvWVtWB8vukyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qXIHPUA+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6860606A31A;
	Wed, 28 Oct 2026 17:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qXIHPUA+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4261D1F01825;
	Wed, 28 Oct 2026 17:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208664;
	bh=57Wyvd8KQywKurBlMudLXA/bYAGcQ0x1+dSadsvCJIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qXIHPUA+IxmpbXsqszFdQwXV7joJBXT3UiFvg79MdgZDgVFp1yLGT/GCJ1JK0AyGA
	 CD8xfeP0jiiOtiHJn5tnEllVGJrURb0UEcHx9UnsF672hP/T48WNmuJDSPDEaBG77h
	 q3IB5ZDZm/hjJNxZPGX1F6XcghBdI/ITbyW2YZz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Benson Leung <bleung@chromium.org>,
	Jameson Thies <jthies@google.com>
Subject: [PATCH 5.10 200/516] usb: typec: ucsi: displayport: Current CAM OOB index fixup
Date: Wed, 28 Oct 2026 17:55:52 +0100
Message-ID: <20261028170008.240371761@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -69,11 +69,14 @@ static int ucsi_displayport_enter(struct
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
 


