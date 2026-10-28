Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213209;
	b=rt6/NWfcj/DQ6d5ltWu/scra7e958gcYU33gjZI2kqfdF8NBLC6z+ZpaBtDiVvDXrIwR
	 KG72YUyuXMgRIGgD1VCCOPx244OClQyaJfy5Chyv0bE/vpmSWee5xI/blx0gdYAr4Cbpd
	 KYjpWz7L9wnikZP1NJr1PlqyZ+YyvV3dF3qBZyP9uCEaytpMIiebFhuiNI+R37TUSDmiZ
	 2a6ekvmhu3vBtHBZWhwCIYAUF7L/VqkFaFhucBrdxJ1/qy+7PcUuarYJ4yD15SjJOUnpU
	 mlq0ktI8IPlHLOhUzOrZbdEoS72Odp4rqPtn/j5fabh56hTzftp0syWG1dI8KwEH1WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m3SYhEP3JYNkw+BC59yJpLpoX6hMj+a+RVac22VAeyg=;
	b=1WyAW9y4usOP+5aClN+wn7zfCzXiBRe+pChFbazZMD0suBwgadqmJgnRhk1/SLGLM8Ja
	 uxmE3+NDKItTHCIRIGBp377f2srVuqUPgUlv9NXtCml9wXKEASmhMvuGKwkqmAwNBUzPK
	 mZ3JUWCJHsRijNVzTDvKow1axLMsIHT+vHU7ZoYbH1SgsfhVovXiPYN26A8fAOITaRaBM
	 yt14AljO9FIKUpsKSQhLsZ1yWvsagwPz45GBtVW6Mrc+EgZOYoHqOrwAriUPj2ZUn9W3H
	 /laEY2WyXMv41h6EJXh/mBaPP7wSL321FvwUz6Rkaqo/8uKzL0c8b1kIemSfimMuBXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JhRYVHP3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A70D606A31A;
	Wed, 28 Oct 2026 18:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JhRYVHP3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988021F01825;
	Wed, 28 Oct 2026 18:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213209;
	bh=m3SYhEP3JYNkw+BC59yJpLpoX6hMj+a+RVac22VAeyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JhRYVHP30kp2v0/SSAceCsPl9Z4+BwtW6BDG94iLtoeWFxVVshVqRkX/RdqOV/7Ky
	 h7TenbbNdpmD13REN8sW9AwVlcUAzdnUS+nDHMA5kj9h1pZOFOAMzCW4PljOSTFdai
	 ljZYs99f0cxAIqHzgP4yijiNlN+53MNv/Ba88/kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>,
	Lee Jones <lee@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0424/1887] HID: uhid: convert to hid_safe_input_report()
Date: Wed, 28 Oct 2026 17:42:00 +0100
Message-ID: <20261028170508.883279337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

[ Upstream commit 63a694c51bf120a37550890b8e7736b4888985e9 ]

Commit 0a3fe972a7cb ("HID: core: Mitigate potential OOB by removing
bogus memset()"), added a check in hid_report_raw_event() to reject
reports if the received data size is smaller than expected. This was
intended to prevent OOB errors by no longer allowing zeroing-out of
shorter reports due to the lack of buffer size information.

However, this leads to regressions in hid_report_raw_event(), where
shorter than expected reports are rejected, even though their buffers
are sufficiently large to be zero-padded.

To solve this issue, Benjamin introduced a safer alternative in commit
206342541fc8 ("HID: core: introduce hid_safe_input_report()"), which
forwards the buffer size and allows hid_report_raw_event() to safely
zero-pad the data.

Convert uhid to use hid_safe_input_report() and pass UHID_DATA_MAX as
the buffer size. This prevents the reported regressions [1], allowing
hid core to zero-pad the shorter reports safely as expected.

Cc: stable@vger.kernel.org
Fixes: 0a3fe972a7cb ("HID: core: Mitigate potential OOB by removing bogus memset()")
Closes: https://lore.kernel.org/all/ahsh0UtTX6e0ZeHa@google.com/ [1]
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Lee Jones <lee@kernel.org>
Closes: https://lore.kernel.org/all/ahsh0UtTX6e0ZeHa@google.com/
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/uhid.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index 59ac757c1d471..72baf8adf46cf 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -597,8 +597,8 @@ static int uhid_dev_input(struct uhid_device *uhid, struct uhid_event *ev)
 	if (!READ_ONCE(uhid->running))
 		return -EINVAL;
 
-	hid_input_report(uhid->hid, HID_INPUT_REPORT, ev->u.input.data,
-			 min_t(size_t, ev->u.input.size, UHID_DATA_MAX), 0);
+	hid_safe_input_report(uhid->hid, HID_INPUT_REPORT, ev->u.input.data, UHID_DATA_MAX,
+			      min_t(size_t, ev->u.input.size, UHID_DATA_MAX), 0);
 
 	return 0;
 }
@@ -608,8 +608,8 @@ static int uhid_dev_input2(struct uhid_device *uhid, struct uhid_event *ev)
 	if (!READ_ONCE(uhid->running))
 		return -EINVAL;
 
-	hid_input_report(uhid->hid, HID_INPUT_REPORT, ev->u.input2.data,
-			 min_t(size_t, ev->u.input2.size, UHID_DATA_MAX), 0);
+	hid_safe_input_report(uhid->hid, HID_INPUT_REPORT, ev->u.input2.data, UHID_DATA_MAX,
+			      min_t(size_t, ev->u.input2.size, UHID_DATA_MAX), 0);
 
 	return 0;
 }
-- 
2.53.0



