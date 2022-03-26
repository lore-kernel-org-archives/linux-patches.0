Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908437E
	for <patches@lists.linux.dev>; Sat, 26 Mar 2022 23:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=bukY4EgwRaqAf/SaO6ho6ij0PMTHMNeJj2ERILhEhQ8=; b=nNRPEugZ95U+6Q3hPTJO1yg8O0
	M+/Q+WEwQGGXK3iy3EfDCcIIGG5oRWUwcYsiquNCKj++4wLlgmwPBE/EJ5TLBE+gEGJS+ordgYnSf
	x0b1Deyer2k2ryMdymHfwlSmXiS49vH8Q1ODnAP0+r+PtOaBA87edurWj+hDtCvpYoIrxaRuFbKI+
	h+1vdhwOuE6pwUbbp8SpzzsuASm6lCOdSxDQAdVya3kcMSXEySFyg2s2yA/RlPd6bynAcWnu5mVQ0
	I7pl1UFwBsFPFyHXWJcCnWyGQ+2Tia4b+kgEpWN7DkpHC09yIMcVzObWQMvlhZgaGJt6ckN0zxq/E
	jUWucFsw==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nYGBx-0052FX-QT; Sat, 26 Mar 2022 23:51:33 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: dri-devel@lists.freedesktop.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Aditya Srivastava <yashsri421@gmail.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Alain Volmat <alain.volmat@foss.st.com>,
	David Airlie <airlied@linux.ie>,
	Daniel Vetter <daniel@ffwll.ch>
Subject: [PATCH] drm: sti: don't use kernel-doc markers
Date: Sat, 26 Mar 2022 16:51:32 -0700
Message-Id: <20220326235132.25192-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't mark static functions as kernel-doc.

Prevents multiple kernel-doc build warnings:

drivers/gpu/drm/sti/sti_hdmi.c:187: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * HDMI interrupt handler threaded
drivers/gpu/drm/sti/sti_hdmi.c:219: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * HDMI interrupt handler
drivers/gpu/drm/sti/sti_hdmi.c:241: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Set hdmi active area depending on the drm display mode selected
drivers/gpu/drm/sti/sti_hdmi.c:262: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Overall hdmi configuration
drivers/gpu/drm/sti/sti_hdmi.c:340: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Helper to concatenate infoframe in 32 bits word
drivers/gpu/drm/sti/sti_hdmi.c:357: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Helper to write info frame
drivers/gpu/drm/sti/sti_hdmi.c:427: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Prepare and configure the AVI infoframe
drivers/gpu/drm/sti/sti_hdmi.c:470: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Prepare and configure the AUDIO infoframe
drivers/gpu/drm/sti/sti_hdmi.c:555: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Software reset of the hdmi subsystem

Fixes: 5402626c83a2 ("drm: sti: add HDMI driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Aditya Srivastava <yashsri421@gmail.com>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: Alain Volmat <alain.volmat@foss.st.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
---
 drivers/gpu/drm/sti/sti_hdmi.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- linux-next-20220325.orig/drivers/gpu/drm/sti/sti_hdmi.c
+++ linux-next-20220325/drivers/gpu/drm/sti/sti_hdmi.c
@@ -183,7 +183,7 @@ void hdmi_write(struct sti_hdmi *hdmi, u
 	writel(val, hdmi->regs + offset);
 }
 
-/**
+/*
  * HDMI interrupt handler threaded
  *
  * @irq: irq number
@@ -215,7 +215,7 @@ static irqreturn_t hdmi_irq_thread(int i
 	return IRQ_HANDLED;
 }
 
-/**
+/*
  * HDMI interrupt handler
  *
  * @irq: irq number
@@ -237,7 +237,7 @@ static irqreturn_t hdmi_irq(int irq, voi
 	return IRQ_WAKE_THREAD;
 }
 
-/**
+/*
  * Set hdmi active area depending on the drm display mode selected
  *
  * @hdmi: pointer on the hdmi internal structure
@@ -258,7 +258,7 @@ static void hdmi_active_area(struct sti_
 	hdmi_write(hdmi, ymax, HDMI_ACTIVE_VID_YMAX);
 }
 
-/**
+/*
  * Overall hdmi configuration
  *
  * @hdmi: pointer on the hdmi internal structure
@@ -336,7 +336,7 @@ static void hdmi_infoframe_reset(struct
 		hdmi_write(hdmi, 0x0, pack_offset + i);
 }
 
-/**
+/*
  * Helper to concatenate infoframe in 32 bits word
  *
  * @ptr: pointer on the hdmi internal structure
@@ -353,7 +353,7 @@ static inline unsigned int hdmi_infofram
 	return value;
 }
 
-/**
+/*
  * Helper to write info frame
  *
  * @hdmi: pointer on the hdmi internal structure
@@ -423,7 +423,7 @@ static void hdmi_infoframe_write_infopac
 	hdmi_write(hdmi, val, HDMI_SW_DI_CFG);
 }
 
-/**
+/*
  * Prepare and configure the AVI infoframe
  *
  * AVI infoframe are transmitted at least once per two video field and
@@ -466,7 +466,7 @@ static int hdmi_avi_infoframe_config(str
 	return 0;
 }
 
-/**
+/*
  * Prepare and configure the AUDIO infoframe
  *
  * AUDIO infoframe are transmitted once per frame and
@@ -551,7 +551,7 @@ static int hdmi_vendor_infoframe_config(
 
 #define HDMI_TIMEOUT_SWRESET  100   /*milliseconds */
 
-/**
+/*
  * Software reset of the hdmi subsystem
  *
  * @hdmi: pointer on the hdmi internal structure
@@ -785,7 +785,7 @@ static void sti_hdmi_disable(struct drm_
 	cec_notifier_set_phys_addr(hdmi->notifier, CEC_PHYS_ADDR_INVALID);
 }
 
-/**
+/*
  * sti_hdmi_audio_get_non_coherent_n() - get N parameter for non-coherent
  * clocks. None-coherent clocks means that audio and TMDS clocks have not the
  * same source (drifts between clocks). In this case assumption is that CTS is
