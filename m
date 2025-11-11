Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE2B7262A;
	Tue, 11 Nov 2025 01:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822960; cv=none; b=Q2J+hBDcsfALliLexjqNhOZfibso32ML/jNaiDMkW2HlaFY42mpizRAA5X24Wz7I7TUvxSXW+pqq6JxS8UbHfg2RHFWSjtpIURvFsAiDHcvjmtUo00dD0s/bxpl2AzfMIDdELItCT225C7Hz6InsR+x+AUqSjWXXf5SNDXZfPqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822960; c=relaxed/simple;
	bh=y1rFbtkNrWXz/9DErEMK9p7+zBEdbjvWIJJLAdWrfl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QyPvX9/gr8yMPIF9KYfsid5lM++EyQDqzuPiflOGyPf3l/5hmTgueiN/Da4aITebw8zqTnHjDf7gni0vq6ayjG9Btj9oXMHq5pZTIUwjIdAwCZ+CgGgby7O0tY1S3566kup19mS7/7ApVkpW8ljBBNuvT8K9DvaNDVfFHNqvBeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JkWaa2Bv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JkWaa2Bv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85B9C4CEF5;
	Tue, 11 Nov 2025 01:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822960;
	bh=y1rFbtkNrWXz/9DErEMK9p7+zBEdbjvWIJJLAdWrfl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JkWaa2BvkBfMYnUgjodNCFc61RbJfOOVpGbq1SfeiWY/Vq58eQHc/pttgWSBhm+9I
	 +HPkKS8sPbIgo2/OPrD/144sYt23/2ACdNNgImUVjJ6V/gudPIa2QWwAu1skl/VbDV
	 oSpL1HHv6FBG21xpsBJuoG1LGG9q3GVTVEKmqSYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 141/565] video: backlight: lp855x_bl: Set correct EPROM start for LP8556
Date: Tue, 11 Nov 2025 09:39:57 +0900
Message-ID: <20251111004530.114192407@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit 07c7efda24453e05951fb2879f5452b720b91169 ]

According to LP8556 datasheet EPROM region starts at 0x98 so adjust value
in the driver accordingly.

Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Reviewed-by: "Daniel Thompson (RISCstar)" <danielt@kernel.org>
Link: https://lore.kernel.org/r/20250909074304.92135-2-clamor95@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/lp855x_bl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index 7075bfab59c4d..d191560ce285f 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -22,7 +22,7 @@
 #define LP855X_DEVICE_CTRL		0x01
 #define LP855X_EEPROM_START		0xA0
 #define LP855X_EEPROM_END		0xA7
-#define LP8556_EPROM_START		0xA0
+#define LP8556_EPROM_START		0x98
 #define LP8556_EPROM_END		0xAF
 
 /* LP8555/7 Registers */
-- 
2.51.0



