Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD9CDF59;
	Sat, 14 Feb 2026 00:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771030722; cv=none; b=KzDLVLui0hpPbetn6FLIAQm8Dj9C1iYGlIQmJDYuK8FeCPJYYDACvT0KE0actGyy2a35v58BKasp9qaOcbFl+uEAJ6mgNx3yddKbXkPOwTS7mYzONGTc7rhoJO8rcE6+2luYyBCxasaWReLT8GoYYdqed8MnrZw7rSPrdIdFqp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771030722; c=relaxed/simple;
	bh=0PgCKvV754f0VqOtNSpEryR/Pm+XV6SuCNVQ+/aHTbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u8LYotk04zgzGCPWKtj0hp3jMOheh68vuI5Q2vnnULTlDVHZb6H8fUzJJ6lYjnQkqy5uXxzuzWQaJgN6wSpFL+vyrTZwSdwrj1hxnh1UoAUhtgB4PiZkWXgivcqEbpuOywRyJedSHRmwAtObWVvggJZw6PAclqAEjZOGwiZDVI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jNDRoq9A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jNDRoq9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C9BC19424;
	Sat, 14 Feb 2026 00:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771030722;
	bh=0PgCKvV754f0VqOtNSpEryR/Pm+XV6SuCNVQ+/aHTbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jNDRoq9ArjxtEzPtbR5sCV2MZ//RJCAuZ+v/joZ/wKBjpZQpk//GrzEKj2qdHE1+L
	 p5YHpyvp09yigXL/88w+oQtNMt1X4pG6LsS93pId2+BuzrYySD18GDEEEHx/W9sNZC
	 jI3mtDjE4OoXNHGDWufyJ31G7K42OemDDSuz1rE1DGbu1EJQGMg9WYJyTkbNZBjaxO
	 gOKxh0FS/j7LCz2/PTC7nBTaFB/YB+5vV+0gylhcfC7W+gBa94NsdHzxMPnJJfbiXd
	 COLsoWovFdC31s6K0sVwQQIo74XZ+l0/krWaQybJQh2Z0+9XN72GCSpf7qBEQko84C
	 Kr4K9mLCeksCw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	thierry.reding@gmail.com,
	jonathanh@nvidia.com,
	neil.armstrong@linaro.org,
	yelangyan@huaqin.corp-partner.google.com,
	linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] arm64: tegra: smaug: Add usb-role-switch support
Date: Fri, 13 Feb 2026 19:58:14 -0500
Message-ID: <20260214005825.3665084-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214005825.3665084-1-sashal@kernel.org>
References: <20260214005825.3665084-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>

[ Upstream commit dfa93788dd8b2f9c59adf45ecf592082b1847b7b ]

The USB2 port on Smaug is configured for OTG operation but lacked the
required 'usb-role-switch' property, leading to a failed probe and a
non-functioning USB port. Add the property along with setting the default
role to host.

Signed-off-by: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis.

---

## Complete Analysis

### 1. COMMIT MESSAGE ANALYSIS

**Subject:** `arm64: tegra: smaug: Add usb-role-switch support`

**Body:** The commit message clearly states the problem: the USB2 port
on Smaug (Google Pixel C) is configured for OTG operation (`mode =
"otg"`) but lacked the required `usb-role-switch` property, **leading to
a failed probe and a non-functioning USB port**. This is a clear bug
fix, not a feature addition.

