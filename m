Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8700946AF1E;
	Tue, 16 Jun 2026 17:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631147; cv=none; b=Z0J9wpzN7iUZuwbixOZsV7dzU1dFJIPYj70k2U/DgEYWO5nTwjCSUVPhaP0Iobo5D5Vw3NCW66oGcK/NsrzSbaYun9rH8LLZeZeCWu7bZfKoyqEYYhu4ojvRQUA50+lywvf0MIvpYxI77zQ8v/JoRu8VrdLrf7shT50PvFVSEVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631147; c=relaxed/simple;
	bh=Rck4v8BZVxXQwxbsjtl4k8dbuGVrqL2ZXl6VRa3IgLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U59RzpFTc+m3Kb3NR8/NJ0TsaIFjR3ioEnU/tVmxNISZiN1fHqybMy9SW1HlzhhjHs+IgLu8PfVQk8ng8u03yvrllYXQ8W8FuJ+Eb3M9u0XLzTklbWco26ZJDKpoXroiJPz5dUX0+d+RT4Rj13mdXUUsQLMT3+ocVGWBjD6BA1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4ZkNpWq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4ZkNpWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE081F000E9;
	Tue, 16 Jun 2026 17:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631146;
	bh=YS0UURF3mXA1IYuELmJ12RQBBuBoTd/Kp8Rq5Hf01ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e4ZkNpWqhyKDAjJcT3XH21+6nK/MuAzF0hjeTKoyrTdsx/YmYA+DvU14zmk2UbPeJ
	 91XUwwozNRktSn4R7IfXg2BH5dxITigCDcx2tsrvSb4hgjj9X039ir4lBx/r46stqC
	 Ep1B7hkMwKwIGVsxXNxltnw2naKMTodAHJ1Ewd7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nicol=C3=A1s=20Bazaes?= <contacto@bazaes.cl>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 138/522] Input: synaptics - add LEN2058 to SMBus passlist for ThinkPad E490
Date: Tue, 16 Jun 2026 20:24:45 +0530
Message-ID: <20260616145132.558258575@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolás Bazaes <contacto@bazaes.cl>

commit 16ca52bc209fa4bf9239cd9e5643e95533476b58 upstream.

The Lenovo ThinkPad E490 (PNP ID: LEN2058) has a Synaptics TM3471-020
touchpad that supports SMBus/RMI4 mode but is not listed in
smbus_pnp_ids[]. Without this entry, RMI4 over SMBus is not enabled
by default, and the touchpad falls back to PS/2 mode.

Adding LEN2058 to the passlist enables automatic RMI4 detection without
requiring the psmouse.synaptics_intertouch parameter, and matches
the behavior of similar ThinkPad models already in the list
(E480/LEN2054, E580/LEN2055).

Tested on ThinkPad E490 with kernel 7.0.5-zen1 and Arch Linux.
RMI4 over SMBus is confirmed working without any kernel parameters.

Signed-off-by: Nicolás Bazaes <contacto@bazaes.cl>
Assisted-by: Claude:claude-sonnet-4-6
Link: https://patch.msgid.link/20260514013552.14234-1-contacto@bazaes.cl
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -189,6 +189,7 @@ static const char * const smbus_pnp_ids[
 	"LEN2044", /* L470  */
 	"LEN2054", /* E480 */
 	"LEN2055", /* E580 */
+	"LEN2058", /* E490 */
 	"LEN2068", /* T14 Gen 1 */
 	"SYN1221", /* TUXEDO InfinityBook Pro 14 v5 */
 	"SYN3003", /* HP EliteBook 850 G1 */


