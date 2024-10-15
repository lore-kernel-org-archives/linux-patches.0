Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3149A1F892A;
	Tue, 15 Oct 2024 12:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994322; cv=none; b=k0/038nLf9F71E3n7EFcEbV1QMUBTZr+ieZOTfuNWJu3g+HSk/fig/m8uKVj/AZUP1+kLSQRXIlfjdlc6Wi1x2i+96i1LTVnmGNIXmXeoNlH2mUtf8YKAbeKmjqC3RJLCEgcMWxf6MZmwNOsg2cNmO5vuptfjeqjNvxW+N4pfTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994322; c=relaxed/simple;
	bh=X9jU1w7ZxrXKY0vNJwMxSMmUn2QZUqfk3OtG97zRnW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcWTfJNLM48JRlJf7W2mAE+7GdN67zwNcIVgAfSjkQ4rWX72y0VB62RPNlos5VQUGqn2cCCws75NXMNZXoOPlnEGQziFZ2jl2e1PlbMnyn1K9RlcoNqmHIsK8BMs+5i3Pw8vA4xGCsTUcNKNGOyngg87R/bHFJ/WugZWGFWsuLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wTQMNfVr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wTQMNfVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4821FC4CECF;
	Tue, 15 Oct 2024 12:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994321;
	bh=X9jU1w7ZxrXKY0vNJwMxSMmUn2QZUqfk3OtG97zRnW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wTQMNfVrPmx3gG6T9KXmxt8k5faNQJnOJyJOw7aqjKbn/YfiaArOnFezFPwHI9vmZ
	 yOb3hViEkKMULmOJhIEb4cvcY5ztgsIA64M3D0Q+EW0pUn+ZGLRXDenc3clqKbPyn9
	 MsblvnretyDee1Hxc66m9PMEN3esqNfHYpnZV+RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SurajSonawane2415 <surajsonawane0215@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.15 671/691] hid: intel-ish-hid: Fix uninitialized variable rv in ish_fw_xfer_direct_dma
Date: Tue, 15 Oct 2024 13:30:19 +0200
Message-ID: <20241015112506.955542814@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -631,7 +631,7 @@ static int ish_fw_xfer_direct_dma(struct
 				  const struct firmware *fw,
 				  const struct shim_fw_info fw_info)
 {
-	int rv;
+	int rv = 0;
 	void *dma_buf;
 	dma_addr_t dma_buf_phy;
 	u32 fragment_offset, fragment_size, payload_max_size;


