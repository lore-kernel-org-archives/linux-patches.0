Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFFB1FF1AD;
	Sat, 14 Feb 2026 01:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771030988; cv=none; b=QBRHJr3qLuuQbwfNQJgJz5GpEUk0NPqPzMx4LpgbChOvD3cbbO+DnPIeOhU6AMehTFOdlwNHaatuD+H0NnwZuJhSoel5BSjM+k/f73ZL2NYM1maW7WA490MfSIe1cm/lJA7MH68s4O2SiD98FyCbqIhAfV2x2PUvMypi+6ynGOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771030988; c=relaxed/simple;
	bh=mRVQDQI3kidxYWJERZnJQhZL1iNNwlyK/wTFc6s9h1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XCLequJZdghHGPOTpz8j/SZ/0geRZyooezX13N2R1PQ03+qc6o6ighKIyEa4dlpnKC2C0h1deoxb6cFHTWTX9IGKP/fyEqFGmOV/KOQquCFTiYNRDHlpJQ89+yoXNiFTmz2JpMluhc6H+bWPQ8zJh3Aqu19ixMXvqliM1aD6nr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kO2aXw3w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kO2aXw3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C5FC116C6;
	Sat, 14 Feb 2026 01:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771030987;
	bh=mRVQDQI3kidxYWJERZnJQhZL1iNNwlyK/wTFc6s9h1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kO2aXw3wvD7U/q7BPMrMvGMX587LXQ6Ne4LfQbjddWvEGQp1e6SzF65N3LEBxrH7v
	 k9dxVNdUdT1+IjQOp4lnKS6rQ4V3Ni2AYKhMaLl2gOjyPB21Xh9Q3kqYwGtGWaqN3G
	 4t+beDE/ZfMJLpF9Zz25yvKLhx1rjY+1CTAfjrPYsAvMcvBQ5bwNjI5WTlBIQY7Cxv
	 5LjdbPfSq6Q5SQWPTxzoMX/XZ43DlrGFlIbunh3LU8/8l9NQDNdwyC77WAyoOfF8TV
	 Ez8FR3cZ1zDnoREppRdcgwhYLAR+YjsNgVZlCwVFs5gTiOZedu6HjNxip2J6E03IUL
	 A9Ae2J+Fg8tUw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thorsten Schmelzer <tschmelzer@topcon.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Michael Tretter <m.tretter@pengutronix.de>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lars@metafoo.de,
	linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] media: adv7180: fix frame interval in progressive mode
Date: Fri, 13 Feb 2026 19:58:13 -0500
Message-ID: <20260214010245.3671907-13-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Thorsten Schmelzer <tschmelzer@topcon.com>

[ Upstream commit 90289b67c5c1d4c18784059b27460d292e16d208 ]

The ADV7280-M may internally convert interlaced video input to
progressive video. If this mode is enabled, the ADV7280-M delivers
progressive video frames at the field rate of 50 fields per second (PAL)
or 60 fields per second (NTSC).

Fix the reported frame interval if progressive video is enabled.

Signed-off-by: Thorsten Schmelzer <tschmelzer@topcon.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of media: adv7180: fix frame interval in progressive mode

### Commit Message Analysis

The commit message clearly states this is a **fix** for incorrect frame
interval reporting when the ADV7280-M chip's de-interlacer is active.
The chip converts interlaced video to progressive frames at the field
rate (50 fps for PAL, 60 fps for NTSC), but the driver was reporting the
interlaced frame rate (25 fps for PAL, 30 fps for NTSC). This means the
reported frame interval was wrong by a factor of 2.

The commit has been reviewed by Niklas Söderlund and merged by Hans
Verkuil (V4L2 maintainer), which are good trust indicators.

### Code Change Analysis

The change is extremely small and surgical - it adds a single
conditional block:

```c
if (state->field == V4L2_FIELD_NONE)
    fi->interval.denominator *= 2;
```

This checks if the de-interlacer is active (`V4L2_FIELD_NONE` means
progressive/non-interlaced output) and, if so, doubles the denominator
of the frame interval fraction, effectively doubling the reported frame
rate from 25→50 (PAL) or ~30→~60 (NTSC).

The logic is straightforward:
- Previously: PAL reported 1/25, NTSC reported 1001/30000
- With fix when progressive: PAL reports 1/50, NTSC reports 1001/60000

This is mathematically correct - when de-interlacing at the field rate,
you get twice as many frames per second.

### Bug Classification

This is a **correctness bug** in the V4L2 subdev frame interval
reporting. Userspace applications querying the frame interval would get
incorrect information when progressive mode is enabled. This could
cause:
- Video recording at wrong timestamps
- A/V synchronization issues
- Incorrect video playback speed
- Applications making wrong decisions about buffer management based on
  incorrect frame rates

### Scope and Risk Assessment

- **Lines changed**: ~5 lines added (including comments)
- **Files touched**: 1 file (drivers/media/i2c/adv7180.c)
- **Risk**: Very low. The change only affects the reported frame
  interval when `state->field == V4L2_FIELD_NONE`. It cannot affect
  interlaced mode operation at all.
- **Complexity**: Trivial multiplication by 2 of an existing value,
  gated by a clear condition.

### Stable Kernel Criteria Check

1. **Obviously correct and tested**: Yes - the math is straightforward
   and it was reviewed by a domain expert.
2. **Fixes a real bug**: Yes - incorrect frame interval reporting in
   progressive mode.
3. **Important issue**: Moderate - it causes incorrect metadata
   reporting that affects video capture applications. Not a crash or
   security issue, but a functional correctness bug that impacts real
   users of ADV7280-M hardware.
4. **Small and contained**: Yes - 5 lines in one file, one driver.
5. **No new features**: Correct - this fixes existing behavior, doesn't
   add new functionality.
6. **Clean application**: The change is self-contained and should apply
   cleanly to any kernel that has the `adv7180_get_frame_interval`
   function with the `v4l2_subdev_state` parameter.

### User Impact

Users of ADV7280-M video decoder chips with de-interlacing enabled would
get incorrect frame rate information from the V4L2 API. This is a real
hardware used in embedded video capture applications (the author is from
Topcon, a precision measurement/imaging company). The fix is important
for correct video processing pipelines.

### Risk vs Benefit

- **Benefit**: Correct frame interval reporting for ADV7280-M users in
  progressive mode
- **Risk**: Essentially zero - the change is gated by a specific
  condition and only affects metadata reporting, not actual video data
  flow

### Concerns

- The `state->field` and `V4L2_SUBDEV_FORMAT_ACTIVE` API patterns need
  to exist in the target stable tree. This is a relatively modern V4L2
  API pattern, so it should be checked which stable versions have the
  relevant code.
- No dependency on other commits - this is a standalone fix.

### Conclusion

This is a clean, small, obviously correct bug fix for a real issue
affecting hardware users. It meets all stable kernel criteria. The fix
is trivial, well-reviewed, and carries essentially no regression risk.

**YES**

 drivers/media/i2c/adv7180.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 378f4e6af12cb..5cbc973df684d 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -507,6 +507,13 @@ static int adv7180_get_frame_interval(struct v4l2_subdev *sd,
 		fi->interval.denominator = 25;
 	}
 
+	/*
+	 * If the de-interlacer is active, the chip produces full video frames
+	 * at the field rate.
+	 */
+	if (state->field == V4L2_FIELD_NONE)
+		fi->interval.denominator *= 2;
+
 	return 0;
 }
 
-- 
2.51.0

