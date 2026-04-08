Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228E93D9033;
	Wed,  8 Apr 2026 18:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672621; cv=none; b=tVpuvxw9fA1Fb/9TOub9dQEAYzLwaTV5kXaEJkwd591uOE0Q45OQyGCtUDTZsxSRTuBg1w5vhNHqvxBhGvXya/kFVjJBMjMs50H4gP6VmTHQmoevd8InPLeKGQ+WdPy5A74OEwItiCUqRVmZ4irhIVHf7ssjIVKYqM9p8JvhSB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672621; c=relaxed/simple;
	bh=0VP1pkd9Z6TsEmZHWupoKBeRB2wwsbdZppUdimOjy0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6kX+m8Hcy3l0bJMw0Lm3sCvcVbJHDFu4m/3a2SL6kL1ET4/8iSjopCJ2LYDtl7Okl/9tjUPg5mR1ujHUqAZKgesyL3NiM4ebSq1AURfbaOo94+JMEXtPFDTInwDRgsvCUugv6KZEPzQfKYYKph4FH6L546xMi2wZupeeF1h3ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mKZuyVs4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mKZuyVs4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6F1C19421;
	Wed,  8 Apr 2026 18:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672621;
	bh=0VP1pkd9Z6TsEmZHWupoKBeRB2wwsbdZppUdimOjy0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKZuyVs49pELfXp7bPNCwuw0U3X9hT+kCq79M/cPxR5VT7Yu1EIYrrtgt80K9sjTE
	 SQhJ6pfYqn6II/LXXcC7hEs6CYtJFImW+yJ8IwIWun/1pDWh0pZb2TOPcq55dvkViH
	 ov93s4e1J4sKHwge5FqFvN9yLlnE8qkJr2VN2ago=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Karsten Hohmeier <linux@hohmatik.de>
Subject: [PATCH 6.6 078/160] ALSA: ctxfi: Fix missing SPDIFI1 index handling
Date: Wed,  8 Apr 2026 20:02:45 +0200
Message-ID: <20260408175916.108508690@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


