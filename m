Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB8228D8E8;
	Thu, 27 Nov 2025 14:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255169; cv=none; b=pq+KHl2i1EqdoWg23mvQpRz7JKKGWHPSise7Tw6rFT0/0tjQ7d6Bth4lwfbzIS09uKHRremZpRf6JjGOf4lvRcgxfqU1Gdc8a/g7FT1iy7WFX/Av5IEM6YwSlteteUPWHwxD8c84NMGngoR/DVgu3irtkGsXM5ylsozQ5VmwDsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255169; c=relaxed/simple;
	bh=gdFf+LC2v9fYe9Jw5dM/chlpAYBFWX5ZhMhs829JFn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPBo6XynZV4kF9uZgLrgmJYQYPgpPsfzH55p+GjcZa7Xd9kV+MCcVLU+7V9Fme1nnJ/+dP95OTdHkoGS7kJaygAoSxA9+/DMc8AcEPXqCrN644jrSsLq1jBEIzHbdkDYAChfa+UHxvBPW9YDXWp6l2Jw3tMl1ikG8DMM9LqiCRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxhjyeY4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxhjyeY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F17C4CEF8;
	Thu, 27 Nov 2025 14:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255169;
	bh=gdFf+LC2v9fYe9Jw5dM/chlpAYBFWX5ZhMhs829JFn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LxhjyeY4GjzdfTkcWrgaKFm7xwN5jV9Z5XLB4+7XxywpKjWCWMPfE0zVYspgrIy+U
	 K0wnQHisCzFUWJ8JcVzGZ8J5h6GmwkpCjxfHAAJu5oOKHBhuDV45XJ9lY3wyZnOmBq
	 utPQ/Qnx0/n0262ftAWQLOSMLZ1X7g8Pq++4SVAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weikang Guo <guoweikang.kernel@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 024/112] Input: goodix - add support for ACPI ID GDIX1003
Date: Thu, 27 Nov 2025 15:45:26 +0100
Message-ID: <20251127144033.693455634@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit c6d99e488117201c63efd747ce17b80687c3f5a9 upstream.

Some newer devices use an ACPI hardware ID of GDIX1003 for their Goodix
touchscreen controller, instead of GDIX1001 / GDIX1002. Add GDIX1003
to the goodix_acpi_match[] table.

Reported-by: Weikang Guo <guoweikang.kernel@gmail.com>
Closes: https://lore.kernel.org/linux-input/20250225024409.1467040-1-guoweikang.kernel@gmail.com/
Tested-by: Weikang Guo <guoweikang.kernel@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20251013121022.44333-1-hansg@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/goodix.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -1519,6 +1519,7 @@ MODULE_DEVICE_TABLE(i2c, goodix_ts_id);
 static const struct acpi_device_id goodix_acpi_match[] = {
 	{ "GDIX1001", 0 },
 	{ "GDIX1002", 0 },
+	{ "GDIX1003", 0 },
 	{ "GDX9110", 0 },
 	{ }
 };


