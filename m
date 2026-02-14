Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47018194098;
	Sat, 14 Feb 2026 01:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031061; cv=none; b=AhL0f6aiGnPpZXj+fAjig3mFF91L0vu/sgM2kEV7Bvjau5Vk2zZ2VmuUOAqM7V8TGmbx+mnvD06YX7ngr5RaUyJdorQoKv9j9/VmTbehQ0SS3Ph83VMxx90fo26XPaoFZ4UT1BJ1YxFdjqQ/Aou+HC5ErSzYZ7hnmUs3gA5Q7kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031061; c=relaxed/simple;
	bh=ETr8D55Mbbp6bNJBkzBxwjRzzXkEmwRe3yNfNAnfX84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QI6PAyvZYEHCm+kFyJKZrZtZPLR8QF2SuXz6rfiStbix6BCyYgS/aKHI1UD0lXlJyPCY1b2ixcx/lFVPutz1R116nvVnt9TdpRocOuSS7S5xSL6Gs9rfAJJinW/4GQF90/cfF83SBHBwdmwHvrhjDbIPrOwbNqD6wirl3P60kB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VRFOoQPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VRFOoQPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E926C16AAE;
	Sat, 14 Feb 2026 01:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031061;
	bh=ETr8D55Mbbp6bNJBkzBxwjRzzXkEmwRe3yNfNAnfX84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VRFOoQPxX2mqNNs2HkcTjv/adIUFUZ/TvVRk1OyUPq2m7HqlO3ojqsVGyBvPQURk+
	 NIaxw38xPE1BMd7tZ/s4mAPjBhXlfoVpRkcrI0eOllJHQchvhKJgPPDA9fGi3mQhfa
	 xUfCqf8Y3lftKsttoUNmN5eThOdb3KTTeLHEkuSI3WBXLCSJTbSPa+6yWKhlJoEp8N
	 UaNbBDtQksZhazU4ge/Qzuzxwq81FHPWFF67TQWFBZ1FSVebtscSU27jZwvtlWVU7E
	 0P3XqO31f9ETJtvhHcCJBsHM8Vcydfates6adH55vSwDpjQ+ri3BkjCc5T+6noR++w
	 AmPWAmPdmIObw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Anj Duvnjak <avian@extremenerds.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] hwmon: (nct6683) Add customer ID for ASRock Z590 Taichi
Date: Fri, 13 Feb 2026 19:58:45 -0500
Message-ID: <20260214010245.3671907-45-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
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

From: Anj Duvnjak <avian@extremenerds.net>

[ Upstream commit c0fa7879c9850bd4597740a79d4fac5ebfcf69cc ]

Add support for customer ID 0x1621 found on ASRock Z590 Taichi
boards using the Nuvoton NCT6686D embedded controller.

This allows the driver to instantiate without requiring the
force=1 module parameter.

Tested on two separate ASRock Z590 Taichi boards, both with
EC firmware version 1.0 build 01/25/21.

Signed-off-by: Anj Duvnjak <avian@extremenerds.net>
Link: https://lore.kernel.org/r/20251222220942.10762-1-avian@extremenerds.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis

This commit adds a new customer ID (0x1621) for ASRock Z590 Taichi
boards to the nct6683 hwmon driver. The purpose is to allow the driver
to instantiate on these boards without requiring the `force=1` module
parameter. The commit has been tested on two separate boards.

### Code Change Analysis

The changes are minimal and straightforward:

1. **Documentation update** (`Documentation/hwmon/nct6683.rst`): Adds
   one line to the tested boards table listing the ASRock Z590 Taichi
   with its firmware version.

2. **Driver change** (`drivers/hwmon/nct6683.c`):
   - Adds a new `#define NCT6683_CUSTOMER_ID_ASROCK5 0x1621` constant.
   - Adds a new `case NCT6683_CUSTOMER_ID_ASROCK5: break;` in the
     `nct6683_probe()` switch statement.

