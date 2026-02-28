Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72087313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301018; cv=none; b=nRRItKkkQDWrqsCark5p2m3Fru5N5buu2BPMhbpt49K8lFMuXqEueKzm7d0eY6VvmSITkupB57wqCvpPl3KSQ+WBp8OWqzHgPD4cxi7uJGTRtoi34ewZ3ss/YCOKeNlYwQQKlMt1/1XMnhR9JviuPqvgTFTjr+HtZK9qRzILEhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301018; c=relaxed/simple;
	bh=QY4r49LELkjFiPWcZ+H/+r+CW7E0L4Bmu3+i0NV0DQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H53iEuZX3W3VOqY5+sryBwXL7XmcqoAwjWDUxl5Rkjzgs+vaqdHjMlEblveGxQoz7X0qSoaNDDNwXgj52jANJE0pWDw9seYzSYerRvslCfCkavELLDSGiSyJeEaUis5/Hxn88tryB4l+OFW2n05H7t/1S1HaJjjPuUSTdZaFnB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mPexm2L/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mPexm2L/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACADAC19423;
	Sat, 28 Feb 2026 17:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301018;
	bh=QY4r49LELkjFiPWcZ+H/+r+CW7E0L4Bmu3+i0NV0DQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mPexm2L/mQENu48cg09kwqL20elBe+dKTfXsj7/l0g84DAkl7oShIx13OkMoe/bx3
	 IZhXTBfAsnJLaXY5GaxWoAhgpNftWyrSNWcQufiQJK5kgu3n1/GbOEqL/ftyONspCY
	 5FxBX8CAi6HEJjSXk7WfjZZ0Iw5ndyKU/YuUi7QsTWzZGOCv0yDuoUVTEEz8vDnJQy
	 6KitNF63mWpFnm0kCTT//JngGLn512nV0ItFg7Ka60ARA5vb1qcRQpstGEYi1/l7NK
	 sjKJKglaC7/W0PSWaMjldletYMULkk6Ob6EfcBFisIlPOUGyj3m1oykzfL6kyvKm4D
	 3XD1cu8yXZ5fw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thorsten Schmelzer <tschmelzer@topcon.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Michael Tretter <m.tretter@pengutronix.de>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 154/752] media: adv7180: fix frame interval in progressive mode
Date: Sat, 28 Feb 2026 12:37:45 -0500
Message-ID: <20260228174750.1542406-154-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

