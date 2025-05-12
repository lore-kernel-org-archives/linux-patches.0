Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A4E78F52;
	Mon, 12 May 2025 17:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071036; cv=none; b=K/MNwSTAX48O4LFFeU3vqqAyq172WhVlxHt4coAQilBBTtaU44ok4mzAITGv8fItCDGa933xWJdVT8QqXwTtLP3yupjpy/qeiuAnICXXMWhKT/z9V2PQpyWhpkG4OFVd8skM7lpS3HHopTM+3fucXL9Wnww0/aBgQPEzicgx4ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071036; c=relaxed/simple;
	bh=x6+ksbR5vLQRBShNh8YJL/BPepu+Q3hQph8FhVCryio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gp9sfZMNKmPoqBQ7FyjS0HRfVCUrFarMs9/wr/wJfcnUyj9vShEirICM5MWJsTxhLr/0LkxkGraNpMxM10bLh/f5cJrc1QEJ1MfYxJbIHLqPGNdnG/0zN97wLz9rsFJfK/s6Sf851Z7TYjCboo/z5jYvWXP5QHOE1zyDJsnxjYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dh9MsSwA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dh9MsSwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D6AC4CEE7;
	Mon, 12 May 2025 17:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071036;
	bh=x6+ksbR5vLQRBShNh8YJL/BPepu+Q3hQph8FhVCryio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dh9MsSwAeP0+bXvsuiUYvqSMlUL2D1+bTpiXa8WOLswSZXJnsb4Z45g5TfMT4U1Bb
	 KfCTG0SFBUH4W17lIqsHA1GoV4/mqsBbB/fnrKVpUVcgKayk8u4IkUEHpUVCMfMThC
	 g7DIpK7SFpihkgHfKcAw/n4GL1sr4QygNDA3RZFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuntao Chi <chotaotao1qaz2wsx@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 16/54] Input: synaptics - enable InterTouch on Dynabook Portege X30L-G
Date: Mon, 12 May 2025 19:29:28 +0200
Message-ID: <20250512172016.302603943@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


