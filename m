Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F67227EAE;
	Mon,  2 Jun 2025 14:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875177; cv=none; b=jXW0IlSyideo+p9DtE4clQT/UhPmoiJ4MjVkpXecJEnw6sx5KoGnBVEA0thgbDLxnS+1PY0kPbOhjHKnaJxYmvwwFmdsGqfiNvLsA/svo4QxrQkMSrjplb+/XE5c6PeIBSXtkeIfGMMUXte0u+sJQfI9eB0WJxvtA3JlVMgyNu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875177; c=relaxed/simple;
	bh=jJlo8Cj3n1s0RQwr2aVAGdXvRSbGVlZ4uBnlLRhHmlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWsRaljjmNZ0I8ZRgeFfulI8Bq00TnJFcfCVpTnX3NcnSTdiYIps8Se5Y1jFC227u3SyqdH121L0IVVci/xlHANQpzfJHc7eCvXhJFGQThGCMf9jpRwG+dTRIz2T6zqQM/jm7Q2Z49r5QO2h9z17T0ZX8eQpQnCWG98GZCOjnWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQmvojDV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQmvojDV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318CFC4CEEB;
	Mon,  2 Jun 2025 14:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875177;
	bh=jJlo8Cj3n1s0RQwr2aVAGdXvRSbGVlZ4uBnlLRhHmlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DQmvojDVUzWu62R5FwtfSfpcGxFHsa/IBUzEVGUb86VvNrLpTY5sw5vE//ozFfoe8
	 +A5o+o6swDrR643hm276DJjAqNSxPsB+XfPdAMCgs3teryNbi40vuEBOAyGNA8JJ8a
	 dYLHzjD4TZt2VfudTdB1D7+WH2C4DOkbxTC4cjLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuntao Chi <chotaotao1qaz2wsx@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 052/270] Input: synaptics - enable InterTouch on Dynabook Portege X30L-G
Date: Mon,  2 Jun 2025 15:45:37 +0200
Message-ID: <20250602134309.321561041@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -192,6 +192,7 @@ static const char * const smbus_pnp_ids[
 	"SYN3221", /* HP 15-ay000 */
 	"SYN323d", /* HP Spectre X360 13-w013dx */
 	"SYN3257", /* HP Envy 13-ad105ng */
+	"TOS01f6", /* Dynabook Portege X30L-G */
 	"TOS0213", /* Dynabook Portege X30-D */
 	NULL
 };


