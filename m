Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3487D1C07F7;
	Tue, 15 Oct 2024 12:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996824; cv=none; b=R0nUQTunPePvSRtTTfkK+z5d5e/UasjjTKJdNCFOJBVheAa7/On7AAEy0E4K1nQzQTRN41CKRzxAn+ewN+48JVN3uqBE1RBTFEJ20deM9F0ABI1738yWamz4pINZMealy4PMVMRQDgFk83a1BhniiUBrP+XfvIR2AR7ZURf+5sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996824; c=relaxed/simple;
	bh=xdZBFBzunBE5cIgVUUDasUIA/xQy615O/9UV0yBr+Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lc/qxeGnYL1vx1WT7VW08bJO2ORkTMfMF1RXbqGzHRVFrxT4ZRSKEClhhJz25VolJm7HGC9jQl81MXsx9J78ZG9ZSY3rsboiOnPCR8Z34WK9/jdJOhQCHkPUaq5p9Ixc7LCgmc3ssxCTsVtkibX208VNlJgE3RTXogZ9Z7m71+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cDGFCpli; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cDGFCpli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC68C4CECF;
	Tue, 15 Oct 2024 12:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728996823;
	bh=xdZBFBzunBE5cIgVUUDasUIA/xQy615O/9UV0yBr+Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cDGFCpliBoLaTDBd+lqU+toY/0AYx7d1XsG//kiH/b+hyj7K2uZwEe9LJniDtiE3S
	 3yU7GtDewLoqd+4c/kkYsD5ligH0iDg7KAMq/Dc25rcGEJ2mYQdTCmMhK9XMsdU6gS
	 7xiGhNhIYccDSesybGi1A0K86ZtnV9O6Ip9lD9Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Denose <jdenose@google.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/518] Input: synaptics - enable SMBus for HP Elitebook 840 G2
Date: Tue, 15 Oct 2024 14:38:34 +0200
Message-ID: <20241015123917.232930454@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e2c130832c15..82504b0ce01b 100644
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



