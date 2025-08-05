Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F44273D9B;
	Tue,  5 Aug 2025 13:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399447; cv=none; b=iMW9gXTdrZPkLhGRMIHKTC3uwsVFIRXl4X8ZPdoqr2H/Jy56rjw203U9nQA/MchyK3DxNIwOyg/MNDZJ9gKGSmE2iHOPr2vlqjsoeM0uSRZbVQxxrbBkFbJLIViuJgfUKa9UbevMiEzUqljoC9RaatYaHFo1lii0ogKjXlem95Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399447; c=relaxed/simple;
	bh=SboLkP/xv0ZgpchhQrQe9OpKHIvyJ1C7ejc3PrCsQco=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HOwLiGwL7udbhhj8yMLWE3mOPnSOZa1KSCOIULjHXudIMk5ru2JqvBUKe34eT4RX8rQmQJWMbnwxJnU0QasnJTdYt5jHmrh4m5OJstbH3t9rwpq1d5p7zFlY+JRl7u9oCHV4U1Mj+167gx9sFqfL1R4OnxwQi6XwsloF5Tk/xeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NVWWAZHD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NVWWAZHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023E4C4CEF4;
	Tue,  5 Aug 2025 13:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399447;
	bh=SboLkP/xv0ZgpchhQrQe9OpKHIvyJ1C7ejc3PrCsQco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NVWWAZHD4kQtEG2vQYXGwvlDIKjL+tCBWS2udRlce6WgjL8xMJRYsGmz4QLO+9y6N
	 Wm3LWEio8//8z7ZkYl59eJeonuF+L24U2Hg6pO0etAq8UvgAVa7rP8tb7E1G4ruLI6
	 wr08khHHDxLJm9BPmMiG1YM6YYr9Qx+flUSubRNcUtFG331ebhuvpvjGef/iIU/rY9
	 PU8DM34IR9WT7AvlywzUdXGzAATzsTX0I9dt6yCuZQJ1B4CKFJgBfyEYrB3Xm7enhm
	 yALUWFCDh9m7stDMZUSvZCQt0P7vm4NjQZge5zDOQuz277Zm4B7d8YcI2jYSHMRMjP
	 +frCtuh4+9dHw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alex Guo <alexguo1023@gmail.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	algonell@gmail.com,
	hverkuil@kernel.org
Subject: [PATCH AUTOSEL 6.16-5.4] media: dvb-frontends: dib7090p: fix null-ptr-deref in dib7090p_rw_on_apb()
Date: Tue,  5 Aug 2025 09:09:02 -0400
Message-Id: <20250805130945.471732-27-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Guo <alexguo1023@gmail.com>

[ Upstream commit ce5cac69b2edac3e3246fee03e8f4c2a1075238b ]

In dib7090p_rw_on_apb, msg is controlled by user. When msg[0].buf is null and
msg[0].len is zero, former checks on msg[0].buf would be passed. If accessing
msg[0].buf[2] without sanity check, null pointer deref would happen. We add
check on msg[0].len to prevent crash. Similar issue occurs when access
msg[1].buf[0] and msg[1].buf[1].

Similar commit: commit 0ed554fd769a ("media: dvb-usb: az6027: fix null-ptr-deref in az6027_i2c_xfer()")

Signed-off-by: Alex Guo <alexguo1023@gmail.com>
Link: https://lore.kernel.org/r/20250616013231.730221-1-alexguo1023@gmail.com
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

## Security Bug Fix
This commit fixes a **null pointer dereference vulnerability** that can
be triggered by user-controlled input through the I2C subsystem. The
vulnerability occurs in `dib7090p_rw_on_apb()` when:

1. **Write path (num == 1)**: The code accesses `msg[0].buf[1]` and
   `msg[0].buf[2]` without checking if `msg[0].len >= 3`:
  ```c
  dib7000p_write_word(state, apb_address, ((msg[0].buf[1] << 8) |
  (msg[0].buf[2])));
  ```

2. **Read path (num != 1)**: The code accesses `msg[1].buf[0]` and
   `msg[1].buf[1]` without checking if `msg[1].len >= 2`:
  ```c
  msg[1].buf[0] = (word >> 8) & 0xff;
  msg[1].buf[1] = (word) & 0xff;
  ```

## User-Controlled Attack Vector
The `msg` parameter comes from user-space through the I2C ioctl
interface, making this a **user-triggerable vulnerability**. A malicious
or buggy application can pass:
- `msg[0].buf = NULL` with `msg[0].len = 0`
- Or a valid buffer with insufficient length

This would cause the kernel to dereference memory beyond the allocated
buffer or dereference NULL, leading to a kernel crash or potential
privilege escalation.

## Minimal and Contained Fix
The fix is:
- **Small**: Only adds 4 lines of bounds checking
- **Contained**: Changes are limited to a single function
- **Low risk**: Simply returns `-EOPNOTSUPP` when buffer lengths are
  insufficient
- **No architectural changes**: Pure defensive programming addition

## Follows Established Pattern
The commit references a similar fix (`0ed554fd769a`) for the same class
of vulnerability in `az6027_i2c_xfer()`, which was already accepted and
likely backported. This shows:
- The issue is recognized as security-relevant
- The fix pattern is established and tested
- Multiple DVB drivers have this vulnerability class

## Meets Stable Criteria
According to stable tree rules, this commit:
- ✅ Fixes a real bug (null-ptr-deref crash)
- ✅ Is small and self-contained (4 lines added)
- ✅ Has minimal risk of regression (defensive checks only)
- ✅ Addresses a security issue (user-triggerable kernel crash)
- ✅ No new features or architectural changes

The vulnerability allows unprivileged users with access to DVB devices
to crash the kernel, making it a significant security issue that
warrants backporting to all maintained stable kernels that contain the
vulnerable code.

 drivers/media/dvb-frontends/dib7000p.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index b40daf242046..360a2d7dd3ed 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -2256,8 +2256,12 @@ static int dib7090p_rw_on_apb(struct i2c_adapter *i2c_adap,
 	u16 word;
 
 	if (num == 1) {		/* write */
+		if (msg[0].len < 3)
+			return -EOPNOTSUPP;
 		dib7000p_write_word(state, apb_address, ((msg[0].buf[1] << 8) | (msg[0].buf[2])));
 	} else {
+		if (msg[1].len < 2)
+			return -EOPNOTSUPP;
 		word = dib7000p_read_word(state, apb_address);
 		msg[1].buf[0] = (word >> 8) & 0xff;
 		msg[1].buf[1] = (word) & 0xff;
-- 
2.39.5

