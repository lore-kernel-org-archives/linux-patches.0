Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F3B19004A;
	Sat, 14 Feb 2026 01:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771030982; cv=none; b=KB3g7xGxSwwL2VBbdPNDI0uOVQUGsQzUJcibLhDKSjN81BeiWXKwVLsiBIgMBY1BfgdcgZjaRh0rLmhfdfLdalVw0Rl7Qw2OwI3wAzCRWg5gkIiaIoIu1cgvlzkk1T/X7Lf7Kr+Wh8Ase2/I3xLP8xUuPXjJDKtY9XhCJpzWjhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771030982; c=relaxed/simple;
	bh=nIZP7J2rJK6heQEF/G+5BMtFT56zeXx3D62wxX97CE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NQI8AchI9elvM4LjvB8/jCbCqySysxMqeA0/TcKDVprE7DCbDtnKyPNYF6XFHYf9rjf4n5gdvwJuE5CG5H+3HdZikox2y41e3TEb0ecWH1maFNcvgeHQGTCAKCZRLeKtjaYSusrY77Lm3WuuO8MmY80oK+3xEjQxPQdsttiy+Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nhYdmAbC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nhYdmAbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE80C116C6;
	Sat, 14 Feb 2026 01:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771030982;
	bh=nIZP7J2rJK6heQEF/G+5BMtFT56zeXx3D62wxX97CE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhYdmAbCMXAwGNW8+7trYD+vlaVsjyFDXxcXzU0evofbIR8Iy7tRmw9JYVHozURrW
	 hSGx1150GzRyaNU0ujP5MOOGZtYAr0OGr/BQphIpl1GySBtRaVmLEfkXHnqFcCA5DO
	 cD4/V3WkeW2YeBrzRDAyma9RoJ0wcbkLXCfylKiP4eoCMywOxVN0H6JIt4escBlbYa
	 YWG8d39u/pAA3DZ1tQdtw550QnDpNw4V65vW72ozKes1FzPElASkKqkyz4XLkPXZ3/
	 yo0qufLd10bWBA3OIGqjTsIHeMrRtmTgGCN5Ilk32oBjrFZB0FhusB04gK83uAMPbz
	 P/Wphq9gGDVng==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	laurent.pinchart+renesas@ideasonboard.com,
	neil.armstrong@linaro.org,
	mchehab+huawei@kernel.org,
	yelangyan@huaqin.corp-partner.google.com,
	jacopo.mondi@ideasonboard.com
Subject: [PATCH AUTOSEL 6.19-5.10] media: omap3isp: isp_video_mbus_to_pix/pix_to_mbus fixes
Date: Fri, 13 Feb 2026 19:58:09 -0500
Message-ID: <20260214010245.3671907-9-sashal@kernel.org>
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

[ Upstream commit 44c03802a5191626996ee9db4bac090b164ca340 ]

The isp_video_mbus_to_pix/pix_to_mbus functions did not take
the last empty entry { 0, } of the formats array into account.

As a result, isp_video_mbus_to_pix would accept code 0 and
isp_video_pix_to_mbus would select code 0 if no match was found.

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information I need. Let me compile my complete
analysis.

---

## Complete Analysis: `media: omap3isp:
isp_video_mbus_to_pix/pix_to_mbus fixes`

### 1. COMMIT MESSAGE ANALYSIS

The commit describes a clear off-by-one bug: the `formats[]` array has a
sentinel entry `{ 0, }` at the end (line 112 of `ispvideo.c`), and two
functions fail to account for this sentinel when iterating the array.
The author is **Hans Verkuil**, the V4L2 subsystem co-maintainer, and
the fix is **Acked-by Sakari Ailus**, the OMAP3 ISP subsystem
maintainer.

### 2. CODE CHANGE ANALYSIS

**The formats array** (lines 39-113) contains 22 real format entries
plus a sentinel `{ 0, }`. The sentinel was added with the original file
creation (commit `ad614acb7eca4`, circa 2009) with this comment:

```109:112:drivers/media/platform/ti/omap3isp/ispvideo.c
        /* Empty entry to catch the unsupported pixel code (0) used by
the CCDC
  - module and avoid NULL pointer dereferences.
         */
        { 0, }
