Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051897;
	b=kquM+En9w/I5L4SG/ZiLQEWW07IO7iWeUnbGfPU2WVY2vZuEBx+AQyBnUChA3eNlRkeO
	 koYQWyqT8ytzD+ATOxMSwzptcnkirevthAQK1a073rNMAgz9dl3edok+fz1gqAo4/uy+l
	 O3+E9WtiL1YiPCoGwQ1HVsJVDgvgrQ8eo6qjFwITcR0HUjmC3jBc1siBLnXYNPq2RfdLp
	 dMKzg2T76BLrlGMTjuFZqRwkgbuMe8A5mrjfR8DtIHDsDoiUYuvQEJ+62KVD9DdEih0Ht
	 ryn7LetYlzmkqv1yfnGYmP06VIQBSbLEbz4gJ9Zaurph0xAB2dxbgOG4mS3eXvgf7FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xC6wO2JuUXrUnLzjKCLYjli7Wh0a7FEOwEbmMMNB/as=;
	b=WtH8gHlGjnGofR8iSXYWQRAOYj0dVeyxrV+8/kABpCUZ5K/mFgy9JeWkw+0LpaCEZoNB
	 Vu/rzC0c6rAQjBnQZqPwvTMd4git2vzzu9z68xEO108Tf+qlpSd2vq0C3fYRA0Fq9Xuhi
	 m4mpd9Qos4xHtsvnZENHkUGWal+8PhvryNUU84kvFqodxmDt5pyNm0RKa6Q6vkm5fPxf/
	 mVKhAqCDdjkeDOZk7okSI5wLWnJk4nyz6vZodNyg3xaUPj4CB91p0X+5pTPvsyn//Z80l
	 yBOd7u52aR7qG34tGpqPRHnXfvJMJsFjGw4+zT03SqRVW9PoVqqnVHGSXp+noFicDIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HKZVqUTy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA9960A261A;
	Thu, 19 Nov 2026 01:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HKZVqUTy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6F91F000C6;
	Thu, 19 Nov 2026 01:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051897;
	bh=xC6wO2JuUXrUnLzjKCLYjli7Wh0a7FEOwEbmMMNB/as=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HKZVqUTyociMBpprCGmrX9iC50Zv0yBEheDFKjZX3w7RzHtqV47VSbr0hzlCCF2bU
	 xhpRi5gieiURVu2eJiE7QtBtvOAA3FO2l2kX4l7A/6NMyU/7Eik5ITMiinfjR+CUpt
	 CIIiEIpXy88Ji1eJQ2lDwawPJ+2qcKtKLFlPayVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.15 0373/2214] HID: cougar: reject short special-key reports
Date: Wed, 18 Nov 2026 15:34:09 +0100
Message-ID: <20261118150025.640627433@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit c6c0df8a4b73a0d563c5e64de640ef5ff525fc82 upstream.

The HID core invokes raw_event callbacks before validating the report
length.  cougar_raw_event() reads the key code and action from offsets one
and two without checking that those bytes are present.  A short report on
the special interface can therefore cause an out-of-bounds read.

Consume reports that do not contain the action field before accessing the
fixed offsets, consistent with the callback's handling of other reports on
the special interface.

Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw_event length validation to hid-asus.

Fixes: b8e759b8f6da ("HID: cougar: Add support for the Cougar 500k Gaming Keyboard")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-cougar.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-cougar.c
+++ b/drivers/hid/hid-cougar.c
@@ -271,6 +271,9 @@ static int cougar_raw_event(struct hid_d
 	if (!shared->enabled || !shared->input)
 		return -EPERM;
 
+	if (size <= COUGAR_FIELD_ACTION)
+		return -EPERM;
+
 	code = data[COUGAR_FIELD_CODE];
 	action = data[COUGAR_FIELD_ACTION];
 	for (i = 0; cougar_mapping[i][0]; i++) {


