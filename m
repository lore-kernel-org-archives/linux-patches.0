Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA03306D48;
	Sat, 25 Oct 2025 16:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409463; cv=none; b=skr7jQJDejhVcoGLK/aznQmoAPxYOC1RjufI/LNZPyRuXNV90+Of+YTuwh25rhkVTLm3gYDBLG8YDhKvR6BzYNNAknMFHGeM0SFU5rh9brQC1yh0gDeUnmjg9yEOGhcUsLAY9mCozjW046B0p1V2susY62dEVYHgfr4g1YLXMvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409463; c=relaxed/simple;
	bh=tI/7aqj47B16z66xDv71+nKQxdSuVDZF0CYVx8bwMDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IYfJfi1ivE0kdyCmw/gldCM1uZKp3oIxDeoVCNQjJjCpWWNQjE0pHQrtglmU7d2rn2IZgvIqBfyw+zj2XfzcyCF0JDSaqO3uOr4ZsdSgAiR65hIekE1WbJ3Diiz2xzApqO8nyceYT6x7zjRWMPSNTLVaBPF5igMmffAvajF6llY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WeJSN5OT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WeJSN5OT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EF8C4CEF5;
	Sat, 25 Oct 2025 16:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409462;
	bh=tI/7aqj47B16z66xDv71+nKQxdSuVDZF0CYVx8bwMDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WeJSN5OTORk8z5B9F5LYP7xlw/MG1gTs7Tu9lpWj6L482Sfpimusj7us4ZsRo2IPE
	 DZu2+MGeXSKFc+mKWAfmmAIiPoGO/4stqtREyqeCmvJBLpbDjqCC25pL0kcPvwyO8P
	 DwA+AJIorPHBFnQp3Vif8S5jG/sNgWKoMoQ+rr49Zq1N2tSGCiG96vK0bqX+9sAa68
	 SVSg9v3WMF5lU+CWnZRK3ZCJ1NFBVOBv3ipU6bto8LawUKsXh6qGdxvX1ETkDKXBsp
	 MXqLf62Cfff3dZPoRBAruuRRujJ38dHBNWvEZca3siMAlpTh6qAFU267tia3MIyyCT
	 /FGp1eRFvUYLA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: William Wu <william.wu@rock-chips.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	mhklinux@outlook.com,
	peter@korsgaard.com,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com,
	danisjiang@gmail.com,
	linuxhid@cosmicgizmosystems.com,
	hoff.benjamin.k@gmail.com
Subject: [PATCH AUTOSEL 6.17-5.4] usb: gadget: f_hid: Fix zero length packet transfer
Date: Sat, 25 Oct 2025 11:59:25 -0400
Message-ID: <20251025160905.3857885-334-sashal@kernel.org>
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

From: William Wu <william.wu@rock-chips.com>

[ Upstream commit ed6f727c575b1eb8136e744acfd5e7306c9548f6 ]

Set the hid req->zero flag of ep0/in_ep to true by default,
then the UDC drivers can transfer a zero length packet at
the end if the hid transfer with size divisible to EPs max
packet size according to the USB 2.0 spec.

Signed-off-by: William Wu <william.wu@rock-chips.com>
Link: https://lore.kernel.org/r/1756204087-26111-1-git-send-email-william.wu@rock-chips.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Explanation:
- What changed
  - For HID gadget IN transfers, `f_hidg_write()` now sets `req->zero =
    1` so the UDC may append a zero-length packet (ZLP) when the
    transfer length is an exact multiple of the endpoint max packet
    size: drivers/usb/gadget/function/f_hid.c:514.
  - For control responses on EP0, the HID function now sets `req->zero =
    1` before queuing the reply, enabling a ZLP at end of the data stage
    when appropriate: drivers/usb/gadget/function/f_hid.c:970.

- Why it matters
  - USB 2.0 requires that IN transfers be terminated by a short packet;
    when app data length is divisible by the endpoint’s max packet size,
    a ZLP is the mechanism to indicate end-of-transfer. Without this,
    controllers or hosts may wait for more data, causing stalls or
    timeouts in some configurations.
  - Many UDCs explicitly consult `req->zero` to decide whether to send a
    trailing ZLP, so this flag is the standard way for gadget functions
    to request it. Examples:
    - drivers/usb/dwc2/gadget.c:1133
    - drivers/usb/chipidea/udc.c:515
    - drivers/usb/mtu3/mtu3_qmu.c:270
  - Other gadget functions already set `req->zero` in similar
    situations, either unconditionally or conditionally, showing clear
    precedent:
    - drivers/usb/gadget/function/f_printer.c:650
    - drivers/usb/gadget/function/f_phonet.c:243
    - drivers/usb/gadget/function/u_ether.c:565, u_ether.c:571

- Scope and risk
  - Minimal, two small changes isolated to `f_hid.c`:
    - IN endpoint write path: drivers/usb/gadget/function/f_hid.c:514
    - EP0 respond path: drivers/usb/gadget/function/f_hid.c:970
  - No API or architectural changes. No impact to other gadget functions
    or host-side drivers. Only affects the HID gadget function’s queuing
    behavior.
  - Low regression risk:
    - The host initiates IN transactions; setting `req->zero` only
      enables the device to respond with a ZLP if the host issues
      another IN token and a ZLP is needed. If not needed (e.g., host
      requested exactly the bytes provided), no extra transaction
      occurs.
    - For EP0 control transfers, UDCs commonly decide ZLP behavior based
      on both `req->zero` and the requested length; sending a ZLP when
      the last packet is full-sized is spec-compliant and commonly
      handled.
    - UDCs that don’t support ZLPs typically advertise quirks (see
      include/linux/usb/gadget.h:407) and ignore the flag safely.

- Stable backport criteria
  - Fixes a real, standards-compliance bug that can lead to incomplete
    termination and observable hangs with some UDCs/hosts when HID
    reports are maxpacket-aligned.
  - Extremely small and contained (two assignments), no behavior changes
    outside HID gadget transfers.
  - No features added; purely correctness per USB 2.0 spec.
  - Touches a non-critical subsystem (USB gadget HID function).

- Additional context
  - The GET_REPORT workqueue path still sets `req->zero = 0`
    intentionally (drivers/usb/gadget/function/f_hid.c:575). This patch
    does not alter that path, focusing only on the normal IN write and
    EP0 respond flows, which are the typical places where ZLP needs to
    be enabled by default.

Given the above, this is a safe, low-risk bug fix that improves
standards compliance and interoperability for HID gadget transfers and
should be backported.

 drivers/usb/gadget/function/f_hid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_hid.c b/drivers/usb/gadget/function/f_hid.c
index 8e1d1e8840503..307ea563af95e 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -511,7 +511,7 @@ static ssize_t f_hidg_write(struct file *file, const char __user *buffer,
 	}
 
 	req->status   = 0;
-	req->zero     = 0;
+	req->zero     = 1;
 	req->length   = count;
 	req->complete = f_hidg_req_complete;
 	req->context  = hidg;
@@ -967,7 +967,7 @@ static int hidg_setup(struct usb_function *f,
 	return -EOPNOTSUPP;
 
 respond:
-	req->zero = 0;
+	req->zero = 1;
 	req->length = length;
 	status = usb_ep_queue(cdev->gadget->ep0, req, GFP_ATOMIC);
 	if (status < 0)
-- 
2.51.0

