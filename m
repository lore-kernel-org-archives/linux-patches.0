Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6AF341660;
	Tue, 26 Aug 2025 13:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214949; cv=none; b=qhIrnEslHhoBTRI3dJKclTpiTwQQ2oDwrLcyxoXV5vkdRJ/U/HwzLnOWiMMUYGRPHA9N63Acx0F7VYQudCDBnOld41CrePD8pqHqEPvWaezVa+kPeRTlymYPtITnmirE3wSEkrh2S6+Lavngp+5Z6p8BJX05GRvkaQ39cwsyyoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214949; c=relaxed/simple;
	bh=24c/EI3QghhQMyWfn7Ub4xYWhiMNAvv5Ufb8S0LignM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpXFR5uvi43G3YfM1aRqZrTudlhHHtZ8XJIvLnl7ITvrxdEcffXFYOn5KP342hSaPIhz4A9EahpFll7wFvua9boegfhNFEClXCBnhhNtZ/jCsaylIiz4yopRW+ObyYAooWxmYBbzVcPfMrr97T6z4G23ukuuLmWgSDTPujaMiBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zQe3H4wo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zQe3H4wo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3794AC4CEF1;
	Tue, 26 Aug 2025 13:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214948;
	bh=24c/EI3QghhQMyWfn7Ub4xYWhiMNAvv5Ufb8S0LignM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zQe3H4woJxdbYYMHpP6K+DvGknY135bldenUNyJGj+S9y/0lZ/+rZFcdFVt1PB61c
	 HtOJ3+W04w79fQgzUH0xUBemNgjqtFeyOOd6gZ4eyhdoQsmfdMJMtSNX07YHqXsexq
	 3+/ezaHGq94d4mLebXukl+aW8L9wcsYLfpT91eYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Bryan ODonoghue <bod@kernel.org>
Subject: [PATCH 6.1 331/482] media: venus: vdec: Clamp param smaller than 1fps and bigger than 240.
Date: Tue, 26 Aug 2025 13:09:44 +0200
Message-ID: <20250826110938.997741774@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

commit 377dc500d253f0b26732b2cb062e89668aef890a upstream.

The driver uses "whole" fps in all its calculations (e.g. in
load_per_instance()). Those calculation expect an fps bigger than 1, and
not big enough to overflow.

Clamp the value if the user provides a param that will result in an invalid
fps.

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Closes: https://lore.kernel.org/linux-media/f11653a7-bc49-48cd-9cdb-1659147453e4@xs4all.nl/T/#m91cd962ac942834654f94c92206e2f85ff7d97f0
Fixes: 7472c1c69138 ("[media] media: venus: vdec: add video decoder files")
Cc: stable@vger.kernel.org
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org> # qrb5615-rb5
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
[bod: Change "parm" to "param"]
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/core.h |    2 ++
 drivers/media/platform/qcom/venus/vdec.c |    5 ++---
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -28,6 +28,8 @@
 #define VIDC_PMDOMAINS_NUM_MAX		3
 #define VIDC_RESETS_NUM_MAX		2
 
+#define VENUS_MAX_FPS			240
+
 extern int venus_fw_debug;
 
 struct freq_tbl {
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -458,11 +458,10 @@ static int vdec_s_parm(struct file *file
 	us_per_frame = timeperframe->numerator * (u64)USEC_PER_SEC;
 	do_div(us_per_frame, timeperframe->denominator);
 
-	if (!us_per_frame)
-		return -EINVAL;
-
+	us_per_frame = clamp(us_per_frame, 1, USEC_PER_SEC);
 	fps = (u64)USEC_PER_SEC;
 	do_div(fps, us_per_frame);
+	fps = min(VENUS_MAX_FPS, fps);
 
 	inst->fps = fps;
 	inst->timeperframe = *timeperframe;


