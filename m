Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620457;
	b=uCcVgMRpMOVwEAVt7Tq5haJCdaJEbtgu9AtG8QhS13a3Ywu0lp01grB6eIlDSV7Gg/G6
	 4U0hK3spXTWFqJULaFLD0X3WIc+yihButFpjouSOjFm9fpz8cGUmSN/KxkC/3GZAG56Fi
	 JyB8Y+yZtZBFdHHacw26UtScXvekjkQmlMsIB3Ki7tTqNaeCxTPXCjeRI4MhdZg4oFert
	 HFVq9NUlJ3YAiaV0i3PySTjG2B2lYc+CZsU6Yot4v8RVhXkgqoJ6JBzLKfVUUMQdxxNEF
	 p5G+TL2qB8qIuuCkNl3s5ckQQsw2O2UArnMWoK6LDynGchUipiHuSDTbpMU0dGBECnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=muZsG/RnJ80RsC6aksWPYj6d0vWCye/gsL5UpmVacyE=;
	b=avpzE6L2C+xqC+2+yVBH/3lUjBVwNWeaH7XrDSwd000SXHoq2NoWLGgX+4mnAreunBlW
	 0vqyWtDMyARbRgLajzX/ouVwTXASUovICJVx40SPl9y87AVxUwDM+DriGZbkxrKV9bvDK
	 5hCB0P+5sZZY8SdSN4MAGPCwbVTJjqwZjByQKV586515qyr6hW81XII3eIF5Rum2wfQnT
	 FjLj0B9ju3m3pqg+of6WNJ2ek/8w126+LEc3UeQwy/xzEDAj9R7NsKN39RhZDkNRHncAQ
	 kFUyXmeBKuHHqXa8cfjmRrGNw1pl6y4Gb5wr1VAsl31kNp5oUQFR7ueCBBG3Oi98W4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W3gpLzkq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7A9606A326;
	Wed, 25 Nov 2026 15:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W3gpLzkq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A181F000CA;
	Wed, 25 Nov 2026 15:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620456;
	bh=muZsG/RnJ80RsC6aksWPYj6d0vWCye/gsL5UpmVacyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W3gpLzkqSiMN27NCxpIp7oNZVm9OMvXT5tMo0S6LBNlGhXNukmkRVic+h/ibFNrvZ
	 AAxsffMjw8VBAgioF8qtcdnAVkjNKOh59o4+2g9wTDS7Wtqb3L0fViYHCCSFmGEB2v
	 rBMq6v59X/iN9cfG6S8khCmGwBZzhHZh/74aFLhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?Ali=20Ahmet=20Memi=C5=9F?= <aliamemis@disroot.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 7.3 0923/1005] usb: typec: ucsi: debugfs: Fix GET commands on UCSI < 2.0
Date: Wed, 25 Nov 2026 15:37:41 +0100
Message-ID: <20261125143843.309413657@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memiş <aliamemis@disroot.org>

commit 7cfb037005c04b9dee5b0c4626e56e2eddeef157 upstream.

Since the debugfs response buffer grew to 24 bytes, every GET command
fails with -EINVAL on UCSI < 2.0, where the data length is limited to 16
bytes. Clamp the length to UCSI_MAX_DATA_LENGTH().

Fixes: d9dc19910321 ("usb: typec: ucsi: Fix debugfs response truncation beyond 16 bytes")
Cc: stable <stable@kernel.org>
Signed-off-by: Ali Ahmet Memiş <aliamemis@disroot.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20261024174441.878903-1-aliamemis@disroot.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/debugfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/ucsi/debugfs.c b/drivers/usb/typec/ucsi/debugfs.c
index 77a0dd75edd3..3cffd3778c67 100644
--- a/drivers/usb/typec/ucsi/debugfs.c
+++ b/drivers/usb/typec/ucsi/debugfs.c
@@ -60,7 +60,8 @@ static int ucsi_cmd(void *data, u64 val)
 	case UCSI_GET_LPM_PPM_INFO:
 		ret = ucsi_send_command(ucsi, val,
 					&ucsi->debugfs->response,
-					sizeof(ucsi->debugfs->response));
+					min(sizeof(ucsi->debugfs->response),
+					    UCSI_MAX_DATA_LENGTH(ucsi)));
 		break;
 	default:
 		ret = -EOPNOTSUPP;
-- 
2.56.1



