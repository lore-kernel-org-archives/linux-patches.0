Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A49B1D86E8;
	Wed,  6 Nov 2024 13:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898879; cv=none; b=bIPZ1FQ6DvqnEysYBEctqikJryItFvZHrS9qYpeFboiKWmAAut9d+WrBv96qqy6xwtM5JscTZLZ790xvGYN5DQNIjOfJMDTy16yZX+VaYlXX2R9RGZP3OPwbuCeW+1kue+LlhpXfLSttHKQTIhZCAxzb5hTHh5QjRk9u6RMz/48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898879; c=relaxed/simple;
	bh=ksuRrO5QrtvSsPdXWpCtWdNPCcVpHvy2UGDTwcZngO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OemWleSM0gd5m6k1QT48gquBW41eIMOpX1C091XIEFKBlX5bEf3XCTokT4R6BSHPi/nYiJ/MweMdIKh+bBCCBHMcStkd21aWeLsjL+onT4575TH86XD1vGJL6hAnUPlLNbAgLeRAXtc7R9xntXkWbD6R6TkbJA3KyGZWNadA2GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xAxL4QFQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xAxL4QFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3442C4CECD;
	Wed,  6 Nov 2024 13:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898879;
	bh=ksuRrO5QrtvSsPdXWpCtWdNPCcVpHvy2UGDTwcZngO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xAxL4QFQIlz16e/RpiowQnNw1L2qvDvmX8nqxGDvtmdQcJh3rftrSaMcwh5vjz3I+
	 Qk6Wqwt/BYhJCKCjGCIuAR4O6H/Mi2JXN1yT/s0Bn+4WjnTz05RvI7S3u4qyKM4d+6
	 6fIMv7GCm41AifjDjKHjSBRNhwXfC0sTnD5W9c4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SurajSonawane2415 <surajsonawane0215@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.4 349/462] hid: intel-ish-hid: Fix uninitialized variable rv in ish_fw_xfer_direct_dma
Date: Wed,  6 Nov 2024 13:04:02 +0100
Message-ID: <20241106120340.148934704@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SurajSonawane2415 <surajsonawane0215@gmail.com>

commit d41bff05a61fb539f21e9bf0d39fac77f457434e upstream.

Fix the uninitialized symbol 'rv' in the function ish_fw_xfer_direct_dma
to resolve the following warning from the smatch tool:
drivers/hid/intel-ish-hid/ishtp-fw-loader.c:714 ish_fw_xfer_direct_dma()
error: uninitialized symbol 'rv'.
Initialize 'rv' to 0 to prevent undefined behavior from uninitialized
access.

Cc: stable@vger.kernel.org
Fixes: 91b228107da3 ("HID: intel-ish-hid: ISH firmware loader client driver")
Signed-off-by: SurajSonawane2415 <surajsonawane0215@gmail.com>
Link: https://patch.msgid.link/20241004075944.44932-1-surajsonawane0215@gmail.com
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/intel-ish-hid/ishtp-fw-loader.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
+++ b/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
@@ -630,7 +630,7 @@ static int ish_fw_xfer_direct_dma(struct
 				  const struct firmware *fw,
 				  const struct shim_fw_info fw_info)
 {
-	int rv;
+	int rv = 0;
 	void *dma_buf;
 	dma_addr_t dma_buf_phy;
 	u32 fragment_offset, fragment_size, payload_max_size;


