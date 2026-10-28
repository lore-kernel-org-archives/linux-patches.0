Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212789;
	b=H3n8ro9oKU3J7nCR0znJoXTyyh7hwQrnjP0QIjzJkd60vtpi4esv1OF+XX5uvZVw6/Qw
	 hlmf8sH/pK+fY5fjkSj+zuv+9DPAzowPYkzzu8yO1Kw2TT5MdLs7wfbcdiPHFyKDudeHA
	 TkT6FU3ueI4D73eYqUVXMi25Oyh4QykHr60hkOZ31ZMSul3vGI+RSnpL3ou/QIRx1G70b
	 29CQCVbX1E1/uDVjFoPRwqBHJf/4EmKiZfrPLeWCIM1Uh2e6M7e/kDmSlT7SPYOyxINxX
	 RLJW0lXVif4Ak7xHRDMA0DLnXKLBfG6ab42OPa5dB7W7Qg239QFQV3YOWoxrNYtUKag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WzCnetFect9T+SjGzZUk2Lk+YQMD7tphKPc1HTM1DVo=;
	b=Oukmdcp46KPBv3BE1JpOmLatLCyOxGvW8RY5v0Zdf+ITozhfeHh/XcJTbMtKIGMnC/nF
	 nKf3rJ6RaQWDUumwP6xqqzwpcUZiHl380bQhcp8vfBik6GqctObgFr9Pr4Xh7V10p9zkw
	 xLrXwz2akPi3LWHRlZQSVkvkzgq72bX+cAAgxVWZ09homT7T74ok1xAtqTQ2NOSDSxMZe
	 xNdwaEVBR9nLLpec9Nimjw8lJzLQC1z0S9F8yfmD/Z7K5tjQCmpXirpT5vcoemNcUzI8a
	 ySxQzuYuBXLxZGgDw1CdVQVLXLse8IU4UEL2lJtzUjA67/z74Z9HBRqIkdBp51oGErg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aUBkuziH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246F1606A31E;
	Wed, 28 Oct 2026 18:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aUBkuziH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749D11F01825;
	Wed, 28 Oct 2026 18:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212789;
	bh=WzCnetFect9T+SjGzZUk2Lk+YQMD7tphKPc1HTM1DVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUBkuziHfkrvvadNL5hafpZLBuusOX/vmjgwNihs3ZvCq0CRgN0nq6ppBWH5tk9kK
	 1uYhd2VrJ7xpkhbQLq4MQgPhspyH0Q2TxB3jDAb9T2NJ2w7uRkM5zhn8anNd2gzjRq
	 50OEGfGjDp6GCV9sw9284fVLO0CU3rFHwkKwWRL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.1 0277/1887] usb: dwc3: am62: Fix runtime PM usage count leak on probe error path
Date: Wed, 28 Oct 2026 17:39:33 +0100
Message-ID: <20261028170505.533784815@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

commit 3d9bbf0ffeb9b7ac1b6ad06b52e037870a7e0c63 upstream.

dwc3_ti_probe() takes a runtime PM reference with pm_runtime_get_noresume()
before creating the dwc3 core child device, and releases it with
pm_runtime_put_autosuspend() once probe has succeeded. The err_pm_disable
error path only disables runtime PM, so the reference taken a few lines
earlier is never dropped.

The usage counter lives in struct device and is not reset when the driver
is unbound, so the leaked reference outlives the failed probe. If the
device is probed again, through a manual rebind or a module reload, the
counter starts at one instead of zero and the pm_runtime_put_autosuspend()
on the success path can no longer bring it back down. The wrapper then
stays runtime resumed for good and autosuspend never kicks in.

Drop the reference before disabling runtime PM, matching the ordering
already used in dwc3_ti_remove().

Fixes: e8784c0aec03 ("drivers: usb: dwc3: Add AM62 USB wrapper driver")
Cc: stable <stable@kernel.org>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/20260902-dwc3-am62-rpm-fix-v1-1-7a2807e33307@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-am62.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc3/dwc3-am62.c
+++ b/drivers/usb/dwc3/dwc3-am62.c
@@ -243,6 +243,7 @@ static int dwc3_ti_probe(struct platform
 
 err_pm_disable:
 	clk_disable_unprepare(am62->usb2_refclk);
+	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);
 	pm_runtime_set_suspended(dev);
 	return ret;


