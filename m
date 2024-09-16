Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A21156F21;
	Mon, 16 Sep 2024 12:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488533; cv=none; b=I5oaj7IhgXN74a4PsriIpV0rRt8SSKe7kWhGIvDoZHjU60us8j6m4DpkKRsV/a1f5Dbk2wiJP8EGgjCjq11CuiDdSql14iwVHJr7qASTvQ9vu3pruNBXc+Tx+/zldnjP+0aBQc3ugRq05nNKzuu2IM4rXs5I8P1GVTa7M/A+lPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488533; c=relaxed/simple;
	bh=INbGkbWhhpXXozGGK1M4YRgoO8NxMkFQsJOdXLH4PKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChoaFMkrksvxi7S5LDNpE4zCr31FHRa8aHNyn6wFgZqmpTHGOt9k71eLY23O1HVD5GLRNqUtS7AUkiiKZHFAOnS+0+k4FmhU0Sa5IddYIMfGABduWJ7sg68QXbVdyjmGH45h9sDiVu1E1I8RfWAwc7Jx/PBKepyJKMERz1DuQpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WX/W0jga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WX/W0jga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C7EC4CEC4;
	Mon, 16 Sep 2024 12:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488533;
	bh=INbGkbWhhpXXozGGK1M4YRgoO8NxMkFQsJOdXLH4PKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WX/W0jgaajLzPORP91XDXsP+Gri5Rs3P8LBDDOnR5JKtBnDFVAWb7WYGRyOABGfHe
	 l2YmO7tQ161NWh79RFh8tuPVzyLeJp0NISt1QQIFLv5yxBCG5KrgZGHp/D5VNaoFXv
	 7rbB47hlJ66kjLeUwsatx9H0B2wwXEdLxhmUe47E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Denose <jdenose@google.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 25/91] Input: synaptics - enable SMBus for HP Elitebook 840 G2
Date: Mon, 16 Sep 2024 13:44:01 +0200
Message-ID: <20240916114225.345365655@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



