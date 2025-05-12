Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7AA297102;
	Mon, 12 May 2025 18:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073302; cv=none; b=U3M3ZUitdXBpVVOPjzXKJfOdtcCoW73uIaxfU9JPWqn6mg7ljE7f8PM2WX84Iszltkzc0aibxYKftsDidSQ0iLzo47GSwUX51Y01b4tSm255EccCGpAYII8Oc2/R5lFUGTA6lGZktz2/c+6bjXchMbqMiP4ANI+cryJlPYQ4N8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073302; c=relaxed/simple;
	bh=XPJXSVPmCSLr5nECEI/dnGaOrvjsO4whIMLwsUR5Ygw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vB0g9eM/aYdicqt/jA97OAeuy+M2OWlzNHA1AoONW4k/WJ3z/yeNqjwc+uSvzQyCwa26QmZfzQ0sl5uAVcqgnI/HwnxjDTzX5mnUXZV7Psahlyyb17ztHM175AWurPPxZ8QJ0h/wLWIQ6wNW2fXXZY2rNjI0A33eNrwsBxlJNOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CsF1zPct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CsF1zPct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DDEC4CEE7;
	Mon, 12 May 2025 18:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073301;
	bh=XPJXSVPmCSLr5nECEI/dnGaOrvjsO4whIMLwsUR5Ygw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CsF1zPctyhYwXWphUuvlOMkoRhhhoy4h8M7Ir2XMIM9Cu3PY867mXHJe/MLW5yszb
	 P8T+6smhza4eP/1AWCloYbGXa263YSKuDnWuqACS7QmoPiG7zZTkEZ4TacYXfkjqbp
	 2HyIlzud2G+fvxzKoTZAAN+UEUNbYe+wyL168d5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuntao Chi <chotaotao1qaz2wsx@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 033/113] Input: synaptics - enable InterTouch on Dynabook Portege X30L-G
Date: Mon, 12 May 2025 19:45:22 +0200
Message-ID: <20250512172029.021990561@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Garg <gargaditya08@live.com>

commit 47d768b32e644b56901bb4bbbdb1feb01ea86c85 upstream.

Enable InterTouch mode on Dynabook Portege X30L-G by adding "TOS01f6" to
the list of SMBus-enabled variants.

Reported-by: Xuntao Chi <chotaotao1qaz2wsx@gmail.com>
Tested-by: Xuntao Chi <chotaotao1qaz2wsx@gmail.com>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Link: https://lore.kernel.org/r/PN3PR01MB959786E4AC797160CDA93012B888A@PN3PR01MB9597.INDPRD01.PROD.OUTLOOK.COM
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
+	"TOS01f6", /* Dynabook Portege X30L-G */
 	"TOS0213", /* Dynabook Portege X30-D */
 	NULL
 };


