Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AED61586CF;
	Mon, 16 Sep 2024 12:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488170; cv=none; b=QTCEkJT50+D/XEVxFf/tBqFkAwRv43JySmTVG695eOQdgmNsSLi3hL0hTE8FrjGL/T929I3nXmFT7+Hbo6cF/TlDL77QjpeKPrugrKYWTnBGaYFNZqH1RL4nDUnbZcx+OXYYdIDyU1oBEriKGacMqz51ka2rz9hM8ybTY5t9fsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488170; c=relaxed/simple;
	bh=kFd0mNyeHxj+uutOdLrULsGg4VXPxFr/JTYru63VZwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDBuTkgW9Gc2szzlWEecvXFYMsJp8gjmFayvNakeE/KcNBAu5pIL3xadveZxQNNPEMr454gA6DjUYPg1hdEmK5x0PNjJNU8BX18NSoOWw3WdazMQmGsIx9TFAaHoNMqNQWgwcPILwSWNYNx2YtACQOF1t9hpK2kgYNTyrPNO6RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jeqImjb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jeqImjb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19903C4CED1;
	Mon, 16 Sep 2024 12:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488170;
	bh=kFd0mNyeHxj+uutOdLrULsGg4VXPxFr/JTYru63VZwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jeqImjb28YlZxcPdCFefsiRkB46jokBmuOolgTiCFvLLnA30L9juTbPGkyYQRNkBR
	 Wm4ZgOG0OxZ3IcJzylMH8j6olzF1tUSIUMd3CkIco5L6FX/VqHfSkjRQr4uf7wC3ry
	 9OKQVISCDXsU/HXAGXNf9OT2YZZIGOb4ddFmrLms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Denose <jdenose@google.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 020/121] Input: synaptics - enable SMBus for HP Elitebook 840 G2
Date: Mon, 16 Sep 2024 13:43:14 +0200
Message-ID: <20240916114229.609319335@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Denose <jdenose@google.com>

[ Upstream commit da897484557b34a54fabb81f6c223c19a69e546d ]

The kernel reports that the touchpad for this device can support a
different bus.

With SMBus enabled the touchpad movement is smoother and three-finger
gestures are recognized.

Signed-off-by: Jonathan Denose <jdenose@google.com>
Link: https://lore.kernel.org/r/20240719180612.1.Ib652dd808c274076f32cd7fc6c1160d2cf71753b@changeid
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/synaptics.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 7a303a9d6bf7..cff3393f0dd0 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -189,6 +189,7 @@ static const char * const smbus_pnp_ids[] = {
 	"LEN2054", /* E480 */
 	"LEN2055", /* E580 */
 	"LEN2068", /* T14 Gen 1 */
+	"SYN3015", /* HP EliteBook 840 G2 */
 	"SYN3052", /* HP EliteBook 840 G4 */
 	"SYN3221", /* HP 15-ay000 */
 	"SYN323d", /* HP Spectre X360 13-w013dx */
-- 
2.43.0



