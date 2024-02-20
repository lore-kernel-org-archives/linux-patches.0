Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19FD612D7;
	Tue, 20 Feb 2024 21:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465262; cv=none; b=ZpTvJV3SgXLy17YN1X8GXyCHUPGom0R0NnW0IqDw38jXaZOgRVYZyT04F9GFn4QthrdWT4Q6w0UfdFJIKZKKhK27Jr58XmWFnjS2XpjZT6dEnj2VBnoKnWgDRkr364W+ukyqCxXRTYonNyxovnrQKaz3kTt/EsNKikqvh+pV9VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465262; c=relaxed/simple;
	bh=U3g/3z9t02xk2ybCuX0ZMS0LauV+qkYpee5jPE6d+oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p83gJ5AilY4/rbaKiSewXny3muC8eCiY7D/UhPA6ZS+wptmGhcTSJPsKdTdOxAqMg3FlHrRlfz3cstqqLLs/tlCTjKCHA0oAIg2Eboyi9I/zSwdYWn3bnHYs9L3V5Qf1LdcWxCHAfaMJclqpmIhOHv1OvSdF493MRI5QIEj1GGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YKa2rzoV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YKa2rzoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694B5C433F1;
	Tue, 20 Feb 2024 21:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465261;
	bh=U3g/3z9t02xk2ybCuX0ZMS0LauV+qkYpee5jPE6d+oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YKa2rzoVr2htxZBfelRVxIhu2VQOfOQ4vn8+AGxDuXRwkvWzPfKnnRHHk4SbCwFVo
	 FfXP03FtEQLg7Wk8VJp6jo4hjGpGDU2b6dRFrW1ChcAvtW4PGfTeLJJHzzVjKfjec2
	 hxSp5kmyUobD6tm33jzkLLQFmdIc1wbVh763UTHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammad Rahimi <rahimi.mhmmd@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.7 258/309] thunderbolt: Fix setting the CNS bit in ROUTER_CS_5
Date: Tue, 20 Feb 2024 21:56:57 +0100
Message-ID: <20240220205641.226910434@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohammad Rahimi <rahimi.mhmmd@gmail.com>

commit ec4d82f855ce332de26fe080892483de98cc1a19 upstream.

The bit 23, CM TBT3 Not Supported (CNS), in ROUTER_CS_5 indicates
whether a USB4 Connection Manager is TBT3-Compatible and should be:
    0b for TBT3-Compatible
    1b for Not TBT3-Compatible

Fixes: b04079837b20 ("thunderbolt: Add initial support for USB4")
Cc: stable@vger.kernel.org
Signed-off-by: Mohammad Rahimi <rahimi.mhmmd@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tb_regs.h |    2 +-
 drivers/thunderbolt/usb4.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/thunderbolt/tb_regs.h
+++ b/drivers/thunderbolt/tb_regs.h
@@ -203,7 +203,7 @@ struct tb_regs_switch_header {
 #define ROUTER_CS_5_WOP				BIT(1)
 #define ROUTER_CS_5_WOU				BIT(2)
 #define ROUTER_CS_5_WOD				BIT(3)
-#define ROUTER_CS_5_C3S				BIT(23)
+#define ROUTER_CS_5_CNS				BIT(23)
 #define ROUTER_CS_5_PTO				BIT(24)
 #define ROUTER_CS_5_UTO				BIT(25)
 #define ROUTER_CS_5_HCO				BIT(26)
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -290,7 +290,7 @@ int usb4_switch_setup(struct tb_switch *
 	}
 
 	/* TBT3 supported by the CM */
-	val |= ROUTER_CS_5_C3S;
+	val &= ~ROUTER_CS_5_CNS;
 
 	return tb_sw_write(sw, &val, TB_CFG_SWITCH, ROUTER_CS_5, 1);
 }


