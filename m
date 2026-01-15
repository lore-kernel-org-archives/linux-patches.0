Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15233D412F;
	Thu, 15 Jan 2026 17:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499573; cv=none; b=QJ1+CBZu2KWtSuR2CF3Z71xUdBoyNcYJzTM3y1gN7vGbg7ckM55ttPGKag8RfSEPz4QPE9ZU8qqaoK/66lZ6iHK9/EFK2CtzdF32zecCym7x0r94CUJnBB8LEtkITtHC3+t4ARe2axolcRLL91aM9OnOOpj+ifxhCWrzP3j/1i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499573; c=relaxed/simple;
	bh=27AA5LWj5mWoZxEgd+y7HyRta/popW+1HLE/ZaUcRyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3F3koYgjJcznbv9l0BCIUOjEyZyFM35JpiQJe/6pX4AF7C+dzh+G5ol614+Dp8FKZ6w48k7MQwuFkiNsMAc0GLI3WRpM6AHqYLbQ6ceixhfFjh/Pm18ZjFIkh9Spmtmo7QW/AL+3lLXMSGJXvPC/CdQAwHtflEjOPvtQvqguIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1HUQZHr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1HUQZHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7B5C116D0;
	Thu, 15 Jan 2026 17:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499573;
	bh=27AA5LWj5mWoZxEgd+y7HyRta/popW+1HLE/ZaUcRyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y1HUQZHrpSQlRiG1YGvCxAjE1JV4KTOwTpk7/h8pr/tmyc68c4zLJ8AU3wOJ7nZSl
	 Ss2az/ChZSIcZbC4MN5SpZkHaug5Mm5tJIsQy2ksaN3WO/6VoeidSnIaXHGDhFZN7Z
	 R1hs3bh/s5K2Iz8WPVtY2jFBpfuSqqYCO1sf8iUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 231/451] media: pvrusb2: Fix incorrect variable used in trace message
Date: Thu, 15 Jan 2026 17:47:12 +0100
Message-ID: <20260115164239.251027374@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

commit be440980eace19c035a0745fd6b6e42707bc4f49 upstream.

The pvr2_trace message is reporting an error about control read
transfers, however it is using the incorrect variable write_len
instead of read_lean. Fix this by using the correct variable
read_len.

Fixes: d855497edbfb ("V4L/DVB (4228a): pvrusb2 to kernel 2.6.18")
Cc: stable@vger.kernel.org
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -3617,7 +3617,7 @@ static int pvr2_send_request_ex(struct p
 		pvr2_trace(
 			PVR2_TRACE_ERROR_LEGS,
 			"Attempted to execute %d byte control-read transfer (limit=%d)",
-			write_len,PVR2_CTL_BUFFSIZE);
+			read_len, PVR2_CTL_BUFFSIZE);
 		return -EINVAL;
 	}
 	if ((!write_len) && (!read_len)) {


