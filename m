Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FC92D8378;
	Sun,  7 Jun 2026 10:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829340; cv=none; b=R9/YCWV1ThcyeXAvXooqgManHKVepMdrzzNaltgtMED4p1pwhOjuZ6jDMWERNtazI6V+jsI6Dapm0yObdtxoGKfcmc3QZbmhDspoS4OOQPPEE1jU991K2Qo9ZRzVtBpYQmbof9gS+PcTOy8F/4sdJakxH5+cgPV+0LsxLpPL1qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829340; c=relaxed/simple;
	bh=Wz+TyvLnNvvp1zTn2nkhF2RKvjvV3QSZFpSFM0jUDxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ehea1dgCZQMM1pfZlm3u0VIfl1ap9U+SAU26mICDzHX4gIeDmlgtlPFIJSFOoLYSfflRzQH0ygnRzjwT8MGyhpt4bbErcVFLAq2y0AljYSLPLacUrTIvEcO5tmHgDuaM3gUMChlQr/xK3fZACEvgogPvlujCiKTpAvEz6ABtyW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LnvRHn/u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LnvRHn/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044571F00893;
	Sun,  7 Jun 2026 10:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829339;
	bh=SyMMQ4iGqyDFujAcqOuzOMgHa7vSydvJiu6HZypHmyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LnvRHn/uk7orhUJZ7verDlXhjUTrChrrSBXvyzK9GO6nioLoV0yZXBWR5xrqzrBx5
	 EvyRSOeAYES6H6XMhYSRfv2Wdcfar8t5oQUxK+ZpWB0u8rh2eN3EIcIF2XIeuoIA6c
	 4iemGhaVMIoq0I9qR+FB4htH8RalPFMh9dYGHTI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nicol=C3=A1s=20Bazaes?= <contacto@bazaes.cl>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.0 242/332] Input: synaptics - add LEN2058 to SMBus passlist for ThinkPad E490
Date: Sun,  7 Jun 2026 12:00:11 +0200
Message-ID: <20260607095736.938740157@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -190,6 +190,7 @@ static const char * const smbus_pnp_ids[
 	"LEN2044", /* L470  */
 	"LEN2054", /* E480 */
 	"LEN2055", /* E580 */
+	"LEN2058", /* E490 */
 	"LEN2068", /* T14 Gen 1 */
 	"SYN1221", /* TUXEDO InfinityBook Pro 14 v5 */
 	"SYN3003", /* HP EliteBook 850 G1 */


