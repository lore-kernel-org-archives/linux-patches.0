Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0525E31F9BC;
	Mon, 13 Apr 2026 16:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099512; cv=none; b=GIFo3zU3MMRYld5zNXRDnxcyuAZTmp3ER3tiuRB/643A8KisTlUvTMuhaZNHpvMwHb0V8Nt4ABe8zNLjzCO4ynZ0Abi7TUm1FFTRIlk1ecI2eNmj2LSKt8+Xp24BSHyry4ZtTm4UKtQqD798wnWHVucbiN+ih9gJdqvzvBMuTP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099512; c=relaxed/simple;
	bh=KmDOoKklymDAZpCX6zomQ3eEthJhZlxnhUGJGPsN+CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fW2atVfSyR9mJPtC5F5kzWnnBP/kHMZb2Ru4EsWxr32MbhZ4gt3g1L2yypeHerGx0Dt+Di0qaKEsevSpWxajzb14Ue1ZCrITSHkO4ab5ioRPQDZK4sU755bgEdnSBD8Lq/gaph/tu6RMG2U34V1nn7jsQOvhKJV9f6qh+fxlTLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ihO7oHrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ihO7oHrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7F1C2BCB3;
	Mon, 13 Apr 2026 16:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099511;
	bh=KmDOoKklymDAZpCX6zomQ3eEthJhZlxnhUGJGPsN+CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ihO7oHrNTyZhoYD3OWITDsglexnHXs8Uuc1e/HTp/mJ5WsadIeZ9QBFtt+6GQ9uMJ
	 33j4IL7zvEaJnW6CXBgqW+7yWJBAf8cudR7OUwGEWr2MRXhLkatIDv04u97j/0STU5
	 5gtgCurQrUgb4KepmiNaRzmJtRYiIc61gFbSr588=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Karsten Hohmeier <linux@hohmatik.de>
Subject: [PATCH 5.10 368/491] ALSA: ctxfi: Fix missing SPDIFI1 index handling
Date: Mon, 13 Apr 2026 18:00:13 +0200
Message-ID: <20260413155832.811242619@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Takashi Iwai <tiwai@suse.de>

commit b045ab3dff97edae6d538eeff900a34c098761f8 upstream.

SPDIF1 DAIO type isn't properly handled in daio_device_index() for
hw20k2, and it returned -EINVAL, which ended up with the out-of-bounds
array access.  Follow the hw20k1 pattern and return the proper index
for this type, too.

Reported-and-tested-by: Karsten Hohmeier <linux@hohmatik.de>
Closes: https://lore.kernel.org/20260315155004.15633-1-linux@hohmatik.de
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260329091240.420194-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/ctxfi/ctdaio.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/ctxfi/ctdaio.c
+++ b/sound/pci/ctxfi/ctdaio.c
@@ -119,6 +119,7 @@ static unsigned int daio_device_index(en
 		switch (type) {
 		case SPDIFOO:	return 0;
 		case SPDIFIO:	return 0;
+		case SPDIFI1:	return 1;
 		case LINEO1:	return 4;
 		case LINEO2:	return 7;
 		case LINEO3:	return 5;


