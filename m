Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635193101A5;
	Sat, 25 Oct 2025 16:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409338; cv=none; b=VhDrsQDV8Q0aci4ysy0A8gx9iCZNsWo8kgrUhkBbmAkCk5mzGXlSJXrcRL1LAC6CZVNEBPwx/IYa2Xa5iHWJm+ivXUEuDKfW/FKDbKhACC1hzgrdL9+CeQKRrvQpmescEkx0oAme8CrkSqhz1sECKM/7fFFIRiHK1ZYSOOTIzuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409338; c=relaxed/simple;
	bh=46XHurAKjgje/048WK9Re7AEwOLB5L4vKF0Lm4eSVzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MXCa8Kv/vR80G5oRrTt0TP9AKRO7FWGWJ6cu75tCCTjUGVuDUH9Dw/xtEHVGtgwV0MJKI3tpdmtK7sqJgGUEj1DUqT6bV5QhviahDlOvqO+SNF0GjKOfiuATaik3DC8oz/z1/wY2/jLbfdOOIdi/sc71yDOyEgvpTJsRr1vqAlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F4zu9v1j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F4zu9v1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67897C4CEF5;
	Sat, 25 Oct 2025 16:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409338;
	bh=46XHurAKjgje/048WK9Re7AEwOLB5L4vKF0Lm4eSVzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F4zu9v1jwKdBRs6/PgGmvy2KZK+Gqj7GN5w2D29M8xx2m380noeDgt52xmdR94hKD
	 k97jdrsH8nEE/e93zDV8S81FFT7ppW9S9JYNgymM+FmcixaA14OHQ5SkJLPEmphnFN
	 eqArVDX/x+gDtUQmPHHBYlrICTYL8qaGPOFCbVuYQ1Odn2tlylKICDxqbzUzFEe05q
	 PQ1h4dHjmXlFA7EexxnStZ9cd9c5BkaFPi/Pl7dq/8Wngc0D22i1YhRJtizI52cquZ
	 U4ifkjQ3KcZl4iKBshiatoxhM/b4uLwyF4/GAo8aCu/ywUZSKKoeSinz7L6a1OkNG2
	 DhjzH3HbwN7Pg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	mathias.nyman@intel.com,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.4] usb: xhci: plat: Facilitate using autosuspend for xhci plat devices
Date: Sat, 25 Oct 2025 11:58:35 -0400
Message-ID: <20251025160905.3857885-284-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>

[ Upstream commit 41cf11946b9076383a2222bbf1ef57d64d033f66 ]

Allow autosuspend to be used by xhci plat device. For Qualcomm SoCs,
when in host mode, it is intended that the controller goes to suspend
state to save power and wait for interrupts from connected peripheral
to wake it up. This is particularly used in cases where a HID or Audio
device is connected. In such scenarios, the usb controller can enter
auto suspend and resume action after getting interrupts from the
connected device.

Signed-off-by: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250916120436.3617598-1-krishna.kurapati@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES. Adding `pm_runtime_use_autosuspend(&pdev->dev);` in
`xhci_plat_probe()` (`drivers/usb/host/xhci-plat.c:185`) finally lets
platform xHCI hosts honour runtime PM autosuspend, so boards that set
`power/control=auto` (such as the Qualcomm configurations called out in
the commit message) can actually drop the controller into low-power idle
instead of burning power indefinitely. The rest of the driver already
implements full runtime suspend/resume support (`drivers/usb/host/xhci-
plat.c:500-573`) and wraps probe/remove paths with the usual runtime-PM
bookkeeping (`drivers/usb/host/xhci-plat.c:355-390`,
`drivers/usb/host/xhci-plat.c:463-548`), so this line simply flips on an
otherwise wired-up capability. Risk is very low: runtime PM remains opt-
in because `pm_runtime_forbid()` keeps the default “on” policy
(`drivers/usb/host/xhci-plat.c:358-362`), and other SoC-specific xHCI
drivers have long invoked the same helper (for example
`drivers/usb/host/xhci-mtk.c:573` and `drivers/usb/host/xhci-
tegra.c:1943`). No dependent changes are required and there are no
follow-up fixes, so this targeted fix for a real power-management
regression is a good candidate for stable backporting.

 drivers/usb/host/xhci-plat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 5eb51797de326..dd57ffedcaa2f 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -171,6 +171,7 @@ int xhci_plat_probe(struct platform_device *pdev, struct device *sysdev, const s
 		return ret;
 
 	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_noresume(&pdev->dev);
 
-- 
2.51.0

