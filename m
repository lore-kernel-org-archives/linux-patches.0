Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626304;
	b=TIaNUpH1UCflV4quDbMw3QjOTDNawjC3Z46cgR1G2Bl01+SaO+r2wjA++gOvL1YNgbEt
	 EROYD85iP9EcW3u0JAAoMG7tihEY4p9eDJnq+6jrWUBCINJxRrJ13AUyDRiJFnjb5x1ta
	 4lsIw/Mfn3ZPuO8orxPvfy7HDCjz3OL8qMGimG4fj758bnB9DPrkdIpnDzEra1ex++HyD
	 IdYSSjZh1fTa/lh2YkYWHzwykteDb1eg0VGEB0epIxYKN3SzHEc7nW2LcLyGf/DnubDvD
	 MytsTC2qqInHo+QsUFP4s5vLRFEsUeyy+lqyyWtQ6SnAzmLj0vWE9ghLNSo6Z/bwZjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YIF7TF/uFke46e44OGKBGH5VDybz+aIHEw5tk/8iMqU=;
	b=EOH0T/HHb/jTDgjXG/+HF0fGElmWQY5g/JbVQufmuSpR8OXLz7PuEK+AR9XbWhNH+keA
	 f/d4iWkBP3OhSvboAEy65xcG310yOsOiOwZH+HVb1b8hVhXNgapqaHzyfoyRf28am7LDN
	 Kp3PMRId+ycl3yHYQ7Uqx94kVRSKVdmESwXVwDCI7OD000fGNB5TTftcXMbxg+zOZDgKe
	 Rq/3N3KX3Eo3nHJt4xPY4TYDr7mn4kIteIR3RDeMQGOsbRuX73J4nSCc3SfyfBqoQzV8N
	 3dIYNc79f6ziu6c3Mci97iChIVAf6WB42uBhXHVRs3cB9+keT0Ig0gzsRdnvSgYWc9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tq773BxL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C00606A33A;
	Wed, 25 Nov 2026 17:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tq773BxL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F661F000C4;
	Wed, 25 Nov 2026 17:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626304;
	bh=YIF7TF/uFke46e44OGKBGH5VDybz+aIHEw5tk/8iMqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tq773BxLAWQ3KGY1EL9hVOE0449iEZeUvHaQyJaQJR5taeg1sTBfKDh8dcN1xKfVN
	 eh9OlCQKFnWx0I9DuxvTBdimtgxCvS6zWYRxjQZpZF6t/Wlqpx6+U+65jwxXeQcXA6
	 f4bQjXYzse1wkr430GnV7mwiwc7axlBCwYhdNNNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 798/816] iio: trigger: free the trigger ID after device_del()
Date: Wed, 25 Nov 2026 15:39:06 +0100
Message-ID: <20261125143907.642634357@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Changyul Lee <lcy8047@gmail.com>

commit d32bf759801e6df23038dc834622a122ec76a4dd upstream.

iio_trigger_unregister() returns the trigger ID to iio_trigger_ida
before device_del() removes the "trigger<N>" device. A trigger
registered in between can get the same ID, and its device_add() fails:

  sysfs: cannot create duplicate filename '/bus/iio/devices/trigger0'

For example, adding a sysfs trigger while an hrtimer trigger is being
removed through configfs, or the other way around, hits this because the
two paths do not share a lock.

Free the ID after device_del(), as the error path of
iio_trigger_register() already does, and drop the "Possible issue in
here" comment.

Fixes: 1637db44413e ("Staging: IIO: Trigger support added to core.")
Signed-off-by: Changyul Lee <lcy8047@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-trigger.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/industrialio-trigger.c
+++ b/drivers/iio/industrialio-trigger.c
@@ -105,9 +105,8 @@ void iio_trigger_unregister(struct iio_t
 	scoped_guard(mutex, &iio_trigger_list_lock)
 		list_del(&trig_info->list);
 
-	ida_free(&iio_trigger_ida, trig_info->id);
-	/* Possible issue in here */
 	device_del(&trig_info->dev);
+	ida_free(&iio_trigger_ida, trig_info->id);
 }
 EXPORT_SYMBOL(iio_trigger_unregister);
 


