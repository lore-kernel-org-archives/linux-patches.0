Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECF31F1302;
	Tue, 30 Sep 2025 15:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244508; cv=none; b=l+6ZZE1xWYyKJqrO4/HpwUJw4k3jAw9HrdUx8EweC3Ll0rfBXfUVige6uehAk4QDJm+tWueQq30JxqtO5n5PV0y3sod7jDvvVLIi5fmFITQ1pgN9LOYaUiRAffGkFDoIw2QhN7llfV8zmKOwKshJ7rrphr3P98jT86dYIM4EtH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244508; c=relaxed/simple;
	bh=w3pVTs7tAEYQwZj+XsYhuQRY3FeHWnj+QEev+iZgq6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OdOtk57QiNDwM1oCO4AkZeBHkKjyIVuQ6nJbuIN83EXOeBuErib5SM9JlJnaehvkNJbRm0O2GURWNMeo6UYdquN9fpdsISAUH5NGBdoN9Z7hDcdc03KIsZ1GEsErrlt7ooeVEQMKFFFMaw1rNtC7lst4hEI81JHWrJaf/Cq2Q8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jn9yqKUO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jn9yqKUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE798C4CEF0;
	Tue, 30 Sep 2025 15:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244508;
	bh=w3pVTs7tAEYQwZj+XsYhuQRY3FeHWnj+QEev+iZgq6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jn9yqKUOGMxrt+rE+IDuO9bmwfb3oRklWyMSW9pPI0FfE45yF15rnSAw8pGvJeJlt
	 DqdotLkAbqmDTLPU8S8Pwlwa3jTcPvdoLndKPWhm21jyJLmGf2mJyRBaKJMP0yw/Tq
	 ATyQmx3rFf25bHrahdc3JoGMALXKDcUH9DKu1cxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 029/143] platform/x86: oxpec: Add support for OneXPlayer X1 Mini Pro (Strix Point)
Date: Tue, 30 Sep 2025 16:45:53 +0200
Message-ID: <20250930143832.405643592@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit 1798561befd8be1e52feb54f850efcab5a595f43 ]

The OneXPlayer X1 Mini Pro (which is the Strix Point variant of the Mini)
uses the same registers as the X1 Mini, so re-use the quirk.

Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://lore.kernel.org/r/20250718163305.159232-2-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/oxpec.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/oxpec.c b/drivers/platform/x86/oxpec.c
index 9839e8cb82ce4..eb076bb4099be 100644
--- a/drivers/platform/x86/oxpec.c
+++ b/drivers/platform/x86/oxpec.c
@@ -292,6 +292,13 @@ static const struct dmi_system_id dmi_table[] = {
 		},
 		.driver_data = (void *)oxp_x1,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ONE-NETBOOK"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "ONEXPLAYER X1Mini Pro"),
+		},
+		.driver_data = (void *)oxp_x1,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "ONE-NETBOOK"),
-- 
2.51.0



