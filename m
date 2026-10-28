Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213343;
	b=t/2SUos+ZlQtllToYy7+APMCRGCNRgM6Y7P6k1X65XPgQ8hM42UX8J9bUXhwbrTay6Za
	 w2pmjuhZm5MMnJGxtMFM2+b7HJU4GkyDc6VFdTJaZGLqpgZD3rplgO8eZt/y56MVqNVYW
	 QcrRPgM2QQjm1+4V1dR1NHYLQ0GqbJsxpW46qd2BtROd5sz4AIZaOspdarjcvJJqXKL+B
	 GZHZwEw6nMwyuSDe5eERojxqnVVqLqZzckz48XZsvzM0mOhtO39WeHkI+NNI1hlffkrDb
	 MPvKJSRAIqZV196zhRmUyGT69lh5vNIF4xDmzoKGavx6N+9wVdwlWX3JgbPWD7L3/AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EV/m65ICJ1oljOXRyQTdpGmAPcWx5FcC6OSAYeIlCqo=;
	b=SzEVC2qocaNLAaKeULYEBXerDmBiVUiO95QGZDmP15s7J/GABfspoIiCH5zgh2Xqoj6l
	 9S55lAYCqHZTeVftUHeODqM0Qd9TJim9baKjKZH+Cps9n2SYoKNQkdWL7ZADBxalsPHBk
	 p2uKkBO8CFcGxH0/6WrQWa7FBwdcHfW9BuoJsw4q+tMMdYwPZnVN2YNYXYDRoLRIB2XLF
	 fZSs7ViiKm2BE6uZv8zLzbOpoay1Rp0f1yoMzkkuza0ZML9J5tcvCq8Th0vKKWJJ4bKzy
	 mkNUFaRTJjznofkEJlC6a/FnrSrsi1zdnqxa3/fq32pEVz8ahcAZzB5SJAcvSb1qSGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zIgi3r3S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF83606A31C;
	Wed, 28 Oct 2026 18:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zIgi3r3S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A90F1F01825;
	Wed, 28 Oct 2026 18:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213342;
	bh=EV/m65ICJ1oljOXRyQTdpGmAPcWx5FcC6OSAYeIlCqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zIgi3r3Sg10qpj2fodhFkIUpaRqr6RX9TcB4Phk/6Kz8LKX/ihToEKJQa0HpgsOK+
	 o0RDXtBdFmr3Td23ifcJWIBrDfOk7z5OHkxbqEX74co2BZCCImPpemxqzppEnGiHpZ
	 3mihJm4vK226RDyXz6tl66jMkYOfnTz676T8ATi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iaroslav Voitovych <yaroslav.voytovych@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 0471/1887] Bluetooth: MGMT: Fix status of pending commands flushed on power off
Date: Wed, 28 Oct 2026 17:42:47 +0100
Message-ID: <20261028170509.956803608@linuxfoundation.org>
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

From: Iaroslav Voitovych <yaroslav.voytovych@gmail.com>

commit 86ef0f58bdecdedb3a1240971c56d71b7e4ce3fc upstream.

cmd_complete_rsp() receives a struct cmd_lookup and, for a pending
command that has no cmd_complete callback, falls through to
cmd_status_rsp(cmd, data). cmd_status_rsp() reads data as a u8 *, so
the status sent comes from the first byte of match->sk's
representation, not from match->mgmt_status.

commit f53e1c9c726d ("Bluetooth: MGMT: Fix possible crash on
mgmt_index_removed") changed the callers' data from &status to &match
and updated the cmd_complete branch to match->mgmt_status, but left
the fall-through passing data unchanged.

In mgmt_index_removed() match->sk is NULL, so every such command is
answered with status 0x00 (Success) instead of
MGMT_STATUS_INVALID_INDEX. In __mgmt_power_off() it is NULL too,
unless a Set Powered command was pending: then settings_rsp() has
stored that command's socket in match->sk, and the byte sent comes
from the socket pointer. Either way the status the caller set,
MGMT_STATUS_NOT_POWERED (or MGMT_STATUS_INVALID_INDEX when the device
is being unregistered), is lost.

Pass the status the callers set.

This was seen on a QCA9377 laptop: bluetoothd's Start Discovery,
pending when the adapter was powered off, was answered with Command
Status 0x00 and no parameters, and bluetoothd 5.72 crashed on the
zero-length success. BlueZ master has since added the length check
on that path ("adapter: Fix crash on short start discovery reply",
BlueZ a734b06059cb), but userspace should still be told Not Powered,
not Success.

Tested on Ubuntu 7.0.0-31 with a virtual controller (hci_vhci):
power off is held in HCI Write Scan Enable while a Start Discovery is
submitted, and the flush answers it with status 0x00 before this
change and 0x0f (Not Powered) after.

Fixes: f53e1c9c726d ("Bluetooth: MGMT: Fix possible crash on mgmt_index_removed")
Cc: stable@vger.kernel.org
Signed-off-by: Iaroslav Voitovych <yaroslav.voytovych@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -1453,7 +1453,7 @@ static void cmd_complete_rsp(struct mgmt
 		return;
 	}
 
-	cmd_status_rsp(cmd, data);
+	cmd_status_rsp(cmd, &match->mgmt_status);
 }
 
 static int generic_cmd_complete(struct mgmt_pending_cmd *cmd, u8 status)


