Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33172385513;
	Wed,  8 Apr 2026 18:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672134; cv=none; b=j+P19t/rg0wr1NCxMYXp/Ql5RsCo1/tMwCvnL/YMXDwbQAzxwwdRiZHPnBTczCjvVZbtdT8UCVhovw7bmMLV6iFGkMd/1tzu1RGljJIkkc6AzzwxBddeSlTzqRJ3NFX4Kv4LmpDbNWA1UWJEKWOpCGmtKf/m/bhykaSsiI5OjCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672134; c=relaxed/simple;
	bh=HqQUYJYVFxIs8MdAWpCkj+nvK7t2ITfqL1wDpbiWHIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZO1k0eOItqZ5gpEacoBzVcjCaZcnprC8Meuntm4mqWjYI+T7rFJD1N8dgqJKn9odl1pfzuTQAXxonEwsnQSmTjJl7M3YhNURLDlVJgYzHy4eUsJDeEUJIE6YAER1J7T/haVDzn/PbohT+hB0c/wUxWHsY2K/xA83lRP9Mr83ihc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVsFBFig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVsFBFig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA1EC19421;
	Wed,  8 Apr 2026 18:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672134;
	bh=HqQUYJYVFxIs8MdAWpCkj+nvK7t2ITfqL1wDpbiWHIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QVsFBFigLZP98w6SzCv5qT95iKxeCEqZvRtiSAKCdsW2qTUJKrdvZvZo5yS1FGeA6
	 AdrAfFQb/4TKOsemoC4+wfM5qmz2dZWIfL4fhWsGMKhZbsTTOfR0pSBCyrHRflZG8c
	 iak1m8dJGGAhCC6ENYrphnuye8+jZxiowaZrlrj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Karsten Hohmeier <linux@hohmatik.de>
Subject: [PATCH 6.1 203/312] ALSA: ctxfi: Fix missing SPDIFI1 index handling
Date: Wed,  8 Apr 2026 20:02:00 +0200
Message-ID: <20260408175941.342344705@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


