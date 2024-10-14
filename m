Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080431C3051;
	Mon, 14 Oct 2024 14:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917219; cv=none; b=tEUmhi+/D2UndkWxfPKaHvhBhyjRnptZkKw4tl9GzcTUi9x453ozriB02IuZ2u61NMLLD8h3htO7fgxjcvOT4UFzUEjPVtQJqaYLoGump+/xnXrLT5pcYxv8SQzjbrtUcfsCRvhIk5rpdDly55VQ5QEYwfCUAwdl3S7HCIRX7Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917219; c=relaxed/simple;
	bh=3c+E21QtkADkZQRCSn/ztGw9BG/i9CPFohHsnaDfcKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTQhb+nznvf58rIn+efTzT8y6YZO9yXmMc9N7II1A1ZyxHZ2+euNNte4lCDEQngs8xR1Lu3bjVEuhhQmvfMW+apy2n0g6r44sqiXLqAUpzM1uTr1Fg6K5jEejfD9pRCWnM99pdI6oziPfHZmoabrRsCTPdHBB6O+rSTQv19/SSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IaUPSpN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IaUPSpN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA51C4CEC3;
	Mon, 14 Oct 2024 14:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917218;
	bh=3c+E21QtkADkZQRCSn/ztGw9BG/i9CPFohHsnaDfcKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IaUPSpN5WyEsbZnKNQXTBQHet8JWYvaCixSoLfrfoghH4ptCyCbYG8LL+DXixz4oB
	 jDfum1LkA2/4/Fq+BoYXqc4FAm8G7yRRyHgvQ+L8KmXQ0DbMBMyqH03g+G4YDVYmXa
	 /5wrqCLlktfbCm/N6fAw8oDKuC8yc8BrJ8vTpoNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SurajSonawane2415 <surajsonawane0215@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.6 187/213] hid: intel-ish-hid: Fix uninitialized variable rv in ish_fw_xfer_direct_dma
Date: Mon, 14 Oct 2024 16:21:33 +0200
Message-ID: <20241014141050.262276850@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -635,7 +635,7 @@ static int ish_fw_xfer_direct_dma(struct
 				  const struct firmware *fw,
 				  const struct shim_fw_info fw_info)
 {
-	int rv;
+	int rv = 0;
 	void *dma_buf;
 	dma_addr_t dma_buf_phy;
 	u32 fragment_offset, fragment_size, payload_max_size;