### Classification

This is a **new device ID addition** to an existing driver — one of the
explicitly allowed exception categories for stable backports. The
pattern is identical to previous ASRock customer ID additions (ASROCK,
ASROCK2, ASROCK3, ASROCK4), following a well-established pattern in this
driver.

### Scope and Risk Assessment

- **Lines changed**: ~5 lines of actual code (1 define, 2 case statement
  lines), plus 1 documentation line.
- **Files touched**: 2 (documentation + driver).
- **Risk**: Essentially zero. The new case statement simply allows the
  probe function to proceed for this specific customer ID value instead
  of returning `-ENODEV`. It doesn't change any behavior for existing
  boards. The fallthrough to `break` is the same pattern used for all
  other recognized customer IDs.

### User Impact

Without this patch, users with ASRock Z590 Taichi boards must use
`force=1` to get hardware monitoring support. With this patch, the
driver works out of the box. This is a real usability improvement for
owners of this specific hardware — hwmon support means fan speed
monitoring, temperature readings, etc.

### Stability Indicators

- Tested on two separate boards by the patch author.
- Accepted by the hwmon maintainer (Guenter Roeck).
- Follows the exact same pattern as all prior customer ID additions in
  this driver.

### Dependency Check

No dependencies on other commits. The driver exists in all recent stable
trees, and the change is self-contained.

### Conclusion

This is a textbook example of a device ID addition to an existing driver
— trivial, zero-risk, tested, and enables hardware support for real
users. It meets all stable kernel criteria and falls squarely into the
"new device IDs" exception category.

**YES**

 Documentation/hwmon/nct6683.rst | 1 +
 drivers/hwmon/nct6683.c         | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/Documentation/hwmon/nct6683.rst b/Documentation/hwmon/nct6683.rst
index 3e549ba95a15a..45eec9dd349aa 100644
--- a/Documentation/hwmon/nct6683.rst
+++ b/Documentation/hwmon/nct6683.rst
@@ -65,6 +65,7 @@ AMD BC-250			NCT6686D EC firmware version 1.0 build 07/28/21
 ASRock X570			NCT6683D EC firmware version 1.0 build 06/28/19
 ASRock X670E			NCT6686D EC firmware version 1.0 build 05/19/22
 ASRock B650 Steel Legend WiFi	NCT6686D EC firmware version 1.0 build 11/09/23
+ASRock Z590 Taichi		NCT6686D EC firmware version 1.0 build 01/25/21
 MSI B550			NCT6687D EC firmware version 1.0 build 05/07/20
 MSI X670-P			NCT6687D EC firmware version 0.0 build 09/27/22
 MSI X870E			NCT6687D EC firmware version 0.0 build 11/13/24
diff --git a/drivers/hwmon/nct6683.c b/drivers/hwmon/nct6683.c
index 6cda35388b24c..4a83804140386 100644
--- a/drivers/hwmon/nct6683.c
+++ b/drivers/hwmon/nct6683.c
@@ -181,6 +181,7 @@ superio_exit(int ioreg)
 #define NCT6683_CUSTOMER_ID_ASROCK2	0xe1b
 #define NCT6683_CUSTOMER_ID_ASROCK3	0x1631
 #define NCT6683_CUSTOMER_ID_ASROCK4	0x163e
+#define NCT6683_CUSTOMER_ID_ASROCK5	0x1621
 
 #define NCT6683_REG_BUILD_YEAR		0x604
 #define NCT6683_REG_BUILD_MONTH		0x605
@@ -1242,6 +1243,8 @@ static int nct6683_probe(struct platform_device *pdev)
 		break;
 	case NCT6683_CUSTOMER_ID_ASROCK4:
 		break;
+	case NCT6683_CUSTOMER_ID_ASROCK5:
+		break;
 	default:
 		if (!force)
 			return -ENODEV;
-- 
2.51.0

