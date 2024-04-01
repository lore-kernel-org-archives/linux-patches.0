Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674DB47A76;
	Mon,  1 Apr 2024 16:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988125; cv=none; b=Hq7+IjyjPp5cqFwGdZGejMhEtSxucJCdL6cJpntHeKJieRUk9zPQuB1mlBuZSlXlP7OkBNEBF7zL03SDL0VTJw/12g0jLFNWtMtLTj4b6lPudxXr5Bs5EMVzuO/VN55VjyZV+fP3/1yP8TzH5hbhH5nhmqnnPB8L/0P1klQ4gug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988125; c=relaxed/simple;
	bh=CSlI9hoty/O2jVCnQNOSrmxmhuQb2GvKMdiapVhLjjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OB1ZLywATlS6k41PRuO96+vz08nfgq9ahsS4b1JKVROsZ8i+bS9noi2nhE9NRs+imharfRVxNamxZ0gj7bpnbDp8Wev6Duy7mmWobzPw1IuWi++y8GYmhS9kSksXrCpnJ1nO7e4rrO/VGJFHcSCFEECTbsCZ2ZfjGPR0sg+6/Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPbX6KuJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPbX6KuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85486C433F1;
	Mon,  1 Apr 2024 16:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988125;
	bh=CSlI9hoty/O2jVCnQNOSrmxmhuQb2GvKMdiapVhLjjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DPbX6KuJnvHLM6R/XO320vCasyzsWAOR1pxohsvZ0rwijT49twdCUiwwtVkvGTTgT
	 ZZgJyCa0EMRHqKx9+i0jDXhl9DZsj0kH3Hd+gg1leaWKWyk+Ll641XfhogvpiU1F/Y
	 c6AEGf/M2W+Vj5FAYHg/7o/b8LlFsKZZzlRiJv84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Quadros <rogerq@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 091/432] usb: dwc3-am62: Disable wakeup at remove
Date: Mon,  1 Apr 2024 17:41:18 +0200
Message-ID: <20240401152555.839004017@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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



