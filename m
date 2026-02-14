Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01ABE1DE8AE;
	Sat, 14 Feb 2026 01:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031107; cv=none; b=POuMrxOqETeEij1a/NllXwzTbvl22XpypT6LkvSpyqlnLQ0QFtP6wneurM1IAneHk2dlkwjXmRLY/lpx0NfIzYtuCmhxz0TegVILJrv8dD848+BS4bv+4OvPHDqchEXZxPwhdxGSohAknfr+KOmrZC9c79sNM+i2x+8no3GPgoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031107; c=relaxed/simple;
	bh=zEXt4mXYDucfUXu8qSg+riIZ0NL2LFE9ggtP/E2PfEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NSBgwu5vhprMbp19ar+mvpezyW9fGYuCn500DuJRap0xJQfFxu57LGtn/ROHQPk1BIkezQmSI6hF8+kVwgYQImKgMZbTubBN5/VDmGYUG7gvsXRYrxT7s6IYGfpRUJL7XbIdxvMU1iJ6LFINy8yhLIwf0LNAg/cOyP4IUjIy21w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CZO2+ioN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CZO2+ioN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD4AC16AAE;
	Sat, 14 Feb 2026 01:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031106;
	bh=zEXt4mXYDucfUXu8qSg+riIZ0NL2LFE9ggtP/E2PfEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZO2+ioN+avibkYdkeCX9tHAMjWi87kSFypcxzdzVniOvG0Ah0xoPBeYQOAF8Y9Na
	 p3xWhcVjm4zuS4XwEzJn9gmL38AAyVCIeaUwAI1MZkGHfeMarEbdUUEGk7rUhVpmU6
	 cBsHWDbuuj8k/ZF3JY1hO+0q6kePMAKpNFGjj5pEmR2dcCZ0nCn63zRa5XVpP0dGZR
	 O4e01eYtgm86Pkm3RzUiEI7loN50YL4LB4XjRkhyS+pCTLjMDvmKIzT+QMVvAKwMlF
	 VvnlFcaNhW/Qc1y5ltmEm+CcKGujtcFOW/h5uFiigsNRn4j3R9gc59XVPz8DBi7fi6
	 7lS9/mziTnueg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	laurent.pinchart+renesas@ideasonboard.com,
	neil.armstrong@linaro.org,
	yelangyan@huaqin.corp-partner.google.com,
	jacopo.mondi@ideasonboard.com
Subject: [PATCH AUTOSEL 6.19-5.10] media: omap3isp: set initial format
Date: Fri, 13 Feb 2026 19:59:04 -0500
Message-ID: <20260214010245.3671907-64-sashal@kernel.org>
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

From: Hans Verkuil <hverkuil+cisco@kernel.org>

[ Upstream commit 7575b8dfa91f82fcb34ffd5568ff415ac4685794 ]

Initialize the v4l2_format to a default. Empty formats are
not allowed in V4L2, so this fixes v4l2-compliance issues:

	fail: v4l2-test-formats.cpp(514): !pix.width || !pix.height
test VIDIOC_G_FMT: FAIL

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a thorough understanding of the code. Let me compile my
analysis.

## Detailed Analysis

### 1. Commit Message Analysis

The commit is authored by **Hans Verkuil**, one of the most prominent
V4L2 maintainers, and acked by **Sakari Ailus**, the omap3isp subsystem
maintainer. The commit message is clear: the omap3isp driver fails to
initialize `handle->format` to a valid default when opening the video
device, leaving width=0, height=0, pixelformat=0, etc. This violates
V4L2 API spec—`VIDIOC_G_FMT` must always return a valid format.

### 2. Code Change Analysis

The change is in `isp_video_open()` in
`drivers/media/platform/ti/omap3isp/ispvideo.c`:

**Before:** After `memset(&handle->format, 0, ...)`, only
`handle->format.type` was set. Everything else (width, height,
pixelformat, field, colorspace, bytesperline, sizeimage) was left as
**zero**.

**After:** The format is initialized with sensible defaults:
- width=720, height=480, pixelformat=V4L2_PIX_FMT_UYVY,
  field=V4L2_FIELD_NONE, colorspace=V4L2_COLORSPACE_SRGB
- Then `isp_video_pix_to_mbus()` + `isp_video_mbus_to_pix()` are called
  to compute proper `bytesperline` and `sizeimage` from these defaults.

The code adds a single local variable `struct v4l2_mbus_framefmt fmt`
and 7 lines of initialization. It uses existing helper functions already
in the driver.

### 3. What Bug Does This Fix?

The empty/zero format causes **concrete, user-visible issues**:

1. **`VIDIOC_G_FMT` returns invalid data**: If a user opens the device
   and calls `VIDIOC_G_FMT` before `VIDIOC_S_FMT`, the driver returns
   width=0, height=0, which violates the V4L2 specification. The V4L2
   API mandates that `G_FMT` must always succeed and return a valid
   format.

