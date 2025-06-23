Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769191F6667;
	Mon, 23 Jun 2025 22:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717126; cv=none; b=a55N7EGome049EceGWPF28af0UT6SOR7wkrjDlPaTl+YMKc6SuDOPsQk/5z4fLbMh+uW0o0us58CM38Osn1+CjRKMoQirQkXAeoqTkmeLzx/o/A1M8/fL7/2Nt6o+8gbtYXzqW8KEMo8fxDzNDmWPwn1SKL7/VBDjMv5srktWOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717126; c=relaxed/simple;
	bh=NtkTUiM5Cj/R8fFnF0ORJvdBK9LSB8y22dhuKioeYWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhoOexedsXdznEuEKI2KSB4jVRQPIfh3jMoQNnpRisScNFzBEVQ7ylKAnav85akQYp/AsbKinXCVXpFk6h4S+DNHH2C7fR0knDbrC5OPI2/ZR9wwfOAcfQGIU2Bujxw5hKWCWiZ8oyV/A5fyoI0KsnVZqwLPxXO5Xpm5C2rzrYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T11iQ4gN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T11iQ4gN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC7AC4CEEA;
	Mon, 23 Jun 2025 22:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717126;
	bh=NtkTUiM5Cj/R8fFnF0ORJvdBK9LSB8y22dhuKioeYWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T11iQ4gNCpIygnr58tMZNt92kQGcV9knVM5DrwJXvW2xCI3IY4VennrvCMoyM3Hyx
	 OGkkCxW3m92leWGXqXg3LBjFMJ+94xjg9ZlaTr/SeOIApHEtFTc00UKV7Ug1X/u0kD
	 aRxFFmIE7OkR/XVcAiXBYbRdEpKCfb5MphgrEmQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyuli@uniontech.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 327/414] Input: sparcspkr - avoid unannotated fall-through
Date: Mon, 23 Jun 2025 15:07:44 +0200
Message-ID: <20250623130650.166461849@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


