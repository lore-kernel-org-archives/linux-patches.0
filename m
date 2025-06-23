Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4175070838;
	Mon, 23 Jun 2025 21:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715922; cv=none; b=PGDroJPvWrrD12KrhArbqbf4FLuVDBYeEf+0CckJBmxJxkP4w8ocSDGnubhZbzFzgkJoxqhGIRK/EV8oo22ksf8d6m4u5Gfw99H95fxvwX1xeufqYvBtAEcG1/j9MZP4huV15/drQH5mT/UzZ82N4FY+gn1szVF+jlvgppLKwQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715922; c=relaxed/simple;
	bh=/PCe7GJZoY/tZD99C3UmS3qOTQpPpNkmJzq+7+W1Rf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/i62pv04DMEQ74LZZsD4iqyVpjK2ikADgP3EVAsqIqvD9W2QokUuuEwyBouum2ANkdFV9+Wfx1bKPuVMyrE9EvE/JnK+hAcgf+at5aFzudc0KVxv7wobmsOpC+WIW42d8NKHDsv8LM6l61VqqIYAIoBfWkhdc/ixzIa9x5zNt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMf9UU0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMf9UU0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3A5C4CEEA;
	Mon, 23 Jun 2025 21:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715922;
	bh=/PCe7GJZoY/tZD99C3UmS3qOTQpPpNkmJzq+7+W1Rf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pMf9UU0HFDvnGMc/nn6cXNBMh9Ge+mngug3gAIfPrswEsRNHV39eK1yicA0Fc53o9
	 pFqy2+wqNhSAbMkaI2Y/UA7lzO1MfTSpVk77Q9HBf5+8RV+/oJK1ZlJsdE1+PHl4kf
	 N3pHhovQNiOKAQwwV3Z5tcxnIqsuy7zMLeGtSQ4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyuli@uniontech.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 229/290] Input: sparcspkr - avoid unannotated fall-through
Date: Mon, 23 Jun 2025 15:08:10 +0200
Message-ID: <20250623130633.815426015@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

From: WangYuli <wangyuli@uniontech.com>

commit 8b1d858cbd4e1800e9336404ba7892b5a721230d upstream.

Fix follow warnings with clang-21i (and reformat for clarity):
  drivers/input/misc/sparcspkr.c:78:3: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
     78 |                 case SND_TONE: break;
        |                 ^
  drivers/input/misc/sparcspkr.c:78:3: note: insert 'break;' to avoid fall-through
     78 |                 case SND_TONE: break;
        |                 ^
        |                 break;
  drivers/input/misc/sparcspkr.c:113:3: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
    113 |                 case SND_TONE: break;
        |                 ^
  drivers/input/misc/sparcspkr.c:113:3: note: insert 'break;' to avoid fall-through
    113 |                 case SND_TONE: break;
        |                 ^
        |                 break;
  2 warnings generated.

Signed-off-by: WangYuli <wangyuli@uniontech.com>
Link: https://lore.kernel.org/r/6730E40353C76908+20250415052439.155051-1-wangyuli@uniontech.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/sparcspkr.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/input/misc/sparcspkr.c
+++ b/drivers/input/misc/sparcspkr.c
@@ -75,9 +75,14 @@ static int bbc_spkr_event(struct input_d
 		return -1;
 
 	switch (code) {
-		case SND_BELL: if (value) value = 1000;
-		case SND_TONE: break;
-		default: return -1;
+	case SND_BELL:
+		if (value)
+			value = 1000;
+		break;
+	case SND_TONE:
+		break;
+	default:
+		return -1;
 	}
 
 	if (value > 20 && value < 32767)
@@ -113,9 +118,14 @@ static int grover_spkr_event(struct inpu
 		return -1;
 
 	switch (code) {
-		case SND_BELL: if (value) value = 1000;
-		case SND_TONE: break;
-		default: return -1;
+	case SND_BELL:
+		if (value)
+			value = 1000;
+		break;
+	case SND_TONE:
+		break;
+	default:
+		return -1;
 	}
 
 	if (value > 20 && value < 32767)