2. **`isp_video_queue_setup()` would fail**: Looking at line 330-332,
   `sizes[0] = vfh->format.fmt.pix.sizeimage` would be 0, and the check
   `if (sizes[0] == 0) return -EINVAL;` would be hit, preventing buffer
   allocation entirely.

3. **Division by zero risk**: At line 334, `video->capture_mem /
   PAGE_ALIGN(sizes[0])` — if sizes[0] is 0, `PAGE_ALIGN(0)` is 0,
   potentially causing a division by zero.

4. **v4l2-compliance test failure**: The commit message shows the exact
   test failure at `v4l2-test-formats.cpp(514)`.

### 4. Classification

This is a **bug fix**: the V4L2 API requires valid initial formats. The
driver was violating this contract, causing compliance test failures and
potentially real operational issues for userspace programs that rely on
sane defaults.

This is NOT a new feature — it's correcting missing initialization that
the driver should have always had. Every other well-behaved V4L2 driver
sets a valid initial format in its open function.

### 5. Scope and Risk Assessment

- **Size**: +8 lines, 1 file changed. Extremely small and contained.
- **Risk**: Very low. The initialization uses hardcoded sensible
  defaults (720x480 UYVY is a standard NTSC-sized format). The
  `isp_video_pix_to_mbus` and `isp_video_mbus_to_pix` functions are
  already well-established helper functions within the same driver, and
  they handle clamping and validation correctly.
- **No behavioral change for well-behaved userspace**: Any application
  that calls `S_FMT` before streaming (which all real applications
  should) will override this default. The fix only affects the case
  where `G_FMT` is called before `S_FMT`.
- **Subsystem**: This is a driver-specific change (OMAP3 ISP), not core
  V4L2 code. It cannot affect any other driver.

### 6. Author and Review Credentials

- **Hans Verkuil**: The primary V4L2 framework maintainer. He literally
  wrote v4l2-compliance and the V4L2 test suite.
- **Sakari Ailus**: The omap3isp/media subsystem maintainer. His Acked-
  by confirms correctness.

### 7. Dependency Check

This commit has **zero dependencies**. It only uses functions and types
that have existed in the omap3isp driver for many years
(`isp_video_pix_to_mbus`, `isp_video_mbus_to_pix`, `V4L2_PIX_FMT_UYVY`,
etc.). The code will apply cleanly to any stable tree that contains the
omap3isp driver.

### 8. User Impact

The OMAP3 ISP is used in OMAP3/OMAP35xx SoC platforms (e.g.,
BeagleBoard, Nokia N900, various TI evaluation boards). While this is an
embedded/ARM platform with a limited user base, users of these platforms
depend on the ISP working correctly. The zero-format bug means:
- Standard V4L2 tools and applications could misbehave
- v4l2-compliance fails, which is used by distros and embedded projects
  for validation
- Buffer allocation could fail in edge cases without `S_FMT` being
  called first

### Risk vs. Benefit

- **Risk**: Essentially zero. The change only sets defaults for
  previously-uninitialized fields, using well-tested conversion
  functions already in the driver.
- **Benefit**: Fixes V4L2 API compliance, prevents potential buffer
  setup failures, and prevents undefined behavior from using zero-
  initialized format structures.

### Conclusion

This is a small, well-understood, well-reviewed bug fix from the V4L2
maintainer himself. It fixes a real API violation (returning invalid
formats from `G_FMT`), is contained to a single driver, has no
dependencies, and carries essentially zero risk of regression. It meets
all stable kernel criteria: obviously correct, fixes a real bug, is
small and self-contained, and introduces no new features or APIs.

**YES**

 drivers/media/platform/ti/omap3isp/ispvideo.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/ti/omap3isp/ispvideo.c b/drivers/media/platform/ti/omap3isp/ispvideo.c
index 68e6a24be5614..eb33a776f27c9 100644
--- a/drivers/media/platform/ti/omap3isp/ispvideo.c
+++ b/drivers/media/platform/ti/omap3isp/ispvideo.c
@@ -1288,6 +1288,7 @@ static const struct v4l2_ioctl_ops isp_video_ioctl_ops = {
 static int isp_video_open(struct file *file)
 {
 	struct isp_video *video = video_drvdata(file);
+	struct v4l2_mbus_framefmt fmt;
 	struct isp_video_fh *handle;
 	struct vb2_queue *queue;
 	int ret = 0;
@@ -1330,6 +1331,13 @@ static int isp_video_open(struct file *file)
 
 	memset(&handle->format, 0, sizeof(handle->format));
 	handle->format.type = video->type;
+	handle->format.fmt.pix.width = 720;
+	handle->format.fmt.pix.height = 480;
+	handle->format.fmt.pix.pixelformat = V4L2_PIX_FMT_UYVY;
+	handle->format.fmt.pix.field = V4L2_FIELD_NONE;
+	handle->format.fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
+	isp_video_pix_to_mbus(&handle->format.fmt.pix, &fmt);
+	isp_video_mbus_to_pix(video, &fmt, &handle->format.fmt.pix);
 	handle->timeperframe.denominator = 1;
 
 	handle->video = video;
-- 
2.51.0