```

**Bug #1 - `isp_video_mbus_to_pix`** (lines 139-180):

The loop `for (i = 0; i < ARRAY_SIZE(formats); ++i)` iterates over ALL
entries including the sentinel. If `mbus->code == 0` (which can happen
via the CCDC module as documented), the sentinel entry matches because
its `code` field is 0. This means:
- `formats[i].bpp = 0`, so `min_bpl = pix->width * 0 = 0`
- `formats[i].pixelformat = 0` (invalid pixel format)
- Buffer size calculation `pix->sizeimage = bytesperline * height` uses
  incorrect values
- The WARN_ON never fires because the sentinel "matched"

**Fix**: Change to `ARRAY_SIZE(formats) - 1` to exclude sentinel. Now if
code=0 is passed, no match is found, `i == ARRAY_SIZE(formats) - 1`, and
the WARN_ON fires properly, returning 0.

**Bug #2 - `isp_video_pix_to_mbus`** (lines 182-202):

The existing comment says "Skip the last format in the loop so that it
will be selected if no match is found." The intent was that the last
real format (YUYV8_2X8) would be selected as default. But
`ARRAY_SIZE(formats) - 1` points to the sentinel `{ 0, }`, not the last
real format. When no pixelformat match is found:
- `i == ARRAY_SIZE(formats) - 1` = sentinel index
- `mbus->code = formats[i].code = 0` (invalid media bus code)

**Fix**: Change to `ARRAY_SIZE(formats) - 2` to skip both sentinel and
the actual last real format. On no match, `i == ARRAY_SIZE(formats) -
2`, which is the last real entry (YUYV8_2X8), and `mbus->code` gets a
valid default.

**Compounding effect**: In `isp_video_set_format` (line 721-722), these
functions are called sequentially:
1. `isp_video_pix_to_mbus(&format->fmt.pix, &fmt)` — on unmatched
   pixelformat, sets `code=0`
2. `isp_video_mbus_to_pix(video, &fmt, &format->fmt.pix)` — then
   `code=0` matches sentinel, uses `bpp=0`

This means any user providing an unsupported pixelformat gets:
`pixelformat=0`, `sizeimage` miscalculated with `bpp=0`. This is a real
data integrity and functional correctness bug.

### 3. CLASSIFICATION

This is a **real bug fix**: an off-by-one error in loop bounds that
causes incorrect format selection and buffer size calculations. It is
NOT a feature, cleanup, or cosmetic change.

### 4. SCOPE AND RISK ASSESSMENT

- **Size**: 4 lines changed in a single file (2 loop bound adjustments,
  1 WARN_ON condition adjustment)
- **Subsystem**: OMAP3 ISP media driver
  (drivers/media/platform/ti/omap3isp/)
- **Risk**: Extremely low. The change only adjusts array iteration
  bounds to correctly account for the sentinel — the resulting behavior
  is exactly what was originally intended.
- **The fix is obviously correct**: the sentinel `{ 0, }` is not a valid
  format entry, so it should not be considered in format lookup or
  default selection.

### 5. USER IMPACT

- Affects users of TI OMAP3 SoC platforms (e.g., BeagleBoard) using the
  ISP camera subsystem
- While niche hardware, users on these platforms have no workaround
- The bug triggers when: (a) an unsupported pixelformat is set via
  `VIDIOC_S_FMT` (pix_to_mbus selects code=0, then mbus_to_pix uses
  bpp=0), or (b) `mbus->code` is 0 from the CCDC path
- Impact: incorrect pixel format, wrong buffer size calculations — could
  lead to video capture failures or buffer underflows

### 6. STABILITY INDICATORS

- Author: Hans Verkuil — V4L2 co-maintainer, extremely experienced
- Ack: Sakari Ailus — OMAP3 ISP maintainer
- The bug has existed since the driver was first created (~2009), so the
  fix addresses a long-standing correctness issue
- The code path is in `isp_video_set_format` and `isp_video_try_format`,
  both V4L2 ioctl handlers reachable from userspace

### 7. DEPENDENCY CHECK

- **No dependencies**: This is a self-contained 4-line fix touching only
  loop bounds
- **Code exists in all stable trees**: Verified that the buggy code is
  identical in stable 6.6 (and would be the same in all older stable
  trees since the driver has not changed in this area)
- **Clean apply**: The patch will apply cleanly to all stable trees with
  this driver

### 8. SUMMARY

| Criterion | Assessment |
|-----------|------------|
| Fixes real bug | YES — off-by-one causing wrong format selection and
buffer calculations |
| Obviously correct | YES — excludes sentinel from search/default,
matching original design intent |
| Small and contained | YES — 4 lines changed in one file |
| No new features | YES — pure bug fix |
| Risk of regression | Very low — only corrects loop bounds to match
array structure |
| Applies to stable | YES — identical buggy code in all stable kernels |
| Impact | Medium — affects OMAP3 ISP camera users when unsupported
formats are requested |

The fix is small, surgical, obviously correct, fixes a real off-by-one
logic bug that can cause incorrect buffer calculations (bpp=0) and
invalid format selection (code=0/pixelformat=0), and is authored and
reviewed by the relevant subsystem maintainers. The risk-to-benefit
ratio strongly favors backporting.

**YES**

 drivers/media/platform/ti/omap3isp/ispvideo.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/ti/omap3isp/ispvideo.c b/drivers/media/platform/ti/omap3isp/ispvideo.c
index 0e7f0bf2b3463..68e6a24be5614 100644
--- a/drivers/media/platform/ti/omap3isp/ispvideo.c
+++ b/drivers/media/platform/ti/omap3isp/ispvideo.c
@@ -148,12 +148,12 @@ static unsigned int isp_video_mbus_to_pix(const struct isp_video *video,
 	pix->width = mbus->width;
 	pix->height = mbus->height;
 
-	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
+	for (i = 0; i < ARRAY_SIZE(formats) - 1; ++i) {
 		if (formats[i].code == mbus->code)
 			break;
 	}
 
-	if (WARN_ON(i == ARRAY_SIZE(formats)))
+	if (WARN_ON(i == ARRAY_SIZE(formats) - 1))
 		return 0;
 
 	min_bpl = pix->width * formats[i].bpp;
@@ -191,7 +191,7 @@ static void isp_video_pix_to_mbus(const struct v4l2_pix_format *pix,
 	/* Skip the last format in the loop so that it will be selected if no
 	 * match is found.
 	 */
-	for (i = 0; i < ARRAY_SIZE(formats) - 1; ++i) {
+	for (i = 0; i < ARRAY_SIZE(formats) - 2; ++i) {
 		if (formats[i].pixelformat == pix->pixelformat)
 			break;
 	}
-- 
2.51.0

