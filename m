Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449D9285060;
	Mon,  9 Feb 2026 14:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647534; cv=none; b=nYahlsvHmY9uhv4Cks3491RQ+ixDC2xMrsK0NdZAsv7qVncW/PPMrOT5UYoGEJW5T17+HHE9GzwEUmlKzoVlDTFFBCGfGHSlfgQ4lEIOhi5gME8U+MwSfnEZkYRoUGNg25AQBVkvkKzBpWMKyG9U/VzljG9UNm6fwUPo7PQdbzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647534; c=relaxed/simple;
	bh=CEsXCyviSM54YFqMpPxnwePgg4EWqZgDtFnrNV6C/yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZQjdvoT0aOhLTyh+L4qXUOxxc4Cm/h8wWxXzmHl0N9YUp53MA/68VWN7YjGFyCvF7clad6oRi4Jb3d7fkktvazsNrbIWuUzbOk6hXgzJuP6IOgp/F23LvQdHFcKShjZCf/fLFpZnmNCh5PzC7M7Uijs+DeNHMvj37OE0QLDxVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t5FYXkNF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t5FYXkNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6B0C116C6;
	Mon,  9 Feb 2026 14:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647534;
	bh=CEsXCyviSM54YFqMpPxnwePgg4EWqZgDtFnrNV6C/yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t5FYXkNFUHKPIcaQqLXxnQz0YkT9eoLT2PK+lRJ0JjaEO/utPtJCp0wXJAC4NCnRf
	 tF6DxFCIblMzRfNamnHbL5yGpjQ6N6aCdY/hOnTsS8T7N49INxBDHKjxlGNqrFHWgp
	 G/XCuCtc0x2aM03JXo+SVwZUd/zU25UuExwhsoaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 094/175] ALSA: hda/tas2781: Add newly-released HP laptop
Date: Mon,  9 Feb 2026 15:22:47 +0100
Message-ID: <20260209142323.808900205@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shenghao Ding <shenghao-ding@ti.com>

[ Upstream commit 46b8d0888f01f250fbd24d00ff80b755c3c42cd4 ]

HP released the new laptop with the subid 0x103C.

Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>
Link: https://patch.msgid.link/20260115124907.629-1-shenghao-ding@ti.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/side-codecs/tas2781_hda_i2c.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c b/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
index 0e4bda3a544ea..624a822341bb7 100644
--- a/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
+++ b/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
@@ -2,7 +2,7 @@
 //
 // TAS2781 HDA I2C driver
 //
-// Copyright 2023 - 2025 Texas Instruments, Inc.
+// Copyright 2023 - 2026 Texas Instruments, Inc.
 //
 // Author: Shenghao Ding <shenghao-ding@ti.com>
 // Current maintainer: Baojun Xu <baojun.xu@ti.com>
@@ -571,6 +571,9 @@ static int tas2781_hda_bind(struct device *dev, struct device *master,
 	case 0x1028:
 		tas_hda->catlog_id = DELL;
 		break;
+	case 0x103C:
+		tas_hda->catlog_id = HP;
+		break;
 	default:
 		tas_hda->catlog_id = LENOVO;
 		break;
-- 
2.51.0