**Author/Signoffs:** Authored by Diogo Ivo, signed off by Thierry Reding
(NVIDIA's Tegra device tree maintainer).

### 2. CODE CHANGE ANALYSIS

The patch adds exactly **two lines** to a device tree file:

```1811:1812:arch/arm64/boot/dts/nvidia/tegra210-smaug.dts
                                usb-role-switch;
                                role-switch-default-mode = "host";
```

These are added to the `usb2-0` port node within the XUSB pad controller
(`padctl@7009f000`), which already has `mode = "otg"`.

### 3. ROOT CAUSE OF THE BUG

The bug was introduced by commit `f67213cee2b35` ("phy: tegra: xusb: Add
usb-role-switch support"), which was merged in **v5.7-rc1**. This commit
added the following mandatory check to
`tegra_xusb_usb2_port_parse_dt()`:

```765:777:drivers/phy/tegra/xusb.c
        /* usb-role-switch property is mandatory for OTG/Peripheral
modes */
        if (usb2->mode == USB_DR_MODE_PERIPHERAL ||
            usb2->mode == USB_DR_MODE_OTG) {
                if (of_property_read_bool(np, "usb-role-switch")) {
                        err = tegra_xusb_setup_usb_role_switch(port);
                        if (err < 0)
                                return err;
                        tegra_xusb_parse_usb_role_default_mode(port);
                } else {
                        dev_err(&port->dev, "usb-role-switch not found
for %s mode",
                                modes[usb2->mode]);
                        return -EINVAL;
                }
        }
```

If the DT node has `mode = "otg"` but **does NOT** have the `usb-role-
switch` property, the driver returns `-EINVAL`, causing the entire XUSB
pad controller probe to **fail**. This means the USB port doesn't work
at all.

When commit `f67213cee2b35` was merged, the companion DTS updates were
done for other Tegra boards (Jetson TX1 in `dbf91ff001e54`, Jetson Nano
in `88d1049e16eaa`, Jetson TX2 in `6895c83fda8c9`), but **Smaug was
missed**. The smaug DTS had `mode = "otg"` since v4.9 (commit
`4d3457826abb1`) but was never updated with the required `usb-role-
switch` property.

### 4. IMPACT AND AFFECTED VERSIONS

- **Broken since:** v5.7 (when `usb-role-switch` became mandatory for
  OTG mode)
- **Affected stable trees:** All active LTS kernels: **5.15.y, 6.1.y,
  6.6.y, 6.12.y**
- **Device:** Google Pixel C (Tegra210 Smaug) — a widely sold consumer
  tablet
- **Symptom:** Complete USB port probe failure. The XUSB pad controller
  fails to initialize, making the USB-C port non-functional. This is not
  a subtle degradation; it's a **total hardware functionality loss**.

### 5. CLASSIFICATION

This falls squarely into the **Device Tree (DT) update** exception
category:
- It's a DT fix for existing hardware with an existing driver
- It corrects an incorrect/incomplete hardware description
- It only affects a specific ARM64 platform (Smaug/Pixel C)
- Zero risk of regression to other platforms

### 6. SCOPE AND RISK ASSESSMENT

- **Size:** 2 lines added to a single DTS file
- **Risk:** Extremely low. Adding a `usb-role-switch` boolean property
  and a `role-switch-default-mode` string property to a DT node is
  trivially safe:
  - `usb-role-switch` enables the existing role-switch code path that is
    already used by every other Tegra OTG board
  - `role-switch-default-mode = "host"` is simply ignored on kernels
    before v6.3 (unused DT properties are silently ignored)
- **No functional dependencies:** While this commit appears in a series
  with `c256740c4b1ff` (tegra-udc node) and `8acdb94dcfd37`
  (DisplayPort), this patch is fully independent — it only adds
  properties to the pad controller's port node, which is separate from
  the UDC node.

### 7. BACKPORT FEASIBILITY

The patch modifies only the smaug DTS file with a trivial 2-line
addition. The context around it (`usb2-0` port node with `mode = "otg"`)
has been stable since v4.9 and exists identically in all stable trees.
This will apply cleanly.

### 8. CONCLUSION

This is a textbook DT bug fix: a missing required property (`usb-role-
switch`) causes a complete probe failure for the USB port on the Google
Pixel C tablet. The fix is a trivial 2-line DTS addition that:

1. Fixes a real bug (non-functioning USB port due to probe failure with
   `-EINVAL`)
2. Is obviously correct (follows the exact same pattern as every other
   Tegra OTG board)
3. Is extremely small and contained (2 lines in one DTS file)
4. Has zero regression risk (only affects one specific device)
5. Has been broken since v5.7, affecting all current stable trees
6. Falls into the explicit "DT updates for existing hardware" exception
   category

The only mild concern is that this commit hasn't merged to mainline yet
(it's in a `next-*` branch). Stable backports typically track mainline
commits. However, from a purely technical standpoint, this is an ideal
stable fix.

**YES**

 arch/arm64/boot/dts/nvidia/tegra210-smaug.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra210-smaug.dts b/arch/arm64/boot/dts/nvidia/tegra210-smaug.dts
index 5aa6afd56cbc6..dfbd1c72388c1 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-smaug.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra210-smaug.dts
@@ -1809,6 +1809,8 @@ usb2-0 {
 				status = "okay";
 				vbus-supply = <&usbc_vbus>;
 				mode = "otg";
+				usb-role-switch;
+				role-switch-default-mode = "host";
 			};
 
 			usb3-0 {
-- 
2.51.0

