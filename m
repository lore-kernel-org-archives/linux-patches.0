Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5B818C00E;
	Wed,  6 Nov 2024 12:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896571; cv=none; b=N4JgOQZU9he3jtDBgVb2LgKlo/fF/NgwYtsGOXZwwOFEGYI20mR3P8rbXg2wB367NOZ2DY0842xQgE27cUE9ab6cgAcrwHOKC/xbdfUl3xJl0bIfQ8fjl0vzUBMNIqu616ChOZvncIYODWZvS9a2CGdNQN+gK65pkUGF3R/9e+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896571; c=relaxed/simple;
	bh=lPi+UEM6GGWJ/DKWYD0QItarQK7ZKkx1AthHertTUhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFYLbZAJQUSBmiS/gVVA/3yK6Tf8UFiykab0pJVPVnFDMY6VbLlyNo46l4Oq5dNs1ixPSxvXiBz3Lm3qfUsH4aSC7UJj0om73PvmYBYMUnc8SnXYst6H3sfVWqvluUDdv7RR+UIyLTrKrcq4lk0qJ8K6hdhIhHuo2Ol3SJSfOwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmceVlBq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmceVlBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BC3C4CECD;
	Wed,  6 Nov 2024 12:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896571;
	bh=lPi+UEM6GGWJ/DKWYD0QItarQK7ZKkx1AthHertTUhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmceVlBqu1wwM/NjlLDhB75RZD4QGmouFmnTb/n3yAtHTfrerYd1FqfyhIufIfr4+
	 /PX2aB2yNwusyFT33hCIjAYcORPsDh7fj4J41cbUW5WGurmFDKiIbQTq9ZBIwyPcPA
	 kka64TYG6yWOB9SKas5HraWsMXbLpFPTvbEWxUzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Teja Pottumuttu <sai.teja.pottumuttu@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 237/245] drm/xe/xe2hpg: Introduce performance tuning changes for Xe2_HPG
Date: Wed,  6 Nov 2024 13:04:50 +0100
Message-ID: <20241106120325.101340490@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sai Teja Pottumuttu <sai.teja.pottumuttu@intel.com>

commit e4ac526c440af8aa94d2bdfe6066339dd93b4db2 upstream.

Add performance tuning changes for Xe2_HPG

Bspec: 72161
Signed-off-by: Sai Teja Pottumuttu <sai.teja.pottumuttu@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240724121521.2347524-1-sai.teja.pottumuttu@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/regs/xe_gt_regs.h |    1 +
 drivers/gpu/drm/xe/xe_tuning.c       |    8 ++++++++
 2 files changed, 9 insertions(+)

--- a/drivers/gpu/drm/xe/regs/xe_gt_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
@@ -109,6 +109,7 @@
 
 #define FF_MODE					XE_REG_MCR(0x6210)
 #define   DIS_TE_AUTOSTRIP			REG_BIT(31)
+#define   VS_HIT_MAX_VALUE_MASK			REG_GENMASK(25, 20)
 #define   DIS_MESH_PARTIAL_AUTOSTRIP		REG_BIT(16)
 #define   DIS_MESH_AUTOSTRIP			REG_BIT(15)
 
--- a/drivers/gpu/drm/xe/xe_tuning.c
+++ b/drivers/gpu/drm/xe/xe_tuning.c
@@ -93,6 +93,14 @@ static const struct xe_rtp_entry_sr lrc_
 				   REG_FIELD_PREP(L3_PWM_TIMER_INIT_VAL_MASK, 0x7f)))
 	},
 
+	/* Xe2_HPG */
+
+	{ XE_RTP_NAME("Tuning: vs hit max value"),
+	  XE_RTP_RULES(GRAPHICS_VERSION(2001), ENGINE_CLASS(RENDER)),
+	  XE_RTP_ACTIONS(FIELD_SET(FF_MODE, VS_HIT_MAX_VALUE_MASK,
+				   REG_FIELD_PREP(VS_HIT_MAX_VALUE_MASK, 0x3f)))
+	},
+
 	{}
 };
 


