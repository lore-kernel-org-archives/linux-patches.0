Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7844254863;
	Mon, 12 May 2025 17:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072440; cv=none; b=Y3SPOvj4QTBXbh24198+nt7NFsD7DWsvs9/zgtx+Qog+xno74MBPs9gHQo3dv1opuUhGGbDn3KPJzNMge/Ozy8hoqEpn7u+eHLyxkC94o+pULxIn6iAaxO9FQsZ3z/9kHk+JdtG+RnCDeJ2BbG1jhBfN1ziW59oYq9KpCAihWjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072440; c=relaxed/simple;
	bh=rUWs6h94fMOLLCoebxLslrenjNOw+mNKb3V+A7QkYek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7DLxtrMLw8w5HopcS1ojOmFNknXkShZ/Tu6WXQvEE4m9je8K69LTM0vCxsU5NU+t3daRNjowtx7emuYz6XzMYSfa4M/vIhnuHNJsdzka9aaDT4T9h0oLuxwl2+XEC+fys6xZCR8v/ft0aChb8/FGbO9queg9pZcQlXU5zYvisk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SkX+0Px2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkX+0Px2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D71C4CEE7;
	Mon, 12 May 2025 17:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072440;
	bh=rUWs6h94fMOLLCoebxLslrenjNOw+mNKb3V+A7QkYek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SkX+0Px2GvA2+m2b7tmgYS/9Y3siEWhU2G547EW7uJAo3ZzYhu9VJoGD4speMc7Qz
	 OOazxLQQIAhBkWLv7Y41zVeaVayD5SeQTyQXsdMH7duJqif4qKALxt90cvwweJPHIM
	 bydau4vCIJNerGNtmii9PgKN5NHP95EzPb/l1R1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Aditya Garg <gargaditya08@live.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 24/92] Input: synaptics - enable InterTouch on Dynabook Portege X30-D
Date: Mon, 12 May 2025 19:44:59 +0200
Message-ID: <20250512172024.107065669@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manuel Fombuena <fombuena@outlook.com>

commit 6d7ea0881000966607772451b789b5fb5766f11d upstream.

[    5.989588] psmouse serio1: synaptics: Your touchpad (PNP: TOS0213 PNP0f03) says it can support a different bus. If i2c-hid and hid-rmi are not used, you might want to try setting psmouse.synaptics_intertouch to 1 and report this to linux-input@vger.kernel.org.
[    6.039923] psmouse serio1: synaptics: Touchpad model: 1, fw: 9.32, id: 0x1e2a1, caps: 0xf00223/0x840300/0x12e800/0x52d884, board id: 3322, fw id: 2658004

The board is labelled TM3322.

Present on the Toshiba / Dynabook Portege X30-D and possibly others.

Confirmed working well with psmouse.synaptics_intertouch=1 and local build.

Signed-off-by: Manuel Fombuena <fombuena@outlook.com>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Link: https://lore.kernel.org/r/PN3PR01MB9597711E7933A08389FEC31DB888A@PN3PR01MB9597.INDPRD01.PROD.OUTLOOK.COM
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -194,6 +194,7 @@ static const char * const smbus_pnp_ids[
 	"SYN3221", /* HP 15-ay000 */
 	"SYN323d", /* HP Spectre X360 13-w013dx */
 	"SYN3257", /* HP Envy 13-ad105ng */
+	"TOS0213", /* Dynabook Portege X30-D */
 	NULL
 };
 


