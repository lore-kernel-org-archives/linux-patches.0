Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7749735BDCC;
	Fri,  9 Jan 2026 12:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962388; cv=none; b=j0x9kG2v271flyy/HoAFqh8d3CSZI7HSQhYq/Z8BVMXOccWVRQg1ezdzzrhrsHVKaUN8bnhJ8OE2MEZ7kIM/04z61o48oIpSWkjTFg2LIPXuSwZAJRJpFb7KBmgmW0+UPh3sMKeFuNVK8egOkrBxLBaqmPlg23gxUFpN2Y/N7CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962388; c=relaxed/simple;
	bh=jG96MmRpl/4GiRI+Puw+YTsweOMvYXDoUGgDO0jEjY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=joOXW+WqfGG2g68scjN6x/j/IH2o3mnHOsp3oRrD3Pl2qMgsv2QyT8QQAzgYNrXUc6rYhfpXzyAgza1kDbEW2I6KIzaOeLnhoCLhRkCTLsydmeAaJr5CNscM+7e9afhyRgj5VOJfREzF9HFlk9DK5PI2WEZlJr9rDkmpK8Va67w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HrKQCXEo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HrKQCXEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06069C4CEF1;
	Fri,  9 Jan 2026 12:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962388;
	bh=jG96MmRpl/4GiRI+Puw+YTsweOMvYXDoUGgDO0jEjY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HrKQCXEohO4spMG74Z96cuekFbpfG2aYIqusVcNcfdrTnQ4EVLOJxmpbI4O6ayEZj
	 RvSJGOR0bBwjfQWkpJnPKKpuqa/oMK4AmkEL1qFq3kPkJ0qHRJogTtx00O4ChSAty7
	 rkPhnBu1Dp2hmYzPetwO1U/teTNTwC3xPd9gq6dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 315/634] platform/x86/intel/hid: Add Dell Pro Rugged 10/12 tablet to VGBS DMI quirks
Date: Fri,  9 Jan 2026 12:39:53 +0100
Message-ID: <20260109112129.384949221@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>

[ Upstream commit b169e1733cadb614e87f69d7a5ae1b186c50d313 ]

Dell Pro Rugged 10/12 tablets has a reliable VGBS method.
If VGBS is not called on boot, the on-screen keyboard won't appear if the
device is booted without a keyboard.

Call VGBS on boot on thess devices to get the initial state of
SW_TABLET_MODE in a reliable way.

Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20251127070407.656463-1-acelan.kao@canonical.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/hid.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index c13837401c26..051f2bb786e9 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -144,6 +144,18 @@ static const struct dmi_system_id dmi_vgbs_allow_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Elite Dragonfly G2 Notebook PC"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell Pro Rugged 10 Tablet RA00260"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell Pro Rugged 12 Tablet RA02260"),
+		},
+	},
 	{ }
 };
 
-- 
2.51.0



