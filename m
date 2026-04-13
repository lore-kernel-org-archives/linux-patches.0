Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBAE26CE32;
	Mon, 13 Apr 2026 16:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098236; cv=none; b=adZDwK8A5B34Brg9UQQamPAqhMqsUM3Xq6RSc4ZKvBrNVYAVEABj0FP3tzNzzo3YbeKdURsOxbEZaVDO6sjbJhfNR2DKw8Aui+pcfw48b3zUTYUWy8XzMKFjO2lNq8hJEnyjRwmnkBTztAazlHzuz5L5d9pv/OpSl3OBuyMs06w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098236; c=relaxed/simple;
	bh=KD3bMnoW6ZrzbNcQ7aUpVuQzwtMVpRMQlwfOR8JPYNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzDcGOJqcaxXyjqhB9bFAh6jQ/GplJNXWrVolWHU3cy2WcG46foLs0JVfHEEjsDGmR42qJ1yBLv5FT7eIaPSTS6kbhDXWYp521nC2hRKFbDi+wr78HYZOMyyiVAh8c7AGJ/2f5GoVxYGOQ68ehPLG7624EX1oc3KqT9lvQiho7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uky5C7h3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uky5C7h3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71A5C2BCAF;
	Mon, 13 Apr 2026 16:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098236;
	bh=KD3bMnoW6ZrzbNcQ7aUpVuQzwtMVpRMQlwfOR8JPYNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uky5C7h3K7rP1LvUa1GRZlWOw1JcBE0p36IGNLojYc+wX2gs4m6cleZK/kDUsDBw4
	 cam8FK0ep+kl8fVF3m+XtB9kHWln75DwTb2LLNA3Sh5roWXVYaYBXv4CFmWlZrC4XH
	 4IkCJhVuzSIf8xTdrkHrKtt6QQDESmVcVtByUXdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Karsten Hohmeier <linux@hohmatik.de>
Subject: [PATCH 5.15 447/570] ALSA: ctxfi: Fix missing SPDIFI1 index handling
Date: Mon, 13 Apr 2026 17:59:38 +0200
Message-ID: <20260413155847.214831178@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


