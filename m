Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E20F3F889E;
	Wed, 20 May 2026 18:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300833; cv=none; b=KwdQak2O1FvFH9PCl1VoLYyNAdKnPUJ5ihXJLh+fH1KvG0VgyJmrPnoKAfeTMzezmWGd89nuPbCl+n0n2miFoYi+eWBhHEUFNmR/EvO/vx6rpdvulqY9rSH7/n8WbDhd6yk/b+6SPY8eRUChtTlshqzSdlVGoDiDG08rzAWZgxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300833; c=relaxed/simple;
	bh=9fYxDJj/d8UkUxzzBJx3OYLCHG3fsFQJtZtPTqG6HHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfP8/V/1ASK7ZmBWaIdHwjEkUSYH/iYHPJtLt1hgdNsnlphIWVC6fQGGjBZnorOYYqL06G7GCjruIWPOXUTAJW/KegaYadE7Quhb9oaZm7hsND7uzbMdbtl7akLon1ypMIIPgoiWhDHInjUd+t46IoB37pAxIyvshYcj9waV4B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fgQAsW3U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fgQAsW3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45651F000E9;
	Wed, 20 May 2026 18:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300832;
	bh=iI3DjGFvv6pr+PtFmn3j7oorAVWqL6zF1GLMf4U6s7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fgQAsW3UjWyfM37IlcnpkauXJx9qATUcJvq4M4t9FCGdqaO4HW/0hbE8hxA6Yj7T3
	 s0OICYJdOlXkfb3g8tktBfEdgIbmBprWmHP9Syba6icuq+l3d9RYMNJfG0x7s62p3e
	 o5zy17TsubttFBp+JxdF3eJZDjKqsi0T8ldjqop0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Michals <tcmichals@yahoo.com>,
	Tanmay Shah <tanmay.shah@amd.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 325/666] remoteproc: xlnx: Fix sram property parsing
Date: Wed, 20 May 2026 18:18:56 +0200
Message-ID: <20260520162118.268976226@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Tim Michals <tcmichals@yahoo.com>

[ Upstream commit d116bccf6f1c199b27c9ebdf07cc3cfe868f919c ]

As per sram bindings, "sram" property can be list of phandles.
When more than one sram phandles are listed, driver can't parse second
phandle's address correctly. Because, phandle index is passed to the API
instead of offset of address from reg property which is always 0 as per
sram.yaml bindings. Fix it by passing 0 to the API instead of sram
phandle index.

Fixes: 77fcdf51b8ca ("remoteproc: xlnx: Add sram support")
Signed-off-by: Tim Michals <tcmichals@yahoo.com>
Signed-off-by: Tanmay Shah <tanmay.shah@amd.com>
Link: https://lore.kernel.org/r/20260204202730.3729984-1-tanmay.shah@amd.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/xlnx_r5_remoteproc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/xlnx_r5_remoteproc.c b/drivers/remoteproc/xlnx_r5_remoteproc.c
index 6a64e5909f6ae..d1c069704da8d 100644
--- a/drivers/remoteproc/xlnx_r5_remoteproc.c
+++ b/drivers/remoteproc/xlnx_r5_remoteproc.c
@@ -990,7 +990,7 @@ static int zynqmp_r5_get_sram_banks(struct zynqmp_r5_core *r5_core)
 		}
 
 		/* Get SRAM device address */
-		ret = of_property_read_reg(sram_np, i, &abs_addr, &size);
+		ret = of_property_read_reg(sram_np, 0, &abs_addr, &size);
 		if (ret) {
 			dev_err(dev, "failed to get reg property\n");
 			goto fail_sram_get;
-- 
2.53.0



