Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210973;
	b=NxCSdCOaM0MW9CWfWlik8Zgcxi65qlOCdM2Pp+H60MjT3pXzG2F1bysC7I8y0hyhYpu3
	 POnKJZwSsOxOZyx6JdpG9AO97RZK0rC2nfrMDejgZvWpXcABYPopEyg9mxKSHqFB4Gguq
	 TxjvxyIcpMgTdLPqjC8f0R6upNiutxNTJozwJ2X96o4DJI8AgqWtLUB1zCbdqdeOPlT2f
	 6Gy2FysnrbxR1mKpYQCNmjSNyctkv4WFRQQJH108TYAUlzImOzp3ypMQY83SjoYcv3BYA
	 0C8isFF9bLW1BewT8B0/bQPpZ5sEr5zoylZDZlHb0lx7ZZiN4lccbNInhzTPRxiG9YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210973;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=99vRIJ9okXU51AvvJsdqLXA/iKHoEuffbwdcDjf1hcI=;
	b=rEh7vb1ZdTp7VKkj5Xs6G000R+bWAUMZzx78IOMpIR5jv97iLnLsDxc3AacXJNR1z37W
	 +GGfmjfDVn3u/waXaQN5VHC9plUlNov4U6IWaVZfijiU+Gw4z76pAKkC8S4IsYLSDv3ds
	 hfu/hAEI5J2mj2jXVfGt9ISfFUvm470UfEsmwaLgLvmdYNasbPkrAX7K9QuM/8VNVuLC0
	 wq+VtL2TW2rjMpaoq39j3kuW7Ac85QB5ZzOc+iChh4W7erw/yQdcMhStn/iYlC5n0yEj3
	 kwMtypO2okf0EegMQbZtGblxokU5ftbF/LCcC7VvP6IU7kpRmGF1EFhKSGo3eCDlEHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XdZKfgMD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40172606A31A;
	Wed, 28 Oct 2026 18:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XdZKfgMD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC551F01825;
	Wed, 28 Oct 2026 18:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210973;
	bh=99vRIJ9okXU51AvvJsdqLXA/iKHoEuffbwdcDjf1hcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XdZKfgMDNE5G0UWOrslcd6M+LGbwoeaioXGyO4pXEL5nigx/qa5cSepxKSqyTqJ0/
	 Uiamyi+5s6WcN4Kv+ZwLCH3khESlIQT+E/n0jwzBqIG2+aGOS1mnkIpCCzAdMmSWL3
	 VLiknR5e0X9HaM8F1wrYQog7OTd+Eu24w8KrZCnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Benson Leung <bleung@chromium.org>,
	Jameson Thies <jthies@google.com>
Subject: [PATCH 5.15 213/571] usb: typec: ucsi: displayport: Current CAM OOB index fixup
Date: Wed, 28 Oct 2026 17:56:00 +0100
Message-ID: <20261028170013.057319988@linuxfoundation.org>
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
 


