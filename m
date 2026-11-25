Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620665;
	b=xBcAWnqxaqggrst81fUVtWE2Wnzu2VtIJpD96xD5pnKA2LK3UyfNYFrC4/Ij7SnehGdu
	 CCwcqKHDa9KQY2gPzuIdEZ775E5KrpCAxXLRE4hc7EUh5el6gJC26Tt0aTC52i3unqk27
	 kRe+Tn79jZPFLUm6s7iz4IkjJCMhqwQmURG71q4VdgX+Bzb46Y2Hv4XqYiA+CZzG47hVp
	 5AgX4iAZ/4lTSIInNQ6GDDd8VD1QcI2IJMaMsQKH52lxz0iu9mIn36eeNr0dLQNXw7Wli
	 shVkWD1J0U5/65Z8LbGQaCfZOUGjluOXzzIm+LIJz5WkM/e6BUHggpPFbhQlZio8hCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+VPA8ruQEF9SG+DX9SAauwFsjLcuWTfOVF7iFvOxtvE=;
	b=0O7j9rYyHa/yrFxYc7ItHaLPHnZ+AoU2SgBAmD8A4gUMcnJd9bH4UiPaa3C31LJDmMnT
	 rIOe/+0O11A91Ht4XLAZBGrTVz5972r9OkneuR+IacQOy+6juLmFO9778+NcqCZUA/M7W
	 NtIdiOCJk4Oy20y55glE8lRCzl7Z6Jc9dYxbaxyeeqA6LJ6OFFu5YP/k7CfZu5mA/6abB
	 Q671k8ec8kZXeK/JTkPyXFqgbs6kx1G/2P1q6Q5bfJj+ZMDEGp2O9YT9WpD1M7PQLMNio
	 7bIui+v8m3SCD6t0KiW+a9FtrbBOUpc1KRBj10hcbDEs+l8YDoQdm+51SvMOC3S39qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u5sC+D58;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1B6606A31E;
	Wed, 25 Nov 2026 15:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u5sC+D58
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CDD1F000CF;
	Wed, 25 Nov 2026 15:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620664;
	bh=+VPA8ruQEF9SG+DX9SAauwFsjLcuWTfOVF7iFvOxtvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u5sC+D58jf06i+YvkIQyToNjmaNaoON7rywOzCD+bVHS2R3SehBtUaJskYM+5xUKX
	 C4HYCZcXy36z8G7FgOxykWhljZP/5MxL/1qpQv6v+szdDHOAXImH6A977kPC/9id/W
	 EsfPrIO73jH/J+q0zobnilNV9cVSxIrmcl9KyoZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0994/1005] iio: trigger: free the trigger ID after device_del()
Date: Wed, 25 Nov 2026 15:38:52 +0100
Message-ID: <20261125143844.937995118@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
 


