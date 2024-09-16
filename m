Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644571534FB;
	Mon, 16 Sep 2024 12:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488043; cv=none; b=In17pIOqgTY1jZRar1TCty2tpK+x7USxUK3e/Ojzn0r39eT7QMEuTixuwUVPmb7Rq/Iusl5j0o08Wbk4S212JjIbl/e0ApyjnvsnVMgSW3YbmnAeNZtVKCrGkEUMXRROfnIWu4c13khGX/bD1/q/kD6/UUfN+MyX2Ruth2hgOnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488043; c=relaxed/simple;
	bh=JwBHg52QM4am7IjyUtzVh3xDtW0IQrOdlqO4HlDJgJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCB6TG9N9ixbfiDkRqBzO/BZhHED7eOULYSvDGsychAYYKavUw1oniQoDkvxgwWFQ6ylERgSB9GsRUYD6VE+pAur9DzrXBfW7+Rx7ZtDYA5ihjWsExS8lrGRSPq+K9M4RKrXXpfENTYgF73VAIgCAPHBQS5TEGkJPOzGk3Vx5y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PlfvDZOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PlfvDZOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24E6C4CEC4;
	Mon, 16 Sep 2024 12:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488043;
	bh=JwBHg52QM4am7IjyUtzVh3xDtW0IQrOdlqO4HlDJgJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PlfvDZOQpN92MPI3qvlbt/vGIzM7ZHLhArPn0mi023dLt/36WusmocgjC/IBc54Pd
	 kc6O6PhlUi2aboQrbMa06WLfSU1NpKyOU2ZE5XHXF8pja9gcUL7lOn8TYNFCGaDXk1
	 0MfYFc7PyQtiE2HPOU0eWLLy1SX1C0q2gyvzNg1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Denose <jdenose@google.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 11/63] Input: synaptics - enable SMBus for HP Elitebook 840 G2
Date: Mon, 16 Sep 2024 13:43:50 +0200
Message-ID: <20240916114221.442724689@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b6749af46262..d8c90a23a101 100644
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



