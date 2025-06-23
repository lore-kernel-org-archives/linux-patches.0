Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DA113B58B;
	Mon, 23 Jun 2025 13:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684558; cv=none; b=fxmepvV5+Tc2v6B91rawfYTr7t9qcwTHIj+iZ95gyxpPZUp/+a9nShNMsPVDN5Mky1x6nJZMOG/RpFRSyH8OwMsA42rbcNpTf2dseaUSoe6RoJhvRfO2YLhT6+4LagyjgchtXRpijiGAY/KlnUH9vljGnQtLunVV/kG5YlYuw2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684558; c=relaxed/simple;
	bh=GMTA9lIONPSUMcRLPgjmI8g9jtmcafOV9OmOH6JV5cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vb0IgfDPisdNg6if43zZaOjhSV/39uPtIfupO0qeb90MzhP7c7qgCxHIJ7hZBVju/7T1f5gEzUtWMNlydP+fUTLu0QaOI6eYkAawAdDZxu7ANqg6oUB+ozdsVf6PpapW71GtOdEEoUArB31SmR2Qkg1r5Xm5/ttWbqpG+Vim4BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHD9E6sE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHD9E6sE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B71C4CEEA;
	Mon, 23 Jun 2025 13:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684557;
	bh=GMTA9lIONPSUMcRLPgjmI8g9jtmcafOV9OmOH6JV5cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JHD9E6sEj3LaqOMO8r6zAWhqgeHfPciChNzSIBi12luNZLrOn/4ZtpFmIwoZfoAkv
	 pyPBDqsVSReV9Tq9itVCzj5Xcdj7vlppVV/rvtOBtUXyQiM+/0U8vB203Qg3rXdPgG
	 VTyL1X4N/+9+qgXvi/Ws/4TNlw9fi5TTGcQIWpHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 076/592] media: ov08x40: Extend sleep after reset to 5 ms
Date: Mon, 23 Jun 2025 15:00:34 +0200
Message-ID: <20250623130702.078249363@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 77aed862c34f192f9d4b80d5288263b22b50ca98 upstream.

Some users are reporting that ov08x40_identify_module() fails
to identify the chip reading 0x00 as value for OV08X40_REG_CHIP_ID.

Intel's out of tree IPU6 drivers include some ov08x40 changes
including adding support for the reset GPIO for older kernels and
Intel's patch for this uses 5 ms. Extend the sleep to 5 ms following
Intel's example, this fixes the ov08x40_identify_module() problem.

Link: https://github.com/intel/ipu6-drivers/blob/c09e2198d801e1eb701984d2948373123ba92a56/patch/v6.12/0008-media-ov08x40-Add-support-for-2-4-lanes-support-at-1.patch#L4607
Fixes: df1ae2251a50 ("media: ov08x40: Add OF probe support")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov08x40.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/ov08x40.c
+++ b/drivers/media/i2c/ov08x40.c
@@ -1341,7 +1341,7 @@ static int ov08x40_power_on(struct devic
 	}
 
 	gpiod_set_value_cansleep(ov08x->reset_gpio, 0);
-	usleep_range(1500, 1800);
+	usleep_range(5000, 5500);
 
 	return 0;
 


