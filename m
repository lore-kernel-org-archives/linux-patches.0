Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E61B263C90;
	Tue,  8 Apr 2025 11:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111459; cv=none; b=kUwHpxMHzeEWcSOy7+Sd4k2KLcTxCRmmuJfilbIPi5kK9702CDMR70dEkTjKN7CV5hynCg36AeLCb01jbuzU9JX0mJg6Jgy9d5kVWS+CMB1w0TkcLB5xgZdapjuXUZaDR6DyTbSsqQ7tejXZdo9UOSZ1xJKFCzUkTPoqU+woOVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111459; c=relaxed/simple;
	bh=DwoWviIyMeCP9CD4YDTHf8kvF/pMsMJp51pDdTTDsqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7QIpkJDP9JNIhaJQEVi16DQYrh3AdyWKxi1u8RL0ij8GbLrslDg46p2j7ZOOlLJHu1x0SRA/JEZswZs5/vJGSWqGH97sLa/fCYAa+BLR1qtY26yFSrubSjEY9BNMdbZkfpAQUXIHQrmcVujl5PhVGB3gNVcAqwZfPWd9wpUGX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F1/A+NW1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F1/A+NW1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0776C4CEE5;
	Tue,  8 Apr 2025 11:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111459;
	bh=DwoWviIyMeCP9CD4YDTHf8kvF/pMsMJp51pDdTTDsqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F1/A+NW1p7jb66kh8zjIe6jvnl+K+x7WtwagGMm+Nc8OenvF1JpceuN4+4VzUVI4C
	 u28TFOTWavhkxL3h/4RV/talorJwKv2a8Amjo5v+o31tf0F112hy+UtK5j+2QIZxOL
	 gO0xSjj+l9mxjJhPJrxwTf/NWdU/lU4UoPFYAAIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 439/731] usb: typec: thunderbolt: Remove IS_ERR check for plug
Date: Tue,  8 Apr 2025 12:45:36 +0200
Message-ID: <20250408104924.483728083@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benson Leung <bleung@chromium.org>

[ Upstream commit 9682c35ff6ecd76d9462d4749b8b413d3e8e605e ]

Fixes these Smatch static checker warnings:
drivers/usb/typec/altmodes/thunderbolt.c:354 tbt_ready() warn: 'plug' is not an error pointer

Fixes: 100e25738659 ("usb: typec: Add driver for Thunderbolt 3 Alternate Mode")
Signed-off-by: Benson Leung <bleung@chromium.org>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/Z5PstnlA52Z1F2SU@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/altmodes/thunderbolt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/altmodes/thunderbolt.c b/drivers/usb/typec/altmodes/thunderbolt.c
index 94e47d30e5989..6eadf7835f8f6 100644
--- a/drivers/usb/typec/altmodes/thunderbolt.c
+++ b/drivers/usb/typec/altmodes/thunderbolt.c
@@ -351,10 +351,10 @@ static bool tbt_ready(struct typec_altmode *alt)
 	 */
 	for (int i = 0; i < TYPEC_PLUG_SOP_PP + 1; i++) {
 		plug = typec_altmode_get_plug(tbt->alt, i);
-		if (IS_ERR(plug))
+		if (!plug)
 			continue;
 
-		if (!plug || plug->svid != USB_TYPEC_TBT_SID)
+		if (plug->svid != USB_TYPEC_TBT_SID)
 			break;
 
 		plug->desc = "Thunderbolt3";
-- 
2.39.5



