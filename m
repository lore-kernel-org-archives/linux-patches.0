Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2314481D5;
	Mon,  1 Apr 2024 15:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986813; cv=none; b=OzhjN0QbD48xlBA8U72SzunfcjPrHpq2Xh32bzXEUKKLVg57zUDs5fvJ5GSPJ+s76ryyiRforbEoiKhQ5hhP+MlOwTQB73LRFPphgYukRLMv6OgViNHz7M6k/l5PkfmDrTcBj8FKbsR3SKeBDGWMZniueGFLJHeA3juq2OL0Az8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986813; c=relaxed/simple;
	bh=tbkDExihZE4XZuHMB78WhD2sFad3Wg3+Gh2LNGYfnY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNnrNTJ1/Ry5/cwxQLJOG2ewx+3g9vj8tYd1NBWaRVF7jO+wqM3I5mM3NFgss/0tUlAqVrp2vgBcrRhHlQiyPOm3vWGHK8SseiZNc9Rt0V44gYcZCTkyPzOZJ3OuPEOSmFz/w9gpOKBE4g+kdvOI1CkzXIHkfR11Y14ESWQfSpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3cnzBkb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3cnzBkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254DEC433C7;
	Mon,  1 Apr 2024 15:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986813;
	bh=tbkDExihZE4XZuHMB78WhD2sFad3Wg3+Gh2LNGYfnY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3cnzBkb4e6QOkz5lIpY6L/osuhvHsIwCZMT74N1yn6HD6D0izCKXgCuA37Vyv2Q+
	 k9f0/ENF7bi0PEB1aGSWce6NyuUYMp6kIIMcWrSxBb6NbmLGf7MtK057Jam1Lhnbvb
	 UJ516SkMswwo0LJUV2uQnkYnMJavev+/I16HzdU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Quadros <rogerq@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 093/399] usb: dwc3-am62: Disable wakeup at remove
Date: Mon,  1 Apr 2024 17:40:59 +0200
Message-ID: <20240401152551.958821657@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@kernel.org>

[ Upstream commit 4ead695e6b3cac06543d7bc7241ab75aee4ea6a6 ]

Disable wakeup at remove.
Fixes the below warnings on module unload and reload.

> dwc3-am62 f900000.dwc3-usb: couldn't enable device as a wakeup source: -17
> dwc3-am62 f910000.dwc3-usb: couldn't enable device as a wakeup source: -17

Fixes: 4e3972b589da ("usb: dwc3-am62: Enable as a wakeup source by default")
Cc: stable@vger.kernel.org # v6.4+
Signed-off-by: Roger Quadros <rogerq@kernel.org>
Link: https://lore.kernel.org/r/20240227-for-v6-9-am62-usb-errata-3-0-v4-2-0ada8ddb0767@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-am62.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/dwc3-am62.c b/drivers/usb/dwc3/dwc3-am62.c
index f85603b7f7c5e..ea6e29091c0c9 100644
--- a/drivers/usb/dwc3/dwc3-am62.c
+++ b/drivers/usb/dwc3/dwc3-am62.c
@@ -274,6 +274,7 @@ static void dwc3_ti_remove(struct platform_device *pdev)
 	u32 reg;
 
 	pm_runtime_get_sync(dev);
+	device_init_wakeup(dev, false);
 	of_platform_depopulate(dev);
 
 	/* Clear mode valid bit */
-- 
2.43.0



