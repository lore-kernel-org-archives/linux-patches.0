Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01803019CB;
	Mon,  9 Feb 2026 12:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770640048; cv=none; b=IsgxkAzNf4ZRCrY5nQDJ9M0QUCtERorjAEv9lxJe4VajQVzmDZgDano//0FUomaJiBiRj2nwTeAmoXWyIPEKd2gfkqKjo9avunDzxfB+79iPW/+syeNFB+MNw8HLWhiODHcnyZS4meD084KANx18BVhif6VL05ML54wUYlj3CSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770640048; c=relaxed/simple;
	bh=2aUL/hiwMfvZvlsr+nayjvicHZWhsyP34+a+oTHFnjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qYoyCSVY+nHwFaxV3Mw4WL+l/8GjPuKJGFpzKyZ7zRhL9q2lBmX/qpqiogad8r2vw1Qwz27IRvQXmaw5fX9FnNUUromqJ/3TPOa+HCw1HVQ6qrn6iRjEmsSTRN/OjbUXBNXCClsH4zUTDuTjVDgcFE5zlYAIIsmsIzkL742sWao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YpldXQ0Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YpldXQ0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D4EC116C6;
	Mon,  9 Feb 2026 12:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770640048;
	bh=2aUL/hiwMfvZvlsr+nayjvicHZWhsyP34+a+oTHFnjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YpldXQ0ZrhEVzXa36y/M7lCoUcnmHvO1Hf1MU3vsoYoMGWei9kJs3XMtD8r6bgoK1
	 xjkN9jTVbm3uPJSjzCxAY272Gqk145mDX/grgcvMfc6xvtWPtVw6K0+h0uNpKpm/KX
	 Gi2k6NssYSJ6ZpBSLfpDHjsTdvXYu6GdAFLCAZEaGoY3tMtU/mV+wPZtlpORzUWWJv
	 nkbZwz8NrYRJFdEH5h5otKnkQFsdfmZDpPSx775zyRcT+V+h/BUr+szE8tE8//D8E5
	 jycUpU7nNKNY5QepmyQSKMLcJoHpPHXY3Zx2xT9nqj6bEmj+REoNSobKJduylAVB6n
	 wNkkZkcsw3OmA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	kenneth.t.chan@gmail.com,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] platform/x86: panasonic-laptop: Fix sysfs group leak in error path
Date: Mon,  9 Feb 2026 07:26:46 -0500
Message-ID: <20260209122714.1037915-7-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260209122714.1037915-1-sashal@kernel.org>
References: <20260209122714.1037915-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.9
Content-Transfer-Encoding: 8bit

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 43b0b7eff4b3fb684f257d5a24376782e9663465 ]

The acpi_pcc_hotkey_add() error path leaks sysfs group pcc_attr_group
if platform_device_register_simple() fails for the "panasonic" platform
device.

Address this by making it call sysfs_remove_group() in that case for
the group in question.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3398370.44csPzL39Z@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis

The commit message is clear and precise: it identifies a **sysfs group
leak** in the error path of `acpi_pcc_hotkey_add()`. Specifically, when
`platform_device_register_simple()` fails, the code jumps to
`out_backlight`, which skips the `sysfs_remove_group()` cleanup for
`pcc_attr_group` that was successfully created earlier. This is a
classic resource leak on an error path.

The author is Rafael J. Wysocki, a highly respected kernel maintainer
(PM subsystem, ACPI), and the patch is reviewed by Ilpo Järvinen (Intel
platform/x86 maintainer). Both are strong trust indicators.

### Code Change Analysis

The fix is extremely small and surgical — exactly 3 lines changed:

1. **Changed `goto out_backlight` to `goto out_sysfs`** — When
   `platform_device_register_simple()` fails, instead of jumping past
   the sysfs cleanup, it now jumps to a new label that properly removes
   the sysfs group first.

2. **Added new `out_sysfs:` label** with
   `sysfs_remove_group(&device->dev.kobj, &pcc_attr_group)` — This
   ensures the sysfs group created by `sysfs_create_group()` a few lines
   earlier is properly cleaned up.

The error path ordering is now correct:
- `out_platform` → unregister platform device
- `out_sysfs` → remove sysfs group (NEW)
- `out_backlight` → unregister backlight
- `out_input` → unregister input device
- `out_sinf` → free sinf
- `out_hotkey` → free pcc

This follows the standard reverse-order cleanup pattern in Linux kernel
drivers.

### Bug Classification

This is a **resource leak fix** on an error path. The leaked sysfs group
means:
- Sysfs entries remain dangling after driver probe failure
- Memory associated with the sysfs group attributes is leaked
- Could cause issues if the driver is retried or another driver tries to
  use the same sysfs paths

### Scope and Risk Assessment

- **Lines changed**: ~3 effective lines (one goto target change, two new
  lines for the label and cleanup call)
- **Files touched**: 1 (drivers/platform/x86/panasonic-laptop.c)
- **Risk**: Extremely low — this only affects the error path when
  `platform_device_register_simple()` fails. It cannot affect the normal
  (successful) code path at all.
- **Correctness**: Obviously correct — it follows the standard cleanup
  ordering pattern used everywhere in the kernel.

### Stable Kernel Criteria

1. **Obviously correct and tested**: Yes — trivial fix, reviewed by
   subsystem maintainer
2. **Fixes a real bug**: Yes — resource leak in error path
3. **Important issue**: Moderate — resource leak in driver probe error
   path. While not a crash, it's a correctness issue
4. **Small and contained**: Yes — 3 lines in one file
5. **No new features**: Correct — pure bug fix
6. **Clean backport**: The code should be straightforward to backport as
   this driver has been stable for a long time

### User Impact

This affects Panasonic laptop users. While the error path is not
frequently hit (it requires `platform_device_register_simple()` to fail,
which is uncommon), when it does occur, resources are leaked. The fix is
zero-risk to the normal path and trivially correct.

### Conclusion

This is a textbook stable-worthy fix: a small, obvious resource leak fix
in an error path, written by a top kernel maintainer, reviewed by the
subsystem maintainer, with zero risk of regression. It meets all stable
kernel criteria.

**YES**

 drivers/platform/x86/panasonic-laptop.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index 255317e6fec88..937f1a5b78edf 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -1089,7 +1089,7 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 			PLATFORM_DEVID_NONE, NULL, 0);
 		if (IS_ERR(pcc->platform)) {
 			result = PTR_ERR(pcc->platform);
-			goto out_backlight;
+			goto out_sysfs;
 		}
 		result = device_create_file(&pcc->platform->dev,
 			&dev_attr_cdpower);
@@ -1105,6 +1105,8 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 
 out_platform:
 	platform_device_unregister(pcc->platform);
+out_sysfs:
+	sysfs_remove_group(&device->dev.kobj, &pcc_attr_group);
 out_backlight:
 	backlight_device_unregister(pcc->backlight);
 out_input:
-- 
2.51.0

