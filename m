Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B8E1E6321;
	Tue, 15 Oct 2024 11:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992108; cv=none; b=MqGGLTJ6WSDl3/LJ7XNAtCyWVdFjaxcMWCfBcSL5FCjlul3rrw8D+Dc559C0Umpod62o0m6Op936iGRQc0tHjnNRxVibnkMqEtGJwVTQqxgKTCcMiMzXdQeCqLuiEcGVF0cNj+bx4rZTpkDsJeJgfM3EZFBHwhU1H+8UGEPuN/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992108; c=relaxed/simple;
	bh=+g9Fg/iFZxP4Pu9dXOQ5snyMeWeyRlGBFh5C2f2gjbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHB5lcd5u5v/wyfSav+9V5Db4lIJRerznvPsmLUT/f58Zzk+d3zjxnDaUBaAxfndhlRCU1kIKlhEoII50SHUNniI3oPMXgxvRbM0wlzLJt1DFO11UaPV5A+TnuBz9slfW6DYE7krXAfPrd2Fz0I1EEhr3erfhj7HLx3I/XotYZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZMk5bVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZMk5bVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD9AC4CEC6;
	Tue, 15 Oct 2024 11:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992108;
	bh=+g9Fg/iFZxP4Pu9dXOQ5snyMeWeyRlGBFh5C2f2gjbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZMk5bVdxE7OHXAlsq32KraqS57nGFE6/wrttHknLgJ5rLTfnULB2Ol/yMflHXV6d
	 /6++O5IYpMA22usmpdFTMQZbLmpNa+3A3VjSulEBEjoOdTPqCSXoAYOCykEwQz//l2
	 eAkiOAjXpZ/Itm+Ce77sMcD9zspZmd8YZtB92YWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Denose <jdenose@google.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/691] Input: synaptics - enable SMBus for HP Elitebook 840 G2
Date: Tue, 15 Oct 2024 13:19:29 +0200
Message-ID: <20241015112441.176107927@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c3a341c16d45..f64f25079481 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -187,6 +187,7 @@ static const char * const smbus_pnp_ids[] = {
 	"LEN2054", /* E480 */
 	"LEN2055", /* E580 */
 	"LEN2068", /* T14 Gen 1 */
+	"SYN3015", /* HP EliteBook 840 G2 */
 	"SYN3052", /* HP EliteBook 840 G4 */
 	"SYN3221", /* HP 15-ay000 */
 	"SYN323d", /* HP Spectre X360 13-w013dx */
-- 
2.43.0



