Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DFD1A08CA;
	Mon, 12 May 2025 17:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072475; cv=none; b=Vt2Sf5Q2Pzr1jJ+CFobReW7dRhrl7yKIibFsRclJmt+Tf7yH5FgqggW6yKe6bhgs0v2CkrXmRiiU+G6YfRnNSASP5okqnY2SKNpqpDqaEXjIWnhquRslO3SVyCbIHDATKePBm40xHjCH9MbTyPq18M1CLkUCI939E6QwHiG00eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072475; c=relaxed/simple;
	bh=G6j+wZ0yefUXsmLIPTlg8Xr5ihbKYfk9F6MO+YpOjHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ST5Yy4XIoTLcTtJB9GWMAZcgfxMnHKJiTOGzPIcUSPTU/8WF0P5c+5KDAzWqcBj4/3p5tM3JpNwdWkdgFkZMnxJ3t2Le6hV8UgEqk8Q4yG8Ldr9mrWKRH5hZHTMYWWLvM7pclHUXyj3wSZPzejn1XTK2YBW3srvkaEtC51LNrDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kwpemu6D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kwpemu6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91649C4CEE7;
	Mon, 12 May 2025 17:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072475;
	bh=G6j+wZ0yefUXsmLIPTlg8Xr5ihbKYfk9F6MO+YpOjHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kwpemu6DN9NGaRGa4P79quu113f03bGgG4tpK0p2IonTjr+KaLY7hp8GgDKnlcRpa
	 oRMvm/iIbw9NBsR1BKrhNcnSnOj7SHM4Y8iy1AP6J00zQuRsMD0oypywb9o6C4gR9A
	 pfqGFh622mb1dy2J/QpLM+9e0DnMEuVRh93ZFOYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuntao Chi <chotaotao1qaz2wsx@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 25/92] Input: synaptics - enable InterTouch on Dynabook Portege X30L-G
Date: Mon, 12 May 2025 19:45:00 +0200
Message-ID: <20250512172024.148990824@linuxfoundation.org>
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


