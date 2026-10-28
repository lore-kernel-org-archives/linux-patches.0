Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212749;
	b=Jhg43V/Oa28aX4yyC6cJ8VkxuGm38b3QGJ+Vmt8O4+JVSrCRxN40rur3/DBrMm1HaW9t
	 ECMsQ4ErOVH01doJHLsXJ1ZotyowdlvudEAox/fNK1EngViWB9U6zsoqK2rG3BDWH5jUr
	 f3movZI9oR/15S917NztvuBu+qGpa9gyBJ+iACeDLYnMlvND5bWXgtt3z1vNzpNtpF3tL
	 UJWmhzorFJ8nWXsG4kPp2RyOKW7ioAUr7BtNMkaHqI4SBhdUbs4NJ1aR2jBi4/1B6cHkm
	 Iy4aYLruW9d4+jC08zsL8KQhWJIvQVUls96Kyj7DEbVWvUXo/CccSvpmOHet/nblpQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dj0Rh3tAo/5sRNGMDb0XdekH8XPeB+/TY2o3HkFjomQ=;
	b=B5aRUV9bxMuknQPk2TNzVo65wLadksriD9SHqmfhrgspDE/heNBjn3kXPILd9BadCosV
	 kwy720hhRb6XrAKju2wAljAzzpvlLbAxkFK1sI5BtPSgH7Z9AbQ8KVrb01GQEAcxmIGZr
	 CMrbPnSENyt0cTdjXZHGOLlf4Krm4YRRwIP0oSJWFMN9A0M/MVAO4lzFaRmjnwbIY5cez
	 sXBz99sUl0ZIa7tuyF9wwssKBorHzXjr623MRKR9eWtaLfzn4MSfBGTZF6ZY+/j2pTZIQ
	 kEGX7wHE1iMqihZEG9zDmYsel0yDleHJms2Xh2vYRJ2JBahWDhv48LixwchKqH80EeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PtoL16Hm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF23606A31C;
	Wed, 28 Oct 2026 18:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PtoL16Hm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5271F01825;
	Wed, 28 Oct 2026 18:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212749;
	bh=dj0Rh3tAo/5sRNGMDb0XdekH8XPeB+/TY2o3HkFjomQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PtoL16Hm6mJGkwG4DshHrO/vyKEQIqb8hzTNzVZEyDWgG1I6G3KxkwXDW15FIp4ql
	 FkboAsr5U5MQd92GW6Ap6v9zTeXhb3waf6n2sr5t7VxHEdkqNHHanqPVWIavOBLh4T
	 cPgchxdR3oesMzqsJ3ouFJWIWD3cMXX5f7L/FN1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Salmun <salmundani@gmail.com>,
	=?UTF-8?q?Rapha=C3=ABl=20Larocque?= <rlarocque@disroot.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 0264/1887] Input: synaptics - limit T440p InterTouch quirk to LEN0036
Date: Wed, 28 Oct 2026 17:39:20 +0100
Message-ID: <20261028170505.237016222@linuxfoundation.org>
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

From: Raphaël Larocque <rlarocque@disroot.org>

commit f0fd8993082ca229faa3f9844f1c9fe182eca20b upstream.

The ThinkPad L440 also uses board id 2722, but does not have the SMBus
initialization problem seen on the T440p. On the L440, the SMBus
companion becomes available shortly after psmouse probes, allowing the
touchpad to use SMBus/RMI4 normally.

The T440p's quirk is currently applied to all Synaptics touchpads with
board id 2722, unnecessarily disabling SMBus InterTouch on the L440,
as reported by Daniel Salmun.

Restrict the quirk to PNP ID LEN0036, which identifies the T440p, so
that other devices sharing board id 2722 retain their normal
SMBus/RMI4 operation.

Reported-by: Daniel Salmun <salmundani@gmail.com>
Link: https://lore.kernel.org/all/20260925230039.236786-1-salmundani@gmail.com/
Fixes: 26eb3d92c7a4 ("Input: synaptics - disable InterTouch on ThinkPad T440p (board id 2722)")
Cc: stable@vger.kernel.org
Signed-off-by: Raphaël Larocque <rlarocque@disroot.org>
Link: https://patch.msgid.link/20260927005810.85971-1-rlarocque@disroot.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1811,8 +1811,10 @@ static int synaptics_setup_intertouch(st
 			return -ENXIO;
 		}
 
-		/* Disable intertouch on known-broken board revisions */
-		if (info->board_id == 2722) {
+		/* Disable intertouch on known-broken T440p board revisions */
+		if (info->board_id == 2722 &&
+		    psmouse_matches_pnp_id(psmouse,
+					   (const char * const []){"LEN0036", NULL})) {
 			psmouse_info(psmouse,
 				     "Disabling intertouch for board id %u\n",
 				     info->board_id);


